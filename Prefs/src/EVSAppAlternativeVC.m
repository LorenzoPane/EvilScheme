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

#pragma mark - table

NS_ENUM(NSInteger, AppVCSection) {
    NameSection,
    BundleIDSection,
    OutlineSection,
};

NS_ENUM(NSInteger, AppTextFieldTags) {
    TargetBundleIDTag,
    SubstituteBundleIDTag,
    NameTag,
};

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case NameSection:
            return @"Customization";
        case BundleIDSection:
            return @"Bundle IDs";
        case OutlineSection:
            return @"Actions";
        default:
            return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case NameSection:
            return 1;
        case BundleIDSection:
            return 2;
        case OutlineSection:
            return [[[self appAlternative] urlOutlines] count] + 1;
        default:
            return 0;
    }
}

#pragma mark - cells

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath section]) {
        case NameSection: {
            L0EditTextCell *cell = [tableView dequeueReusableCellWithIdentifier:EDIT_TEXT_CELL_ID forIndexPath:indexPath];
            [[cell textLabel] setText:@"Name"];
            [[cell field] setText:[[self appAlternative] name]];
            [[cell field] setTag:NameTag];
            [cell setDelegate:self];
            return cell;
        }
        case BundleIDSection: {
            L0EditTextCell *cell = [tableView dequeueReusableCellWithIdentifier:EDIT_TEXT_CELL_ID forIndexPath:indexPath];
            [[cell textLabel] setText:([indexPath row] ? @"New" : @"Old")];
            [[cell field] setPlaceholder:@"ex: com.apple.mobilesafari"];
            [[cell field] setText:([indexPath row] ? [[self appAlternative] substituteBundleID] : [[self appAlternative] targetBundleID])];
            [[cell field] setTag:[indexPath row]];
            [cell setDelegate:self];
            return cell;
        }
        case OutlineSection: {
            if([indexPath row] < [[[self appAlternative] urlOutlines] count]) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LINK_CELL_ID forIndexPath:indexPath];
                [[cell textLabel] setText:[[[self appAlternative] urlOutlines] allKeys][[indexPath row]]];
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
    if([indexPath section] == OutlineSection) {
        EVSOutlineVC *ctrl = [EVSOutlineVC new];
        if([indexPath row] < [[[self appAlternative] urlOutlines] count]) {
            NSDictionary *outlines = [[self appAlternative] urlOutlines];
            NSString *key = [outlines allKeys][[indexPath row]];
            [ctrl setKey:key];
            [ctrl setRegex:key];
            [ctrl setOutline:[[outlines objectForKey:key] mutableCopy]];
        } else {
            [ctrl setKey:@""];
            [ctrl setRegex:@""];
            [ctrl setOutline:[NSMutableArray new]];
        }
        [ctrl setDelegate:self];
        [[self navigationController] pushViewController:ctrl animated:YES];
    }

    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - editing

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableDictionary* dict = [[[self appAlternative] urlOutlines] mutableCopy];
        [dict removeObjectForKey:[dict allKeys][[indexPath row]]];
        [[self appAlternative] setUrlOutlines:dict];
        [[self tableView] deleteRowsAtIndexPaths:@[indexPath]
                                withRowAnimation:UITableViewRowAnimationMiddle];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [indexPath section] == OutlineSection && [indexPath row] < [[[self appAlternative] urlOutlines] count];
}

- (BOOL)controller:(L0PrefVC *)controller canMoveFromKey:(NSString *)from toKey:(NSString *)to {
    return !([to isEqualToString:@""] || [[self appAlternative] containsKey:to]);

}

- (void)showPresetView {
    EVSPresetListVC *ctrl = [EVSPresetListVC new];
    [ctrl setDelegate:self];
    UINavigationController *child = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [self presentViewController:child animated:YES completion:nil];
}

#pragma mark - model

- (void)controllerDidChangeModel:(EVSOutlineVC *)controller {
    if([controller isKindOfClass:[EVSOutlineVC class]]) {
        NSMutableDictionary* dict = [[[self appAlternative] urlOutlines] mutableCopy];
        [dict removeObjectForKey:[controller key]];
        [dict setObject:[controller outline] forKey:[controller regex]];
        [controller setKey:[controller regex]];
        [[self appAlternative] setUrlOutlines:dict];
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
        case TargetBundleIDTag:
            [[self appAlternative] setTargetBundleID:[textField text]];
            break;
        case SubstituteBundleIDTag:
            [[self appAlternative] setSubstituteBundleID:[textField text]];
            break;
    }
    
    [[self delegate] controllerDidChangeModel:self];
}

@end
