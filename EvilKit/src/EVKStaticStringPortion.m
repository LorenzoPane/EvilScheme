#import "EVKURLPortions.h"

#define set(...) [NSOrderedSet orderedSetWithObjects:__VA_ARGS__, nil]

@implementation EVKStaticStringPortion

- (instancetype)initWithString:(NSString *)str percentEncodingIterations:(int)iterations {
    if((self = [super initWithPercentEncodingIterations:iterations])) {
        _string = str;
    }

    return self;
}

- (instancetype)init {
    return [self initWithString:@"" percentEncodingIterations:0];
}

+ (instancetype)portionWithString:(NSString *)str percentEncodingIterations:(int)iterations {
    return [[EVKStaticStringPortion alloc] initWithString:str percentEncodingIterations:iterations];
}

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url { return [self string]; }

- (NSString *)stringRepresentation {
    return [NSString stringWithFormat:@"Text: %@", [self string]];
}

// Coding {{{
- (NSOrderedSet<NSString *> *)endUserAccessibleKeys {
    return set(@"string", @"percentEncodingIterations");
}

+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:[self string] forKey:@"string"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithString:[coder decodeObjectOfClass:[NSString class] forKey:@"string"]
      percentEncodingIterations:[coder decodeIntForKey:@"percentEncodingIterations"]];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[self class] portionWithString:[self string]
                 percentEncodingIterations:[[self percentEncodingIterations] intValue]];
}
// }}}

@end
