#import <EvilKit/EvilKit.h>
#import "EVSAppAlternativeVC.h"
#import "../L0Prefs/L0Prefs.h"

@interface EVSPresetListVC : L0PrefVC
@property (atomic, strong) L0DictionaryController<NSArray<EVSAppAlternativeWrapper *> *> *presets;
@end
