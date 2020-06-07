#import "EVKURLPortions.h"

/// Object to represent a regex pattern and its corrosponding blueprint
@interface EVKAction : NSObject <NSSecureCoding, NSCopying>

@property (atomic, strong) NSString *regexPattern;
@property (atomic, strong) NSArray<NSObject<EVKURLPortion> *> *outline;

/// Initializes a newly allocated action with all properties
/// @param pattern Regular expression pattern
/// @param outline Array of URL fragments
- (instancetype)initWithRegexPattern:(NSString *)pattern
                          URLOutline:(NSArray<NSObject<EVKURLPortion> *> *)outline;
+ (instancetype)actionWithPattern:(NSString *)pattern
                          outline:(NSArray<NSObject<EVKURLPortion> *> *)outline;

/// Returns concatenation of all fragments evaulted with a URL if it contains a match for the regex, nil otherwise
- (NSURL *)transformURL:(NSURL *)url;

@end
