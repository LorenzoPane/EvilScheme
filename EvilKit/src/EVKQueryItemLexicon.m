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
        _param = key;
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

    return [NSURLQueryItem queryItemWithName:[self param] value:value];
}

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:[self param] forKey:@"key"];
    [coder encodeObject:[self substitutions] forKey:@"substitutions"];
    [coder encodeInteger:[self defaultState] forKey:@"defaultState"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithKeyName:[coder decodeObjectOfClass:[NSString class] forKey:@"key"]
                      dictionary:[coder decodeObjectOfClass:[NSDictionary class] forKey:@"substitutions"]
                    defaultState:[coder decodeIntegerForKey:@"defaultState"]];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[[self class] alloc] initWithKeyName:[self param]
                                      dictionary:[self substitutions]
                                    defaultState:[self defaultState]];
}
// }}}

@end
