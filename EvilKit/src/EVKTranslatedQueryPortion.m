#import "EVKURLPortions.h"
#import "NSURL+ComponentAdditions.h"

#define set(...) [NSOrderedSet orderedSetWithObjects:__VA_ARGS__, nil]

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
    return set(@"paramTranslations", @"percentEncoded");
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
