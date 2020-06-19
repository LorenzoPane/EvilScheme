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
        result = [[EVKTrimmedPathPortion portionWithPercentEncodingIterations:0] evaluateWithURL:urls[i]];
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
        result = [[EVKFullURLPortion portionWithPercentEncodingIterations:0] evaluateWithURL:urls[i]];
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
    } percentEncodingIterations:0];
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
    } percentEncodingIterations:0];

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
                                  urlOutlines:@[
                                      [EVKAction actionWithPattern:@"^x-web-search:" outline:@[
                                          [EVKStaticStringPortion portionWithString:ffx percentEncodingIterations:0],
                                          [EVKStaticStringPortion portionWithString:ddg percentEncodingIterations:1],
                                          [EVKQueryPortion portionWithPercentEncodingIterations:1],
                                      ]],
                                      [EVKAction actionWithPattern:@"^http(s?):" outline:@[
                                          [EVKStaticStringPortion portionWithString:ffx percentEncodingIterations:0],
                                          [EVKFullURLPortion portionWithPercentEncodingIterations:1],
                                      ]],
                                  ]];

    EVKAppAlternative *mail = [EVKAppAlternative alloc];
    mail = [mail initWithTargetBundleID:@"com.apple.mobilemail"
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
                            ]];

    EVKAppAlternative *navigator = [EVKAppAlternative alloc];
    navigator = [navigator initWithTargetBundleID:@"com.apple.Maps"
                               substituteBundleID:@"com.google.Maps"
                                      urlOutlines:@[
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
                                                  @"address" : [EVKQueryItemLexicon identityLexiconWithName:@"daddr"],
                                                  @"daddr"   : [EVKQueryItemLexicon identityLexiconWithName:@"daddr"],
                                                  @"saddr"   : [EVKQueryItemLexicon identityLexiconWithName:@"saddr"],
                                                  @"q"       : [EVKQueryItemLexicon identityLexiconWithName:@"q"],
                                                  @"ll"      : [EVKQueryItemLexicon identityLexiconWithName:@"q"],
                                                  @"z"       : [EVKQueryItemLexicon identityLexiconWithName:@"zoom"],
                                              } percentEncodingIterations:0]
                                          ]]]];

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

