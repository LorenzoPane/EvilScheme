#import "EVSAppAlternativeWrapper.h"

@implementation EVSAppAlternativeWrapper

- (instancetype)init {
    return [self initWithAppAlternative:[EVKAppAlternative new] name:@""];
}

- (instancetype)initWithAppAlternative:(EVKAppAlternative *)app name:(NSString *)name {
    if((self = [super init])) {
        _orig = app;
        _name = name;
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

- (NSDictionary *)dict {
    return [self urlOutlines];
}
- (void)setDict:(NSDictionary *)dict {
    [self setUrlOutlines:dict];
}

// Coding {{{

+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:[self orig] forKey:@"orig"];
    [coder encodeObject:[self name] forKey:@"name"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithAppAlternative:[coder decodeObjectForKey:@"orig"]
                                   name:[coder decodeObjectForKey:@"name"]];
}

// }}}

@end
