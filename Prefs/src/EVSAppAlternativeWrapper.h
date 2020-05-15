#import <Foundation/Foundation.h>
#import <EvilKit/EvilKit.h>
#import "../L0Prefs/L0Prefs.h"

@interface EVSAppAlternativeWrapper : L0DictionaryController <NSSecureCoding>

@property (atomic, strong) EVKAppAlternative *orig;
@property (atomic, strong) NSString *name;

- (instancetype)initWithAppAlternative:(EVKAppAlternative *)app name:(NSString *)name;
- (NSString *)targetBundleID;
- (void)setTargetBundleID:(NSString *)bundleID;
- (NSString *)substituteBundleID;
- (void)setSubstituteBundleID:(NSString *)bundleID;
- (NSDictionary<NSString *, NSArray<NSObject<EVKURLPortion> *> *> *)urlOutlines;
- (void)setUrlOutlines:(NSDictionary<NSString *, NSArray<NSObject<EVKURLPortion> *> *> *)outlines;

@end
