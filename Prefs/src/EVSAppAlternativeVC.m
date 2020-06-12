#import "../L0Prefs/L0Prefs.h"
#import "EVSPresetListVC.h"
#import "EVSAppAlternativeVC.h"

@implementation EVSAppAlternativeVC

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
}

- (void)setupNav {
    [self setTitle:[[self appAlternative] name]];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                                                               target:self
                                                                                               action:@selector(showPresetView)]];
}

- (void)setupTable {
    [super setupTable];
    [[self tableView] setEditing:YES];
    [[self tableView] setAllowsSelectionDuringEditing:YES];
}

#pragma mark - table

NS_ENUM(NSInteger, AppVCSection) {
    MetaSection,
    TargetAppSection,
    OutlineSection,
};

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case TargetAppSection:
            return @"Target Bundle IDs";
        case OutlineSection:
            return @"Actions";
        default:
            return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case MetaSection:
            return 2;
        case TargetAppSection:
            return [[[self appAlternative] targetBundleIDs] count] + 1;
        case OutlineSection:
            return [[[self appAlternative] urlOutlines] count] + 1;
        default:
            return 0;
    }
}

#pragma mark - cells

NS_ENUM(NSInteger, AppTextFieldTags) {
    NameTag               = -1,
    SubstituteBundleIDTag = -2,
};

NS_ENUM(NSInteger, MetaCells) {
    NameCell,
    SubstituteBundleCell,
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath section]) {
        case MetaSection: {
            L0EditTextCell *cell = [tableView dequeueReusableCellWithIdentifier:EDIT_TEXT_CELL_ID forIndexPath:indexPath];
            switch([indexPath row]) {
                case NameCell: {
                    [[cell textLabel] setText:@"Name"];
                    [[cell field] setPlaceholder:@"For easy identification"];
                    [[cell field] setText:[[self appAlternative] name]];
                    [[cell field] setTag:NameTag];
                    break;
                }
                case SubstituteBundleCell: {
                    [[cell textLabel] setText:@"New Bundle ID"];
                    [[cell field] setPlaceholder:@"ex: com.brave.ios.browser"];
                    [[cell field] setText:[[self appAlternative] substituteBundleID]];
                    [[cell field] setTag:SubstituteBundleIDTag];
                    break;
                }
            }
            [cell setDelegate:self];
            return cell;
        }
        case TargetAppSection: {
            if([indexPath row] < [[[self appAlternative] targetBundleIDs] count]) {
                L0PureEditTextCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:PURE_EDIT_TEXT_CELL_ID forIndexPath:indexPath];
                [cell setDelegate:self];
                [[cell field] setTag:[indexPath row]];
                [[cell field] setPlaceholder:@"ex. com.apple.mobilesafari"];
                [[cell field] setText:[[self appAlternative] targetBundleIDs][[indexPath row]]];

                return cell;
            } else {
                UITableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:BASIC_CELL_ID forIndexPath:indexPath];
                [[cell textLabel] setText:@"Add new"];

                return cell;
            }
        }
        case OutlineSection: {
            if([indexPath row] < [[[self appAlternative] urlOutlines] count]) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LINK_CELL_ID forIndexPath:indexPath];
                [[cell textLabel] setText:[[[self appAlternative] urlOutlines][[indexPath row]] regexPattern]];
                return cell;
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BUTTON_CELL_ID forIndexPath:indexPath];
                [[cell textLabel] setText:@"Add new"];
                return cell;
            }
        }
        default:
            return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch([indexPath section]) {
        case OutlineSection: {
            EVSOutlineVC *ctrl = [EVSOutlineVC new];
            if([indexPath row] < [[[self appAlternative] urlOutlines] count]) {
                [ctrl setIndex:[indexPath row]];
                [ctrl setAction:[[self appAlternative] urlOutlines][[indexPath row]]];
            } else {
                [ctrl setIndex:[indexPath row]];
                [ctrl setAction:[EVKAction new]];
            }
            [ctrl setDelegate:self];
            [[self navigationController] pushViewController:ctrl animated:YES];
            break;
        }
        case TargetAppSection: {
            if([indexPath row] == [[[self appAlternative] targetBundleIDs] count]) {
                [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
                [self tableView:[self tableView] commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:indexPath];
            }
            break;
        }
        default:
            break;
    }

    [super tableView:tableView didSelectRowAtIndexPath:indexPath];

}

