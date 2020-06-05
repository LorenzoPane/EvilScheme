#import "../L0Prefs/L0Prefs.h"
#import "EVSPortionVC.h"
#import "EVSQueryTranslatorVC.h"

@implementation EVSPortionVC

#pragma mark - lifecycle

- (instancetype)initWithPortion:(EVSPortionVM *)portion withIndex:(NSInteger)idx {
    if((self = [super init])) {
        _portion = portion;
        _index = idx;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
}

- (void)setupNav {
    [self setTitle:@"Configure fragment"];
}

#pragma mark - table

NS_ENUM(NSInteger, PortionVCSection) {
    TypeSection,
    PropertiesSection,
};

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

#pragma mark - cells

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch([indexPath section]) {
        case TypeSection: {
            L0PickerCell *cell = [tableView dequeueReusableCellWithIdentifier:PICKER_CELL_ID forIndexPath:indexPath];
            [[cell textLabel] setText:@"Type"];
            [[cell field] setText:[[self portion] stringRepresentation]];

            NSDictionary *mappings = [EVSPortionVM classNameMappings];
            [cell setOptions:[mappings allKeys]];

            for(NSString *key in [mappings allKeys]) {
                if([[[self portion] portion] class] == mappings[key]) {
                    [cell selectObject:key];
                    break;
                }
            }

            [[cell field] setTag:-1];
            [cell setDelegate:self];
            return cell;
        }
        case PropertiesSection: {
            Class cellType = [[self portion] cellTypeForIndex:[indexPath row]];
            NSInteger row = [indexPath row];
            if(cellType == [L0ToggleCell class]) {
                L0ToggleCell *cell = [tableView dequeueReusableCellWithIdentifier:TOGGLE_CELL_ID forIndexPath:indexPath];
                [[cell textLabel] setText:[[self portion] propertyNameForIndex:row]];
                [[cell toggle] setOn:[[[self portion] objectForPropertyIndex:row] boolValue]];
                [cell setDelegate:self];
                [[cell toggle] setTag:row];
                return cell;
            } else if(cellType == [L0LinkCell class]) {
                L0LinkCell *cell = [tableView dequeueReusableCellWithIdentifier:LINK_CELL_ID forIndexPath:indexPath];
                [[cell textLabel] setText:[[self portion] propertyNameForIndex:row]];
                return cell;
            } else if(cellType == [L0StepperCell class]) {
                L0StepperCell *cell = [tableView dequeueReusableCellWithIdentifier:STEPPER_CELL_ID forIndexPath:indexPath];
                [cell setPrefix:[[self portion] propertyNameForIndex:row]];
                [[cell stepper] setMinimumValue:-10];
                [[cell stepper] setMaximumValue:10];
                [[cell stepper] setTag:row];
                [[cell stepper] setValue:[(NSNumber *)[[self portion] objectForPropertyIndex:row] intValue]];
                [cell setDelegate:self];
                [cell stepperValueDidChange:[cell stepper]];
                return cell;
            } else {
                L0EditTextCell *cell = [tableView dequeueReusableCellWithIdentifier:EDIT_TEXT_CELL_ID forIndexPath:indexPath];
                [[cell textLabel] setText:[[self portion] propertyNameForIndex:row]];
                [[cell field] setText:[[self portion] valueStringForIndex:row]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    if([indexPath section] == PropertiesSection
    && [[self portion] cellTypeForIndex:row] == [L0LinkCell class]) {
        id obj = [[self portion] objectForPropertyIndex:row];
        if([obj isKindOfClass:[NSDictionary class]]) {
            EVSQueryTranslatorVC *ctrl = [[EVSQueryTranslatorVC alloc] initWithDictionary:obj];
            [ctrl setTag:row];
            [ctrl setDelegate:self];
            [[self navigationController] pushViewController:ctrl animated:YES];
        }
    }

    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - editing

- (void)toggleEditing {
    [[self tableView] setEditing:![[self tableView] isEditing] animated:YES];
    [[[self navigationItem] rightBarButtonItem] setTitle:([[self tableView] isEditing] ? @"Done" : @"Edit")];
}

#pragma mark - model

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

- (void)stepperValueDidChange:(UIStepper *)stepper {
    [[self portion] setObject:@([stepper value]) forPropertyIndex:[stepper tag]];
    [[self delegate] controllerDidChangeModel:self];
}

- (void)switchValueDidChange:(UISwitch *)toggle {
    [[self portion] setObject:@([toggle isOn]) forPropertyIndex:[toggle tag]];
    [[self delegate] controllerDidChangeModel:self];
}

- (void)controllerDidChangeModel:(EVSQueryTranslatorVC *)controller {
    [[self portion] setObject:[[controller dict] dict] forPropertyIndex:[controller tag]];

    [super controllerDidChangeModel:controller];
}

@end
