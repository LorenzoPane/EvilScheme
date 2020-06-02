#import "EVSPreferenceManager.h"

#define handle(err) if(err) { NSLog(@"[EVS] %@", [err localizedDescription]); err = nil; }
#define NEWALT [EVKAppAlternative alloc]

#pragma GCC diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

NSString *const dir              = @"/var/mobile/Library/Preferences/EvilScheme/";
NSString *const prefsPath        = @"file:/var/mobile/Library/Preferences/EvilScheme/prefs.plist";
NSString *const blacklistPath    = @"file:/var/mobile/Library/Preferences/EvilScheme/blacklist.plist";
NSString *const searchEnginePath = @"file:/var/mobile/Library/Preferences/EvilScheme/search.txt";
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

+ (void)applyActiveAlternatives:(NSArray<EVSAppAlternativeWrapper *> *)alternatives {
    NSError *err;


    NSMutableDictionary<NSString *, EVKAppAlternative *> *dict = [NSMutableDictionary new];
    for(EVSAppAlternativeWrapper *alt in alternatives) {
        dict[[[alt orig] targetBundleID]] = [alt orig];
    }

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[NSDictionary dictionaryWithDictionary:dict]
                                         requiringSecureCoding:NO
                                                         error:&err]; handle(err);
    [data writeToURL:[NSURL URLWithString:alternativesPath]
             options:0
               error:&err]; handle(err);
}

+ (void)setActiveAlternatives:(NSArray<EVSAppAlternativeWrapper *> *)alternatives {
    NSError *err;

    [self ensureDirExists:dir];

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:alternatives
                                         requiringSecureCoding:NO
                                                         error:&err]; handle(err);
    [data writeToURL:[NSURL URLWithString:prefsPath]
             options:0
               error:&err]; handle(err);
}

