#import "EVSKeyValuePairVC.h"

@implementation EVSKeyValuePairVC

#pragma mark - lifecycle

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value {
    if((self = [super init])) {
        _key = key;
        _value = value;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setTitle:[self key]];
}

- (void)setupNav {
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                               target:self
                                                                                               action:@selector(dismiss)]];
}

- (void)dismiss {
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Translate argument";
}

#pragma mark - cells

NS_ENUM(NSUInteger, KeyValuePairCells) {
    KeyTag,
    ValueTag,
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    L0EditTextCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:EDIT_TEXT_CELL_ID forIndexPath:indexPath];
    [[cell field] setTag:[indexPath row]];
    [cell setDelegate:self];
    switch([indexPath row]) {
        case KeyTag: {
            [[cell textLabel] setText:@"To"];
            [[cell field] setText:[self value]];
        }
        case ValueTag: {
            [[cell textLabel] setText:@"From"];
            [[cell field] setText:[self key]];
        }
    }

    return cell;
}

#pragma mark - model

- (void)textFieldDidChange:(UITextField *)field {
    NSString *txt = [field text];
    switch([field tag]) {
        case KeyTag: {
            if([[self delegate] controller:self canMoveFromKey:[self key] toKey:txt]) {
                [[self delegate] controller:self willMoveFromKey:[self key] toKey:txt];
                [self setKey:[field text]];
                [self setTitle:[field text]];
            }
            break;
        }
        case ValueTag: {
            [self setValue:txt];
            [[self delegate] controllerDidChangeModel:self];
            break;
        }
    }
}

@end
