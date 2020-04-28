#import "EVKURLPortions.h"
#import "NSURL+ComponentAdditions.h"

#define set(...) [NSOrderedSet orderedSetWithObjects:__VA_ARGS__, nil]

@implementation EVKFullURLPortion

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url { return [url absoluteString]; }

- (NSString *)stringRepresentation { return @"Full URL"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { [super encodeWithCoder:coder]; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [super initWithCoder:coder]; }
// }}}

@end

@implementation EVKTrimmedPathPortion

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url { return [url trimmedPathComponent]; }

- (NSString *)stringRepresentation { return @"Path"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { [super encodeWithCoder:coder]; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [super initWithCoder:coder]; };
// }}}

@end

@implementation EVKTrimmedResourceSpecifierPortion

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url { return [url trimmedResourceSpecifier]; }

- (NSString *)stringRepresentation { return @"Resource specifier"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { [super encodeWithCoder:coder]; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [super initWithCoder:coder]; };
// }}}

@end

@implementation EVKHostPortion

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url { return [url hostComponent]; }

- (NSString *)stringRepresentation { return @"Host domain"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { [super encodeWithCoder:coder]; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [super initWithCoder:coder]; };
// }}}

@end

@implementation EVKSchemePortion

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url {
    return [url scheme];
}

- (NSString *)stringRepresentation { return @"Original scheme"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { [super encodeWithCoder:coder]; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [super initWithCoder:coder]; };
// }}}

@end

@implementation EVKQueryPortion

- (NSString *)evaluateUnencodedWithURL:(NSURL *)url { return [url queryString]; }

- (NSString *)stringRepresentation { return @"Original query"; }

// Coding {{{
+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder { [super encodeWithCoder:coder]; }

- (instancetype)initWithCoder:(NSCoder *)coder { return [super initWithCoder:coder]; };
// }}}

@end
