#import "../L0Prefs/L0Prefs.h"

@interface EVSKeyValuePairVC : L0PrefVC <L0TextCellDelegate>

@property (atomic, strong) NSString *key;
@property (atomic, strong) NSString *value;

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value;

@end