// Preset tests {{{
- (void)testFocus {
    NSArray *targets = @[
        @"",
        @"mB*RTDCwT7kVYmyM4(dr5c6jxTr%83ICoHEXdKn7Z$~ABHq#B=3n82WuUResWcGK",
        @"example.com",
        @"www.example.com",
        @"firefox-focus://open-url?url=%68%74%74%70%3A%2F%2F%65%78%61%6D%70%6C%65%2E%63%6F%6D",
        @"firefox-focus://open-url?url=%68%74%74%70%73%3A%2F%2F%77%77%77%2E%65%78%61%6D%70%6C%65%2E%63%6F%6D",
        @"firefox-focus://open-url?url=%68%74%74%70%73%3A%2F%2F%77%77%77%2E%65%78%61%6D%70%6C%65%2E%63%6F%6D%2F%70%61%74%68%2F%74%6F%2F%6E%65%61%74%2F%66%69%6C%65%2E%74%78%74",
        @"firefox-focus://open-url?url=%68%74%74%70%73%3A%2F%2F%77%77%77%2E%65%78%61%6D%70%6C%65%2E%63%6F%6D%2F%3F%61%72%67%31%3D%34%32%30%26%61%72%67%32%3D%36%39",
        @"firefox-focus://open-url?url=%68%74%74%70%73%3A%2F%2F%6A%6F%68%6E%6E%79%3A%70%34%73%73%77%30%72%64%40%77%77%77%2E%65%78%61%6D%70%6C%65%2E%63%6F%6D%3A%34%34%33%2F%73%63%72%69%70%74%2E%65%78%74%3B%70%61%72%61%6D%3D%76%61%6C%75%65%3F%71%75%65%72%79%3D%76%61%6C%75%65%23%72%65%66",
        @"firefox-focus://open-url?url=http%3A%2F%2Fexample%2Ecom%2F%3Farg1%3D420%26arg2%3D69",
        @"firefox-focus://open-url?url=%68%74%74%70%73%3A%2F%2F%6D%61%70%73%2E%61%70%70%6C%65%2E%63%6F%6D%2F%3F%61%64%64%72%65%73%73%3D%31%25%32%30%49%6E%66%69%6E%69%74%65%25%32%30%4C%6F%6F%70%25%32%30%43%75%70%65%72%74%69%6E%6F%25%32%30%43%41%25%32%30%39%35%30%31%34%25%32%30%55%6E%69%74%65%64%25%32%30%53%74%61%74%65%73%26%61%62%50%65%72%73%6F%6E%49%44%3D%33",
        @"maps:?saddr=San+Jose&daddr=San+Francisco&dirflg=r",
        @"maps://?q=Mexican+Restaurant&sll=50.894967,4.341626&z=10&t=r",
        @"firefox-focus://open-url?url=%68%74%74%70%73%3A%2F%2F%64%64%67%2E%67%67%2F%3F%71%3D%74%68%69%73%25%32%30%69%73%25%32%30%61%25%32%30%74%65%73%74",
        @"firefox-focus://open-url?url=%68%74%74%70%73%3A%2F%2F%64%64%67%2E%67%67%2F%3F%71%3D%74%68%69%73%25%32%30%69%73%25%32%30%61%25%32%30%74%65%73%74%2D%2F%3A%3B%28%29%24%24%26%25%45%32%25%38%30%25%39%44%40%2C%3F%25%45%32%25%38%30%25%39%39%25%32%30%6E%25%35%44%2B%25%45%32%25%38%32%25%41%43%25%32%33%21%25%37%43",
        @"mailto:test@example.com",
        @"mailto:test@example.com?cc=bar@example.com&subject=Greetings%20from%20Cupertino!&body=Wish%20you%20were%20here!",
        @"firefox-focus://open-url?url=%68%74%74%70%73%3A%2F%2F%79%6F%75%74%75%2E%62%65%2F%64%51%77%34%77%39%57%67%58%63",
        @"firefox-focus://open-url?url=%68%74%74%70%73%3A%2F%2F%65%78%61%6D%70%6C%65%2E%63%6F%6D%2F%3F%6E%31%3D%6F%6E%65%26%6E%32%3D%74%77%6F",
        @"firefox-focus://open-url?url=%68%74%74%70%73%3A%2F%2F%65%78%61%6D%70%6C%65%2E%63%6F%6D%2F%3F%6E%4F%6E%65%3D%31%26%6E%54%77%6F%3D%32"
    ];

    NSString *ffx = @"firefox-focus://open-url?url=";
    NSString *ddg = @"https://ddg.gg/?q=";
    EVKAppAlternative *browser = [EVKAppAlternative alloc];
    browser = [browser initWithTargetBundleID:@"com.apple.mobilesafari"
                           substituteBundleID:@"org.mozilla.ios.Focus"
                                  urlOutlines:@[
                                      [EVKAction actionWithPattern:@"^x-web-search:" outline:@[
                                          [EVKStaticStringPortion portionWithString:ffx percentEncodingIterations:0],
                                          [EVKStaticStringPortion portionWithString:ddg percentEncodingIterations:1],
                                          [EVKQueryPortion portionWithPercentEncodingIterations:1],
                                      ]],
                                      [EVKAction actionWithPattern:@"^http(s?):" outline:@[
                                          [EVKStaticStringPortion portionWithString:ffx percentEncodingIterations:0],
                                          [EVKFullURLPortion portionWithPercentEncodingIterations:1],
                                      ]],
                                  ]];
    NSString *target;
    NSString *result;
    for(int i = 0; i < [urlStrings count]; i++) {
        target = targets[i];
        result = [[browser transformURL:[NSURL URLWithString:urlStrings[i]]] absoluteString];
        XCTAssertTrue(!result || [result isEqualToString:target]);
    }
}

