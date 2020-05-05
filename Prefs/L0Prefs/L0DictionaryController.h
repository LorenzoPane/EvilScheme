#import <Foundation/Foundation.h>

@interface L0DictionaryController<T> : NSObject

@property (atomic, strong) NSDictionary<NSString *, T> *dict;

- (instancetype)initWithDict:(NSDictionary<NSString *, T> *)dict;

- (NSInteger)count;
- (BOOL)containsKey:(NSString *)key;

- (NSArray<NSString *> *)keys;
- (NSArray<T> *)objects;

- (NSString *)keyAtIndex:(NSInteger)idx;

- (T)objectForKey:(NSString *)key;
- (T)objectAtIndex:(NSInteger)idx;

- (void)removeObjectForKey:(NSString *)key;
- (void)removeObjectAtIndex:(NSInteger)idx;

- (void)setObject:(T)obj forKey:(NSString *)key;
- (void)setObject:(T)obj atIndex:(NSInteger)idx;

- (void)renameKey:(NSString *)key toString:(NSString *)str;
- (void)renameKeyAtIndex:(NSInteger)idx toString:(NSString *)str;

@end
