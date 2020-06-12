#import <EvilKit/EvilKit.h>
#import <UIKit/UIKit.h>
#import "../L0Prefs/L0Prefs.h"
#import "EVSAppAlternativeVC.h"
#import "EVSPreferenceManager.h"
#import "EVSRootVC.h"
#import "EVSExperimentalPrefsVC.h"
#import "EVSLogVC.h"

@implementation EVSRootVC {
    NSMutableArray<EVSAppAlternativeWrapper *> *appAlternatives;
    NSArray<NSString *> *linkTitles;
    NSArray<NSString *> *linkURLs;
}

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupNav];
    [self setupHeader];
}

- (void)setupData {
    linkTitles = @[
        @"Manual",
        @"Source code / Bug tracker",
        @"License: BSD 3-Clause",
        @"Follow me on twitter :)",
        @"Tip jar <3",
    ];

    linkURLs = @[
        @"https://l.pane.net/evil.html",
        @"https://github.com/lorenzopane/evilscheme",
        @"https://opensource.org/licenses/BSD-3-Clause",
        @"https://twitter.com/mushyware",
        @"https://l.pane.net/causes.html",
    ];

    appAlternatives = [[EVSPreferenceManager activeAlternatives] mutableCopy];
}

- (void)setupNav {
    [self setTitle:@"Evil Scheme"];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(saveSettings)]];
}

- (void)setupHeader {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 70)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 300, 70)];
    [titleLabel setText:@"EvilScheme://"];
    [titleLabel setFont:[UIFont monospacedSystemFontOfSize:28 weight:UIFontWeightThin]];
    [headerView addSubview:titleLabel];
    [[self tableView] setTableHeaderView:headerView];
}

- (BOOL)isRootVC { return YES; }

- (void)viewWillDisappear:(BOOL)animated {
    [EVSPreferenceManager setActiveAlternatives:appAlternatives];
    [super viewWillDisappear:animated];
}

#pragma mark - table

NS_ENUM(NSInteger, RootVCSection) {
    MetaSection,
    AppAlternativeSection,
    MoreSettingsSection,
};

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section) {
        case MetaSection:
            return [linkTitles count];
        case AppAlternativeSection:
            return [appAlternatives count] + 1;
        case MoreSettingsSection:
            return 2;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case AppAlternativeSection:
            return @"Default Apps";
        case MoreSettingsSection:
            return @"Advanced";
        default:
            return @"";
    }
}

#pragma mark - cells

NS_ENUM(NSInteger, MoreSettingsCells) {
    ExperimentalCell,
    LogCell,
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch([indexPath section]) {
        case MetaSection: {
            L0ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:BUTTON_CELL_ID forIndexPath:indexPath];
            [[cell textLabel] setText:linkTitles[[indexPath row]]];
            return cell;
        }
        case AppAlternativeSection: {
            if([indexPath row] < [appAlternatives count]) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LINK_CELL_ID forIndexPath:indexPath];
                [[cell textLabel] setText:[appAlternatives[[indexPath row]] name]];
                return cell;
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BUTTON_CELL_ID forIndexPath:indexPath];
                [[cell textLabel] setText:@"Add new"];
                return cell;
            };
        }
        case MoreSettingsSection: {
            L0LinkCell *cell = [tableView dequeueReusableCellWithIdentifier:LINK_CELL_ID forIndexPath:indexPath];
            [[cell textLabel] setText:([indexPath row] == LogCell ? @"Log" : @"Experimental Settings")];
            return cell;
        }
        default:
            return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath section]) {
        case MetaSection: {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkURLs[[indexPath row]]]
                                               options:@{}
                                     completionHandler:nil];
            break;
        }
        case AppAlternativeSection: {
            EVSAppAlternativeVC *ctrl = [EVSAppAlternativeVC new];
            if([indexPath row] < [appAlternatives count]) {
                [ctrl setAppAlternative:appAlternatives[[indexPath row]]];
                [ctrl setIndex:[indexPath row]];
                [ctrl setDelegate:self];
                [[self navigationController] pushViewController:ctrl animated:YES];
            } else {
                [ctrl setAppAlternative:[EVSAppAlternativeWrapper new]];
                [ctrl setIndex:[indexPath row]];
                [ctrl setDelegate:self];
                [[self navigationController] pushViewController:ctrl animated:YES];
                [ctrl showPresetView];
            }
            break;
        }
        case MoreSettingsSection: {
            switch([indexPath row]) {
                case LogCell: {
                    EVSLogVC *ctrl = [EVSLogVC new];
                    [[self navigationController] pushViewController:ctrl animated:YES];
                    break;
                }
                case ExperimentalCell: {
                    EVSExperimentalPrefsVC *ctrl = [EVSExperimentalPrefsVC new];
                    [[self navigationController] pushViewController:ctrl animated:YES];
                    break;
                }
            }
            break;
        }
        default:
            break;
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - editing

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [indexPath section] == AppAlternativeSection && [indexPath row] < [appAlternatives count];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [appAlternatives removeObjectAtIndex:[indexPath row]];
        [[self tableView] deleteRowsAtIndexPaths:@[indexPath]
                                withRowAnimation:UITableViewRowAnimationMiddle];
    }
}

#pragma mark - model

- (void)controllerDidChangeModel:(EVSAppAlternativeVC *)controller {
    [appAlternatives setObject:[controller appAlternative] atIndexedSubscript:[controller index]];
    [super controllerDidChangeModel:controller];
}

- (BOOL)controller:(L0PrefVC *)controller canMoveFromKey:(NSString *)from toKey:(NSString *)to {
    if([to isEqualToString:@""])
        return NO;

    for(EVSAppAlternativeWrapper *wrapper in appAlternatives)
        if([[wrapper name] isEqualToString:to])
            return NO;

    return YES;
}

- (void)saveSettings {
    [EVSPreferenceManager setActiveAlternatives:appAlternatives];
    [EVSPreferenceManager applyActiveAlternatives:appAlternatives];
    UIAlertController *ctrl = [UIAlertController alertControllerWithTitle:@"Saved" message:@"Preferences applied" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:ctrl animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [ctrl dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
