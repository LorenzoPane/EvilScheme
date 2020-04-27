#import "EVSAppAlternativeWrapper.h"

@implementation EVSAppAlternativeWrapper

- (instancetype)init {
    return [self initWithAppAlternative:[EVKAppAlternative new] name:@""];
}

- (instancetype)initWithAppAlternative:(EVKAppAlternative *)app
                                  name:(NSString *)name {
    if((self = [super init])) {
        _orig = app;
        _name = name;
        _enabled = YES;
    }

    return self;
}

- (NSString *)targetBundleID {
    return [[self orig] targetBundleID];
}

- (void)setTargetBundleID:(NSString *)bundleID {
    [[self orig] setTargetBundleID:bundleID];
}

- (NSString *)substituteBundleID {
    return [[self orig] substituteBundleID];
}

- (void)setSubstituteBundleID:(NSString *)bundleID {
    [[self orig] setSubstituteBundleID:bundleID];
}

- (NSDictionary<NSString *, NSArray<NSObject<EVKURLPortion> *> *> *)urlOutlines {
    return [[self orig] urlOutlines];
}

- (void)setUrlOutlines:(NSDictionary<NSString *, NSArray<NSObject <EVKURLPortion> *> *> *)outlines {
   [[self orig] setUrlOutlines:outlines];
}

@end
