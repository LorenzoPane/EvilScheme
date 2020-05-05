#import "EVSOutlineVC.h"
#import "EVSPortionVC.h"

@implementation EVSOutlineVC

#pragma mark - setup

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
}

- (void)setupNav {
    [self setTitle:@"Edit URL Outline"];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                                  style:UIBarButtonItemStyleDone
                                                                                 target:self
                                                                                 action:@selector(toggleEditing)]];
}

#pragma mark - table

NS_ENUM(NSInteger, OutlineVCSection) {
    RegexSection,
    PortionSection,
};

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

#pragma mark - cells

NS_ENUM(NSInteger, OutlineTextFieldTags) {
    RegexTag,
    TestURLTag,
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch([indexPath section]) {
        case RegexSection: {
            L0EditTextCell *cell = [tableView dequeueReusableCellWithIdentifier:EDIT_TEXT_CELL_ID forIndexPath:indexPath];
            [[cell textLabel] setText:@"Regex"];
            [[cell field] setText:[self regex]];
            [cell setDelegate:self];
            return cell;
        }
        case PortionSection: {
            if([indexPath row] < [[self outline] count]) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LINK_CELL_ID forIndexPath:indexPath];
                NSObject<EVKURLPortion> *item = [self outline][[indexPath row]];
                [[cell textLabel] setText:[item stringRepresentation]];
                return cell;
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BUTTON_CELL_ID forIndexPath:indexPath];
                [[cell textLabel] setText:@"Add new fragment"];
                return cell;
            }
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath section] == PortionSection) {
            NSInteger row = [indexPath row];
        if(row < [[self outline] count]) {
            [self presentVCForPortion:[self outline][row] withIndex:row];
        } else {
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Add new URL fragment"
                                                                               message:@"Choose a fragment type"
                                                                        preferredStyle:UIAlertControllerStyleActionSheet];
            [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleCancel
                                                        handler:^void(UIAlertAction *action) {}]];

            for(NSString *key in [EVSPortionVM classNameMappings]) {
                [alertCtrl addAction:[UIAlertAction actionWithTitle:key
                                                              style:UIAlertActionStyleDefault
                                                            handler:^void(UIAlertAction *action) {
                    [self presentVCForPortion:[[EVSPortionVM classNameMappings][key] new]
                                    withIndex:row];
                    [[self tableView] reloadRowsAtIndexPaths:@[indexPath]
                                            withRowAnimation:UITableViewRowAnimationMiddle];
                }]];
            }
            [self presentViewController:alertCtrl animated:YES completion:nil];
        }
    }

    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)presentVCForPortion:(NSObject<EVKURLPortion> *)portion withIndex:(NSInteger)idx {
    EVSPortionVC *ctrl = [[EVSPortionVC alloc] initWithPortion:[[EVSPortionVM alloc] initWithPortion:portion]
                                                     withIndex:idx];
    [ctrl setDelegate:self];
    [self controllerDidChangeModel:ctrl];
    [[self navigationController] pushViewController:ctrl animated:YES];
}

#pragma mark - editing

- (void)toggleEditing {
    [[self tableView] setEditing:![[self tableView] isEditing] animated:YES];
    [[[self navigationItem] rightBarButtonItem] setTitle:([[self tableView] isEditing] ? @"Done" : @"Edit")];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [[self outline] removeObjectAtIndex:[indexPath row]];
        [[self tableView] deleteRowsAtIndexPaths:@[indexPath]
                                withRowAnimation:UITableViewRowAnimationMiddle];
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

#pragma mark - model

- (void)textFieldDidChange:(UITextField *)field {
    if([field tag] == RegexTag && [[self delegate] controller:self canMoveFromKey:[self regex] toKey:[field text]]) {
        [self setRegex:[field text]];
        [[self delegate] controllerDidChangeModel:self];
    }
}

- (void)controllerDidChangeModel:(EVSPortionVC *)controller {
    [self outline][[controller index]] = [[controller portion] portion];
    [super controllerDidChangeModel:controller];
}

@end