#pragma mark - editing

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(editingStyle) {
        case UITableViewCellEditingStyleDelete: {
            switch([indexPath section]) {
                case OutlineSection: {
                    NSMutableArray *arr = [[[self appAlternative] urlOutlines] mutableCopy];
                    [arr removeObjectAtIndex:[indexPath row]];
                    [[self appAlternative] setUrlOutlines:arr];
                    [[self tableView] deleteRowsAtIndexPaths:@[indexPath]
                                            withRowAnimation:UITableViewRowAnimationMiddle];
                    break;
                } case TargetAppSection: {
                    [[[self appAlternative] targetBundleIDs] removeObjectAtIndex:[indexPath row]];
                    [[self tableView] deleteRowsAtIndexPaths:@[indexPath]
                                            withRowAnimation:UITableViewRowAnimationMiddle];
                }
            }
            break;
        }
        case UITableViewCellEditingStyleInsert: {
            if(![[[self appAlternative] targetBundleIDs] containsObject:@""]) {
                [[[self appAlternative] targetBundleIDs] addObject:@""];
                [[self tableView] insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            break;
        }

        default:
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [indexPath section] == TargetAppSection
    || ([indexPath section] == OutlineSection
        && [indexPath row] < [[[self appAlternative] urlOutlines] count]);
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return [indexPath section] == OutlineSection && [indexPath row] < [[[self appAlternative] urlOutlines] count];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch([indexPath section]) {
        case OutlineSection:
            return UITableViewCellEditingStyleDelete;
            break;

        case TargetAppSection: {
            return [indexPath row] < [[[self appAlternative] targetBundleIDs] count] ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleInsert;
        }
        default:
            return UITableViewCellEditingStyleNone;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    return ([proposedDestinationIndexPath section] == OutlineSection && [proposedDestinationIndexPath row] < [[[self appAlternative] urlOutlines] count]) ? proposedDestinationIndexPath : sourceIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSMutableArray *mut = [[[self appAlternative] urlOutlines] mutableCopy];
    EVKAction *action = mut[[sourceIndexPath row]];
    [mut removeObjectAtIndex:[sourceIndexPath row]];
    [mut insertObject:action atIndex:[destinationIndexPath row]];
    [[self appAlternative] setUrlOutlines:mut];
    [[self delegate] controllerDidChangeModel:self];
}

#pragma mark - model

- (BOOL)controller:(L0PrefVC *)controller canMoveFromKey:(NSString *)from toKey:(NSString *)to {
    return !([to isEqualToString:@""] || [[self appAlternative] containsKey:to]);

}

- (void)showPresetView {
    EVSPresetListVC *ctrl = [EVSPresetListVC new];
    [ctrl setDelegate:self];
    UINavigationController *child = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [self presentViewController:child animated:YES completion:nil];
}

- (void)controllerDidChangeModel:(EVSOutlineVC *)controller {
    if([controller isKindOfClass:[EVSOutlineVC class]]) {
        NSMutableArray *arr = [[[self appAlternative] urlOutlines] mutableCopy];
        arr[[controller index]] = [controller action];
        [[self appAlternative] setUrlOutlines:arr];

    }

    [self setTitle:[[self appAlternative] name]];
    [super controllerDidChangeModel:controller];
}

- (void)textFieldDidChange:(UITextField *)textField {
    switch([textField tag]) {
        case NameTag:
            if([[self delegate] controller:self canMoveFromKey:[[self appAlternative] name] toKey:[textField text]]) {
                [[self appAlternative] setName:[textField text]];
            }
            break;
        case SubstituteBundleIDTag:
            [[self appAlternative] setSubstituteBundleID:[textField text]];
            break;
        default: {
            [[self appAlternative] targetBundleIDs][[textField tag]] = [textField text];
            break;
        }
    }

    [[self delegate] controllerDidChangeModel:self];
}

@end
