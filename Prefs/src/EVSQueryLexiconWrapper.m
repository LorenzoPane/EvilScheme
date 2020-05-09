#import <EvilKit/EvilKit.h>
#import "EVSQueryLexiconWrapper.h"

@implementation EVSQueryLexiconWrapper

- (instancetype)initWithLexicon:(EVKQueryItemLexicon *)lex {
    if((self = [super init])) {
        _lex = lex;
    }

    return self;
}

- (NSString *)defaultState {
    return [[self lex] defaultState] ? @"Keep original value" : @"Exclude argument";
}

- (void)setDefaultState:(NSString *)state {
    [[self lex] setDefaultState:[state isEqualToString:@"Keep original value"]];
}

- (NSString *)param {
    return [[self lex] param];
}

- (void)setParam:(NSString *)str {
    [[self lex] setParam:str];
}

- (NSDictionary *)dict {
    return [[self lex] substitutions];
}

- (void)setDict:(NSDictionary *)dict {
    [[self lex] setSubstitutions:dict];
}

@end
