#import "EVKURLPortions.h"
#import "NSURL+ComponentAdditions.h"
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

@implementation EVKStaticStringPortion

- (instancetype)initWithString:(NSString *)str percentEncoded:(BOOL)percentEncoded {
    if((self = [super initWithPercentEncoding:percentEncoded])) {
        _string = str;
    }

    return self;
}

- (instancetype)init {
    return [self initWithString:@"" percentEncoded:NO];
}

+ (instancetype)portionWithString:(NSString *)str percentEncoded:(BOOL)percentEncoded {
    return [[EVKStaticStringPortion alloc] initWithString:str percentEncoded:percentEncoded];
}

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url { return [self string]; }

- (NSString *)stringRepresentation {
    return [NSString stringWithFormat:@"Text: %@", [self string]];
}

// Coding {{{
- (NSOrderedSet<NSString *> *)endUserAccessibleKeys {
    return set(@"string", @"percentEncoded");
}

+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:[self string] forKey:@"string"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithString:[coder decodeObjectOfClass:[NSString class] forKey:@"string"]
                 percentEncoded:[coder decodeBoolForKey:@"percentEncoded"]];
}
// }}}

@end

@implementation EVKFullURLPortion

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url { return [url absoluteString]; }

- (NSString *)stringRepresentation { return @"Full URL"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { [super encodeWithCoder:coder]; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [super initWithCoder:coder]; }
// }}}

@end

@implementation EVKTrimmedPathPortion

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url { return [url trimmedPathComponent]; }

- (NSString *)stringRepresentation { return @"Path"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { [super encodeWithCoder:coder]; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [super initWithCoder:coder]; };
// }}}

@end

@implementation EVKTrimmedResourceSpecifierPortion

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url { return [url trimmedResourceSpecifier]; }

- (NSString *)stringRepresentation { return @"Resource specifier"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { [super encodeWithCoder:coder]; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [super initWithCoder:coder]; };
// }}}

@end

@implementation EVKHostPortion

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url { return [url hostComponent]; }

- (NSString *)stringRepresentation { return @"Host (domain)"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { return; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [self init]; };
// }}}

@end

@implementation EVKSchemePortion

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url {
    return [url scheme];
}

- (NSString *)stringRepresentation { return @"Original scheme"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { return; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [self init]; };
// }}}

@end

@implementation EVKQueryPortion

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url { return [url queryString]; }

- (NSString *)stringRepresentation { return @"Original query"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { return; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [self init]; }
// }}}

@end

@implementation EVKTranslatedQueryPortion

- (instancetype)initWithDictionary:(NSDictionary<NSString *, EVKQueryItemLexicon *> *)dict
                    percentEncoded:(BOOL)percentEncoded {
    if((self = [super initWithPercentEncoding:percentEncoded])) {
        _paramTranslations = dict;
    }

    return self;
}

- (instancetype)init {
    return [self initWithDictionary:@{} percentEncoded:NO];
}

+ (instancetype)portionWithDictionary:(NSDictionary<NSString *,EVKQueryItemLexicon *> *)dict
                       percentEncoded:(BOOL)percentEncoded {
    return [[[self class] alloc] initWithDictionary:dict percentEncoded:percentEncoded];
}

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url {
    NSMutableArray *items = [NSMutableArray new];
    EVKQueryItemLexicon *t;
    NSURLQueryItem *translatedItem;

    for(NSURLQueryItem *item in [url queryItems]) {
        if((t = _paramTranslations[[item name]]) &&
            (translatedItem = [t translateItem:item])) {
            [items addObject:translatedItem];
        }
    }

    NSURLComponents *c = [[NSURLComponents alloc] init];
    [c setQueryItems:items];

    return [c percentEncodedQuery];
}

- (NSString *)stringRepresentation { return @"Translated query"; }

// Coding {{{
- (NSOrderedSet<NSString *> *)endUserAccessibleKeys {
    return set(@"percentEncoded", @"paramTranslations");
}

+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:_paramTranslations forKey:@"paramTranslations"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithDictionary:[coder decodeObjectOfClass:[NSDictionary class]
                                                        forKey:@"paramTranslations"]
                     percentEncoded:[coder decodeBoolForKey:@"percentEncoded"]];
}
// }}}

@end

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
    return set(@"percentEncoded", @"regex", @"templet");
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
