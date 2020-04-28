#import "EVKURLPortions.h"

#define set(...) [NSOrderedSet orderedSetWithObjects:__VA_ARGS__, nil]

@implementation EVKStaticStringPortion

- (instancetype)initWithString:(NSString *)str percentEncoded:(BOOL)percentEncoded {
    if((self = [super initWithPercentEncoding:percentEncoded])) {
        _string = str;
    }

    return self;
}

- (instancetype)init {
    return [self initWithString:@"" percentEncoded:NO];
}

+ (instancetype)portionWithString:(NSString *)str percentEncoded:(BOOL)percentEncoded {
    return [[EVKStaticStringPortion alloc] initWithString:str percentEncoded:percentEncoded];
}

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url { return [self string]; }

- (NSString *)stringRepresentation {
    return [NSString stringWithFormat:@"Text: %@", [self string]];
}

// Coding {{{
- (NSOrderedSet<NSString *> *)endUserAccessibleKeys {
    return set(@"string", @"percentEncoded");
}

+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:[self string] forKey:@"string"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithString:[coder decodeObjectOfClass:[NSString class] forKey:@"string"]
                 percentEncoded:[coder decodeBoolForKey:@"percentEncoded"]];
}
// }}}

@end
