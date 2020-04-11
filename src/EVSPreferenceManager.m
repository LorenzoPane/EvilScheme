#import "EVSPreferenceManager.h"

@implementation EVSPreferenceManager

+ (NSDictionary<NSString *, EVKAppAlternative *> *)appAlternatives {
    NSString *ffx = @"firefox-focus://open-url?url=";
    NSString *ddg = percentEncode(@"https://ddg.gg/?q=");

    EVKAppAlternative *browser = [EVKAppAlternative alloc];
    browser = [browser initWithTargetBundleID:@"com.apple.mobilesafari"
                           substituteBundleID:@"org.mozilla.ios.Focus"
                                  urlOutlines:@{
                                      @"^x-web-search:" : @[
                                              [EVKStaticStringPortion portionWithString:[ffx stringByAppendingString:ddg]],
                                              [EVKQueryPortion new],
                                      ],
                                      @"^http(s?):" : @[
                                          [EVKStaticStringPortion portionWithString:ffx],
                                          [EVKFullURLPortion portionWithPercentEncoding:YES],
                                      ],
                                  }];

    EVKAppAlternative *mail = [EVKAppAlternative alloc];
    mail = [mail initWithTargetBundleID:@"com.apple.mobilemail"
                     substituteBundleID:@"com.readdle.smartemail"
                            urlOutlines:@{
                                @"^mailto:[^\?]*$" : @[
                                        [EVKStaticStringPortion portionWithString:@"readdle-spark://compose?recipient="],
                                        [EVKTrimmedPathPortion new],
                                ],
                                @"^mailto:.*\?.*$" : @[
                                        [EVKStaticStringPortion portionWithString:@"readdle-spark://compose?recipient="],
                                        [EVKTrimmedPathPortion new],
                                        [EVKStaticStringPortion portionWithString:@"&"],
                                        [EVKTranslatedQueryPortion portionWithDictionary:@{
                                            @"bcc"     : [EVKQueryItemLexicon identityLexiconWithName:@"bcc"],
                                            @"body"    : [EVKQueryItemLexicon identityLexiconWithName:@"body"],
                                            @"cc"      : [EVKQueryItemLexicon identityLexiconWithName:@"cc"],
                                            @"subject" : [EVKQueryItemLexicon identityLexiconWithName:@"subject"],
                                            @"to"      : [EVKQueryItemLexicon identityLexiconWithName:@"recipient"],
                                        }],
                                ],
                            }];

    EVKAppAlternative *navigator = [EVKAppAlternative alloc];
    navigator = [navigator initWithTargetBundleID:@"com.apple.Maps"
                               substituteBundleID:@"com.google.Maps"
                                      urlOutlines:@{
                                          @"^(((http(s?)://)?maps.apple.com)|(maps:))" : @[
                                                  [EVKStaticStringPortion portionWithString:@"comgooglemaps://?"],
                                                  [EVKTranslatedQueryPortion portionWithDictionary:@{
                                                      @"t" : [[EVKQueryItemLexicon alloc] initWithKeyName:@"directionsmode"
                                                                                               dictionary:@{
                                                                                                   @"d": @"driving",
                                                                                                   @"w": @"walking",
                                                                                                   @"r": @"transit",
                                                                                               }
                                                                                             defaultState:URLQueryStateNull],
                                                      @"dirflg":  [[EVKQueryItemLexicon alloc] initWithKeyName:@"views"
                                                                                                    dictionary:@{
                                                                                                        @"k": @"satelite",
                                                                                                        @"r": @"transit",
                                                                                                    }
                                                                                                  defaultState:URLQueryStateNull],
                                                      @"address" : [EVKQueryItemLexicon identityLexiconWithName:@"daddr"],
                                                      @"daddr" : [EVKQueryItemLexicon identityLexiconWithName:@"daddr"],
                                                      @"saddr" : [EVKQueryItemLexicon identityLexiconWithName:@"saddr"],
                                                      @"q" : [EVKQueryItemLexicon identityLexiconWithName:@"q"],
                                                      @"ll" : [EVKQueryItemLexicon identityLexiconWithName:@"q"],
                                                      @"z" : [EVKQueryItemLexicon identityLexiconWithName:@"zoom"],
                                                  }]]}];

    return @{
        @"com.apple.mobilesafari" : browser,
        @"com.apple.Maps"         : navigator,
        @"com.apple.mobilemail"   : mail,
    };
}

@end
