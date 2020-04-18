#import "PrivateFrameworks.h"
#import "EVSPreferenceManager.h"
#include <time.h>

static NSURL *urlFromActions(NSArray *actions) {
    __block NSURL *ret;
    for(BSAction *action in actions) {
        [[[action info] allSettings] enumerateIndexesUsingBlock:^ (NSUInteger idx, BOOL *stop) {
            id obj = [[action info] objectForSetting:idx];
            if([obj isKindOfClass:%c(NSData)]) {
                ret = [[NSKeyedUnarchiver unarchivedObjectOfClass:[UAUserActivityInfo class]
                                                         fromData:obj
                                                            error:nil] webpageURL];
            }
        }];
    }
    return ret;
}

%hook FBSystemServiceOpenApplicationRequest

- (void)setOptions:(FBSOpenApplicationOptions *)options {
    // TODO: Handle universal URL's with safari targets more elegently
    NSMutableDictionary *opts = [[options dictionary] mutableCopy];
    NSDictionary *apps = [%c(EVSPreferenceManager) appAlternatives];
    EVKAppAlternative *app;

    __block NSURL *url = opts[@"__PayloadURL"];

    if((app = [apps valueForKey:[self bundleIdentifier]])) {
        if(url || (url = urlFromActions(opts[@"__Actions"]))) {
            [opts setObject:[app transformURL:url] forKey:@"__PayloadURL"];
            [self setBundleIdentifier:[app substituteBundleID]];
        }
    }

    NSLog(@"[EVS] From: %@", options);
    [options setDictionary:opts];
    NSLog(@"[EVS] To:   %@", options);
    %orig;
}

%end
