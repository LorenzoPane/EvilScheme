#import "EVSPreferenceManager.h"

#define handle(err) if(err) { NSLog(@"[EVS] %@", [err localizedDescription]); err = nil; }
#define NEWALT [EVKAppAlternative alloc]

#pragma GCC diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

NSString *const dir = @"/var/mobile/Library/Preferences/EvilScheme/";
NSString *const prefsPath = @"file:/var/mobile/Library/Preferences/EvilScheme/prefs.plist";
NSString *const alternativesPath = @"file:/var/mobile/Library/Preferences/EvilScheme/alternatives.plist";

@implementation EVSPreferenceManager

+ (void)ensureDirExists:(NSString *)dirString {
    NSError *err;

    if (![[NSFileManager defaultManager] fileExistsAtPath:dirString
                                              isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirString
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:&err];
    } handle(err);
}

+ (NSArray<EVSAppAlternativeWrapper *> *)activeAlternatives {
    NSError *err;

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:prefsPath]
                                         options:0
                                           error:&err]; handle(err);

    NSArray *ret = [NSKeyedUnarchiver unarchiveTopLevelObjectWithData:data
                                                                error:&err]; handle(err);

    return ret ? : @[];
}

+ (void)setActiveAlternatives:(NSArray<EVSAppAlternativeWrapper *> *)alternatives {
    NSError *err;

    [self ensureDirExists:dir];

    // Write prefs to disk
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:alternatives
                                         requiringSecureCoding:NO
                                                         error:&err]; handle(err);
    [data writeToURL:[NSURL URLWithString:prefsPath]
             options:0
               error:&err]; handle(err);

    // Build bundleid-indexed dict for hook
    NSMutableDictionary<NSString *, EVKAppAlternative *> *dict = [NSMutableDictionary new];
    for(EVSAppAlternativeWrapper *alt in alternatives) {
        dict[[[alt orig] targetBundleID]] = [alt orig];
    }

    // Write dict to disk
    data = [NSKeyedArchiver archivedDataWithRootObject:[NSDictionary dictionaryWithDictionary:dict]
                                 requiringSecureCoding:NO
                                                 error:&err]; handle(err);
    [data writeToURL:[NSURL URLWithString:alternativesPath]
             options:0
               error:&err]; handle(err);
}

