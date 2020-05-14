#import <Foundation/Foundation.h>
#import "EVKQueryItemLexicon.h"

/// Percent encode a given string
/// @param str NSString to encode
#define percentEncode(str) [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@""]]

/// Protocol representing functions of URLs that return strings
@protocol EVKURLPortion <NSSecureCoding>
/// Returns the evaluated portion given the original URL or an empty string
/// @param url Original URL
- (NSString *)evaluateWithURL:(NSURL *)url;
/// Returns a human-readable string representation of the un-evaluated portion
- (NSString *)stringRepresentation;
/// Returns an array of stridngs to be used to access KVC-compliant properties
- (NSOrderedSet<NSString *> *)endUserAccessibleKeys;
@end

/// Protocol to represent URL portions thay optionally may be percent encoded
@protocol EVKPercentEncodable <EVKURLPortion>
/// Method to be overridden with the intended unencoded output of evaluateWithURL:
/// @param url Original URL
/// @seealso evaluateWithURL:
- (NSString *)evaluateUnencodedWithURL:(NSURL *)url;
@end

/// Mostly abstract class to implement EVKPercentEncodable, also encapsulates default
/// return value logic: `(ret ? : @"")`
/// @seealso EVKPercentEncodable
/// @discussion When subclassed, evaluateUnencodedWithURL: should be overridden rather than evaluateWithURL:
@interface EVKPercentEncodablePortion : NSObject <EVKPercentEncodable>
@property (getter=isPercentEncoded, copy) NSNumber *percentEncoded;
- (instancetype)initWithPercentEncoding:(BOOL)percentEncoded;
+ (instancetype)portionWithPercentEncoding:(BOOL)percentEncoded;
@end

/// Portion which always returns a fixed string, optionally percent encoded for convenience
@interface EVKStaticStringPortion : EVKPercentEncodablePortion
@property (copy) NSString *string;
- (instancetype)initWithString:(NSString *)str percentEncoded:(BOOL)percentEncoded;
+ (instancetype)portionWithString:(NSString *)str percentEncoded:(BOOL)percentEncoded;
@end

/// Portion which returns the entire URL
@interface EVKFullURLPortion : EVKPercentEncodablePortion
@end

/// Portion which returns the URL's path
@interface EVKTrimmedPathPortion : EVKPercentEncodablePortion
@end

/// Portion which returns the URL's fragment
@interface EVKFragmentPortion : EVKPercentEncodablePortion
@end

/// Portion which returns the URL's resource specifier, excluding leading and trailing slashes
@interface EVKTrimmedResourceSpecifierPortion : EVKPercentEncodablePortion
@end

/// Portion which returns the URL's host
@interface EVKHostPortion : EVKPercentEncodablePortion
@end

/// Portion which returns the URL's scheme
@interface EVKSchemePortion : EVKPercentEncodablePortion
@end

/// Portion which returns the URL's query string unmodified
@interface EVKQueryPortion : EVKPercentEncodablePortion
@end

/// Portion which returns the URL's query string translated with a given dictionary
@interface EVKTranslatedQueryPortion : EVKPercentEncodablePortion
@property (copy) NSDictionary<NSString *, EVKQueryItemLexicon *> *paramTranslations;
- (instancetype)initWithDictionary:(NSDictionary<NSString *, EVKQueryItemLexicon *> *)dict
                    percentEncoded:(BOOL)percentEncoded;
+ (instancetype)portionWithDictionary:(NSDictionary<NSString *, EVKQueryItemLexicon *> *)dict
                       percentEncoded:(BOOL)percentEncoded;
@end

/// Portion which returns the result of a substitution being performed on the url with a given regex and template
@interface EVKRegexSubstitutionPortion : EVKPercentEncodablePortion
@property (copy) NSString *regex;
@property (copy) NSString *templet;
- (instancetype)initWithRegex:(NSString *)regex
                     template:(NSString *)templet
               percentEncoded:(BOOL)percentEncoded;
+ (instancetype)portionWithRegex:(NSString *)regex
                        template:(NSString *)templet
                  percentEncoded:(BOOL)percentEncoded;
@end
