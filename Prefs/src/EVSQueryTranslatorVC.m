#import "../L0Prefs/L0Prefs.h"
#import "EVSQueryTranslatorVC.h"
#import "EVSQueryLexiconVC.h"

@implementation EVSQueryTranslatorVC

#pragma mark - lifecycle

- (instancetype)initWithDictionary:(NSDictionary<NSString *,EVKQueryItemLexicon *> *)dict {
    if((self = [super init])) {
        _dict = [[L0DictionaryController alloc] initWithDict:dict];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
}

- (void)setupNav {
    [self setTitle:@"Configure query translator"];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditing)]];
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self dict] count] + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Query fields";
}

#pragma mark - cells

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath row] < [[self dict] count]) {
        L0LinkCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:LINK_CELL_ID forIndexPath:indexPath];
        [[cell textLabel] setText:[[self dict] keyAtIndex:[indexPath row]]];
        return cell;
    } else {
        L0ButtonCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:BUTTON_CELL_ID forIndexPath:indexPath];
        [[cell textLabel] setText:@"Add new"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EVSQueryLexiconVC *ctrl;
    if([indexPath row] < [[self dict] count]) {
        ctrl = [[EVSQueryLexiconVC alloc] initWithKey:[[self dict] keyAtIndex:[indexPath row]]
                                              lexicon:[[EVSQueryLexiconWrapper alloc] initWithLexicon:[[self dict] objectAtIndex:[indexPath row]]]];

    } else {
        ctrl = [[EVSQueryLexiconVC alloc] initWithKey:@"" lexicon:[[EVSQueryLexiconWrapper alloc] initWithLexicon:[EVKQueryItemLexicon new]]];
    }

    [ctrl setDelegate:self];
    [[self navigationController] pushViewController:ctrl animated:YES];
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - editing

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [[self dict] removeObjectAtIndex:[indexPath row]];
        [[self tableView] deleteRowsAtIndexPaths:@[indexPath]
                                withRowAnimation:UITableViewRowAnimationMiddle];
        [[self delegate] controllerDidChangeModel:self];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [indexPath row] < [[self dict] count];
}

- (void)toggleEditing {
    [[self tableView] setEditing:![[self tableView] isEditing] animated:YES];
    [[[self navigationItem] rightBarButtonItem] setTitle:([[self tableView] isEditing] ? @"Done" : @"Edit")];
}

#pragma mark - model

- (BOOL)controller:(L0PrefVC *)controller canMoveFromKey:(NSString *)from toKey:(NSString *)to {
    return !([to isEqualToString:@""] || [[self dict] containsKey:to]);
}

- (void)controller:(L0PrefVC *)controller willMoveFromKey:(NSString *)from toKey:(NSString *)to {
    [[self dict] renameKey:from toString:to];
    [super controllerDidChangeModel:controller];
}

- (void)controllerDidChangeModel:(EVSQueryLexiconVC *)controller {
    [[self dict] setObject:[[controller lex] lex] forKey:[controller key]];
    [super controllerDidChangeModel:controller];
}

@end
