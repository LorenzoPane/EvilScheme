#import "EVKURLPortions.h"
#import "NSURL+ComponentAdditions.h"

#define maybePercentEncode(str) ([self isPercentEncoded] ? [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@""]] : str)

@implementation EVKPercentEncodablePortion

- (instancetype)initWithPercentEncoding:(BOOL)percentEncoded {
    if((self = [super init])) {
        _percentEncoded = percentEncoded;
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeBool:[self isPercentEncoded] forKey:@"percentEncoded"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithPercentEncoding:[coder decodeBoolForKey:@"percentEncoded"]];
}

@end

@implementation EVKStaticStringPortion

- (instancetype)initWithString:(NSString *)str percentEncoded:(BOOL)percentEncoded {
    if((self = [super initWithPercentEncoding:percentEncoded])) {
        _string = str;
    }

    return self;
}

+ (instancetype)portionWithString:(NSString *)str percentEncoded:(BOOL)percentEncoded {
    return [[EVKStaticStringPortion alloc] initWithString:str percentEncoded:percentEncoded];
}

- (NSString *)evaluateWithURL:(NSURL *)url {
    return maybePercentEncode([self string]);
}

- (NSString *)stringRepresentation {
    return [NSString stringWithFormat:@"Text: %@", [self string]];
}

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:[self string] forKey:@"string"];
    [coder encodeBool:[self isPercentEncoded] forKey:@"percentEncoded"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithString:[coder decodeObjectOfClass:[NSString class] forKey:@"string"]
                 percentEncoded:[coder decodeBoolForKey:@"percentEncoded"]];
}
// }}}

@end

@implementation EVKFullURLPortion

+ (instancetype)portionWithPercentEncoding:(BOOL)encoded {
    return [[EVKFullURLPortion alloc] initWithPercentEncoding:encoded];
}

- (NSString *)evaluateWithURL:(NSURL *)url {
    NSString *ret = maybePercentEncode([url absoluteString]);
    return ret ? : @"";
}

- (NSString *)stringRepresentation { return @"Full URL"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeBool:[self isPercentEncoded] forKey:@"percentEncoded"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithPercentEncoding:[coder decodeBoolForKey:@"percentEncoded"]];
}
// }}}

@end

@implementation EVKTrimmedPathPortion

- (NSString *)evaluateWithURL:(NSURL *)url {
    NSString *ret = maybePercentEncode([url trimmedPathComponent]);
    return ret ? : @"";
}

- (NSString *)stringRepresentation { return @"Path"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { [super encodeWithCoder:coder]; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [super initWithCoder:coder]; };
// }}}

@end

@implementation EVKTrimmedResourceSpecifierPortion

- (NSString *)evaluateWithURL:(NSURL *)url {
    NSString * ret = maybePercentEncode([url trimmedResourceSpecifier]);
    return ret ? : @"";
}

- (NSString *)stringRepresentation { return @"Resource specifier"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { [super encodeWithCoder:coder]; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [super initWithCoder:coder]; };
// }}}

@end

@implementation EVKQueryPortion

- (NSString *)evaluateWithURL:(NSURL *)url {
    NSString *ret = [url queryString];
    return ret ? : @"";
}

- (NSString *)stringRepresentation { return @"Original query"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { return; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [self init]; }
// }}}

@end

@implementation EVKRegexSubstitutionPortion

- (instancetype)initWithRegex:(NSRegularExpression *)regex template:(NSString *)str {
    if((self = [super init])) {
        _regex = regex;
        _template = str;
    }

    return self;
}

+ (instancetype)portionWithRegex:(NSRegularExpression *)regex template:(NSString *)template {
    return [[EVKRegexSubstitutionPortion alloc] initWithRegex:regex template:template];
}

- (NSString *)evaluateWithURL:(NSURL *)url {
    NSMatchingOptions opts = NSMatchingWithTransparentBounds | NSMatchingWithoutAnchoringBounds;
    NSString * ret =  [_regex stringByReplacingMatchesInString:[url absoluteString]
                                                       options:opts
                                                         range:NSMakeRange(0, [[url absoluteString] length])
                                                  withTemplate:_template];
    return ret ? : @"";
}

- (NSString *)stringRepresentation { return @"Regex substitution"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_regex forKey:@"regex"];
    [coder encodeObject:_template forKey:@"template"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithRegex:[coder decodeObjectOfClass:[NSRegularExpression class] forKey:@"regex"]
                      template:[coder decodeObjectOfClass:[NSString class] forKey:@"template"]];
}
// }}}

@end

@implementation EVKTranslatedQueryPortion

- (instancetype)initWithDictionary:(NSDictionary<NSString *, EVKQueryItemLexicon *> *)dict {
    if((self = [super init])) {
        _paramTranslations = dict;
    }

    return self;
}

+ (instancetype)portionWithDictionary:(NSDictionary<NSString *,EVKQueryItemLexicon *> *)dict {
    return [[EVKTranslatedQueryPortion alloc] initWithDictionary:dict];
}

- (NSString *)evaluateWithURL:(NSURL *)url {
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

    NSString *ret = [c percentEncodedQuery];
    return ret ? ret : @"";
}

- (NSString *)stringRepresentation { return @"Translated query"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_paramTranslations forKey:@"paramTranslations"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithDictionary:[coder decodeObjectOfClass:[NSDictionary class] forKey:@"paramTranslations"]];
}
// }}}

@end

@implementation EVKHostPortion

- (NSString *)evaluateWithURL:(NSURL *)url {
    NSString *ret = [url hostComponent];;
    return ret ? : @"";
}

- (NSString *)stringRepresentation { return @"Host (domain)"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { return; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [self init]; };
// }}}

@end

@implementation EVKSchemePortion

- (NSString *)evaluateWithURL:(NSURL *)url {
    NSString *ret = [url scheme];
    return ret ? : @"";
}

- (NSString *)stringRepresentation { return @"Original scheme"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { return; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [self init]; };
// }}}

@end