- (void)testChrome {
    NSArray *targets = @[
        [NSNull null],
        @"mB*RTDCwT7kVYmyM4(dr5c6jxTr%83ICoHEXdKn7Z$~ABHq#B=3n82WuUResWcGK",
        @"example.com",
        @"www.example.com",
        @"googlechrome://example.com",
        @"googlechromes://www.example.com",
        @"googlechromes://www.example.com/path/to/neat/file.txt",
        @"googlechromes://www.example.com/?arg1=420&arg2=69",
        @"googlechromes://johnny:p4ssw0rd@www.example.com:443/script.ext;param=value?query=value#ref",
        @"firefox-focus://open-url?url=http%3A%2F%2Fexample%2Ecom%2F%3Farg1%3D420%26arg2%3D69",
        @"googlechromes://maps.apple.com/?address=1%20Infinite%20Loop%20Cupertino%20CA%2095014%20United%20States&abPersonID=3",
        @"maps:?saddr=San+Jose&daddr=San+Francisco&dirflg=r",
        @"maps://?q=Mexican+Restaurant&sll=50.894967,4.341626&z=10&t=r",
        @"googlechromes://ddg.gg/?q=%74%68%69%73%25%32%30%69%73%25%32%30%61%25%32%30%74%65%73%74",
        @"googlechromes://ddg.gg/?q=%74%68%69%73%25%32%30%69%73%25%32%30%61%25%32%30%74%65%73%74%2D%2F%3A%3B%28%29%24%24%26%25%45%32%25%38%30%25%39%44%40%2C%3F%25%45%32%25%38%30%25%39%39%25%32%30%6E%25%35%44%2B%25%45%32%25%38%32%25%41%43%25%32%33%21%25%37%43",
        @"mailto:test@example.com",
        @"mailto:test@example.com?cc=bar@example.com&subject=Greetings%20from%20Cupertino!&body=Wish%20you%20were%20here!",
        @"googlechromes://youtu.be/dQw4w9WgXc",
        @"googlechromes://example.com/?n1=one&n2=two",
        @"googlechromes://example.com/?nOne=1&nTwo=2",
    ];


    NSString *chr = @"googlechrome://";
    NSString *chrs = @"googlechromes://";
    NSString *ddg = @"ddg.gg/?q=";
    EVKAppAlternative *browser = [EVKAppAlternative alloc];
    browser = [browser initWithTargetBundleID:@"com.apple.mobilesafari"
                           substituteBundleID:@"com.google.chrome.ios"
                                  urlOutlines:@[
                                      [EVKAction actionWithPattern:@"^http:" outline:@[
                                          [EVKStaticStringPortion portionWithString:chr percentEncodingIterations:0],
                                          [EVKTrimmedResourceSpecifierPortion portionWithPercentEncodingIterations:0],
                                      ]],
                                      [EVKAction actionWithPattern:@"^https:" outline:@[
                                          [EVKStaticStringPortion portionWithString:chrs percentEncodingIterations:0],
                                          [EVKTrimmedResourceSpecifierPortion portionWithPercentEncodingIterations:0],
                                      ]],
                                      [EVKAction actionWithPattern:@"^x-web-search:" outline:@[
                                          [EVKStaticStringPortion portionWithString:chrs percentEncodingIterations:0],
                                          [EVKStaticStringPortion portionWithString:ddg percentEncodingIterations:0],
                                          [EVKQueryPortion portionWithPercentEncodingIterations:1],
                                      ]],
                                  ]];
    NSString *target;
    NSString *result;
    for(int i = 0; i < [urlStrings count]; i++) {
        target = targets[i];
        result = [[browser transformURL:[NSURL URLWithString:urlStrings[i]]] absoluteString];
        XCTAssertTrue(!result || [result isEqualToString:target]);
    }
}

