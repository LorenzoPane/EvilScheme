#import <EvilKit/EvilKit.h>
#import "PrivateFrameworks.h"

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

#pragma GCC diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

static NSDictionary<NSString *, EVKAppAlternative *> *prefs() {
    NSError *err;

    NSString *path = @"/var/mobile/Library/Preferences/EvilScheme/alternatives.plist";
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *ret = [NSKeyedUnarchiver unarchiveTopLevelObjectWithData:data error:&err];

    if(err) NSLog(@"[EVS] ERROR LOADING PREFS: %@", [err localizedDescription]);

    return ret ? : @{};
}

#pragma GCC diagnostic pop

%hook FBSystemService

- (void)openApplication:(NSString *)bundleID
            withOptions:(FBSOpenApplicationOptions *)options
             originator:(BSProcessHandle *)source
              requestID:(NSUInteger)req
             completion:(id)completion {
    NSLog(@"[EVS] From: %@\n%@", bundleID, options);
    EVKAppAlternative *app = prefs()[bundleID];
    if(app) {
        NSURL *url;
        if((url = [options dictionary][@"__PayloadURL"])
        || (url = [[options dictionary][@"__AppLink4LS"] URL])
        || (url = urlFromActions([options dictionary][@"__Actions"]))) {
            if((url = [app transformURL:url])) {
                NSMutableDictionary *opts = [NSMutableDictionary new];
                opts[@"__PayloadURL"]     = [app transformURL:url];
                opts[@"__PayloadOptions"] = [options dictionary][@"__PayloadOptions"];
                [options setDictionary:opts];
                bundleID = [app substituteBundleID];
            }
        }
    }
    NSLog(@"[EVS] To:   %@\n%@", bundleID, options);
    %orig;
}

%end
