#import "EVSPreferenceManager.h"

#define handle(err) if(err) { NSLog(@"[EVS] %@", [err localizedDescription]); err = nil; }
#define NEWALT [EVKAppAlternative alloc]

#pragma GCC diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

NSString *const dir              = @"/var/mobile/Library/Preferences/EvilScheme/";
NSString *const prefsPath        = @"file:/var/mobile/Library/Preferences/EvilScheme/prefs.plist";
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
                                                                                                        [EVKStaticStringPortion portionWithString:aloha percentEncoded:NO],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncoded:YES],
                                                                                                        [EVKQueryPortion portionWithPercentEncoding:YES],
                                                                                                ],
                                                                                                @"^http(s?):" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:aloha percentEncoded:NO],
                                                                                                        [EVKFullURLPortion portionWithPercentEncoding:YES],
                                                                                                ],
                                                                                            }] name:@"Aloha"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.brave.ios.browser"
                                                                                            urlOutlines:@{
                                                                                                @"^x-web-search:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:brv percentEncoded:NO],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncoded:YES],
                                                                                                        [EVKQueryPortion portionWithPercentEncoding:YES],
                                                                                                ],
                                                                                                @"^http(s?):" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:brv percentEncoded:NO],
                                                                                                        [EVKFullURLPortion portionWithPercentEncoding:YES],
                                                                                                ],
                                                                                            }] name:@"Brave"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.lipslabs.cake"
                                                                                            urlOutlines:@{
                                                                                                @"^x-web-search:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:cake percentEncoded:NO],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncoded:YES],
                                                                                                        [EVKQueryPortion portionWithPercentEncoding:YES],
                                                                                                ],
                                                                                                @"^http(s?):" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:cake percentEncoded:NO],
                                                                                                        [EVKFullURLPortion portionWithPercentEncoding:YES],
                                                                                                ],
                                                                                            }] name:@"Cake"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.duckduckgo.mobile.ios"
                                                                                            urlOutlines:@{
                                                                                                @"^x-web-search:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:ddgBrowser percentEncoded:NO],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncoded:YES],
                                                                                                        [EVKQueryPortion portionWithPercentEncoding:YES],
                                                                                                ],
                                                                                                @"^http(s?):" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:ddgBrowser percentEncoded:NO],
                                                                                                        [EVKFullURLPortion portionWithPercentEncoding:NO],
                                                                                                ],
                                                                                            }] name:@"DuckDuckGo"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.microsoft.msedge"
                                                                                            urlOutlines:@{
                                                                                                @"^x-web-search:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"microsoft-edge-https://" percentEncoded:NO],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncoded:YES],
                                                                                                        [EVKQueryPortion portionWithPercentEncoding:YES],
                                                                                                ],
                                                                                                @"^http:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"microsoft-edge-http://" percentEncoded:NO],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncoding:NO],
                                                                                                ],
                                                                                                @"^https:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"microsoft-edge-https://" percentEncoded:NO],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncoding:NO],
                                                                                                ],
                                                                                            }] name:@"Microsoft Edge"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.google.chrome.ios"
                                                                                            urlOutlines:@{
                                                                                                @"^x-web-search:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"googlechromes://" percentEncoded:NO],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncoded:YES],
                                                                                                        [EVKQueryPortion portionWithPercentEncoding:YES],
                                                                                                ],
                                                                                                @"^http:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"googlechrome://" percentEncoded:NO],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncoding:NO],
                                                                                                ],
                                                                                                @"^https:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"googlechromes://" percentEncoded:NO],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncoding:NO],
                                                                                                ],
                                                                                            }] name:@"Google Chrome"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"org.mozilla.ios.Firefox"
                                                                                            urlOutlines:@{
                                                                                                @"^x-web-search:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:ffx percentEncoded:NO],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncoded:YES],
                                                                                                        [EVKQueryPortion portionWithPercentEncoding:YES],
                                                                                                ],
                                                                                                @"^http(s?):" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:ffx percentEncoded:NO],
                                                                                                        [EVKFullURLPortion portionWithPercentEncoding:YES],
                                                                                                ],
                                                                                            }] name:@"Firefox"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"org.mozilla.ios.Focus"
                                                                                            urlOutlines:@{
                                                                                                @"^x-web-search:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:focus percentEncoded:NO],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncoded:YES],
                                                                                                        [EVKQueryPortion portionWithPercentEncoding:YES],
                                                                                                ],
                                                                                                @"^http(s?):" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:focus percentEncoded:NO],
                                                                                                        [EVKFullURLPortion portionWithPercentEncoding:YES],
                                                                                                ],
                                                                                            }] name:@"Firefox Focus"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.miketigas.OnionBrowser"
                                                                                            urlOutlines:@{
                                                                                                @"^x-web-search:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"onionhttps://" percentEncoded:NO],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncoded:YES],
                                                                                                        [EVKQueryPortion portionWithPercentEncoding:YES],
                                                                                                ],
                                                                                                @"^http:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"onionhttp://" percentEncoded:NO],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncoding:NO],
                                                                                                ],
                                                                                                @"^https:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"onionhttps://" percentEncoded:NO],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncoding:NO],
                                                                                                ],
                                                                                            }] name:@"OnionBrowser"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.opera.OperaTouch"
                                                                                            urlOutlines:@{
                                                                                                @"^x-web-search:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"touch-https://" percentEncoded:NO],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncoded:YES],
                                                                                                        [EVKQueryPortion portionWithPercentEncoding:YES],
                                                                                                ],
                                                                                                @"^http:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"touch-http://" percentEncoded:NO],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncoding:NO],
                                                                                                ],
                                                                                                @"^https:" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"touch-https://" percentEncoded:NO],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncoding:NO],
                                                                                                ],
                                                                                            }] name:@"Opera"],
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
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.Maps"
                                                                                     substituteBundleID:@"com.waze.iphone"
                                                                                            urlOutlines:@{
                                                                                                @"^(((http(s?)://)?maps.apple.com)|(maps:))" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"waze://?" percentEncoded:NO],
                                                                                                        [EVKTranslatedQueryPortion portionWithDictionary:@{
                                                                                                            @"address" : [EVKQueryItemLexicon identityLexiconWithName:@"q"],
                                                                                                            @"daddr"   : [EVKQueryItemLexicon identityLexiconWithName:@"q"],
                                                                                                            @"ll"      : [EVKQueryItemLexicon identityLexiconWithName:@"ll"],
                                                                                                            @"near"    : [EVKQueryItemLexicon identityLexiconWithName:@"ll"],
                                                                                                            @"q"       : [EVKQueryItemLexicon identityLexiconWithName:@"q"],
                                                                                                            @"sll"     : [EVKQueryItemLexicon identityLexiconWithName:@"ll"],
                                                                                                            @"z"       : [EVKQueryItemLexicon identityLexiconWithName:@"z"],
                                                                                                        } percentEncoded:NO]
                                                                                                ]}] name:@"Waze"],
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
                                                                                                @".*reddit.com/.+$.*" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"apollo://" percentEncoded:NO],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncoding:NO],
                                                                                                ],
                                                                                                @".*reddit.com(/?)$" : @[
                                                                                                        [EVKStaticStringPortion portionWithString:@"apollo://" percentEncoded:NO],
                                                                                                        [EVKTrimmedPathPortion portionWithPercentEncoding:NO],
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

@end

#pragma GCC diagnostic pop
