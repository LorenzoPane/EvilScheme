#import "EVSAppAlternativeWrapper.h"

@implementation EVSAppAlternativeWrapper

- (instancetype)init {
    return [self initWithAppAlternative:nil name:nil];
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
    return [[self orig] setTargetBundleID:bundleID];
}

- (NSString *)substituteBundleID {
    return [[self orig] substituteBundleID];
}

- (void)setSubstituteBundleID:(NSString *)bundleID {
    return [[self orig] setSubstituteBundleID:bundleID];
}

- (NSDictionary<NSString *, NSArray<id <EVKURLPortion>> *> *)urlOutlines {
    return [[self orig] urlOutlines];
}

- (void)setUrlOutlines:(NSDictionary<NSString *, NSArray<id <EVKURLPortion>> *> *)outlines {
    return [[self orig] setUrlOutlines:outlines];
}

@end