- (void)testBrave {
    NSArray *targets = @[
        [NSNull null],
        @"mB*RTDCwT7kVYmyM4(dr5c6jxTr%83ICoHEXdKn7Z$~ABHq#B=3n82WuUResWcGK",
        @"example.com",
        @"www.example.com",
        @"brave://open-url?url=%68%74%74%70%3A%2F%2F%65%78%61%6D%70%6C%65%2E%63%6F%6D",
        @"brave://open-url?url=%68%74%74%70%73%3A%2F%2F%77%77%77%2E%65%78%61%6D%70%6C%65%2E%63%6F%6D",
        @"brave://open-url?url=%68%74%74%70%73%3A%2F%2F%77%77%77%2E%65%78%61%6D%70%6C%65%2E%63%6F%6D%2F%70%61%74%68%2F%74%6F%2F%6E%65%61%74%2F%66%69%6C%65%2E%74%78%74",
        @"brave://open-url?url=%68%74%74%70%73%3A%2F%2F%77%77%77%2E%65%78%61%6D%70%6C%65%2E%63%6F%6D%2F%3F%61%72%67%31%3D%34%32%30%26%61%72%67%32%3D%36%39",
        @"brave://open-url?url=%68%74%74%70%73%3A%2F%2F%6A%6F%68%6E%6E%79%3A%70%34%73%73%77%30%72%64%40%77%77%77%2E%65%78%61%6D%70%6C%65%2E%63%6F%6D%3A%34%34%33%2F%73%63%72%69%70%74%2E%65%78%74%3B%70%61%72%61%6D%3D%76%61%6C%75%65%3F%71%75%65%72%79%3D%76%61%6C%75%65%23%72%65%66",
        @"firefox-focus://open-url?url=http%3A%2F%2Fexample%2Ecom%2F%3Farg1%3D420%26arg2%3D69",
        @"brave://open-url?url=%68%74%74%70%73%3A%2F%2F%6D%61%70%73%2E%61%70%70%6C%65%2E%63%6F%6D%2F%3F%61%64%64%72%65%73%73%3D%31%25%32%30%49%6E%66%69%6E%69%74%65%25%32%30%4C%6F%6F%70%25%32%30%43%75%70%65%72%74%69%6E%6F%25%32%30%43%41%25%32%30%39%35%30%31%34%25%32%30%55%6E%69%74%65%64%25%32%30%53%74%61%74%65%73%26%61%62%50%65%72%73%6F%6E%49%44%3D%33",
        @"maps:?saddr=San+Jose&daddr=San+Francisco&dirflg=r",
        @"maps://?q=Mexican+Restaurant&sll=50.894967,4.341626&z=10&t=r",
        @"brave://open-url?url=%68%74%74%70%73%3A%2F%2F%64%64%67%2E%67%67%2F%3F%71%3D%74%68%69%73%25%32%30%69%73%25%32%30%61%25%32%30%74%65%73%74",
        @"brave://open-url?url=%68%74%74%70%73%3A%2F%2F%64%64%67%2E%67%67%2F%3F%71%3D%74%68%69%73%25%32%30%69%73%25%32%30%61%25%32%30%74%65%73%74%2D%2F%3A%3B%28%29%24%24%26%25%45%32%25%38%30%25%39%44%40%2C%3F%25%45%32%25%38%30%25%39%39%25%32%30%6E%25%35%44%2B%25%45%32%25%38%32%25%41%43%25%32%33%21%25%37%43",
        @"mailto:test@example.com",
        @"mailto:test@example.com?cc=bar@example.com&subject=Greetings%20from%20Cupertino!&body=Wish%20you%20were%20here!",
        @"brave://open-url?url=%68%74%74%70%73%3A%2F%2F%79%6F%75%74%75%2E%62%65%2F%64%51%77%34%77%39%57%67%58%63",
        @"brave://open-url?url=%68%74%74%70%73%3A%2F%2F%65%78%61%6D%70%6C%65%2E%63%6F%6D%2F%3F%6E%31%3D%6F%6E%65%26%6E%32%3D%74%77%6F",
        @"brave://open-url?url=%68%74%74%70%73%3A%2F%2F%65%78%61%6D%70%6C%65%2E%63%6F%6D%2F%3F%6E%4F%6E%65%3D%31%26%6E%54%77%6F%3D%32"
    ];

    NSString *ffx = @"brave://open-url?url=";
    NSString *ddg = @"https://ddg.gg/?q=";
    EVKAppAlternative *browser = [EVKAppAlternative alloc];
    browser = [browser initWithTargetBundleID:@"com.apple.mobilesafari"
                           substituteBundleID:@"com.brave.ios.browser"
                                  urlOutlines:@[
                                      [EVKAction actionWithPattern:@"^x-web-search:" outline:@[
                                          [EVKStaticStringPortion portionWithString:ffx percentEncodingIterations:0],
                                          [EVKStaticStringPortion portionWithString:ddg percentEncodingIterations:1],
                                          [EVKQueryPortion portionWithPercentEncodingIterations:1],
                                      ]],
                                      [EVKAction actionWithPattern:@"^http(s?):" outline:@[
                                          [EVKStaticStringPortion portionWithString:ffx percentEncodingIterations:0],
                                          [EVKFullURLPortion portionWithPercentEncodingIterations:1],
                                      ]],
                                  ]];
    NSString *target;
    NSString *result;
    for(int i = 0; i < [urlStrings count]; i++) {
        target = targets[i];
        result = [[browser transformURL:[NSURL URLWithString:urlStrings[i]]] absoluteString];
        XCTAssertTrue(!result || [result isEqualToString:target]);
    }
}

