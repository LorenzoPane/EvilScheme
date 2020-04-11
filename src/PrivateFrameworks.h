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
@end

@interface BSAction : NSObject
@property (nonatomic,copy,readonly) BSSettings *info;
@end

@interface UAUserActivityInfo : NSObject
@property (copy) NSURL * webpageURL;
@end
