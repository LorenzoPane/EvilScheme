#import <Foundation/Foundation.h>
#import "EVKURLPortions.h"
#import "EVKAction.h"

/// Object to represent an altenative app to a default scheme endpoint and the modifications that must be made to it's request
@interface EVKAppAlternative : NSObject <NSSecureCoding, NSCopying>

/// Bundle ID of the default scheme endpoint
@property (copy) NSString *targetBundleID;

/// Bundle ID of the altenrative app
@property (copy) NSString *substituteBundleID;

/// Array of EVKActions in order of priority
@property (copy) NSArray<EVKAction *> *urlOutlines;

/// Initializes a newly allocated alternative with all properties
/// @param targetBundleID Bundle ID of the default scheme endpoint
/// @param substituteBundleID Bundle ID of the alternative app
/// @param outlines Array of EVKActions in order of priority
- (instancetype)initWithTargetBundleID:(NSString *)targetBundleID
                    substituteBundleID:(NSString *)substituteBundleID
                           urlOutlines:(NSArray<EVKAction *> *)outlines;

/// Transforms given URL with the proper outline
/// @param url URL to transform
/// @return Transformed url, returns nil if no matches are found
- (NSURL *)transformURL:(NSURL *)url;

@end
