#import "EVSLogVC.h"
#import "EVSPreferenceManager.h"

@implementation EVSLogVC {
    NSArray<NSString *> *log;
}

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self refresh];
}

- (void)setupNav {
    [self setTitle:@"Log"];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Refresh"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(refresh)]];
}

#pragma mark - table

NS_ENUM(NSInteger, LogSections) {
    ToggleSection,
    LogSection,
};

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section) {
        case ToggleSection:
            return 1;
        case LogSection:
            return [log count];
        default:
            return 0;
    }
}

#pragma mark - cells

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath section]) {
        case ToggleSection: {
            L0ToggleCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:TOGGLE_CELL_ID];
            [[cell textLabel] setText:@"Enable Logging"];
            [[cell toggle] setOn:[EVSPreferenceManager isLogging]];
            [cell setDelegate:self];
            return cell;
        }
        case LogSection: {
            L0ProseCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:PROSE_CELL_ID];
            [[cell textLabel] setText:log[[indexPath row]]];
            return cell;
        }
        default:
            return nil;
    }
}

#pragma mark - model

- (void)switchValueDidChange:(UISwitch *)toggle {
    [EVSPreferenceManager setLogging:[toggle isOn]];
}

- (void)refresh {
    log = [[[EVSPreferenceManager logDict][@"data"] reverseObjectEnumerator] allObjects];
    [[self tableView] reloadSections:[NSIndexSet indexSetWithIndex:LogSection] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end

