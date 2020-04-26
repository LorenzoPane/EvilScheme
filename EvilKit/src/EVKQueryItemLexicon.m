#import "EVKQueryItemLexicon.h"

@implementation EVKQueryItemLexicon

+ (instancetype)identityLexiconWithName:(NSString *)key {
    return [[self alloc] initWithKeyName:key
                              dictionary:@{}
                            defaultState:URLQueryStatePassThrough];
}

- (instancetype)initWithKeyName:(NSString *)key
                     dictionary:(NSDictionary<NSString *, NSString *> *)dictionary
                   defaultState:(URLQueryState)state {
    if((self = [super init])) {
        _key = key;
        _substitutions = dictionary;
        _defaultState = state;
    }

    return self;
}

- (instancetype)init {
    return [self initWithKeyName:@"" dictionary:@{} defaultState:URLQueryStateNull];
}

- (NSURLQueryItem *)translateItem:(NSURLQueryItem *)item {
    NSString *value;

    if(!(value = [self substitutions][[item value]])) {
        switch([self defaultState]) {
            case URLQueryStatePassThrough:
                value = [item value];
                break;
            default:
                return nil;
        }
    }

    return [NSURLQueryItem queryItemWithName:[self key] value:value];
}

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:[self key] forKey:@"key"];
    [coder encodeObject:[self substitutions] forKey:@"substitutions"];
    [coder encodeInteger:[self defaultState] forKey:@"defaultState"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithKeyName:[coder decodeObjectOfClass:[NSString class] forKey:@"key"]
                      dictionary:[coder decodeObjectOfClass:[NSDictionary class] forKey:@"substitutions"]
                    defaultState:[coder decodeIntegerForKey:@"defaultState"]];
}
// }}}

@end
