#import <EvilKit/EvilKit.h>
#import <UIKit/UIKit.h>
#import "EVSRootVC.h"
#import "EVSPreferenceManager.h"

#define LINK_COLOR [UIColor colorWithRed:0.776 green:0.471 blue:0.867 alpha:1]

NS_ENUM(NSInteger, RootVCSection) {
    MetaSection,
    AppAlternativeSection,
    FuckYouSection,
};

@implementation EVSRootVC {
    NSMutableArray<EVSAppAlternativeWrapper *> *appAlternatives;
    NSArray<NSString *> *linkTitles;
    NSArray<NSString *> *linkURLs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupNav];
    [self setupTable];
    [self setupHeader];
}

- (void)setupData {
    linkTitles = @[
        @"Manual",
        @"Source code / Bug tracker",
        @"License: BSD 3-Clause",
        @"Follow me on twitter :)",
    ];

    linkURLs = @[
        @"https://github.com/lorenzopane/evilscheme",
        @"https://github.com/lorenzopane/evilscheme",
        @"https://opensource.org/licenses/BSD-3-Clause",
        @"https://twitter.com/L0Dev",
    ];

    appAlternatives = [[EVSPreferenceManager appAlternatives] mutableCopy];
}

- (void)setupNav {
    [self setTitle:@"EvilScheme"];
    [[[self navigationController] navigationBar] setTintColor:LINK_COLOR];
    UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Save/Apply"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(saveSettings)];
    [applyButton setTintColor:LINK_COLOR];
    [[self navigationItem] setRightBarButtonItem:applyButton];
    [[[self navigationItem] backBarButtonItem] setTintColor:LINK_COLOR];
}

- (void)setupTable {
    [self setTableView:[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped]];
    [[self tableView] setDataSource:self];
    [[self tableView] setDelegate:self];
    [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LabelCell"];
    [[self tableView] setAllowsMultipleSelectionDuringEditing:NO];
    [self setView:[self tableView]];
}

- (void)setupHeader {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 70)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 300, 70)];
    [titleLabel setText:@"EvilScheme://"];
    [titleLabel setFont:[UIFont monospacedSystemFontOfSize:28 weight:UIFontWeightThin]];
    [headerView addSubview:titleLabel];
    [[self tableView] setTableHeaderView:headerView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath section]) {
        case MetaSection:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkURLs[[indexPath row]]]
                                               options:@{}
                                     completionHandler:nil];
            break;
        case AppAlternativeSection: {
            EVSAppAlternativeVC *ctrl = [[EVSAppAlternativeVC alloc] init];
            if([indexPath row] < [appAlternatives count]) {
                [ctrl setAppAlternative:appAlternatives[[indexPath row]]];
            } else {
                [ctrl setAppAlternative:[EVSAppAlternativeWrapper new]];
            }
            [ctrl setIndex:[indexPath row]];
            [ctrl setDelegate:self];
            [[self navigationController] pushViewController:ctrl animated:YES];
            break;
        }
        case FuckYouSection: {
            //EVSDefaultBrowserVC *ctrl = [[EVSDefaultBrowserVC alloc] init];
            //[ctrl setModalPresentationStyle:UIModalPresentationFormSheet];
            //[ctrl setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            //[self presentViewController:ctrl animated:YES completion:nil];
            //break;
        }
        default:
            break;
    }
    [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell" forIndexPath:indexPath];

    switch([indexPath section]) {
        case MetaSection:
            [[cell textLabel] setText:linkTitles[[indexPath row]]];
            [[cell textLabel] setTextColor:LINK_COLOR];
            break;
        case AppAlternativeSection:
            if([indexPath row] < [appAlternatives count]) {
                [[cell textLabel] setText:[appAlternatives[[indexPath row]] name]];
                [[cell textLabel] setTextColor:[UIColor labelColor]];
            } else {
                [[cell textLabel] setText:@"Add new"];
                [[cell textLabel] setTextColor:LINK_COLOR];
            }
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;
        case FuckYouSection: {
            [[cell textLabel] setText:@"Just let me change my default browser!"];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;
        }
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section) {
        case MetaSection:
            return 4;
        case AppAlternativeSection:
            return [appAlternatives count] + 1;
        case FuckYouSection:
            return 1;
        default:
            return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case AppAlternativeSection:
            return @"Default Apps";
        case FuckYouSection:
            return @"This is all too complecated!";
        default:
            return @"";
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [indexPath section] == 1 && [indexPath row] < [appAlternatives count];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [appAlternatives removeObjectAtIndex:[indexPath row]];
        [[self tableView] reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)controllerDidChangeModel:(EVSAppAlternativeVC *)viewController {
    [appAlternatives setObject:[viewController appAlternative] atIndexedSubscript:[viewController index]];
    [[self tableView] reloadData];
}

- (void)saveSettings {}

@end
