#import "EVSPresetListVC.h"
#import "EVSPreferenceManager.h"
#import "EVSAppAlternativeVC.h"

@implementation EVSPresetListVC

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setPresets:[EVSPreferenceManager presets]];
    [[self tableView] setSectionFooterHeight:0];
}

- (void)setupNav {
    [self setTitle:@"Presets"];
    [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                              target:self
                                                                                              action:@selector(dismiss)]];
}

- (void)dismiss {
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - table

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self presets] keyAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self presets] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self presets] objectAtIndex:section] count];
}

#pragma mark - cells

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    L0LinkCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:LINK_CELL_ID forIndexPath:indexPath];
    [[cell textLabel] setText:[[[[self presets] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] name]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [(EVSAppAlternativeVC *)[self delegate] setAppAlternative:[[[self presets] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]]];
    [[self delegate] controllerDidChangeModel:nil];
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self dismiss];
}

@end
