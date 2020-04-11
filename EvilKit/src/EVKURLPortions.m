#import "EVKURLPortions.h"
#import "NSURL+ComponentAdditions.h"

@implementation EVKStaticStringPortion {
    NSString* string;
}

- (instancetype)initWithString:(NSString *)str {
    if((self = [super init])) {
        string = str;
    }

    return self;
}

+ (instancetype)portionWithString:(NSString *)str {
    return [[EVKStaticStringPortion alloc] initWithString:str];
}

- (NSString *)evaluateWithURL:(NSURL *)url {
    return string;
}

@end

@implementation EVKFullURLPortion {
    BOOL percentEncoded;
}

- (instancetype)initWithPercentEncoding:(BOOL)encoded {
    if((self = [super init])) {
        percentEncoded = encoded;
    }

    return self;
}

+ (instancetype)portionWithPercentEncoding:(BOOL)encoded {
    return [[EVKFullURLPortion alloc] initWithPercentEncoding:encoded];
}

- (NSString *)evaluateWithURL:(NSURL *)url {
    NSString *ret =  percentEncoded ? percentEncode([url absoluteString]) : [url absoluteString];
    return ret ? ret : @"";
}

@end

@implementation EVKTrimmedPathPortion

- (NSString *)evaluateWithURL:(NSURL *)url {
    NSString *ret = [url trimmedPathComponent];
    return ret ? ret : @"";
}

@end

@implementation EVKTrimmedResourceSpecifierPortion

- (NSString *)evaluateWithURL:(NSURL *)url {
    NSString * ret = [url trimmedResourceSpecifier];
    return ret ? ret : @"";
}

@end

@implementation EVKQueryPortion

- (NSString *)evaluateWithURL:(NSURL *)url {
    NSString *ret = [url queryString];
    return ret ? ret : @"";
}

@end

@implementation EVKRegexSubstitutionPortion {
    NSRegularExpression *_regex;
    NSString *_template;
}

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
    return ret ? ret : @"";
}

@end

@implementation EVKTranslatedQueryPortion {
    NSDictionary<NSString *, EVKQueryItemLexicon *> *paramTranslations;
}

- (instancetype)initWithDictionary:(NSDictionary<NSString *, EVKQueryItemLexicon *> *)dict {
    if((self = [super init])) {
        paramTranslations = dict;
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
        if((t = paramTranslations[[item name]]) &&
            (translatedItem = [t translateItem:item])) {
            [items addObject:translatedItem];
        }
    }

    NSURLComponents *c = [[NSURLComponents alloc] init];
    [c setQueryItems:items];

    NSString *ret = [c percentEncodedQuery];
    return ret ? ret : @"";
}

@end

@implementation EVKHostPortion

- (NSString *)evaluateWithURL:(NSURL *)url {
    NSString *ret = [url hostComponent];;
    return ret ? ret : @"";
}

@end

@implementation EVKSchemePortion

- (NSString *)evaluateWithURL:(NSURL *)url {
    NSString *ret = [url scheme];
    return ret ? ret : @"";
}

@end
