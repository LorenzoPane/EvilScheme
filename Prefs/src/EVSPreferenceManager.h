#import <Foundation/Foundation.h>
#import <EvilKit/EvilKit.h>
#import "EVSAppAlternativeWrapper.h"

@interface EVSPreferenceManager : NSObject
+ (NSArray<EVSAppAlternativeWrapper *> *)appAlternatives;
@end
