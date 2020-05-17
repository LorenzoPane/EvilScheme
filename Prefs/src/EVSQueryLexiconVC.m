#import "../L0Prefs/L0Prefs.h"
#import "EVSQueryLexiconVC.h"
#import "EVSKeyValuePairVC.h"

@implementation EVSQueryLexiconVC

#pragma mark - lifecycle

- (instancetype)initWithKey:(NSString *)key lexicon:(EVSQueryLexiconWrapper *)lex {
    if((self = [super init])) {
        _key = key;
        _lex = lex;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
}

- (void)setupNav {
    [self setTitle:[self key]];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                                  style:UIBarButtonItemStyleDone
                                                                                 target:self
                                                                                 action:@selector(toggleEditing)]];
}

#pragma mark - table

NS_ENUM(NSUInteger, QueryLexiconVCSections) {
    MetaSection,
    SubstitutionSection,
};

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section ? [[self lex] count] + 1 : 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

#pragma mark - cells

NS_ENUM(NSUInteger, QueryLexiconTextFieldTags) {
    OldParamTag,
    NewParamTag,
    DefaultStateTag,
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch([indexPath section]) {
        case MetaSection: {
            L0EditTextCell *cell;
            switch([indexPath row]) {
                case OldParamTag: {
                    cell = [[self tableView] dequeueReusableCellWithIdentifier:EDIT_TEXT_CELL_ID forIndexPath:indexPath];
                    [[cell textLabel] setText:@"Old Parameter"];
                    [[cell field] setText:[self key]];
                    break;
                }
                case NewParamTag: {
                    cell = [[self tableView] dequeueReusableCellWithIdentifier:EDIT_TEXT_CELL_ID forIndexPath:indexPath];
                    [[cell textLabel] setText:@"New Parameter"];
                    [[cell field] setText:[[self lex] param]];
                    break;
                }
                case DefaultStateTag: {
                    cell = [[self tableView] dequeueReusableCellWithIdentifier:PICKER_CELL_ID forIndexPath:indexPath];
                    [[cell textLabel] setText:@"Default state"];
                    [[cell field] setText:[[self lex] defaultState]];
                    [(L0PickerCell *)cell setOptions:@[@"Exclude value", @"Keep original value"]];
                    break;
                }
            }
            [[cell field] setTag:[indexPath row]];
            [cell setDelegate:self];
            return cell;
        }
        case SubstitutionSection: {
            if([indexPath row] < [[self lex] count]) {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BASIC_CELL_ID];
                [[cell textLabel] setText:[[self lex] keys][[indexPath row]]];
                [[cell detailTextLabel] setText:[[self lex] objectAtIndex:[indexPath row]]];
                return cell;
            } else {
                L0ButtonCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:BUTTON_CELL_ID forIndexPath:indexPath];
                [[cell textLabel] setText:@"Add new"];
                return cell;
            }
        }
        default: return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath section] == SubstitutionSection) {
        NSInteger idx = [indexPath row];
        EVSKeyValuePairVC *ctrl = [EVSKeyValuePairVC alloc];

        if(idx < [[self lex] count]) {
            ctrl = [ctrl initWithKey:[[self lex] keys][idx]
                               value:[[self lex] objectAtIndex:idx]];
        } else {
            ctrl = [ctrl initWithKey:@"" value:@""];
        }

        [ctrl setDelegate:self];
        UINavigationController *child = [[UINavigationController alloc] initWithRootViewController:ctrl];
        [self presentViewController:child animated:YES completion:nil];
    }

    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - editing

- (void)toggleEditing {
    [[self tableView] setEditing:![[self tableView] isEditing] animated:YES];
    [[[self navigationItem] rightBarButtonItem] setTitle:([[self tableView] isEditing] ? @"Done" : @"Edit")];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [indexPath section] == SubstitutionSection && [indexPath row] < [[self lex] count];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle  == UITableViewCellEditingStyleDelete) {
        [[self lex] removeObjectAtIndex:[indexPath row]];
        [[self tableView] deleteRowsAtIndexPaths:@[indexPath]
                                withRowAnimation:UITableViewRowAnimationMiddle];
    }
}

#pragma mark - model

- (BOOL)controller:(L0PrefVC *)controller canMoveFromKey:(NSString *)from toKey:(NSString *)to {
    return !([[self lex] containsKey:to] || [to isEqualToString:@""]);
}

- (void)controllerDidChangeModel:(EVSKeyValuePairVC *)controller {
    [[self lex] setObject:[controller value] forKey:[controller key]];
    [super controllerDidChangeModel:controller];
}

- (void)controller:(L0PrefVC *)controller willMoveFromKey:(NSString *)from toKey:(NSString *)to {
    [[self lex] renameKey:from toString:to];
    [super controllerDidChangeModel:controller];
}

- (void)textFieldDidChange:(UITextField *)field {
    switch([field tag]) {
        case OldParamTag: {
            if([[self delegate] controller:self canMoveFromKey:[self key] toKey:[field text]]) {
                [[self delegate] controller:self willMoveFromKey:[self key] toKey:[field text]];
                [self setKey:[field text]];
                [self setTitle:[field text]];
            }
            break;
        }
        case NewParamTag: {
            [[self lex] setParam:[field text]];
            [[self delegate] controllerDidChangeModel:self];
            break;
        }
        case DefaultStateTag: {
            [[self lex] setDefaultState:[field text]];
            [[self delegate] controllerDidChangeModel:self];
            break;
        }
    }
}

@end
