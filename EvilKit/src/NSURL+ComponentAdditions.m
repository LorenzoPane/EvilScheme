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

- (NSString *)pathComponent {
    return [[NSURLComponents componentsWithURL:self
                       resolvingAgainstBaseURL:NO] path];
}

- (NSString *)trimmedResourceSpecifier {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"/"];
    return [[self resourceSpecifier] stringByTrimmingCharactersInSet:set];
}

- (BOOL)matchesRegularExpression:(NSRegularExpression *)regex {
    return [regex numberOfMatchesInString:[self absoluteString]
                                  options:0
                                    range:NSMakeRange(0, [[self absoluteString] length])] ? YES : NO;
}

@end