+ (L0DictionaryController<NSArray<EVSAppAlternativeWrapper *> *> *)presets {
    NSString *brv = @"brave://open-url?url=";
    NSString *ffx = @"firefox-focus://open-url?url=";
    NSString *ddg = @"https://ddg.gg/?q=";

    return [[L0DictionaryController alloc] initWithDict: @{
        @"Web Browsers": @[
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.brave.ios.browser"
                                                                                            urlOutlines:@{
                                                                                                @"^x-web-search:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:brv percentEncoded:NO],
                                                                                                        [EVKStaticStringPortion portionWithString:ddg percentEncoded:YES],
                                                                                                        [EVKQueryPortion portionWithPercentEncoding:YES],
                                                                                                ],
                                                                                                @"^http(s?):" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:brv percentEncoded:NO],
                                                                                                        [EVKFullURLPortion portionWithPercentEncoding:YES],
                                                                                                ],
                                                                                            }] name:@"Brave"],
                //            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Cake"],
                //            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"DuckDuckGo"],
                //            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Google Chrome"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"org.mozilla.ios.Focus"
                                                                                            urlOutlines:@{
                                                                                                @"^x-web-search:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:ffx percentEncoded:NO],
                                                                                                        [EVKStaticStringPortion portionWithString:ddg percentEncoded:YES],
                                                                                                        [EVKQueryPortion portionWithPercentEncoding:YES],
                                                                                                ],
                                                                                                @"^http(s?):" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:ffx percentEncoded:NO],
                                                                                                        [EVKFullURLPortion portionWithPercentEncoding:YES],
                                                                                                ],
                                                                                            }] name:@"Firefox Focus"],
                //            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Firefox"],
                //            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Opera"],
        ],
        @"Maps": @[
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.Maps"
                                                                                     substituteBundleID:@"com.google.Maps"
                                                                                            urlOutlines:@{
                                                                                                @"^(((http(s?)://)?maps.apple.com)|(maps:))" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"comgooglemaps://?" percentEncoded:NO],
                                                                                                        [EVKTranslatedQueryPortion portionWithDictionary:@{
                                                                                                            @"t"       : [[EVKQueryItemLexicon alloc] initWithKeyName:@"directionsmode"
                                                                                                                                                           dictionary:@{
                                                                                                                                                               @"d": @"driving",
                                                                                                                                                               @"w": @"walking",
                                                                                                                                                               @"r": @"transit",
                                                                                                                                                           }
                                                                                                                                                         defaultState:URLQueryStateNull],
                                                                                                            @"dirflg"  : [[EVKQueryItemLexicon alloc] initWithKeyName:@"views"
                                                                                                                                                           dictionary:@{
                                                                                                                                                               @"k": @"satelite",
                                                                                                                                                               @"r": @"transit",
                                                                                                                                                           }
                                                                                                                                                         defaultState:URLQueryStateNull],
                                                                                                            @"address" : [EVKQueryItemLexicon identityLexiconWithName:@"daddr"],
                                                                                                            @"daddr"   : [EVKQueryItemLexicon identityLexiconWithName:@"daddr"],
                                                                                                            @"saddr"   : [EVKQueryItemLexicon identityLexiconWithName:@"saddr"],
                                                                                                            @"q"       : [EVKQueryItemLexicon identityLexiconWithName:@"q"],
                                                                                                            @"ll"      : [EVKQueryItemLexicon identityLexiconWithName:@"q"],
                                                                                                            @"z"       : [EVKQueryItemLexicon identityLexiconWithName:@"zoom"],
                                                                                                        } percentEncoded:NO]
                                                                                                ]}] name:@"Google Maps"],
                //            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Magic Earth"],
                //            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Waze"],
        ],
        @"Mail Clients": @[
                //            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Airmail"],
                //            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Edison"],
                //            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Outlook"],
                //            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"PolyMail"],
                //            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Proton Mail"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilemail"
                                                                                     substituteBundleID:@"com.readdle.smartemail"
                                                                                            urlOutlines:@{
                                                                                                @"^mailto:[^\?]*$" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"readdle-spark://compose?recipient=" percentEncoded:NO],
                                                                                                        [EVKTrimmedPathPortion portionWithPercentEncoding:NO],
                                                                                                ],
                                                                                                @"^mailto:.*\?.*$" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"readdle-spark://compose?recipient=" percentEncoded:NO],
                                                                                                        [EVKTrimmedPathPortion portionWithPercentEncoding:NO],
                                                                                                        [EVKStaticStringPortion portionWithString:@"&" percentEncoded:NO],
                                                                                                        [EVKTranslatedQueryPortion portionWithDictionary:@{
                                                                                                            @"bcc"     : [EVKQueryItemLexicon identityLexiconWithName:@"bcc"],
                                                                                                            @"body"    : [EVKQueryItemLexicon identityLexiconWithName:@"body"],
                                                                                                            @"cc"      : [EVKQueryItemLexicon identityLexiconWithName:@"cc"],
                                                                                                            @"subject" : [EVKQueryItemLexicon identityLexiconWithName:@"subject"],
                                                                                                            @"to"      : [EVKQueryItemLexicon identityLexiconWithName:@"recipient"],
                                                                                                        } percentEncoded:NO],
                                                                                                ],
                                                                                            }] name:@"Spark"],
                //            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Yahoo Mail"],
        ],
        @"Package Manager": @[
                //            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Installer"],
                //            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Sileo"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.saurik.Cydia"
                                                                                     substituteBundleID:@"xyz.willy.Zebra"
                                                                                            urlOutlines:@{
                                                                                                @"^cydia:.*" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"zbra://sources/add/" percentEncoded:NO],
                                                                                                        [EVKRegexSubstitutionPortion portionWithRegex:@"(.*)=(.*)" template:@"$2" percentEncoded:NO],
                                                                                                ],
                                                                                            }] name:@"Zebra"],
        ],
        @"Reddit Client": @[
                //            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Alien Blue"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.reddit.Reddit"
                                                                                     substituteBundleID:@"com.christianselig.Apollo"
                                                                                            urlOutlines:@{
                                                                                                @".*reddit.com.*" : @[
                                                                                                    [EVKStaticStringPortion portionWithString:@"apollo://https://reddit.com/" percentEncoded:NO],
                                                                                                    [EVKTrimmedPathPortion portionWithPercentEncoding:NO],
                                                                                                ]
                                                                                            }] name:@"Apollo"],
        ],
        @"Twitter Client": @[
                //            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"TweetDeck"],
                //            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"TweetBot"],
        ],
    }];
}

@end

#pragma GCC diagnostic pop
