#import "L0DictionaryController.h"

@implementation L0DictionaryController

- (instancetype)initWithDict:(NSDictionary *)dict {
    if((self = [super init])) {
        _dict = dict;
    }

    return self;
}

- (instancetype)init {
    return [self initWithDict:@{}];
}

- (NSInteger)count {
    return [[self dict] count];
}

- (BOOL)containsKey:(NSString *)key {
    return (BOOL)[self dict][key];
}

- (NSArray<NSString *> *)keys {
    return [[[self dict] allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSArray *)objects {
    NSMutableArray *ret = [NSMutableArray new];
    for(NSString *key in [self keys])  [ret addObject:[self dict][key]];
    return ret;
}

- (NSString *)keyAtIndex:(NSInteger)idx {
    return [self keys][idx];
}

- (id)objectForKey:(NSString *)key {
    return [self dict][key];
}

- (id)objectAtIndex:(NSInteger)idx {
    return [self dict][[self keys][idx]];
}

- (void)removeObjectForKey:(NSString *)key {
    NSMutableDictionary *dict = [[self dict] mutableCopy];
    [dict removeObjectForKey:key];
    [self setDict:dict];
}

- (void)removeObjectAtIndex:(NSInteger)idx {
    [self removeObjectForKey:[self keyAtIndex:idx]];
}

- (void)setObject:(id)obj forKey:(NSString *)key {
    NSMutableDictionary *dict = [[self dict] mutableCopy];
    dict[key] = obj;
    [self setDict:dict];
}

- (void)setObject:(id)obj atIndex:(NSInteger)idx {
    [self setObject:obj forKey:[self keys][idx]];
}

- (void)renameKey:(NSString *)key toString:(NSString *)str {
    NSMutableDictionary *dict = [[self dict] mutableCopy];
    id value = dict[key];
    [dict removeObjectForKey:key];
    dict[str] = value;
    [self setDict:dict];
}

- (void)renameKeyAtIndex:(NSInteger)idx toString:(NSString *)str {
    [self renameKey:[self keys][idx] toString:str];
}

@end