+ (L0DictionaryController<NSArray<EVSAppAlternativeWrapper *> *> *)presets {
    NSString *search = @{
        @"DuckDuckGo": @"https://ddg.gg/?q=",
        @"Google": @"https://google.com/search?q=",
        @"Yahoo": @"https://search.yahoo.com/search?q=",
        @"Bing": @"http://bing.com/search?q=",
    }[[self searchEngine]];

    NSString *aloha = @"alohabrowser://open?link=";
    NSString *brv = @"brave://open-url?url=";
    NSString *cake = @"cakebrowser://open-url?url=";
    NSString *ddgBrowser = @"ddgQuickLink://";
    NSString *ffx = @"firefox://open-url?url=";
    NSString *focus = @"firefox-focus://open-url?url=";

    return [[L0DictionaryController alloc] initWithDict: @{
        @"Web Browsers": @[
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.alohabrowser.alohabrowser"
                                                                                            urlOutlines:@{
                                                                                                @"^x-web-search:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:aloha percentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncodingIterations:1],
                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:1],
                                                                                                ],
                                                                                                @"^http(s?):" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:aloha percentEncodingIterations:0],
                                                                                                        [EVKFullURLPortion portionWithPercentEncodingIterations:1],
                                                                                                ],
                                                                                            }] name:@"Aloha"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.brave.ios.browser"
                                                                                            urlOutlines:@{
                                                                                                @"^x-web-search:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:brv percentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncodingIterations:1],
                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:1],
                                                                                                ],
                                                                                                @"^http(s?):" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:brv percentEncodingIterations:0],
                                                                                                        [EVKFullURLPortion portionWithPercentEncodingIterations:1],
                                                                                                ],
                                                                                            }] name:@"Brave"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.lipslabs.cake"
                                                                                            urlOutlines:@{
                                                                                                @"^x-web-search:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:cake percentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncodingIterations:1],
                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:1],
                                                                                                ],
                                                                                                @"^http(s?):" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:cake percentEncodingIterations:0],
                                                                                                        [EVKFullURLPortion portionWithPercentEncodingIterations:1],
                                                                                                ],
                                                                                            }] name:@"Cake"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.duckduckgo.mobile.ios"
                                                                                            urlOutlines:@{
                                                                                                @"^x-web-search:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:ddgBrowser percentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncodingIterations:1],
                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:1],
                                                                                                ],
                                                                                                @"^http(s?):" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:ddgBrowser percentEncodingIterations:0],
                                                                                                        [EVKFullURLPortion portionWithPercentEncodingIterations:0],
                                                                                                ],
                                                                                            }] name:@"DuckDuckGo"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.microsoft.msedge"
                                                                                            urlOutlines:@{
                                                                                                @"^x-web-search:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"microsoft-edge-https://" percentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncodingIterations:1],
                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:1],
                                                                                                ],
                                                                                                @"^http:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"microsoft-edge-http://" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncodingIterations:0],
                                                                                                ],
                                                                                                @"^https:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"microsoft-edge-https://" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncodingIterations:0],
                                                                                                ],
                                                                                            }] name:@"Microsoft Edge"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.google.chrome.ios"
                                                                                            urlOutlines:@{
                                                                                                @"^x-web-search:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"googlechromes://" percentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncodingIterations:1],
                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:1],
                                                                                                ],
                                                                                                @"^http:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"googlechrome://" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncodingIterations:0],
                                                                                                ],
                                                                                                @"^https:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"googlechromes://" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncodingIterations:0],
                                                                                                ],
                                                                                            }] name:@"Google Chrome"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"org.mozilla.ios.Firefox"
                                                                                            urlOutlines:@{
                                                                                                @"^x-web-search:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:ffx percentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncodingIterations:1],
                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:1],
                                                                                                ],
                                                                                                @"^http(s?):" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:ffx percentEncodingIterations:0],
                                                                                                        [EVKFullURLPortion portionWithPercentEncodingIterations:1],
                                                                                                ],
                                                                                            }] name:@"Firefox"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"org.mozilla.ios.Focus"
                                                                                            urlOutlines:@{
                                                                                                @"^x-web-search:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:focus percentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncodingIterations:1],
                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:1],
                                                                                                ],
                                                                                                @"^http(s?):" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:focus percentEncodingIterations:0],
                                                                                                        [EVKFullURLPortion portionWithPercentEncodingIterations:1],
                                                                                                ],
                                                                                            }] name:@"Firefox Focus"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.miketigas.OnionBrowser"
                                                                                            urlOutlines:@{
                                                                                                @"^x-web-search:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"onionhttps://" percentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncodingIterations:1],
                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:1],
                                                                                                ],
                                                                                                @"^http:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"onionhttp://" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncodingIterations:0],
                                                                                                ],
                                                                                                @"^https:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"onionhttps://" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncodingIterations:0],
                                                                                                ],
                                                                                            }] name:@"OnionBrowser"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.opera.OperaTouch"
                                                                                            urlOutlines:@{
                                                                                                @"^x-web-search:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"touch-https://" percentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncodingIterations:1],
                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:1],
                                                                                                ],
                                                                                                @"^http:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"touch-http://" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncodingIterations:0],
                                                                                                ],
                                                                                                @"^https:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"touch-https://" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncodingIterations:0],
                                                                                                ],
                                                                                            }] name:@"Opera"],
        ],
        @"Maps": @[
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.Maps"
                                                                                     substituteBundleID:@"com.google.Maps"
                                                                                            urlOutlines:@{
                                                                                                @"^(((http(s?)://)?maps.apple.com)|(maps:))" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"comgooglemaps://?" percentEncodingIterations:0],
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
                                                                                                            @"address" : [EVKQueryItemLexicon identityLexiconWithName:@"q"],
                                                                                                            @"daddr"   : [EVKQueryItemLexicon identityLexiconWithName:@"daddr"],
                                                                                                            @"saddr"   : [EVKQueryItemLexicon identityLexiconWithName:@"saddr"],
                                                                                                            @"q"       : [EVKQueryItemLexicon identityLexiconWithName:@"q"],
                                                                                                            @"ll"      : [EVKQueryItemLexicon identityLexiconWithName:@"q"],
                                                                                                            @"z"       : [EVKQueryItemLexicon identityLexiconWithName:@"zoom"],
                                                                                                        } percentEncodingIterations:0]
                                                                                                ]}] name:@"Google Maps"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.Maps"
                                                                                     substituteBundleID:@"com.waze.iphone"
                                                                                            urlOutlines:@{
                                                                                                @"^(((http(s?)://)?maps.apple.com)|(maps:))" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"waze://?" percentEncodingIterations:0],
                                                                                                        [EVKTranslatedQueryPortion portionWithDictionary:@{
                                                                                                            @"address" : [EVKQueryItemLexicon identityLexiconWithName:@"q"],
                                                                                                            @"daddr"   : [EVKQueryItemLexicon identityLexiconWithName:@"q"],
                                                                                                            @"ll"      : [EVKQueryItemLexicon identityLexiconWithName:@"ll"],
                                                                                                            @"near"    : [EVKQueryItemLexicon identityLexiconWithName:@"ll"],
                                                                                                            @"q"       : [EVKQueryItemLexicon identityLexiconWithName:@"q"],
                                                                                                            @"sll"     : [EVKQueryItemLexicon identityLexiconWithName:@"ll"],
                                                                                                            @"z"       : [EVKQueryItemLexicon identityLexiconWithName:@"z"],
                                                                                                        } percentEncodingIterations:0]
                                                                                                ]}] name:@"Waze"],
        ],
        @"Mail Clients": @[
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilemail"
                                                                                     substituteBundleID:@"com.readdle.smartemail"
                                                                                            urlOutlines:@{
                                                                                                @"^mailto:[^\?]*$" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"readdle-spark://compose?recipient=" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedPathPortion portionWithPercentEncodingIterations:0],
                                                                                                ],
                                                                                                @"^mailto:.*\?.*$" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"readdle-spark://compose?recipient=" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedPathPortion portionWithPercentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:@"&" percentEncodingIterations:0],
                                                                                                        [EVKTranslatedQueryPortion portionWithDictionary:@{
                                                                                                            @"bcc"     : [EVKQueryItemLexicon identityLexiconWithName:@"bcc"],
                                                                                                            @"body"    : [EVKQueryItemLexicon identityLexiconWithName:@"body"],
                                                                                                            @"cc"      : [EVKQueryItemLexicon identityLexiconWithName:@"cc"],
                                                                                                            @"subject" : [EVKQueryItemLexicon identityLexiconWithName:@"subject"],
                                                                                                            @"to"      : [EVKQueryItemLexicon identityLexiconWithName:@"recipient"],
                                                                                                        } percentEncodingIterations:0],
                                                                                                ],
                                                                                            }] name:@"Spark"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilemail"
                                                                                     substituteBundleID:@"com.google.Gmail"
                                                                                            urlOutlines:@{
                                                                                                @"^mailto:[^\?]*$" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"googlegmail://co?to=" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedPathPortion portionWithPercentEncodingIterations:0],
                                                                                                ],
                                                                                                @"^mailto:.*\?.*$" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"googlegmail://co?to=" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedPathPortion portionWithPercentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:@"&" percentEncodingIterations:0],

                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:1],
                                                                                                ],
                                                                                            }] name:@"GMail"],
        ],
        @"Package Manager": @[
                //            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Installer"],
                //            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Sileo"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.saurik.Cydia"
                                                                                     substituteBundleID:@"xyz.willy.Zebra"
                                                                                            urlOutlines:@{
                                                                                                @"^cydia:.*" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"zbra://sources/add/" percentEncodingIterations:0],
                                                                                                        [EVKRegexSubstitutionPortion portionWithRegex:@"(.*)=(.*)" template:@"$2" percentEncodingIterations:0],
                                                                                                ],
                                                                                            }] name:@"Zebra"],
        ],
        @"Reddit Client": @[
                //            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Alien Blue"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.reddit.Reddit"
                                                                                     substituteBundleID:@"com.christianselig.Apollo"
                                                                                            urlOutlines:@{
                                                                                                @".*reddit.com/r.*" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"apollo://reddit.com/" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedPathPortion portionWithPercentEncodingIterations:0],
                                                                                                ],
                                                                                                @".*reddit.com(/?)$" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"apollo://" percentEncodingIterations:0],
                                                                                                ],
                                                                                                @"amp.reddit.com/branch-redirect.*" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"apollo://reddit.com" percentEncodingIterations:0],
                                                                                                        [EVKQueryParameterValuePortion portionWithParameter:@"path" percentEncodingIterations:0]
                                                                                                ],
                                                                                                @".*reddit.app.link.*" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"apollo://reddit.com" percentEncodingIterations:0],
                                                                                                        [EVKQueryParameterValuePortion portionWithParameter:@"$deeplink_path" percentEncodingIterations:0]
                                                                                                ],
                                                                                            }] name:@"Apollo"],
        ],
    }];
}

