#import <Foundation/Foundation.h>
#import <EvilKit/EvilKit.h>

@interface EVSPreferenceManager : NSObject
+ (NSDictionary<NSString *, EVKAppAlternative *> *)appAlternatives;
@end
