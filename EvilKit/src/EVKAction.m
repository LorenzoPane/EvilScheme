#import "EVKAction.h"
#import "NSURL+ComponentAdditions.h"

#define regex(pattern) [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil]

@implementation EVKAction

+ (instancetype)actionWithPattern:(NSString *)pattern
                          outline:(NSArray<NSObject<EVKURLPortion> *> *)outline {
    return [[self alloc] initWithRegexPattern:pattern
                                   URLOutline:outline];
}

- (instancetype)initWithRegexPattern:(NSString *)pattern
                          URLOutline:(NSArray<NSObject<EVKURLPortion> *> *)outline {
    if((self = [super init])) {
        _regexPattern = pattern;
        _outline = outline;
    }

    return self;
}

- (instancetype)init {
    return [self initWithRegexPattern:@"" URLOutline:@[]];
}

- (NSURL *)transformURL:(NSURL *)url {
    if(regex([self regexPattern]) && [url matchesRegularExpression:regex([self regexPattern])]) {
        NSMutableString *ret = [NSMutableString new];
        for(NSObject<EVKURLPortion> *portion in [self outline]) {
            [ret appendString:[portion evaluateWithURL:url]];
        }
        return [NSURL URLWithString:ret];
    }

    return nil;
}

@end

