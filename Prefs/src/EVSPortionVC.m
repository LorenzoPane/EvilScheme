#import "EVSPortionVC.h"
#import "../L0Prefs/L0Prefs.h"

NS_ENUM(NSInteger, PortionVCSection) {
    TypeSection,
    PropertiesSection,
};

@implementation EVSPortionVC

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch([indexPath section]) {
        case TypeSection: {
            L0PickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PickerCell" forIndexPath:indexPath];
            [[cell textLabel] setText:@"Type"];
            [[cell field] setText:[[self portion] stringRepresentation]];
            [cell setOptions:[[EVSPortionVM classNameMappings] allKeys]];
            [[cell field] setTag:-1];
            [cell setDelegate:self];
            return cell;
        }
        case PropertiesSection: {
            if([[self portion] cellTypeForIndex:[indexPath row]] == [L0ToggleCell class]) {
                L0ToggleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToggleCell" forIndexPath:indexPath];
                [cell setLabelText:[[self portion] propertyNameForIndex:[indexPath row]]];
                [[cell toggle] setOn:[[[self portion] objectForPropertyIndex:[indexPath row]] boolValue]];
                [cell setDelegate:self];
                [[cell toggle] setTag:[indexPath row]];
                return cell;
            } else {
                L0EditTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditTextCell" forIndexPath:indexPath];
                [cell setLabelText:[[self portion] propertyNameForIndex:[indexPath row]]];
                [[cell field] setText:[[self portion] valueStringForIndex:[indexPath row]]];
                [cell setDelegate:self];
                [[cell field] setTag:[indexPath row]];
                return cell;
            }
        }
        default: {
            return nil;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section) {
        case TypeSection:
            return 1;
        case PropertiesSection:
            return [[self portion] propertyCount];
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case TypeSection:
            return @"Portion Type";
        case PropertiesSection:
            return @"Portion Properties";
        default:
            return @"";
    }
}

- (void)textFieldDidChange:(UITextField *)field {
    if([field tag] == -1) {
        [self setPortion:[[EVSPortionVM alloc] initWithPortion:[[EVSPortionVM classNameMappings][[field text]] new]]];
        [[self tableView] reloadSections:[NSIndexSet indexSetWithIndex:PropertiesSection]
                        withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [[self portion] setObject:[field text] forPropertyIndex:[field tag]];
    }
    [[self delegate] controllerDidChangeModel:self];
}

- (void)switchValueDidChange:(UISwitch *)toggle {
    [[self portion] setObject:@([toggle isOn]) forPropertyIndex:[toggle tag]];
    [[self delegate] controllerDidChangeModel:self];
}

@end