- (void)testReddit {
    NSDictionary *URLs = @{
        @"https://reddit.com": @"apollo://",
        @"http://www.reddit.com/r/jailbreak/": @"apollo://reddit.com/r/jailbreak",
        @"https://www.reddit.com/r/jailbreak/comments/gth4zu/": @"apollo://reddit.com/r/jailbreak/comments/gth4zu",
        @"https://m.reddit.com/r/jailbreak/comments/gth4zu/upcoming_free_release_evil_scheme_change_your/": @"apollo://reddit.com/r/jailbreak/comments/gth4zu/upcoming_free_release_evil_scheme_change_your",
        @"https://amp.reddit.com/branch-redirect?creative=AppSelectorModal&experiment=app_selector_contrast_iteration&path=%2Fr%2Fjailbreak%2Fcomments%2Fgth4zu%2Fupcoming_free_release_evil_scheme_change_your%2F&variant=control_2": @"apollo://reddit.com/r/jailbreak/comments/gth4zu/upcoming_free_release_evil_scheme_change_your/",
        @"https://reddit.app.link/?channel=xpromo&feature=amp&campaign=app_selector_contrast_iteration&tags=AppSelectorModal&keyword=blue_header&%24og_redirect=https%3A%2F%2Fwww.reddit.com%2Fr%2Fjailbreak%2Fcomments%2Fgth4zu%2Fupcoming_free_release_evil_scheme_change_your%2F&%24deeplink_path=%2Fr%2Fjailbreak%2Fcomments%2Fgth4zu%2Fupcoming_free_release_evil_scheme_change_your%2F&%24android_deeplink_path=reddit%2Fr%2Fjailbreak%2Fcomments%2Fgth4zu%2Fupcoming_free_release_evil_scheme_change_your%2F&utm_source=xpromo&utm_medium=amp&utm_name=app_selector_contrast_iteration&utm_term=blue_header&utm_content=AppSelectorModal&mweb_loid=;" : @"apollo://reddit.com/r/jailbreak/comments/gth4zu/upcoming_free_release_evil_scheme_change_your/",
        @"reddit:///r/jailbreak/comments/gth4zu/": @"apollo://reddit.com/r/jailbreak/comments/gth4zu",
    };

    EVKAppAlternative *apollo =  [[EVKAppAlternative alloc] initWithTargetBundleID:@"com.reddit.Reddit"
                                                                substituteBundleID:@"com.christianselig.Apollo"
                                                                       urlOutlines:@[
                                                                           [EVKAction actionWithPattern:@".*reddit.com/r.*" outline:@[
                                                                               [EVKStaticStringPortion portionWithString:@"apollo://reddit.com/" percentEncodingIterations:0],
                                                                               [EVKTrimmedPathPortion portionWithPercentEncodingIterations:0],
                                                                           ]],
                                                                           [EVKAction actionWithPattern:@".*reddit.com(/?)$" outline:@[
                                                                               [EVKStaticStringPortion portionWithString:@"apollo://" percentEncodingIterations:0],
                                                                           ]],
                                                                           [EVKAction actionWithPattern:@"amp.reddit.com/branch-redirect.*" outline:@[
                                                                               [EVKStaticStringPortion portionWithString:@"apollo://reddit.com" percentEncodingIterations:0],
                                                                               [EVKQueryParameterValuePortion portionWithParameter:@"path" percentEncodingIterations:0]
                                                                           ]],
                                                                           [EVKAction actionWithPattern:@".*reddit.app.link.*" outline:@[
                                                                               [EVKStaticStringPortion portionWithString:@"apollo://reddit.com" percentEncodingIterations:0],
                                                                               [EVKQueryParameterValuePortion portionWithParameter:@"$deeplink_path" percentEncodingIterations:0]
                                                                           ]],
                                                                           [EVKAction actionWithPattern:@"reddit:///r/.*" outline:@[
                                                                               [EVKStaticStringPortion portionWithString:@"apollo://reddit.com/" percentEncodingIterations:0],
                                                                               [EVKTrimmedResourceSpecifierPortion portionWithPercentEncodingIterations:0],
                                                                           ]],
                                                                       ]];
    for(NSString *url in URLs) {
        NSString *target = URLs[url];
        NSString *result = [[apollo transformURL:[NSURL URLWithString:url]] absoluteString];
        XCTAssertTrue(!result || [result isEqualToString:target]);
    }
}

