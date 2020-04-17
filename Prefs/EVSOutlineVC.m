#import "EVSOutlineVC.h"

NS_ENUM(NSInteger, OutlineVCSection) {
    RegexSection,
    PortionSection,
};

NS_ENUM(NSInteger, OutlineTextFieldTags) {
    RegexTag,
    TestURLTag,
};

@implementation EVSOutlineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupTable];
}

- (void)setupNav {
    [self setTitle:@"Edit URL Outline"];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                target:self
                                                                                action:@selector(toggleEditing)];
    [[self navigationItem] setRightBarButtonItem:editButton];
}

- (void)toggleEditing {
    [[self tableView] setEditing:![[self tableView] isEditing] animated:YES];
    [[[self navigationItem] rightBarButtonItem] setTitle:([[self tableView] isEditing] ? @"Done" : @"Edit")];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch([indexPath section]) {
        case RegexSection: {
            EVSEditTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditTextCell" forIndexPath:indexPath];
            [[cell textLabel] setText:@"Regex"];
            [[cell field] setText:[self regex]];
            [cell setDelegate:self];
            return cell;
        }
        case PortionSection: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell" forIndexPath:indexPath];
            id<EVKURLPortion> item = [self outline][[indexPath row]];
            [[cell textLabel] setText:[item stringRepresentation]];
            return cell;
        }
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell" forIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section) {
        case RegexSection:
            return 1;
        case PortionSection:
            return [[self outline] count];
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case RegexSection:
            return @"Trigger";
        case PortionSection:
            return @"Pieces";
        default:
            return @"";
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    return [proposedDestinationIndexPath section] == PortionSection ? proposedDestinationIndexPath : sourceIndexPath;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [indexPath section] == PortionSection;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return [indexPath section] == PortionSection;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id<EVKURLPortion> obj = [self outline][[sourceIndexPath row]];
    [[self outline] removeObjectAtIndex:[sourceIndexPath row]];
    [[self outline] insertObject:obj atIndex:[destinationIndexPath row]];
    [[self delegate] controllerDidChangeModel:self];
}

- (void)textFieldDidChange:(UITextField *)field {
    if([field tag] == RegexTag) {
        [self setRegex:[field text]];
        [[self delegate] controllerDidChangeModel:self];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath section] == PortionSection) {
        //EVSPortionVC *ctrl = [[EVSPortionVC alloc] init];
        //[ctrl setPortion:[self outline][[indexPath row]]];
        //[ctrl setModalPresentationStyle:UIModalPresentationFormSheet];
        //[ctrl setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        //[self presentViewController:ctrl animated:YES completion:nil];
    }
    [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
}

@end
