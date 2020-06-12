#import "EVSLogVC.h"
#import "EVSPreferenceManager.h"

@implementation EVSLogVC {
    NSMutableArray<NSString *> *log;
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
    TopSection,
    LogSection,
};

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section) {
        case TopSection:
            return 2;
        case LogSection:
            return [log count];
        default:
            return 0;
    }
}

#pragma mark - cells

NS_ENUM(NSInteger, TopCells) {
    ToggleCell,
    ResetCell,
};

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch([indexPath section]) {
        case TopSection: {
            switch([indexPath row]) {
                case ToggleCell: {
                    L0ToggleCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:TOGGLE_CELL_ID];
                    [[cell textLabel] setText:@"Enable Logging"];
                    [[cell toggle] setOn:[EVSPreferenceManager isLogging]];
                    [cell setDelegate:self];
                    return cell;
                }
                case ResetCell: {
                    L0ButtonCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:BUTTON_CELL_ID];
                    [[cell textLabel] setText:@"Clear log"];
                    return cell;
                }
            }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath isEqual:[NSIndexPath indexPathForRow:ResetCell inSection:TopSection]]) {
        NSMutableDictionary *dict = [[EVSPreferenceManager logDict] mutableCopy];
        dict[@"data"] = @[];
        [EVSPreferenceManager setLogDict:dict];
        [self refresh];
    }

    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}


#pragma mark - editing

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [indexPath section] == LogSection;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete && [indexPath section] == LogSection) {
        NSMutableDictionary *dict = [[EVSPreferenceManager logDict] mutableCopy];

        [log removeObjectAtIndex:[indexPath row]];
        [dict setObject:log forKey:@"data"];
        [EVSPreferenceManager setLogDict:dict];

        [[self tableView] deleteRowsAtIndexPaths:@[indexPath]
                                withRowAnimation:UITableViewRowAnimationMiddle];
    }
}

#pragma mark - model

- (void)switchValueDidChange:(UISwitch *)toggle {
    [EVSPreferenceManager setLogging:[toggle isOn]];
}

- (void)refresh {
    log = [[[[EVSPreferenceManager logDict][@"data"] reverseObjectEnumerator] allObjects] mutableCopy];
    [[self tableView] reloadSections:[NSIndexSet indexSetWithIndex:LogSection] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end

