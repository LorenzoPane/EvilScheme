#import "EVKAppAlternative.h"
#import "NSURL+ComponentAdditions.h"

#define regex(pattern) [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil]

@implementation EVKAppAlternative

- (instancetype)initWithTargetBundleID:(NSString *)targetBundleID
                    substituteBundleID:(NSString *)substituteBundleID
                           urlOutlines:(NSDictionary<NSString *, NSArray<NSObject<EVKURLPortion> *> *> *)outlines {
    if((self = [super init])) {
        _targetBundleID = targetBundleID;
        _substituteBundleID = substituteBundleID;
        _urlOutlines = outlines;
    }

    return self;
}

- (instancetype)init {
    return [self initWithTargetBundleID:@""
                     substituteBundleID:@""
                            urlOutlines:@{}];
}

- (NSURL *)transformURL:(NSURL *)url {
    NSArray<NSObject<EVKURLPortion> *> *outline;

    for(NSString *pattern in [self urlOutlines]) {
        if(regex(pattern) && [url matchesRegularExpression:regex(pattern)]) {
            outline = [self urlOutlines][pattern];
            break;
        }
    }

    if(outline) {
        NSMutableString *ret = [NSMutableString new];
        for(NSObject<EVKURLPortion> *portion in outline) {
            [ret appendString:[portion evaluateWithURL:url]];
        }
        return [NSURL URLWithString:ret];
    }

    return url;
}

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:[self targetBundleID] forKey:@"targetBundleID"];
    [coder encodeObject:[self substituteBundleID] forKey:@"substituteBundleID"];
    [coder encodeObject:[self urlOutlines] forKey:@"urlOutlines"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithTargetBundleID:[coder decodeObjectOfClass:[NSString class] forKey:@"targetBundleID"]
                     substituteBundleID:[coder decodeObjectOfClass:[NSString class] forKey:@"substituteBundleID"]
                            urlOutlines:[coder decodeObjectOfClass:[NSDictionary class] forKey:@"urlOutlines"]];
}
// }}}

@end
