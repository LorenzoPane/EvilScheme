#import <objc/runtime.h>
#import "../L0Prefs/L0Prefs.h"
#import "EVSPortionVM.h"

@implementation EVSPortionVM

+ (NSDictionary<NSString *, NSString *> *)propertyNameMappings {
    return @{
        @"percentEncoded"    : @"Percent Encoded",
        @"paramTranslations" : @"Query Translator",
        @"string"            : @"Text",
        @"regex"             : @"Regular Expression",
        @"templet"           : @"Template",
    };
}

+ (NSDictionary<NSString *, Class> *)classNameMappings {
    return @{
        @"Constant Text"      : [EVKStaticStringPortion class],
        @"Full URL"           : [EVKFullURLPortion class],
        @"Path"               : [EVKTrimmedPathPortion class],
        @"Resource Specifier" : [EVKTrimmedResourceSpecifierPortion class],
        @"Domain"             : [EVKHostPortion class],
        @"Scheme"             : [EVKSchemePortion class],
        @"Query"              : [EVKQueryPortion class],
        @"Translated Query"   : [EVKTranslatedQueryPortion class],
        @"Regex Substitution" : [EVKRegexSubstitutionPortion class],
    };
}

- (instancetype)initWithPortion:(NSObject<EVKURLPortion> *)portion {
    if((self = [super init])) {
        _portion = portion;
    }

    return self;
}

- (NSString *)stringRepresentation {
    return [[self portion] stringRepresentation];
}

- (int)propertyCount {
    return (int)[[[self portion] endUserAccessibleKeys] count];
}

- (id)objectForPropertyIndex:(NSInteger)index {
    return [[self portion] valueForKey:[[self portion] endUserAccessibleKeys][index]];
}

- (void)setObject:(NSObject *)obj forPropertyIndex:(NSInteger)index {
    return [[self portion] setValue:obj forKey:[[self portion] endUserAccessibleKeys][index]];
}

- (NSString *)propertyKeyForIndex:(NSInteger)index {
    return [[self portion] endUserAccessibleKeys][index];
}

- (NSString *)propertyNameForIndex:(NSInteger)index {
    return [[self class] propertyNameMappings][[self propertyKeyForIndex:index]];
}

- (NSString *)valueStringForKey:(NSString *)key {
    NSObject *obj = [[self portion] valueForKey:key];
    NSString *str = [NSString stringWithFormat:@"%@", obj];
    if([obj isKindOfClass:objc_getClass("__NSCFBoolean")])
        str = [(NSNumber *)obj boolValue] ? @"True" : @"False";
    else if([obj isKindOfClass:[EVKQueryPortion class]])
        str = @"";

    return str;
}

- (NSString *)valueStringForIndex:(NSInteger)index {
    return [self valueStringForKey:[self propertyKeyForIndex:index]];
}

- (Class)cellTypeForIndex:(NSInteger)index {
    return [self cellTypeForKey:[self propertyKeyForIndex:index]];
}

- (Class)cellTypeForKey:(NSString *)key {
    NSObject *obj = [[self portion] valueForKey:key];
    if([obj isKindOfClass:objc_getClass("__NSCFBoolean")])
        return [L0ToggleCell class];
    else if([obj isKindOfClass:[EVKQueryItemLexicon class]])
        return [L0LinkCell class];
    else if([obj isKindOfClass:[NSString class]])
        return [L0EditTextCell class];
    return [L0EditTextCell class];
}

@end
