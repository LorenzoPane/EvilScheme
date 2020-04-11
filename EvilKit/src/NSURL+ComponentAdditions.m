#import "NSURL+ComponentAdditions.h"

@implementation NSURL (ComponentAdditions)

- (NSArray<NSURLQueryItem *> *)queryItems {
    return [[NSURLComponents componentsWithURL:self
                       resolvingAgainstBaseURL:NO] queryItems];
}

- (NSString *)queryString {
    return [[NSURLComponents componentsWithURL:self
                       resolvingAgainstBaseURL:NO] percentEncodedQuery];
}

- (NSString *)trimmedPathComponent {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"/"];
    return [[[NSURLComponents componentsWithURL:self
                       resolvingAgainstBaseURL:NO] path] stringByTrimmingCharactersInSet:set];
}

- (NSString *)trimmedResourceSpecifier {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"/"];
    return [[self resourceSpecifier] stringByTrimmingCharactersInSet:set];
}

- (NSString *)hostComponent {
    return [[NSURLComponents componentsWithURL:self
                       resolvingAgainstBaseURL:NO] host];
}

- (BOOL)matchesRegularExpression:(NSRegularExpression *)regex {
    return [regex numberOfMatchesInString:[self absoluteString]
                                  options:0
                                    range:NSMakeRange(0, [[self absoluteString] length])] ? YES : NO;
}

@end
