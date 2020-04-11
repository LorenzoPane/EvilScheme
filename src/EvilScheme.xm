#import "PrivateFrameworks.h"
#include <time.h>

static void logOptions(FBSOpenApplicationOptions *options, NSString *bundleID) {
    NSError *error;
    NSString *path = [NSString stringWithFormat:@"%@%@%ld",
                      @"/var/mobile/Documents/logs/",
                      bundleID,
                      time(NULL)];

    NSString *dict = [NSString stringWithFormat:@"%@", [options dictionary]];

    [dict writeToURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@.txt", path]]
          atomically:YES
            encoding:NSUTF8StringEncoding
               error:&error];

    NSArray *actions;
    if((actions = [options dictionary][@"__Actions"])) {
        for(BSAction *action in actions) {
            BSSettings *info = [action info];
            [[info allSettings] enumerateIndexesUsingBlock:^ (NSUInteger idx, BOOL *stop) {
                id obj = [info objectForSetting:idx];
                if([obj isKindOfClass:%c(NSData)]) {
                    [obj writeToFile:[NSString stringWithFormat:@"%@.USERDATA.plist", path]
                          atomically:YES];
                    // This can be unarchived to a UAUserActivityInfo w/ NSKeyedUnarchiver
                }
            }];
        }
    }
}

%hook FBSystemServiceOpenApplicationRequest

- (void)setOptions:(FBSOpenApplicationOptions *)options {
    logOptions(options, [self bundleIdentifier]);
    %orig;
}

%end
