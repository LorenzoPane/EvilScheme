#import "EVKAppAlternative.h"
#import "NSURL+ComponentAdditions.h"

#define regex(pattern) [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil]

@implementation EVKAppAlternative

- (instancetype)initWithTargetBundleID:(NSString *)targetBundleID
                    substituteBundleID:(NSString *)substituteBundleID
                           urlOutlines:(NSDictionary *)outlines {
    if((self = [super init])) {
        _targetBundleID = targetBundleID;
        _substituteBundleID = substituteBundleID;
        _urlOutlines = outlines;
    }

    return self;
}

- (NSURL *)transformURL:(NSURL *)url {
    NSArray<id <EVKURLPortion>> *outline;

    for(NSString *pattern in [self urlOutlines]) {
        if(regex(pattern) && [url matchesRegularExpression:regex(pattern)]) {
            outline = [self urlOutlines][pattern];
            break;
        }
    }

    if(outline) {
        NSMutableString *ret = [NSMutableString new];
        for(id <EVKURLPortion> portion in outline) {
            NSString *str = [portion evalutatePortionWithURL:url];
            if(str) [ret appendString: str];
        }
        return [NSURL URLWithString:ret];
    }

    return url;
}

@end
