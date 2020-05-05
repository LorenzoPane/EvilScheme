#import <EvilKit/EvilKit.h>
#import "../L0Prefs/L0Prefs.h"

@interface EVSQueryTranslatorVC : L0PrefVC

@property (atomic, strong) L0DictionaryController<EVKQueryItemLexicon *> *dict;
@property (atomic, assign) NSInteger tag;

- (instancetype)initWithDictionary:(NSDictionary<NSString *,EVKQueryItemLexicon *> *)dict;

@end
