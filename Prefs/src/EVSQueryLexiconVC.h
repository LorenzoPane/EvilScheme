#import <EvilKit/EvilKit.h>
#import "../L0Prefs/L0Prefs.h"
#import "EVSQueryLexiconWrapper.h"

@interface EVSQueryLexiconVC : L0PrefVC <L0TextCellDelegate>

@property (atomic, strong) EVSQueryLexiconWrapper *lex;
@property (atomic, strong) NSString *key;

- (instancetype)initWithKey:(NSString *)key lexicon:(EVSQueryLexiconWrapper *)lex;

@end
