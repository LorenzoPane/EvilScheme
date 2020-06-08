#import "EVSAppAlternativeWrapper.h"

@implementation EVSAppAlternativeWrapper

- (instancetype)init {
    return [self initWithAppAlternative:[EVKAppAlternative new] name:@""];
}

- (instancetype)initWithAppAlternative:(EVKAppAlternative *)app
                                  name:(NSString *)name
                       targetBundleIDs:(NSArray<NSString *> *)targets {
    if((self = [super init])) {
        _orig = app;
        _name = name;
        _targetBundleIDs = [(targets ? : @[]) mutableCopy];
        if(![_targetBundleIDs containsObject:[app targetBundleID]]) {
            [_targetBundleIDs addObject:[app targetBundleID]];
        }
    }

    return self;
}

- (instancetype)initWithAppAlternative:(EVKAppAlternative *)app name:(NSString *)name {
    return [self initWithAppAlternative:app
                                   name:name
                        targetBundleIDs:@[]];
}

- (NSString *)substituteBundleID {
    return [[self orig] substituteBundleID];
}

- (void)setSubstituteBundleID:(NSString *)bundleID {
    [[self orig] setSubstituteBundleID:bundleID];
}

- (NSArray<EVKAction *> *)urlOutlines {
    return [[self orig] urlOutlines];
}

- (void)setUrlOutlines:(NSArray<EVKAction *> *)outlines {
   [[self orig] setUrlOutlines:outlines];
}

// Coding {{{

+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:[self orig] forKey:@"orig"];
    [coder encodeObject:[self name] forKey:@"name"];
    [coder encodeObject:[self targetBundleIDs] forKey:@"targetBundleIDs"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithAppAlternative:[coder decodeObjectForKey:@"orig"]
                                   name:[coder decodeObjectForKey:@"name"]
                        targetBundleIDs:[coder decodeObjectForKey:@"targetBundleIDs"]];
}

// }}}

@end