- (void)testZebra {
    NSDictionary<NSString *, NSString *> *urls = @{
        @"cydia://url/https://cydia.saurik.com/api/share#?source=https://repo.dynastic.co":  @"zbra://sources/add/https://repo.dynastic.co",
        @"cydia://url/https://cydia.saurik.com/api/share#?source=https://repo.dynastic.co/&package=net.pane.l.evilscheme": @"zbra://packages/net.pane.l.evilscheme?source=https://repo.dynastic.co/",
        @"cydia://url/https://cydia.saurik.com/api/share#?package=net.pane.l.evilscheme": @"zbra://packages/net.pane.l.evilscheme",
    };

    EVKAppAlternative *zebra = [[EVKAppAlternative alloc] initWithTargetBundleID:@"com.saurik.Cydia"
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
                                                                     ]];

    for(NSString *url in urls) {
        NSURL *result = [zebra transformURL:[NSURL URLWithString:url]];
        XCTAssertTrue([[result absoluteString] isEqualToString:urls[url]]);
    }
}

- (void)testTweetbot {
    NSArray *urls = @[
        @"https://twitter.com/mushyware",
        @"https://www.twitter.com/mushyware/status/1267615150321827840",
        @"http://twitter.com/i/lists/1005878912671461376",
        @"https://twitter.com/pwn20wnd/status/1163111004370161666?s=21",
    ];

    EVKAppAlternative *tweetbot = [[EVKAppAlternative alloc] initWithTargetBundleID:@"com.atebits.Tweetie2"
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
                                                                        ]];
    for(NSString *url in urls) {
        NSLog(@"%@", [tweetbot transformURL:[NSURL URLWithString:url]]);
    }
}

// }}}

@end
