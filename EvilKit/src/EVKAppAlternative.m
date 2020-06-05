#import "EVKAppAlternative.h"

@implementation EVKAppAlternative

- (instancetype)initWithTargetBundleID:(NSString *)targetBundleID
                    substituteBundleID:(NSString *)substituteBundleID
                           urlOutlines:(NSArray<EVKAction *> *)outlines {
    if((self = [super init])) {
        _targetBundleID = targetBundleID;
        _substituteBundleID = substituteBundleID;
        _urlOutlines = outlines;
    }

    return self;
}

- (instancetype)init {
    return [self initWithTargetBundleID:@""
                     substituteBundleID:@""
                            urlOutlines:@[]];
}

- (NSURL *)transformURL:(NSURL *)url {
    NSURL *ret;
    for(EVKAction *action in [self urlOutlines]) {
        if((ret = [action transformURL:url])) {
            return ret;
        }
    }

    return nil;
}

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:[self targetBundleID] forKey:@"targetBundleID"];
    [coder encodeObject:[self substituteBundleID] forKey:@"substituteBundleID"];
    [coder encodeObject:[self urlOutlines] forKey:@"urlOutlines"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithTargetBundleID:[coder decodeObjectOfClass:[NSString class] forKey:@"targetBundleID"]
                     substituteBundleID:[coder decodeObjectOfClass:[NSString class] forKey:@"substituteBundleID"]
                            urlOutlines:[coder decodeObjectOfClass:[NSDictionary class] forKey:@"urlOutlines"]];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[[self class] alloc] initWithTargetBundleID:[self targetBundleID]
                                     substituteBundleID:[self substituteBundleID]
                                            urlOutlines:[self urlOutlines]];
}
// }}}

@end
