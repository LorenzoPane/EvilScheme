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
@end

@interface EVKPercentEncodablePortion : NSObject
@property (getter=isPercentEncoded) BOOL percentEncoded;
- (instancetype)initWithPercentEncoding:(BOOL)percentEncoded;
@end

/// Portion which always returns a fixed string, optionally percent encoded for convenience
@interface EVKStaticStringPortion : EVKPercentEncodablePortion <EVKURLPortion>
@property (copy) NSString *string;
- (instancetype)initWithString:(NSString *)str percentEncoded:(BOOL)percentEncoded;
+ (instancetype)portionWithString:(NSString *)str percentEncoded:(BOOL)percentEncoded;
@end

/// Portion which returns the entire URL as a string, optionally percent encoded
@interface EVKFullURLPortion : EVKPercentEncodablePortion <EVKURLPortion>
+ (instancetype)portionWithPercentEncoding:(BOOL)percentEncoded;
@end

/// Portion which returns the URL's path as a string optionally percent encoded
@interface EVKTrimmedPathPortion : EVKPercentEncodablePortion <EVKURLPortion>
@end

/// Portion which returns the URL's resource specifier, excluding leading and trailing slashes, optionally percent encoded
@interface EVKTrimmedResourceSpecifierPortion : EVKPercentEncodablePortion <EVKURLPortion>
@end

/// Portion which returns the URL's query string unmodified
@interface EVKQueryPortion : NSObject <EVKURLPortion>
@end

/// Portion which returns the result of a substitution being performed on the url with a given regex and template
@interface EVKRegexSubstitutionPortion : NSObject <EVKURLPortion>
- (instancetype)initWithRegex:(NSRegularExpression *)regex template:(NSString *)str;
+ (instancetype)portionWithRegex:(NSRegularExpression *)regex template:(NSString *)str;
@property (copy) NSRegularExpression *regex;
@property (copy) NSString *templet;
@end

/// Portion which returns the URL's query string translated with a given dictionary
@interface EVKTranslatedQueryPortion : NSObject <EVKURLPortion>
@property (copy) NSDictionary<NSString *, EVKQueryItemLexicon *> *paramTranslations;
- (instancetype)initWithDictionary:(NSDictionary<NSString *, EVKQueryItemLexicon *> *)dict;
+ (instancetype)portionWithDictionary:(NSDictionary<NSString *, EVKQueryItemLexicon *> *)dict;
@end

/// Portion which returns the URL's host
@interface EVKHostPortion : NSObject <EVKURLPortion>
@end

/// Portion which returns the URL's scheme
@interface EVKSchemePortion : NSObject <EVKURLPortion>
@end
