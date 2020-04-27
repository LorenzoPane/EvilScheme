#import <Foundation/Foundation.h>
#import <EvilKit/EvilKit.h>

@interface EVSAppAlternativeWrapper : NSObject

@property EVKAppAlternative *orig;
@property NSString *name;
@property(getter=isEnabled) BOOL enabled;

- (instancetype)initWithAppAlternative:(EVKAppAlternative *)app
                                  name:(NSString *)name;
- (NSString *)targetBundleID;
- (void)setTargetBundleID:(NSString *)bundleID;
- (NSString *)substituteBundleID;
- (void)setSubstituteBundleID:(NSString *)bundleID;
- (NSDictionary<NSString *, NSArray<NSObject<EVKURLPortion> *> *> *)urlOutlines;
- (void)setUrlOutlines:(NSDictionary<NSString *, NSArray<NSObject<EVKURLPortion> *> *> *)outlines;

@end
