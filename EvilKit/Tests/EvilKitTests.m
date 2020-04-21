#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import <EvilKit/EvilKit.h>

@interface EvilKitTests : XCTestCase

@end

@implementation EvilKitTests {
    NSArray<NSString *> *urlStrings;
    NSMutableArray<NSURL *> *urls;
}

- (void)setUp {
    urlStrings = @[
        @"",
        @"mB*RTDCwT7kVYmyM4(dr5c6jxTr%83ICoHEXdKn7Z$~ABHq#B=3n82WuUResWcGK",
        @"example.com",
        @"www.example.com",
        @"http://example.com",
        @"https://www.example.com",
        @"https://www.example.com/path/to/neat/file.txt",
        @"https://www.example.com/?arg1=420&arg2=69",
        @"https://johnny:p4ssw0rd@www.example.com:443/script.ext;param=value?query=value#ref",
        @"firefox-focus://open-url?url=http%3A%2F%2Fexample%2Ecom%2F%3Farg1%3D420%26arg2%3D69",
        @"https://maps.apple.com/?address=1%20Infinite%20Loop%20Cupertino%20CA%2095014%20United%20States&abPersonID=3",
        @"maps:?saddr=San+Jose&daddr=San+Francisco&dirflg=r",
        @"maps://?q=Mexican+Restaurant&sll=50.894967,4.341626&z=10&t=r",
        @"x-web-search://?this%20is%20a%20test",
        @"x-web-search://?this%20is%20a%20test-/:;()$$&%E2%80%9D@,?%E2%80%99%20n%5D+%E2%82%AC%23!%7C",
        @"mailto:test@example.com",
        @"mailto:test@example.com?cc=bar@example.com&subject=Greetings%20from%20Cupertino!&body=Wish%20you%20were%20here!",
        @"https://youtu.be/dQw4w9WgXc",
        @"https://example.com/?n1=one&n2=two",
        @"https://example.com/?nOne=1&nTwo=2",
    ];

    urls = [NSMutableArray new];
    for(NSString *url in urlStrings)
        [urls addObject:[NSURL URLWithString:url]];
}

// Trivial portion tests {{{
- (void)testQuery {
    NSArray<NSString *> *queries = @[
        @"",
        @"",
        @"",
        @"",
        @"",
        @"",
        @"",
        @"arg1=420&arg2=69",
        @"query=value",
        @"url=http%3A%2F%2Fexample%2Ecom%2F%3Farg1%3D420%26arg2%3D69",
        @"address=1%20Infinite%20Loop%20Cupertino%20CA%2095014%20United%20States&abPersonID=3",
        @"saddr=San+Jose&daddr=San+Francisco&dirflg=r",
        @"q=Mexican+Restaurant&sll=50.894967,4.341626&z=10&t=r",
        @"this%20is%20a%20test",
        @"this%20is%20a%20test-/:;()$$&%E2%80%9D@,?%E2%80%99%20n%5D+%E2%82%AC%23!%7C",
        @"",
        @"cc=bar@example.com&subject=Greetings%20from%20Cupertino!&body=Wish%20you%20were%20here!",
        @"",
        @"n1=one&n2=two",
        @"nOne=1&nTwo=2",
    ];

    NSString *target;
    NSString *result;
    for(int i = 0; i < [urlStrings count]; i++) {
        target = queries[i];
        result = [[EVKQueryPortion new] evaluateWithURL:urls[i]];
        XCTAssertTrue([target isEqualToString:result]);
    }
}

- (void)testResource {
    NSArray<NSString *> *schemes = @[
        @"",
        @"mB*RTDCwT7kVYmyM4(dr5c6jxTr%83ICoHEXdKn7Z$~ABHq#B=3n82WuUResWcGK",
        @"example.com",
        @"www.example.com",
        @"example.com",
        @"www.example.com",
        @"www.example.com/path/to/neat/file.txt",
        @"www.example.com/?arg1=420&arg2=69",
        @"johnny:p4ssw0rd@www.example.com:443/script.ext;param=value?query=value#ref",
        @"open-url?url=http%3A%2F%2Fexample%2Ecom%2F%3Farg1%3D420%26arg2%3D69",
        @"maps.apple.com/?address=1%20Infinite%20Loop%20Cupertino%20CA%2095014%20United%20States&abPersonID=3",
        @"?saddr=San+Jose&daddr=San+Francisco&dirflg=r",
        @"?q=Mexican+Restaurant&sll=50.894967,4.341626&z=10&t=r",
        @"?this%20is%20a%20test",
        @"?this%20is%20a%20test-/:;()$$&%E2%80%9D@,?%E2%80%99%20n%5D+%E2%82%AC%23!%7C",
        @"test@example.com",
        @"test@example.com?cc=bar@example.com&subject=Greetings%20from%20Cupertino!&body=Wish%20you%20were%20here!",
        @"youtu.be/dQw4w9WgXc",
        @"example.com/?n1=one&n2=two",
        @"example.com/?nOne=1&nTwo=2",
    ];

    NSString *target;
    NSString *result;
    for(int i = 0; i < [urlStrings count]; i++) {
        target = schemes[i];
        result = [[EVKTrimmedResourceSpecifierPortion new] evaluateWithURL:urls[i]];
        XCTAssertTrue([target isEqualToString:result]);
    }
}

