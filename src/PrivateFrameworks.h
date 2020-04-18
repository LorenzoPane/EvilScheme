#include <Foundation/Foundation.h>

@interface FBSOpenApplicationOptions : NSObject
@property (nonatomic,copy) NSDictionary *dictionary;
@end

@interface FBSystemServiceOpenApplicationRequest : NSObject
@property (nonatomic,copy) NSString *bundleIdentifier;
@end

@interface BSSettings : NSObject
-(id)objectForSetting:(unsigned long long)index;
-(NSIndexSet *)allSettings;
-(void)_setObject:(id)obj forSetting:(NSUInteger)setting ;
@end

@interface BSAction : NSObject
@property (nonatomic,copy,readonly) BSSettings *info;
-(id)initWithInfo:(id)arg1 timeout:(double)arg2 forResponseOnQueue:(id)arg3 withHandler:(/*^block*/id)arg4 ;
@end

@interface UAUserActivityInfo : NSObject
@property (copy) NSURL * webpageURL;
@end
