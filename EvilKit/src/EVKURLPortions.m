#import "EVKURLPortions.h"
#import "NSURL+ComponentAdditions.h"

#define set(...) [NSOrderedSet orderedSetWithObjects:__VA_ARGS__, nil]

@implementation EVKFullURLPortion

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url { return [url absoluteString]; }

- (NSString *)stringRepresentation { return @"Full URL"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { [super encodeWithCoder:coder]; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [super initWithCoder:coder]; }

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[self class] portionWithPercentEncodingIterations:[[self percentEncodingIterations] intValue]];
}
// }}}

@end

@implementation EVKTrimmedPathPortion

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url { return [url trimmedPathComponent]; }

- (NSString *)stringRepresentation { return @"Path"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { [super encodeWithCoder:coder]; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [super initWithCoder:coder]; };

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[self class] portionWithPercentEncodingIterations:[[self percentEncodingIterations] intValue]];
}
// }}}

@end

@implementation EVKTrimmedResourceSpecifierPortion

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url { return [url trimmedResourceSpecifier]; }

- (NSString *)stringRepresentation { return @"Resource specifier"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { [super encodeWithCoder:coder]; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [super initWithCoder:coder]; };

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[self class] portionWithPercentEncodingIterations:[[self percentEncodingIterations] intValue]];
}
// }}}

@end

@implementation EVKHostPortion

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url { return [url hostComponent]; }

- (NSString *)stringRepresentation { return @"Host domain"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { [super encodeWithCoder:coder]; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [super initWithCoder:coder]; };

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[self class] portionWithPercentEncodingIterations:[[self percentEncodingIterations] intValue]];
}
// }}}

@end

@implementation EVKSchemePortion

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url {
    return [url scheme];
}

- (NSString *)stringRepresentation { return @"Original scheme"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { [super encodeWithCoder:coder]; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [super initWithCoder:coder]; };

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[self class] portionWithPercentEncodingIterations:[[self percentEncodingIterations] intValue]];
}
// }}}

@end

@implementation EVKQueryPortion

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url { return [url queryString]; }

- (NSString *)stringRepresentation { return @"Original query"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { [super encodeWithCoder:coder]; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [super initWithCoder:coder]; };

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[self class] portionWithPercentEncodingIterations:[[self percentEncodingIterations] intValue]];
}
// }}}

@end

@implementation EVKFragmentPortion

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url {
    return [url fragmentString];
}

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { [super encodeWithCoder:coder]; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [super initWithCoder:coder]; };

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[self class] portionWithPercentEncodingIterations:[[self percentEncodingIterations] intValue]];
}
// }}}
@end

@implementation EVKQueryParameterValuePortion : EVKPercentEncodablePortion

- (instancetype)initWithParameter:(NSString *)param
        percentEncodingIterations:(int)iterations {
    if((self = [super initWithPercentEncodingIterations:iterations])) {
        _parameter = param;
    }

    return self;
}

- (instancetype)init {
    return [self initWithParameter:@"" percentEncodingIterations:0];
}

+ (instancetype)portionWithParameter:(NSString *)param
           percentEncodingIterations:(int)iterations {
    return [[self alloc] initWithParameter:param percentEncodingIterations:iterations];
}

- (NSString *)stringRepresentation { return @"Query parameter"; }

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url { return [url queryValueForParameter:[self parameter]]; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:[self parameter] forKey:@"parameter"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithParameter:[coder decodeObjectForKey:@"parameter"]
         percentEncodingIterations:[coder decodeIntForKey:@"percentEncodingIterations"]];
}

- (NSOrderedSet<NSString *> *)endUserAccessibleKeys {
    return set(@"parameter", @"percentEncodingIterations");
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[self class] portionWithPercentEncodingIterations:[[self percentEncodingIterations] intValue]];
}
// }}}

@end
