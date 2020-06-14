#import <objc/runtime.h>
#import "../L0Prefs/L0Prefs.h"
#import "EVSPortionVM.h"

@implementation EVSPortionVM

+ (NSDictionary<NSString *, NSString *> *)propertyNameMappings {
    return @{
        @"paramTranslations"         : @"Query Translator",
        @"parameter"                 : @"Parameter Name",
        @"percentEncodingIterations" : @"Percent Encoding",
        @"regex"                     : @"Regular Expression",
        @"string"                    : @"Text",
        @"templet"                   : @"Template",
        @"path"                      : @"Key-value path"
    };
}

+ (NSDictionary<NSString *, Class> *)classNameMappings {
    return @{
        @"Address unwrapper"  : [EVKMapItemUnwrapperPortion class],
        @"Constant Text"      : [EVKStaticStringPortion class],
        @"Domain"             : [EVKHostPortion class],
        @"Full URL"           : [EVKFullURLPortion class],
        @"Key-value path"     : [EVKKeyValuePathPortion class],
        @"Path"               : [EVKTrimmedPathPortion class],
        @"Query Parameter"    : [EVKQueryParameterValuePortion class],
        @"Query"              : [EVKQueryPortion class],
        @"Regex Substitution" : [EVKRegexSubstitutionPortion class],
        @"Resource Specifier" : [EVKTrimmedResourceSpecifierPortion class],
        @"Scheme"             : [EVKSchemePortion class],
        @"Translated Query"   : [EVKTranslatedQueryPortion class],
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
    else if([obj isKindOfClass:[NSNumber class]])
        str = [NSString stringWithFormat:@"%d", [(NSNumber *)obj intValue]];
    else if([obj isKindOfClass:[NSDictionary class]])
        str = @"Query Tranlator";

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
    else if([obj isKindOfClass:[NSNumber class]])
        return [L0StepperCell class];
    else if([obj isKindOfClass:[NSDictionary class]])
        return [L0LinkCell class];
    else if([obj isKindOfClass:[NSString class]])
        return [L0EditTextCell class];
    return [L0EditTextCell class];
}

@end
