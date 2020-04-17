#import <Foundation/Foundation.h>
#import "EVKURLPortions.h"

/// Object to represent an altenative app to a default scheme endpoint and the modifications that must be made to it's request
@interface EVKAppAlternative : NSObject <NSSecureCoding>

/// Bundle ID of the default scheme endpoint
@property (copy) NSString *targetBundleID;

/// Bundle ID of the altenrative app
@property (copy) NSString *substituteBundleID;

/// Dictionary of regular expression patterns for URLs and the corrosponding url blueprints
@property (copy) NSDictionary<NSString *, NSArray<id <EVKURLPortion>> *> *urlOutlines;

/// Initializes a newly allocated alternative with all properties
/// @param targetBundleID Bundle ID of the default scheme endpoint
/// @param substituteBundleID Bundle ID of the alternative app
/// @param outlines Dictionary of prefixes to URLs and the corrosponding arrays of portions
- (instancetype)initWithTargetBundleID:(NSString *)targetBundleID
                    substituteBundleID:(NSString *)substituteBundleID
                           urlOutlines:(NSDictionary<NSString *, NSArray<id <EVKURLPortion>> *> *)outlines;

/// Transforms given URL with the proper outline
/// @param url URL to transform
/// @return Transformed url, returns the input if no matches are found
- (NSURL *)transformURL:(NSURL *)url;

@end
