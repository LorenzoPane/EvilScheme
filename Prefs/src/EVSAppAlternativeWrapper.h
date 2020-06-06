#import <Foundation/Foundation.h>
#import <EvilKit/EvilKit.h>
#import "../L0Prefs/L0Prefs.h"

@interface EVSAppAlternativeWrapper : L0DictionaryController <NSSecureCoding>

@property (atomic, strong) EVKAppAlternative *orig;
@property (atomic, strong) NSString *name;
@property (atomic, strong) NSMutableArray<NSString *> *targetBundleIDs;

- (instancetype)initWithAppAlternative:(EVKAppAlternative *)app name:(NSString *)name;
- (instancetype)initWithAppAlternative:(EVKAppAlternative *)app
                                  name:(NSString *)name
                       targetBundleIDs:(NSArray<NSString *> *)targets;
- (NSString *)substituteBundleID;
- (void)setSubstituteBundleID:(NSString *)bundleID;
- (NSArray<EVKAction *> *)urlOutlines;
- (void)setUrlOutlines:(NSArray<EVKAction *> *)outlines;

@end
