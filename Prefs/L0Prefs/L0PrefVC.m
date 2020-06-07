#import "L0Prefs.h"

@implementation L0PrefVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTable];
}

+ (UIWindow *)keyWindow {
    NSArray *windows = [[UIApplication sharedApplication] windows];
    UIWindow *ret = nil;
    for (UIWindow *window in windows) {
        if (window.isKeyWindow) {
            ret = window;
            break;
        }
    }
    return ret;
}

- (void)setupTable {
    [self setCells:@{
        LINK_CELL_ID           : [L0LinkCell class],
        BASIC_CELL_ID          : [L0DataCell class],
        PICKER_CELL_ID         : [L0PickerCell class],
        PROSE_CELL_ID          : [L0ProseCell class],
        BUTTON_CELL_ID         : [L0ButtonCell class],
        TOGGLE_CELL_ID         : [L0ToggleCell class],
        STEPPER_CELL_ID        : [L0StepperCell class],
        EDIT_TEXT_CELL_ID      : [L0EditTextCell class],
        PURE_EDIT_TEXT_CELL_ID : [L0PureEditTextCell class],
    }];

    [self setTableView:[[UITableView alloc] initWithFrame:CGRectZero
                                                    style:UITableViewStyleGrouped]];

    [[self tableView] setDataSource:self];
    [[self tableView] setDelegate:self];
    [[self tableView] setRowHeight:44];
    [[self tableView] setAllowsMultipleSelectionDuringEditing:NO];

    for(NSString *reuseID in [self cells]) {
        [[self tableView] registerClass:[self cells][reuseID]
                 forCellReuseIdentifier:reuseID];
    }

    [self setView:[self tableView]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIWindow *window = [L0PrefVC keyWindow];
    if (!window) {
        window = [[[UIApplication sharedApplication] windows] firstObject];
    }
    if ([window respondsToSelector:@selector(setTintColor:)]) {
        [window setTintColor:TINT_COLOR];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self isRootVC]) {
        UIWindow *window = [L0PrefVC keyWindow];
        if (!window) {
            window = [[[UIApplication sharedApplication] windows] firstObject];
        }
        if ([window respondsToSelector:@selector(setTintColor:)]) {
            [window setTintColor:nil];
        }
    }
}

- (void)controllerDidChangeModel:(L0PrefVC *)controller {
    [[self tableView] reloadData];
    [[self delegate] controllerDidChangeModel:self];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (BOOL)isRootVC { return NO; }

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
}

@end