- (void)testHost {
    NSArray<NSString *> *schemes = @[
        @"",
        @"",
        @"",
        @"",
        @"example.com",
        @"www.example.com",
        @"www.example.com",
        @"www.example.com",
        @"www.example.com",
        @"open-url",
        @"maps.apple.com",
        @"",
        @"",
        @"",
        @"",
        @"",
        @"",
        @"youtu.be",
        @"example.com",
        @"example.com",
    ];

    NSString *target;
    NSString *result;
    for(int i = 0; i < [urlStrings count]; i++) {
        target = schemes[i];
        result = [[EVKHostPortion new] evaluateWithURL:urls[i]];
        XCTAssertTrue([target isEqualToString:result]);
    }
}

- (void)testPath {
    NSArray<NSString *> *schemes = @[
        @"",
        @"",
        @"example.com",
        @"www.example.com",
        @"",
        @"",
        @"path/to/neat/file.txt",
        @"",
        @"script.ext;param=value",
        @"",
        @"",
        @"",
        @"",
        @"",
        @"",
        @"test@example.com",
        @"test@example.com",
        @"dQw4w9WgXc",
        @"",
        @"",
    ];

    NSString *target;
    NSString *result;
    for(int i = 0; i < [urlStrings count]; i++) {
        target = schemes[i];
        result = [[EVKTrimmedPathPortion portionWithPercentEncoding:NO] evaluateWithURL:urls[i]];
        XCTAssertTrue([target isEqualToString:result]);
    }
}

- (void)testScheme {
    NSArray<NSString *> *schemes = @[
        @"",
        @"",
        @"",
        @"",
        @"http",
        @"https",
        @"https",
        @"https",
        @"https",
        @"firefox-focus",
        @"https",
        @"maps",
        @"maps",
        @"x-web-search",
        @"x-web-search",
        @"mailto",
        @"mailto",
        @"https",
        @"https",
        @"https",
    ];

    NSString *target;
    NSString *result;
    for(int i = 0; i < [urlStrings count]; i++) {
        target = schemes[i];
        result = [[EVKSchemePortion new] evaluateWithURL:urls[i]];
        XCTAssertTrue([target isEqualToString:result]);
    }
}

- (void)testFullURL {
    NSString *target;
    NSString *result;
    for(int i = 0; i < [urlStrings count]; i++) {
        target = urlStrings[i];
        result = [[EVKFullURLPortion portionWithPercentEncoding:NO] evaluateWithURL:urls[i]];
        XCTAssertTrue([target isEqualToString:result]);
    }
}

- (void)testStaticString {/* good luck breaking that */}
// }}}

// Complex portion tests {{{
- (void)testQueryTranslations {
    EVKTranslatedQueryPortion *example = [EVKTranslatedQueryPortion portionWithDictionary:@{
        @"n1" : [[EVKQueryItemLexicon alloc] initWithKeyName:@"nOne"
                                                  dictionary:@{@"one" : @"1"}
                                                defaultState:URLQueryStateNull],
        @"n2" : [[EVKQueryItemLexicon alloc] initWithKeyName:@"nTwo"
                                                  dictionary:@{@"two" : @"2"}
                                                defaultState:URLQueryStateNull],
    } percentEncoded:NO];
    EVKTranslatedQueryPortion *maps = [EVKTranslatedQueryPortion portionWithDictionary:@{
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
    } percentEncoded:NO];

    XCTAssertTrue([[example evaluateWithURL:urls[18]] isEqualToString:@"nOne=1&nTwo=2"]);
    XCTAssertTrue([[maps evaluateWithURL:urls[10]] isEqualToString:@"daddr=1%20Infinite%20Loop%20Cupertino%20CA%2095014%20United%20States"]);
    XCTAssertTrue([[maps evaluateWithURL:urls[11]] isEqualToString:@"saddr=San+Jose&daddr=San+Francisco&views=transit"]);
    XCTAssertTrue([[maps evaluateWithURL:urls[12]] isEqualToString:@"q=Mexican+Restaurant&zoom=10&directionsmode=transit"]);
}

- (void)testRegexSubstitution {/* apple's behaviour */}
// }}}

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (void)testArchive {
    NSError *error;

    NSString *ffx = @"firefox-focus://open-url?url=";
    NSString *ddg = @"https://ddg.gg/?q=";
    EVKAppAlternative *browser = [EVKAppAlternative alloc];
    browser = [browser initWithTargetBundleID:@"com.apple.mobilesafari"
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

    NSDictionary *appAlternatives =  @{
        @"com.apple.mobilesafari" : browser,
        @"com.apple.Maps"         : navigator,
        @"com.apple.mobilemail"   : mail,
    };

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appAlternatives
                                         requiringSecureCoding:YES
                                                         error:&error];
    XCTAssertNil(error);

    [data writeToURL:[NSURL URLWithString:@"file:/tmp/archive.plist"]
             options:0
               error:&error];

    XCTAssertNil(error);

    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"file:/tmp/archive.plist"]
                                 options:0
                                   error:&error];

    XCTAssertNil(error);

    [NSKeyedUnarchiver unarchiveTopLevelObjectWithData:data
                                                 error:&error];

    XCTAssertNil(error);
}
#pragma GCC diagnostic pop

@end
