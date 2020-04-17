#import "EVSAppAlternativeVC.h"
#import "EVSEditTextCell.h"

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

@interface EVSAppAlternativeVC ()

@end

@implementation EVSAppAlternativeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupTable];
}

- (void)setupNav {
    [self setTitle:[[self appAlternative] name]];
    UIBarButtonItem *presetButton = [[UIBarButtonItem alloc] initWithTitle:@"Load Preset"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(showPresetView)];
    [presetButton setTintColor:LINK_COLOR];
    [[self navigationItem] setRightBarButtonItem:presetButton];
}

- (void)setupTable {
    [self setTableView:[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped]];
    [[self tableView] setDataSource:self];
    [[self tableView] setDelegate:self];
    [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LabelCell"];
    [[self tableView] registerClass:[EVSEditTextCell class] forCellReuseIdentifier:@"EditTextCell"];
    [[self tableView] setRowHeight:44];
    [self setView:[self tableView]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath section]) {
        case NameSection: {
            EVSEditTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditTextCell" forIndexPath:indexPath];
            [cell setLabelText:@"Name"];
            [[cell field] setText:[[self appAlternative] name]];
            [[cell field] setTag:NameTag];
            [cell setDelegate:self];
            return cell;
        }
        case BundleIDSection: {
            EVSEditTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditTextCell" forIndexPath:indexPath];
            [cell setLabelText:([indexPath row] ? @"New" : @"Old")];
            [cell setFieldPlaceholder:@"ex: com.apple.mobilesafari"];
            [[cell field] setText:([indexPath row] ? [[self appAlternative] substituteBundleID] : [[self appAlternative] targetBundleID])];
            [[cell field] setTag:[indexPath row]];
            [cell setDelegate:self];
            return cell;
        }
        case OutlineSection: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell" forIndexPath:indexPath];
            if([indexPath row] < [[[self appAlternative] urlOutlines] count]) {
                [[cell textLabel] setText:[[[self appAlternative] urlOutlines] allKeys][[indexPath row]]];
                [[cell textLabel] setTextColor:[UIColor labelColor]];
            } else {
                [[cell textLabel] setText:@"Add new"];
                [[cell textLabel] setTextColor:LINK_COLOR];
            }
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            return cell;
        }
        default:
            return nil;
    }
}

- (void)controllerDidChangeModel:(EVSOutlineVC *)viewController {
    NSMutableDictionary* dict = [[[self appAlternative] urlOutlines] mutableCopy];
    [dict removeObjectForKey:[viewController key]];
    [dict setObject:[viewController outline] forKey:[viewController regex]];
    [[self appAlternative] setUrlOutlines:dict];
    [[self tableView] reloadData];
    [[self delegate] controllerDidChangeModel:self];
}

- (void)textFieldDidChange:(UITextField *)textField {
    switch([textField tag]) {
        case NameTag:
            if(![[[textField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
                [[self appAlternative] setName:[textField text]];
                [self setTitle:[textField text]];
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

- (void)showPresetView {}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath section] == OutlineSection) {
        EVSOutlineVC *ctrl = [[EVSOutlineVC alloc] init];
        NSDictionary *outlines = [[self appAlternative] urlOutlines];
        NSString *key = [outlines allKeys][[indexPath row]];
        [ctrl setKey:key];
        [ctrl setRegex:key];
        [ctrl setOutline:[[outlines objectForKey:key] mutableCopy]];
        [ctrl setDelegate:self];
        [[self navigationController] pushViewController:ctrl animated:YES];
    }
    [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
}

@end
