#import <EvilKit/EvilKit.h>
#import "PrivateFrameworks.h"

// Preference retrieval {{{
static NSDictionary<NSString *, EVKAppAlternative *> *prefs() {
    NSError *err;

    NSString *path = @"/var/mobile/Library/Preferences/EvilScheme/alternatives.plist";
    NSData *data = [NSData dataWithContentsOfFile:path];

    NSKeyedUnarchiver *u = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:&err];
    [u setRequiresSecureCoding:NO];
    NSDictionary *ret = [u decodeObjectForKey:NSKeyedArchiveRootObjectKey];

    if(err) NSLog(@"[EVS] Error loading prefs: %@", [err localizedDescription]);

    return ret ? : @{};
}

static NSSet *blacklist() {
    NSError *err;

    NSString *path = @"/var/mobile/Library/Preferences/EvilScheme/blacklist.plist";
    NSData *data = [NSData dataWithContentsOfFile:path];

    NSSet *types = [NSSet setWithObjects:[NSOrderedSet class], [NSString class], nil];
    NSOrderedSet *ret = [NSKeyedUnarchiver unarchivedObjectOfClasses:types
                                                            fromData:data
                                                               error:&err];
    if(err) NSLog(@"[EVS] Error loading blacklist: %@", [err localizedDescription]);
    return [[ret set] setByAddingObject:@"com.apple.siri"];
}
// }}}

// Spelunk into actions as a last resort to find URL
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

%hook FBSystemService

- (void)openApplication:(NSString *)bundleID
            withOptions:(FBSOpenApplicationOptions *)options
             originator:(BSProcessHandle *)source
              requestID:(NSUInteger)req
             completion:(id)completion {
    if([blacklist() containsObject:[source bundleIdentifier]]) {
        NSLog(@"[EVS] Ignored: %@\n%@", bundleID, options);
    }
    else {
        NSLog(@"[EVS] From:    %@\n%@", bundleID, options);
        EVKAppAlternative *app = prefs()[bundleID];
        if(app) {
            NSURL *url; // Check all known URL locations
            if((url = [options dictionary][@"__PayloadURL"])
            || (url = [[options dictionary][@"__AppLink4LS"] URL])
            || (url = urlFromActions([options dictionary][@"__Actions"]))) {
                if((url = [app transformURL:url])) {
                    // Craft new request
                    bundleID                  = [app substituteBundleID];
                    NSMutableDictionary *opts = [NSMutableDictionary new];
                    opts[@"__PayloadURL"]     = [app transformURL:url];
                    opts[@"__PayloadOptions"] = [options dictionary][@"__PayloadOptions"];
                    [options setDictionary:opts];
                }
            }
        }
        NSLog(@"[EVS] To:      %@\n%@", bundleID, options);
    }
    %orig;
}

%end
