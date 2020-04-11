#import "EVKQueryItemLexicon.h"

@implementation EVKQueryItemLexicon

+ (instancetype)identityLexiconWithName:(NSString *)key {
    return [[self alloc] initWithKeyName:key
                              dictionary:@{}
                            defaultState:URLQueryStatePassThrough];
}

- (instancetype)initWithKeyName:(NSString *)key
                     dictionary:(NSDictionary *)dictionary
                   defaultState:(URLQueryState)state {
    if((self = [super init])) {
        _key = key;
        _substitutions = dictionary;
        _defaultState = state;
    }

    return self;
}

- (NSURLQueryItem *)translateItem:(NSURLQueryItem *)item {
    NSString *value;

    if(!(value = [self substitutions][[item value]])) {
        switch([self defaultState]) {
            case(URLQueryStatePassThrough):
                value = [item value];
                break;
            default:
                return nil;
        }
    }

    return [NSURLQueryItem queryItemWithName:[self key] value:value];
}

@end
