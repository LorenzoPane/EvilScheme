#import <Foundation/Foundation.h>
#import <EvilKit/EvilKit.h>
#import "EVSAppAlternativeWrapper.h"

@interface EVSPreferenceManager : NSObject

+ (void)ensureDirExists:(NSString *)dirString;
+ (NSArray<EVSAppAlternativeWrapper *> *)activeAlternatives;
+ (void)setActiveAlternatives:(NSArray<EVSAppAlternativeWrapper *> *)alternatives;
+ (void)applyActiveAlternatives:(NSArray<EVSAppAlternativeWrapper *> *)alternatives;
+ (L0DictionaryController<NSArray<EVSAppAlternativeWrapper *> *> *)presets;
+ (void)setSearchEngine:(NSString *)engine;
+ (NSString *)searchEngine;

@end
