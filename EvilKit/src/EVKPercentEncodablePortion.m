#import "EVKURLPortions.h"

#define set(...) [NSOrderedSet orderedSetWithObjects:__VA_ARGS__, nil]

@implementation EVKPercentEncodablePortion

+ (instancetype)portionWithPercentEncodingIterations:(int)iterations {
    return [[[self class] alloc] initWithPercentEncodingIterations:iterations];
}

- (instancetype)initWithPercentEncodingIterations:(int)iterations {
    if((self = [super init])) {
        _percentEncodingIterations = @(iterations);
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithPercentEncodingIterations:0];
}

- (NSString *)stringRepresentation { return @""; }

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url { return nil; }

- (NSString *)evaluateWithURL:(NSURL *)url {
    NSString *ret = [self evaluateUnencodedWithURL:url];
    int iters = [[self percentEncodingIterations] intValue];
    while(iters != 0) {
        if(iters < 0) {
            iters += 1;
            ret = percentDecode(ret);
        } else {
            iters -= 1;
            ret = percentEncode(ret);
        }
    }
    return ret ? : @"";
}

// Coding {{{
- (NSOrderedSet<NSString *> *)endUserAccessibleKeys {
    return set(@"percentEncodingIterations");
}

+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInt:[[self percentEncodingIterations] intValue] forKey:@"percentEncodingIterations"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithPercentEncodingIterations:[coder decodeIntForKey:@"percentEncodingIterations"]];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[self class] portionWithPercentEncodingIterations:[[self percentEncodingIterations] intValue]];
}
// }}}

@end
