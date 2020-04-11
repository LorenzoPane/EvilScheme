#import <Foundation/Foundation.h>

@interface NSURL (ComponentAdditions)

/// Returns query as an array of name/value pairs
- (NSArray<NSURLQueryItem *> *)queryItems;

/// Returns percent encoded query string
- (NSString *)queryString;

/// Returns resource specifier excluding leading and trailing slashes
- (NSString *)trimmedResourceSpecifier;

/// Returns path parsed by NSURLComponents
- (NSString *)pathComponent;

/// Returns YES if the absolute string contains a match for a given regular expression
/// @param regex regular expression to use
- (BOOL)matchesRegularExpression:(NSRegularExpression *)regex;

@end
