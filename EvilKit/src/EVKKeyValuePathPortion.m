#import "EVKURLPortions.h"

#define set(...) [NSOrderedSet orderedSetWithObjects:__VA_ARGS__, nil]

@implementation EVKKeyValuePathPortion

+ (instancetype)portionWithRegex:(NSString *)regex
                        template:(NSString *)templet
                            path:(NSString *)path
       percentEncodingIterations:(int)iterations {
    return [[self alloc] initWithRegex:regex
                              template:templet
                                  path:path
             percentEncodingIterations:iterations];
}

- (instancetype)initWithRegex:(NSString *)regex
                     template:(NSString *)templet
                         path:(NSString *)path
    percentEncodingIterations:(int)iterations {
    if((self = [super initWithRegex:regex template:templet percentEncodingIterations:iterations])) {
        _path = path;
    }

    return self;
}

- (instancetype)init {
    return [self initWithRegex:@"" template:@"" path:@"" percentEncodingIterations:0];
}

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url {
    // I want to vomit
    @try {
        // Data from template
        NSData *data = [[NSData alloc] initWithBase64EncodedString:[super evaluateUnencodedWithURL:url]
                                                           options:0];
        // Resulting object
        id obj = [[NSPropertyListSerialization propertyListWithData:data
                                                            options:0
                                                             format:nil
                                                              error:nil] valueForKeyPath:[self path]];

        if([obj respondsToSelector:@selector(countByEnumeratingWithState:objects:count:)]) {
            NSMutableString *ret = [NSMutableString new];
            for(NSObject *item in obj) {
                [ret appendString:[item description]];
            }
            return ret;
        }
        else {
            return [obj description];
        }
    } @catch (NSException *ex) {
        return @"";
    }

    return @"";
}

- (NSString *)stringRepresentation { return @"Key-value path"; }

// Coding {{{
- (NSOrderedSet<NSString *> *)endUserAccessibleKeys {
    return set(@"regex", @"templet", @"path",  @"percentEncodingIterations");
}

+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:[self regex] forKey:@"regex"];
    [coder encodeObject:[self templet] forKey:@"templet"];
    [coder encodeObject:[self path] forKey:@"path"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithRegex:[coder decodeObjectForKey:@"regex"]
                      template:[coder decodeObjectForKey:@"templet"]
                          path:[coder decodeObjectForKey:@"path"]
     percentEncodingIterations:[coder decodeIntForKey:@"percentEncodingIterations"]];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[self class] portionWithRegex:[self regex]
                                 template:[self templet]
                                     path:[self path]
                percentEncodingIterations:[[self percentEncodingIterations] intValue]];
}
// }}}

@end
