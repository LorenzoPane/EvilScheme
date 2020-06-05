#include <Foundation/Foundation.h>

@interface FBSOpenApplicationOptions : NSObject
@property (nonatomic,copy) NSDictionary *dictionary;
@end

@interface BSSettings : NSObject
-(id)objectForSetting:(NSUInteger)index;
-(NSIndexSet *)allSettings;
-(void)_setObject:(id)obj forSetting:(NSUInteger)setting ;
@end

@interface BSAction : NSObject
@property (nonatomic,copy,readonly) BSSettings *info;
@end

@interface UAUserActivityInfo : NSObject
@property (copy) NSURL * webpageURL;
@end

@interface BSProcessHandle
@property NSString *bundleIdentifier;
@end

@interface LSApplicationWorkspace : NSObject
+ (instancetype)defaultWorkspace;
- (BOOL)applicationIsInstalled:(NSString *)bundleID;
@end

@interface FBSystemService : NSObject
- (void)openApplication:(NSString *)bundleID
            withOptions:(FBSOpenApplicationOptions *)options
             originator:(BSProcessHandle *)source
              requestID:(NSUInteger)req
             completion:(id)completion;
- (void)activateApplication:(NSString *)bundleID
                  requestID:(NSUInteger)req
                    options:(FBSOpenApplicationOptions *)options
                     source:(BSProcessHandle *)source
             originalSource:(BSProcessHandle *)origSource
                 withResult:(id)completion;
- (void)_activateApplication:(NSString *)bundleID
                   requestID:(NSUInteger)req
                     options:(FBSOpenApplicationOptions *)options
                      source:(BSProcessHandle *)source
              originalSource:(BSProcessHandle *)origSource
                  withResult:(id)completion;
- (void)_reallyActivateApplication:(NSString *)bundleID
                         requestID:(NSUInteger)req
                           options:(FBSOpenApplicationOptions *)options
                            source:(BSProcessHandle *)source
                    originalSource:(BSProcessHandle *)origSource
                         isTrusted:(BOOL)sourceTrusted
                    sequenceNumber:(unsigned long long)sourceSeq
                         cacheGUID:(id)sourceGUID
                 ourSequenceNumber:(unsigned long long)ourSeq
                      ourCacheGUID:(id)ourGUID
                        withResult:(id)completion;
@end
