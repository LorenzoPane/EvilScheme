#import "EVKURLPortions.h"

#define set(...) [NSOrderedSet orderedSetWithObjects:__VA_ARGS__, nil]

@implementation EVKRegexSubstitutionPortion

- (instancetype)initWithRegex:(NSRegularExpression *)regex
                     template:(NSString *)templet
               percentEncoded:(BOOL)percentEncoded {
    if((self = [super initWithPercentEncoding:percentEncoded])) {
        _regex = regex;
        _templet = templet;
    }

    return self;
}

+ (instancetype)portionWithRegex:(NSRegularExpression *)regex
                        template:(NSString *)templet
                  percentEncoded:(BOOL)percentEncoded {
    return [[[self class] alloc] initWithRegex:regex
                                      template:templet
                                percentEncoded:percentEncoded];
}

- (instancetype)init {
    return [self initWithRegex:[NSRegularExpression new] template:@"" percentEncoded:NO];
}

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url {
    NSMatchingOptions opts = NSMatchingWithTransparentBounds | NSMatchingWithoutAnchoringBounds;
    return [_regex stringByReplacingMatchesInString:[url absoluteString]
                                            options:opts
                                              range:NSMakeRange(0, [[url absoluteString] length])
                                       withTemplate:[self templet]];
}

- (NSString *)stringRepresentation { return @"Regex substitution"; }

// Coding {{{
- (NSOrderedSet<NSString *> *)endUserAccessibleKeys {
    return set(@"regex", @"templet", @"percentEncoded");
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
                percentEncoded:[coder decodeBoolForKey:@"percentEncoded"] ];
}
// }}}

@end
