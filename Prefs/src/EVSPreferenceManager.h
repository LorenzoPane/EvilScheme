#import <Foundation/Foundation.h>
#import <EvilKit/EvilKit.h>
#import "EVSAppAlternativeWrapper.h"

@interface EVSPreferenceManager : NSObject

+ (NSArray<EVSAppAlternativeWrapper *> *)appAlternatives;
+ (void)storeAppAlternative:(EVSAppAlternativeWrapper *)appAlternative;
+ (L0DictionaryController<NSArray<EVSAppAlternativeWrapper *> *> *)presets;

@end
