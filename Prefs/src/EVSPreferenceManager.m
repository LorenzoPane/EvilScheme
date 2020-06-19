#import "EVSPreferenceManager.h"

#define handle(err) if(err) { NSLog(@"[EVS] %@", [err localizedDescription]); err = nil; }
#define NEWALT [EVKAppAlternative alloc]

#pragma GCC diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

NSString *const dir              = @"/var/mobile/Library/Preferences/EvilScheme/";
NSString *const logPath          = @"file:/var/mobile/Library/Preferences/EvilScheme/log_v0.plist";
NSString *const prefsPath        = @"file:/var/mobile/Library/Preferences/EvilScheme/prefs_v0.plist";
NSString *const blacklistPath    = @"file:/var/mobile/Library/Preferences/EvilScheme/blacklist_v0.plist";
NSString *const searchEnginePath = @"file:/var/mobile/Library/Preferences/EvilScheme/search_v0.txt";
NSString *const alternativesPath = @"file:/var/mobile/Library/Preferences/EvilScheme/alternatives_v0.plist";

@implementation EVSPreferenceManager

+ (void)ensureDirExists:(NSString *)dirString {
    NSError *err;

    if (![[NSFileManager defaultManager] fileExistsAtPath:dirString
                                              isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirString
                                  withIntermediateDirectories:YES
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
    for(EVSAppAlternativeWrapper *altWrapper in alternatives) {
        for(NSString *target in [altWrapper targetBundleIDs]) {
            EVKAppAlternative *alt = [[altWrapper orig] copy];
            [alt setTargetBundleID:target];
            dict[target] = alt;
        }
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
    NSString *eng = [self searchEngine];
    NSString *search = @{
        @"DuckDuckGo": @"ddg.gg/?q=",
        @"Google": @"google.com/search?q=",
        @"Yahoo": @"search.yahoo.com/search?q=",
        @"Bing": @"bing.com/search?q=",
    }[eng] ? : eng;

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
                                                                                            urlOutlines:@[
                                                                                                [EVKAction actionWithPattern:@"^x-web-search:" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:aloha percentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:@"https://" percentEncodingIterations:1],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncodingIterations:1],
                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^http(s?):" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:aloha percentEncodingIterations:0],
                                                                                                        [EVKFullURLPortion portionWithPercentEncodingIterations:1],
                                                                                                ]],
                                                                                            ]] name:@"Aloha"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.brave.ios.browser"
                                                                                            urlOutlines:@[
                                                                                                [EVKAction actionWithPattern:@"^x-web-search:" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:brv percentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:@"https://" percentEncodingIterations:1],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncodingIterations:1],
                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:1],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^http(s?):" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:brv percentEncodingIterations:0],
                                                                                                        [EVKFullURLPortion portionWithPercentEncodingIterations:1],
                                                                                                ]],
                                                                                            ]] name:@"Brave"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.lipslabs.cake"
                                                                                            urlOutlines:@[
                                                                                                [EVKAction actionWithPattern:@"^x-web-search:" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:cake percentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:@"https://" percentEncodingIterations:1],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncodingIterations:1],
                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:2],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^http(s?):" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:cake percentEncodingIterations:0],
                                                                                                        [EVKFullURLPortion portionWithPercentEncodingIterations:1],
                                                                                                ]],
                                                                                            ]] name:@"Cake"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.duckduckgo.mobile.ios"
                                                                                            urlOutlines:@[
                                                                                                [EVKAction actionWithPattern:@"^x-web-search:" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:ddgBrowser percentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:@"https://" percentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncodingIterations:0],
                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^http(s?):" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:ddgBrowser percentEncodingIterations:0],
                                                                                                        [EVKFullURLPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                            ]] name:@"DuckDuckGo"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.microsoft.msedge"
                                                                                            urlOutlines:@[
                                                                                                [EVKAction actionWithPattern:@"^x-web-search:" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"microsoft-edge-https://" percentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncodingIterations:0],
                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^http:" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"microsoft-edge-http://" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^https:" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"microsoft-edge-https://" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                            ]] name:@"Microsoft Edge"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.google.chrome.ios"
                                                                                            urlOutlines:@[
                                                                                                [EVKAction actionWithPattern:@"^x-web-search:" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"googlechromes://" percentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncodingIterations:0],
                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^http:" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"googlechrome://" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^https:" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"googlechromes://" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                            ]] name:@"Google Chrome"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"org.mozilla.ios.Firefox"
                                                                                            urlOutlines:@[
                                                                                                [EVKAction actionWithPattern:@"^x-web-search:" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:ffx percentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:@"https://" percentEncodingIterations:1],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncodingIterations:1],
                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:1],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^http(s?):" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:ffx percentEncodingIterations:0],
                                                                                                        [EVKFullURLPortion portionWithPercentEncodingIterations:1],
                                                                                                ]],
                                                                                            ]] name:@"Firefox"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"org.mozilla.ios.Focus"
                                                                                            urlOutlines:@[
                                                                                                [EVKAction actionWithPattern:@"^x-web-search:" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:focus percentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:@"https://" percentEncodingIterations:1],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncodingIterations:1],
                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:1],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^http(s?):" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:focus percentEncodingIterations:0],
                                                                                                        [EVKFullURLPortion portionWithPercentEncodingIterations:1],
                                                                                                ]],
                                                                                            ]] name:@"Firefox Focus"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.miketigas.OnionBrowser"
                                                                                            urlOutlines:@[
                                                                                                [EVKAction actionWithPattern:@"^x-web-search:" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"onionhttps://" percentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncodingIterations:0],
                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^http:" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"onionhttp://" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^https:" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"onionhttps://" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                            ]] name:@"OnionBrowser"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilesafari"
                                                                                     substituteBundleID:@"com.opera.OperaTouch"
                                                                                            urlOutlines:@[
                                                                                                [EVKAction actionWithPattern:@"^x-web-search:" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"touch-https://" percentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:search percentEncodingIterations:0],
                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^http:" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"touch-http://" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^https:" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"touch-https://" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedResourceSpecifierPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                            ]] name:@"Opera"],
        ],
        @"Maps": @[
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.Maps"
                                                                                     substituteBundleID:@"com.google.Maps"
                                                                                            urlOutlines:@[
                                                                                                [EVKAction actionWithPattern:@"^mapitem://" outline:@[
                                                                                                    [EVKStaticStringPortion portionWithString:@"waze://?q=" percentEncodingIterations:0],
                                                                                                    [EVKMapItemUnwrapperPortion portionWithPercentEncodingIterations:1],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^(((http(s?)://)?maps.apple.com)|(maps:))" outline:@[
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
                                                                                                        } percentEncodingIterations:0]]
                                                                                                ]]] name:@"Google Maps"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.Maps"
                                                                                     substituteBundleID:@"com.waze.iphone"
                                                                                            urlOutlines:@[
                                                                                                [EVKAction actionWithPattern:@"^mapitem://" outline:@[
                                                                                                    [EVKStaticStringPortion portionWithString:@"waze://?q=" percentEncodingIterations:0],
                                                                                                    [EVKMapItemUnwrapperPortion portionWithPercentEncodingIterations:1],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^(((http(s?)://)?maps.apple.com)|(maps:))" outline:@[
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
                                                                                                ]]]] name:@"Waze"],
        ],
        @"Mail Clients": @[
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilemail"
                                                                                     substituteBundleID:@"com.readdle.smartemail"
                                                                                            urlOutlines:@[
                                                                                                [EVKAction actionWithPattern:@"^mailto:[^\?]*$" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"readdle-spark://compose?recipient=" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedPathPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^mailto:.*\?.*$" outline:@[
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
                                                                                                ]],
                                                                                            ]] name:@"Spark"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilemail"
                                                                                     substituteBundleID:@"com.google.Gmail"
                                                                                            urlOutlines:@[
                                                                                                [EVKAction actionWithPattern:@"^mailto:[^\?]*$" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"googlegmail://co?to=" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedPathPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^mailto:.*\?.*$" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"googlegmail://co?to=" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedPathPortion portionWithPercentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:@"&" percentEncodingIterations:0],

                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                            ]] name:@"GMail"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilemail"
                                                                                     substituteBundleID:@"com.CloudMagic.Mail"
                                                                                            urlOutlines:@[
                                                                                                [EVKAction actionWithPattern:@"^mailto:[^\?]*$" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"cloudmagic://compose?to=" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedPathPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^mailto:.*\?.*$" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"cloudmagic://compose?to=" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedPathPortion portionWithPercentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:@"&" percentEncodingIterations:0],

                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                            ]] name:@"Newton"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilemail"
                                                                                     substituteBundleID:@"com.airmailapp.iphone"
                                                                                            urlOutlines:@[
                                                                                                [EVKAction actionWithPattern:@"^mailto:[^\?]*$" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"airmail://compose?to=" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedPathPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^mailto:.*\?.*$" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"airmail://compose?to=" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedPathPortion portionWithPercentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:@"&" percentEncodingIterations:0],


                                                                                                        [EVKTranslatedQueryPortion portionWithDictionary:@{
                                                                                                            @"bcc"     : [EVKQueryItemLexicon identityLexiconWithName:@"bcc"],
                                                                                                            @"body"    : [EVKQueryItemLexicon identityLexiconWithName:@"plainBody"],
                                                                                                            @"cc"      : [EVKQueryItemLexicon identityLexiconWithName:@"cc"],
                                                                                                            @"subject" : [EVKQueryItemLexicon identityLexiconWithName:@"subject"],
                                                                                                            @"to"      : [EVKQueryItemLexicon identityLexiconWithName:@"recipient"],
                                                                                                        } percentEncodingIterations:0],
                                                                                                ]],
                                                                                            ]] name:@"Airmail"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.apple.mobilemail"
                                                                                     substituteBundleID:@"com.microsoft.Office.Outlook"
                                                                                            urlOutlines:@[
                                                                                                [EVKAction actionWithPattern:@"^mailto:[^\?]*$" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"ms-outlook://compose?to=" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedPathPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^mailto:.*\?.*$" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"ms-outlook://compose?to=" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedPathPortion portionWithPercentEncodingIterations:0],
                                                                                                        [EVKStaticStringPortion portionWithString:@"&" percentEncodingIterations:0],

                                                                                                        [EVKQueryPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                             ]] name:@"Outlook"],
        ],
        @"Package Managers": @[
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.saurik.Cydia"
                                                                                     substituteBundleID:@"xyz.willy.Zebra"
                                                                                            urlOutlines:@[
                                                                                                [EVKAction actionWithPattern:@"^cydia:.*(((source).*(package))|((package).*(source)))" outline:@[
                                                                                                    [EVKStaticStringPortion portionWithString:@"zbra://packages/" percentEncodingIterations:0],
                                                                                                    [EVKRegexSubstitutionPortion portionWithRegex:@".*?package=(.*?)(&|$).*"
                                                                                                                                         template:@"$1"
                                                                                                                        percentEncodingIterations:0],
                                                                                                    [EVKStaticStringPortion portionWithString:@"?source=" percentEncodingIterations:0],
                                                                                                    [EVKRegexSubstitutionPortion portionWithRegex:@".*?source=(.*?)(&|$).*"
                                                                                                                                         template:@"$1"
                                                                                                                        percentEncodingIterations:0],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^cydia:.*package" outline:@[
                                                                                                    [EVKStaticStringPortion portionWithString:@"zbra://packages/" percentEncodingIterations:0],
                                                                                                    [EVKRegexSubstitutionPortion portionWithRegex:@".*?package=(.*?)(&|$).*"
                                                                                                                                         template:@"$1"
                                                                                                                        percentEncodingIterations:0],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"^cydia:.*source" outline:@[
                                                                                                    [EVKStaticStringPortion portionWithString:@"zbra://sources/add/" percentEncodingIterations:0],
                                                                                                    [EVKRegexSubstitutionPortion portionWithRegex:@".*?source=(.*?)(&|$).*"
                                                                                                                                         template:@"$1"
                                                                                                                        percentEncodingIterations:0],
                                                                                                ]],
                                                                                            ]]
                                                                    name:@"Zebra"
                                                         targetBundleIDs:@[@"org.coolstar.SileoStore"]],
        ],
        @"Reddit Clients": @[
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.reddit.Reddit"
                                                                                     substituteBundleID:@"com.christianselig.Apollo"
                                                                                            urlOutlines:@[
                                                                                                [EVKAction actionWithPattern:@".*reddit.app.link.*" outline:@[
                                                                                                    [EVKStaticStringPortion portionWithString:@"apollo://reddit.com" percentEncodingIterations:0],
                                                                                                    [EVKQueryParameterValuePortion portionWithParameter:@"$deeplink_path" percentEncodingIterations:0]
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"amp.reddit.com/branch-redirect.*" outline:@[
                                                                                                    [EVKStaticStringPortion portionWithString:@"apollo://reddit.com" percentEncodingIterations:0],
                                                                                                    [EVKQueryParameterValuePortion portionWithParameter:@"path" percentEncodingIterations:0]
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@".*reddit.com(/?)$" outline:@[
                                                                                                    [EVKStaticStringPortion portionWithString:@"apollo://" percentEncodingIterations:0],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@".*reddit.com/r.*" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"apollo://reddit.com/" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedPathPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"reddit:///r/.*" outline:@[
                                                                                                    [EVKStaticStringPortion portionWithString:@"apollo://reddit.com/" percentEncodingIterations:0],
                                                                                                    [EVKTrimmedResourceSpecifierPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                          ]] name:@"Apollo"],
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.reddit.Reddit"
                                                                                     substituteBundleID:@"AaronKovacs.Comet"
                                                                                            urlOutlines:@[
                                                                                                [EVKAction actionWithPattern:@".*reddit.app.link.*" outline:@[
                                                                                                    [EVKStaticStringPortion portionWithString:@"comet://reddit.com" percentEncodingIterations:0],
                                                                                                    [EVKQueryParameterValuePortion portionWithParameter:@"$deeplink_path" percentEncodingIterations:0]
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"amp.reddit.com/branch-redirect.*" outline:@[
                                                                                                    [EVKStaticStringPortion portionWithString:@"comet://reddit.com" percentEncodingIterations:0],
                                                                                                    [EVKQueryParameterValuePortion portionWithParameter:@"path" percentEncodingIterations:0]
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@".*reddit.com/r.*" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"comet://reddit.com/" percentEncodingIterations:0],
                                                                                                        [EVKTrimmedPathPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@".*reddit.com(/?)$" outline:@[
                                                                                                        [EVKStaticStringPortion portionWithString:@"comet://" percentEncodingIterations:0],
                                                                                                ]],
                                                                                                [EVKAction actionWithPattern:@"reddit:///r/.*" outline:@[
                                                                                                    [EVKStaticStringPortion portionWithString:@"comet://reddit.com/" percentEncodingIterations:0],
                                                                                                    [EVKTrimmedResourceSpecifierPortion portionWithPercentEncodingIterations:0],
                                                                                                ]],
                                                                                           ]] name:@"Comet"],
        ],
        @"Twitter Clients": @[
                [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:[NEWALT initWithTargetBundleID:@"com.atebits.Tweetie2"
                                                                                     substituteBundleID:@"com.tapbots.Tweetbot4"
                                                                                            urlOutlines:@[
                                                                                                [EVKAction actionWithPattern:@".*twitter.com/[^/]+/?$"
                                                                                                                     outline:@[
                                                                                                                         [EVKStaticStringPortion portionWithString:@"tweetbotbot:///user_profile/" percentEncodingIterations:0],
                                                                                                                         [EVKTrimmedPathPortion portionWithPercentEncodingIterations:0],
                                                                                                                     ]],
                                                                                                [EVKAction actionWithPattern:@".*twitter.com/i/lists/.*$"
                                                                                                                     outline:@[
                                                                                                                         [EVKStaticStringPortion portionWithString:@"tweetbot:///list/" percentEncodingIterations:0],
                                                                                                                         [EVKRegexSubstitutionPortion portionWithRegex:@"^.*/i/lists/(\\d+).*$"
                                                                                                                                                              template:@"$1"
                                                                                                                                             percentEncodingIterations:0],
                                                                                                                     ]],
                                                                                                [EVKAction actionWithPattern:@".*twitter.com/.+/status/.*$"
                                                                                                                     outline:@[
                                                                                                                         [EVKStaticStringPortion portionWithString:@"tweetbot:///status/" percentEncodingIterations:0],
                                                                                                                         [EVKRegexSubstitutionPortion portionWithRegex:@"^.*/[^/]+/status/(\\d+).*$"
                                                                                                                                                              template:@"$1"
                                                                                                                                             percentEncodingIterations:0],
                                                                                                                     ]],
                                                                                                [EVKAction actionWithPattern:@".*twitter.com.*"
                                                                                                                     outline:@[
                                                                                                                         [EVKStaticStringPortion portionWithString:@"tweetbotbot:///" percentEncodingIterations:0],
                                                                                                                         [EVKTrimmedPathPortion portionWithPercentEncodingIterations:0],
                                                                                                                     ]],
                                                                                            ]]
                                                                    name:@"Tweetbot 5"]
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

+ (BOOL)isLogging {
    return [[self logDict][@"enabled"] boolValue];
}

+ (void)setLogging:(BOOL)logging {
    NSMutableDictionary *dict = [[self logDict] ? : @{} mutableCopy];
    dict[@"enabled"] = @(logging);
    [self setLogDict:dict];
}

+ (NSDictionary *)logDict {
    [self ensureDirExists:dir];
    NSError *err;

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:logPath]
                                         options:0
                                           error:&err]; handle(err);

    NSDictionary *ret = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSDictionary class], [NSArray class], [NSString class], [NSNumber class], nil]
                                                            fromData:data
                                                               error:&err]; handle(err);

    return ret;
}

+ (void)setLogDict:(NSDictionary *)dict {
    NSError *err;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict
                                         requiringSecureCoding:NO
                                                         error:&err]; handle(err);
    [data writeToURL:[NSURL URLWithString:logPath]
             options:0
               error:&err]; handle(err);
}

@end

#pragma GCC diagnostic pop
