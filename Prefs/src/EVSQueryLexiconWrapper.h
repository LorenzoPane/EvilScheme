#import <Foundation/Foundation.h>
#import "../L0Prefs/L0Prefs.h"

@interface EVSQueryLexiconWrapper : L0DictionaryController

@property (atomic, strong) EVKQueryItemLexicon *lex;

- (instancetype)initWithLexicon:(EVKQueryItemLexicon *)lex;

- (NSString *)defaultState;
- (void)setDefaultState:(NSString *)state;

- (NSString *)param;
- (void)setParam:(NSString *)str;

@end
