#import "EVKURLPortions.h"

#define set(...) [NSOrderedSet orderedSetWithObjects:__VA_ARGS__, nil]

@implementation EVKRegexSubstitutionPortion

- (instancetype)initWithRegex:(NSString *)regex
                     template:(NSString *)templet
    percentEncodingIterations:(int)iterations {
    if((self = [super initWithPercentEncodingIterations:iterations])) {
        _regex = regex;
        _templet = templet;
    }

    return self;
}

+ (instancetype)portionWithRegex:(NSString *)regex
                        template:(NSString *)templet
       percentEncodingIterations:(int)iterations {
    return [[[self class] alloc] initWithRegex:regex
                                      template:templet
                     percentEncodingIterations:iterations];
}

- (instancetype)init {
    return [self initWithRegex:@"" template:@""percentEncodingIterations:0];
}

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url {
    NSMatchingOptions opts = NSMatchingWithTransparentBounds | NSMatchingWithoutAnchoringBounds;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:_regex
                                                                           options:0
                                                                             error:nil];
    return [regex stringByReplacingMatchesInString:[url absoluteString]
                                           options:opts
                                             range:NSMakeRange(0, [[url absoluteString] length])
                                      withTemplate:[self templet]];
}

- (NSString *)stringRepresentation { return @"Regex substitution"; }

// Coding {{{
- (NSOrderedSet<NSString *> *)endUserAccessibleKeys {
    return set(@"regex", @"templet", @"percentEncodingIterations");
}

+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:_regex forKey:@"regex"];
    [coder encodeObject:_templet forKey:@"templet"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithRegex:[coder decodeObjectOfClass:[NSRegularExpression class] forKey:@"regex"]
                      template:[coder decodeObjectOfClass:[NSString class] forKey:@"templet"]
     percentEncodingIterations:[coder decodeIntForKey:@"percentEncodingIterations"] ];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[self class] portionWithRegex:[self regex]
                                 template:[self templet]
                percentEncodingIterations:[[self percentEncodingIterations] intValue]];
}
// }}}

@end
