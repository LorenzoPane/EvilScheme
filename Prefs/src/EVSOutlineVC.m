#import "EVSOutlineVC.h"
#import "EVSPortionVC.h"

NS_ENUM(NSInteger, OutlineVCSection) {
    RegexSection,
    PortionSection,
};

NS_ENUM(NSInteger, OutlineTextFieldTags) {
    RegexTag,
    TestURLTag,
};

@implementation EVSOutlineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
}

- (void)setupNav {
    [self setTitle:@"Edit URL Outline"];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(toggleEditing)]];
}

- (void)toggleEditing {
    [[self tableView] setEditing:![[self tableView] isEditing] animated:YES];
    [[[self navigationItem] rightBarButtonItem] setTitle:([[self tableView] isEditing] ? @"Done" : @"Edit")];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [[self outline] removeObjectAtIndex:[indexPath row]];
        [[self tableView] reloadSections:[NSIndexSet indexSetWithIndex:PortionSection]
                        withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch([indexPath section]) {
        case RegexSection: {
            L0EditTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditTextCell" forIndexPath:indexPath];
            [[cell textLabel] setText:@"Regex"];
            [[cell field] setText:[self regex]];
            [cell setDelegate:self];
            return cell;
        }
        case PortionSection: {
            if([indexPath row] < [[self outline] count]) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LinkCell" forIndexPath:indexPath];
                NSObject<EVKURLPortion> *item = [self outline][[indexPath row]];
                [[cell textLabel] setText:[item stringRepresentation]];
                return cell;
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell" forIndexPath:indexPath];
                [[cell textLabel] setText:@"Add new fragment"];
                return cell;
            }
        }
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section) {
        case RegexSection:
            return 1;
        case PortionSection:
            return [[self outline] count] + 1;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case RegexSection:
            return @"Trigger";
        case PortionSection:
            return @"Blueprint";
        default:
            return @"";
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    return ([proposedDestinationIndexPath section] == PortionSection && [proposedDestinationIndexPath row] < [[self outline] count]) ? proposedDestinationIndexPath : sourceIndexPath;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [indexPath section] == PortionSection && [indexPath row] < [[self outline] count];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return [indexPath section] == PortionSection && [indexPath row] < [[self outline] count];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSObject<EVKURLPortion> *obj = [self outline][[sourceIndexPath row]];
    [[self outline] removeObjectAtIndex:[sourceIndexPath row]];
    [[self outline] insertObject:obj atIndex:[destinationIndexPath row]];
    [[self delegate] controllerDidChangeModel:self];
}

- (void)textFieldDidChange:(UITextField *)field {
    if([field tag] == RegexTag) {
        [self setRegex:[field text]];
        [[self delegate] controllerDidChangeModel:self];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath section] == PortionSection) {
        if([indexPath row] < [[self outline] count]) {
            EVSPortionVC *ctrl = [[EVSPortionVC alloc] init];
            [ctrl setDelegate:self];
            [ctrl setPortion:[[EVSPortionVM alloc] initWithPortion:[self outline][[indexPath row]]]];
            [ctrl setIndex:[indexPath row]];
            [ctrl setModalPresentationStyle:UIModalPresentationFormSheet];
            [ctrl setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [self presentViewController:ctrl animated:YES completion:nil];
        } else {
            UIAlertController *ctrl = [UIAlertController alertControllerWithTitle:@"Add new URL fragment"
                                                                          message:@"Choose a fragment type"
                                                                   preferredStyle:UIAlertControllerStyleActionSheet];
            [ctrl addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^void(UIAlertAction *action) {}]];

            for(NSString *key in [EVSPortionVM classNameMappings]) {
                [ctrl addAction:[UIAlertAction actionWithTitle:key
                                                         style:UIAlertActionStyleDefault
                                                       handler:^void(UIAlertAction *action) {
                    EVSPortionVC *ctrl = [[EVSPortionVC alloc] init];
                    [ctrl setDelegate:self];
                    [ctrl setIndex:[indexPath row]];
                    [ctrl setPortion:[[EVSPortionVM alloc] initWithPortion:[[EVSPortionVM classNameMappings][key] new]]];
                    [ctrl setModalPresentationStyle:UIModalPresentationFormSheet];
                    [ctrl setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                    [self presentViewController:ctrl animated:YES completion:nil]; }]];
            }

            [self presentViewController:ctrl animated:YES completion:nil];
        }
    }
    [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)controllerDidChangeModel:(EVSPortionVC *)controller {
    [self outline][[controller index]] = [[controller portion] portion];
    [super controllerDidChangeModel:controller];
}

@end
