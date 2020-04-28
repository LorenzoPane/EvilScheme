#import "EVKURLPortions.h"

#define set(...) [NSOrderedSet orderedSetWithObjects:__VA_ARGS__, nil]

@implementation EVKPercentEncodablePortion

+ (instancetype)portionWithPercentEncoding:(BOOL)percentEncoded {
    return [[[self class] alloc] initWithPercentEncoding:percentEncoded];
}

- (instancetype)initWithPercentEncoding:(BOOL)percentEncoded {
    if((self = [super init])) {
        _percentEncoded = @(percentEncoded);
    }

    return self;
}

- (instancetype)init {
    return [self initWithPercentEncoding:NO];
}

- (NSString *)stringRepresentation { return @""; }

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url { return nil; }

- (NSString *)evaluateWithURL:(NSURL *)url {
    NSString *ret = [self evaluateUnencodedWithURL:url];
    return ([[self isPercentEncoded] boolValue] ? percentEncode(ret) : ret) ? : @"";
}

// Coding {{{
- (NSOrderedSet<NSString *> *)endUserAccessibleKeys {
    return set(@"percentEncoded");
}

+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeBool:[[self isPercentEncoded] boolValue] forKey:@"percentEncoded"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithPercentEncoding:[coder decodeBoolForKey:@"percentEncoded"]];
}
// }}}

@end
