#import <Foundation/Foundation.h>
#import "EVKQueryItemLexicon.h"

/// Percent encode a given string
/// @param str NSString to encode
#define percentEncode(str) [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@""]]

/// Protocol representing functions of URLs that return strings
@protocol EVKURLPortion <NSObject>
/// Return the evaluated portion given the original URL or an empty string
/// @param url Original URL
- (NSString *)evaluateWithURL:(NSURL *)url;
@end

/// Portion which always returns a fixed string
@interface EVKStaticStringPortion : NSObject <EVKURLPortion>
- (instancetype)initWithString:(NSString *)str;
+ (instancetype)portionWithString:(NSString *)str;
@end

/// Portion which returns the entire URL as a string, optionally percent encoded
@interface EVKFullURLPortion : NSObject <EVKURLPortion>
- (instancetype)initWithPercentEncoding:(BOOL)encoded;
+ (instancetype)portionWithPercentEncoding:(BOOL)encoded;
@end

/// Portion which returns the URL's path as a string
@interface EVKTrimmedPathPortion : NSObject <EVKURLPortion>
@end

/// Portion which returns the URL's resource specifier, excluding leading and trailing slashes
@interface EVKTrimmedResourceSpecifierPortion : NSObject <EVKURLPortion>
@end

/// Portion which returns the URL's query string unmodified
@interface EVKQueryPortion : NSObject <EVKURLPortion>
@end

/// Portion which returns the result of a substitution being performed on the url with a given regex and template
@interface EVKRegexSubstitutionPortion : NSObject <EVKURLPortion>
- (instancetype)initWithRegex:(NSRegularExpression *)regex template:(NSString *)str;
+ (instancetype)portionWithRegex:(NSRegularExpression *)regex template:(NSString *)str;
@end

/// Portion which returns the URL's query string translated with a given dictionary
@interface EVKTranslatedQueryPortion : NSObject <EVKURLPortion>
- (instancetype)initWithDictionary:(NSDictionary<NSString *, EVKQueryItemLexicon *> *)dict;
+ (instancetype)portionWithDictionary:(NSDictionary<NSString *, EVKQueryItemLexicon *> *)dict;
@end

/// Portion which returns the URL's host
@interface EVKHostPortion : NSObject <EVKURLPortion>
@end

/// Portion which returns the URL's scheme
@interface EVKSchemePortion : NSObject <EVKURLPortion>
@end
