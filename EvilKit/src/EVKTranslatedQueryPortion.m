#import "EVKURLPortions.h"
#import "NSURL+ComponentAdditions.h"

#define set(...) [NSOrderedSet orderedSetWithObjects:__VA_ARGS__, nil]

@implementation EVKTranslatedQueryPortion

- (instancetype)initWithDictionary:(NSDictionary<NSString *, EVKQueryItemLexicon *> *)dict
         percentEncodingIterations:(int)iterations {
    if((self = [super initWithPercentEncodingIterations:iterations])) {
        _paramTranslations = dict;
    }

    return self;
}

- (instancetype)init {
    return [self initWithDictionary:@{} percentEncodingIterations:NO];
}

+ (instancetype)portionWithDictionary:(NSDictionary<NSString *,EVKQueryItemLexicon *> *)dict
            percentEncodingIterations:(int)iterations {
    return [[[self class] alloc] initWithDictionary:dict percentEncodingIterations:iterations];
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
    return set(@"paramTranslations", @"percentEncodingIterations");
}

+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:_paramTranslations forKey:@"paramTranslations"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithDictionary:[coder decodeObjectOfClass:[NSDictionary class]
                                                        forKey:@"paramTranslations"]
          percentEncodingIterations:[coder decodeIntForKey:@"percentEncodingIterations"]];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[self class] portionWithDictionary:[self paramTranslations]
                     percentEncodingIterations:[[self percentEncodingIterations] intValue]];
}
// }}}

@end
