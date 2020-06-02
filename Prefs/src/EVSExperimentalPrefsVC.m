#import "EVSExperimentalPrefsVC.h"
#import "EVSPreferenceManager.h"

@implementation EVSExperimentalPrefsVC {
    NSMutableArray<NSString *> *blacklist;
}

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [[self tableView] setEditing:YES animated:YES];
    [self setupNav];
    blacklist = [[EVSPreferenceManager blacklistedApps] mutableCopy];
}

- (void)setupNav {
    [self setTitle:@"Experimental Preferences"];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(saveSettings)]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [EVSPreferenceManager setBlacklistedApps:blacklist];
}

#pragma mark - table

NS_ENUM(NSInteger, ExperimentalPrefsSections) {
    SearchEngineSection,
    BlacklistedAppSection,
};

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SearchEngineSection:
            return 1;
        case BlacklistedAppSection:
            return [blacklist count] + 1;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case SearchEngineSection:
            return @"Spotlight search engine";
        case BlacklistedAppSection:
            return @"Disabled apps";
        default:
            return @"";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    switch(section) {
        case SearchEngineSection:
            return @"To apply changes to default search engines, you may have to re-apply browser presets from the presets menu";
        case BlacklistedAppSection:
            return @"Links opened from these apps will use stock behavior";
        default:
            return @"";
    }
}

#pragma mark - cells

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch([indexPath section]) {
        case SearchEngineSection: {
            L0PickerCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:PICKER_CELL_ID forIndexPath:indexPath];
            [cell setDelegate:self];
            [[cell textLabel] setText:@"Engine"];
            [[cell field] setText:[EVSPreferenceManager searchEngine]];
            [[cell field] setTag:-1];
            [cell setOptions:@[@"DuckDuckGo", @"Google", @"Yahoo", @"Bing"]];

            return cell;
        }
        case BlacklistedAppSection: {
            if([indexPath row] < [blacklist count]) {
                L0PureEditTextCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:PURE_EDIT_TEXT_CELL_ID forIndexPath:indexPath];
                [cell setDelegate:self];
                [[cell field] setTag:[indexPath row]];
                [[cell field] setPlaceholder:@"ex. com.saurik.Cydia"];
                [[cell field] setText:blacklist[[indexPath row]]];

                return cell;
            } else {
                UITableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:BASIC_CELL_ID forIndexPath:indexPath];
                [[cell textLabel] setText:@"Add new"];

                return cell;
            }

            return nil;
        }
        default:
            return nil;
    }
}

#pragma mark - editing

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [indexPath section];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath section]) {
        if([indexPath row] < [blacklist count]) {
            return UITableViewCellEditingStyleDelete;
        }
        return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(editingStyle) {
        case UITableViewCellEditingStyleDelete:
            [blacklist removeObjectAtIndex:[indexPath row]];
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case UITableViewCellEditingStyleInsert:
            [blacklist addObject:@""];
            [[self tableView] insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            break;
    }
}

#pragma mark - model

- (void)textFieldDidChange:(UITextField *)field {
    if([field tag] == -1) {
        [EVSPreferenceManager setSearchEngine:[field text]];
    } else {
        blacklist[[field tag]] = [[field text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}

- (void)saveSettings {
    [EVSPreferenceManager setBlacklistedApps:blacklist];
    UIAlertController *ctrl = [UIAlertController alertControllerWithTitle:@"Saved" message:@"Preferences applied" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:ctrl animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [ctrl dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
