#import "EVSExperimentalPrefsVC.h"
#import "EVSPreferenceManager.h"

@implementation EVSExperimentalPrefsVC

#pragma mark - lifecycle

- (void)viewDidLoad {
    [self setTitle:@"Experimental Preferences"];

    [super viewDidLoad];
}

#pragma mark - table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"To apply changes to default search engines, you may have to re-apply browser presets";
}

#pragma mark - cells

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    L0PickerCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:PICKER_CELL_ID forIndexPath:indexPath];
    [cell setDelegate:self];
    [cell setLabelText:@"Search Engine"];
    [[cell field] setText:[EVSPreferenceManager searchEngine]];
    [cell setOptions:@[@"DuckDuckGo", @"Google", @"Yahoo", @"Bing"]];

    return cell;
}

- (void)textFieldDidChange:(UITextField *)field {
    [EVSPreferenceManager setSearchEngine:[field text]];
}

@end
