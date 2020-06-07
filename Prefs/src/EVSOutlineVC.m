#import "EVSOutlineVC.h"
#import "EVSPortionVC.h"

@implementation EVSOutlineVC

#pragma mark - lifecycle

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
            return [[[self action] outline] count] + 1;
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
            [[cell field] setText:[[self action] regexPattern]];
            [cell setDelegate:self];
            return cell;
        }
        case PortionSection: {
            if([indexPath row] < [[[self action] outline] count]) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LINK_CELL_ID forIndexPath:indexPath];
                NSObject<EVKURLPortion> *item = [[self action] outline][[indexPath row]];
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
        if(row < [[[self action] outline] count]) {
            [self presentVCForPortion:[[self action] outline][row] withIndex:row];
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
        NSMutableArray *arr = [[[self action] outline] mutableCopy];
        [arr removeObjectAtIndex:[indexPath row]];
        [[self action] setOutline:arr];
        [[self tableView] deleteRowsAtIndexPaths:@[indexPath]
                                withRowAnimation:UITableViewRowAnimationMiddle];
    }
    [[self delegate] controllerDidChangeModel:self];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    return ([proposedDestinationIndexPath section] == PortionSection && [proposedDestinationIndexPath row] < [[[self action] outline] count]) ? proposedDestinationIndexPath : sourceIndexPath;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [indexPath section] == PortionSection && [indexPath row] < [[[self action] outline] count];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return [indexPath section] == PortionSection && [indexPath row] < [[[self action] outline] count];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSObject<EVKURLPortion> *obj = [[self action] outline][[sourceIndexPath row]];
    NSMutableArray *arr = [[[self action] outline] mutableCopy];
    [arr removeObjectAtIndex:[sourceIndexPath row]];
    [arr insertObject:obj atIndex:[destinationIndexPath row]];
    [[self action] setOutline:arr];
    [[self delegate] controllerDidChangeModel:self];
}

#pragma mark - model

- (void)textFieldDidChange:(UITextField *)field {
    if([field tag] == RegexTag && [[self delegate] controller:self canMoveFromKey:[[self action] regexPattern] toKey:[field text]]) {
        [[self action] setRegexPattern:[field text]];
        [[self delegate] controllerDidChangeModel:self];
    }
}

- (void)controllerDidChangeModel:(EVSPortionVC *)controller {
    NSMutableArray *arr = [[[self action] outline] mutableCopy];
    arr[[controller index]] = [[controller portion] portion];
    [[self action] setOutline:arr];
    [super controllerDidChangeModel:controller];
}

@end
