#import <Foundation/Foundation.h>

@interface NSURL (ComponentAdditions)

/// Returns query as an array of name/value pairs
- (NSArray<NSURLQueryItem *> *)queryItems;

/// Returns percent encoded query string
- (NSString *)queryString;

/// Returns resource specifier excluding leading and trailing slashes
- (NSString *)trimmedResourceSpecifier;

/// Returns path parsed by NSURLComponents
- (NSString *)trimmedPathComponent;

/// Returns the host parsed by NSURLComponents
- (NSString *)hostComponent;

/// Returns the fragment parsed by NSURLComponents
- (NSString *)fragmentString;

/// Returns YES if the absolute string contains a match for a given regular expression
/// @param regex regular expression to use
- (BOOL)matchesRegularExpression:(NSRegularExpression *)regex;

/// Returns string value for a given query parameter, nil if key is not found
- (NSString *)queryValueForParameter:(NSString *)param;

@end