+ (void)setSearchEngine:(NSString *)engine {
    [self ensureDirExists:dir];

    NSError *err;
    [engine writeToURL:[NSURL URLWithString:searchEnginePath]
            atomically:YES
              encoding:NSUnicodeStringEncoding
                 error:&err]; handle(err);
}

+ (NSString *)searchEngine {
    [self ensureDirExists:dir];

    NSError *err;
    NSString *ret = [NSString stringWithContentsOfURL:[NSURL URLWithString:searchEnginePath]
                                             encoding:NSUnicodeStringEncoding
                                                error:&err]; handle(err);
    return ret ? : @"DuckDuckGo";
}

+ (void)setBlacklistedApps:(NSArray<NSString *> *)apps {
    NSError *err;
    NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSetWithArray:apps];
    [set removeObject:@""];

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:set
                                         requiringSecureCoding:YES
                                                         error:&err]; handle(err);
    [data writeToURL:[NSURL URLWithString:blacklistPath]
             options:0
               error:&err]; handle(err);
}

+ (NSArray<NSString *> *)blacklistedApps {
    NSError *err;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:blacklistPath]
                                         options:0
                                           error:&err]; handle(err);
    NSOrderedSet *set = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSOrderedSet class], [NSString class], nil]
                                                            fromData:data
                                                               error:&err]; handle(err);
    return [set array] ? : @[];
}

@end

#pragma GCC diagnostic pop
