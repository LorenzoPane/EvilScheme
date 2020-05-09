#import "EVSPreferenceManager.h"

@implementation EVSPreferenceManager

+ (NSArray<EVSAppAlternativeWrapper *> *)appAlternatives {
    NSString *ffx = @"brave://open-url?url=";
    NSString *ddg = @"https://ddg.gg/?q=";
    EVKAppAlternative *browser = [EVKAppAlternative alloc];
    browser = [browser initWithTargetBundleID:@"com.apple.mobilesafari"
                           substituteBundleID:@"com.brave.ios.browser"
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
                                  }];

    EVKAppAlternative *mail = [EVKAppAlternative alloc];
    mail = [mail initWithTargetBundleID:@"com.apple.mobilemail"
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
                            }];

    EVKAppAlternative *navigator = [EVKAppAlternative alloc];
    navigator = [navigator initWithTargetBundleID:@"com.apple.Maps"
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
                                          ]}];

    return @[
        [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:browser
                                                            name:@"Web Browser"],
        [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:navigator
                                                            name:@"Navigator & Maps"],
        [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:mail
                                                            name:@"Mail Client"],
    ];
}

+ (void)storeAppAlternative:(EVSAppAlternativeWrapper *)appAlternative {
    NSLog(@"Storing %@", appAlternative);
}

+ (L0DictionaryController<NSArray<EVSAppAlternativeWrapper *> *> *)presets {
    return [[L0DictionaryController alloc] initWithDict: @{
        @"Web Browsers": @[
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Brave"],
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Cake"],
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"DuckDuckGo"],
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Google Chrome"],
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Firefox Focus"],
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Firefox"],
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Opera"],
        ],
        @"Maps": @[
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Google Maps"],
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Magic Earth"],
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Waze"],
        ],
        @"Mail Clients": @[
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Airmail"],
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Edison"],
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Outlook"],
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"PolyMail"],
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Proton Mail"],
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Spark"],
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Yahoo Mail"],
        ],
        @"Package Manager": @[
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Installer"],
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Sileo"],
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Zebra"],
        ],
        @"Reddit Client": @[
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Alien Blue"],
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"Apollo"],
        ],
        @"Twitter Client": @[
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"TweetDeck"],
            [[EVSAppAlternativeWrapper alloc] initWithAppAlternative:nil name:@"TweetBot"],
        ],
        @"User Added": @[],
    }];
}

@end
