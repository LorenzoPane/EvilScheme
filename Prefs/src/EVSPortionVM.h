#import <Foundation/Foundation.h>
#import <EvilKit/EvilKit.h>

@interface EVSPortionVM : NSObject

@property (atomic, strong) NSObject<EVKURLPortion> *portion;

+ (NSDictionary<NSString *, NSString *> *)propertyNameMappings;
+ (NSDictionary<NSString *, Class> *)classNameMappings;

- (instancetype)initWithPortion:(NSObject<EVKURLPortion> *)portion;
- (NSString *)stringRepresentation;
- (int)propertyCount;
- (NSString *)propertyNameForIndex:(NSInteger)index;
- (id)objectForPropertyIndex:(NSInteger)index;
- (void)setObject:(NSObject *)obj forPropertyIndex:(NSInteger)index;
- (NSString *)valueStringForIndex:(NSInteger)index;
- (NSString *)valueStringForKey:(NSString *)key;
- (Class)cellTypeForIndex:(NSInteger)index;
- (Class)cellTypeForKey:(NSString *)index;

@end
