#import <EvilKit/EvilKit.h>
#import "PrivateFrameworks.h"

#define appInstalled(app)  [[LSApplicationWorkspace defaultWorkspace] applicationIsInstalled:app]

// Preference retrieval {{{
static NSDictionary<NSString *, EVKAppAlternative *> *prefs() {
    NSError *err;

    NSString *path = @"/var/mobile/Library/Preferences/EvilScheme/alternatives_v0.plist";
    NSData *data = [NSData dataWithContentsOfFile:path];

    NSKeyedUnarchiver *u = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:&err];
    [u setRequiresSecureCoding:NO];
    NSDictionary *ret = [u decodeObjectForKey:NSKeyedArchiveRootObjectKey];

    if(err) NSLog(@"[EVS] Error loading prefs: %@", [err localizedDescription]);

    return ret ? : @{};
}

static NSSet *blacklist() {
    NSError *err;

    NSString *path = @"/var/mobile/Library/Preferences/EvilScheme/blacklist_v0.plist";
    NSData *data = [NSData dataWithContentsOfFile:path];

    NSSet *types = [NSSet setWithObjects:[NSOrderedSet class], [NSString class], nil];
    NSOrderedSet *ret = [NSKeyedUnarchiver unarchivedObjectOfClasses:types
                                                            fromData:data
                                                               error:&err];
    if(err) NSLog(@"[EVS] Error loading blacklist: %@", [err localizedDescription]);
    return [[ret set] setByAddingObject:@"com.apple.siri"];
}
// }}}

// Logging {{{
static NSDictionary *logDict() {
    NSError *err;
    NSString *path = @"file:/var/mobile/Library/Preferences/EvilScheme/log_v0.plist";

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]
                                         options:0
                                           error:&err];

    NSSet *types = [NSSet setWithObjects:[NSDictionary class],
                                         [NSArray class],
                                         [NSString class],
                                         [NSNumber class], nil];

    NSDictionary *ret = [NSKeyedUnarchiver unarchivedObjectOfClasses:types
                                                            fromData:data
                                                               error:&err];

    if(err) NSLog(@"[EVS] Error reading log: %@", [err localizedDescription]);

    return ret;
}

static void setLogDict(NSDictionary *dict) {
    NSError *err;

    NSString *dir = @"/var/mobile/Library/Preferences/EvilScheme/";
    // Ensure dir exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:dir
                                              isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dir
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&err];
    }

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict
                                         requiringSecureCoding:NO
                                                         error:&err];

    NSString *path = @"file:/var/mobile/Library/Preferences/EvilScheme/log_v0.plist";
    [data writeToURL:[NSURL URLWithString:path]
             options:0
               error:&err];

    if(err) NSLog(@"[EVS] Error writing to log: %@", [err localizedDescription]);
}

static void logString(NSString *lString) {
    NSLog(@"[EVS] %@", lString);
    NSMutableDictionary *ld = [logDict() ? : @{} mutableCopy];
    if([ld[@"enabled"] boolValue]) {
        NSMutableArray *arr = [ld[@"data"] ? : @[] mutableCopy];
        [arr addObject:lString];
        ld[@"data"] = arr;
        setLogDict(ld);
    }
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

    EVKAppAlternative *app = prefs()[bundleID];
    NSMutableString *lString = [NSMutableString new];
    if([blacklist() containsObject:[source bundleIdentifier]]
    || !appInstalled([app substituteBundleID])) {
        [lString appendFormat:@"Ignored: %@\n%@\n", bundleID, options];
    }
    else {
        [lString appendFormat:@"From: %@\n%@\n", bundleID, options];
        if(app) {
            NSURL *url; // Check all known URL locations
            if((url = [options dictionary][@"__PayloadURL"])
            || (url = [[options dictionary][@"__AppLink4LS"] URL])
            || (url = urlFromActions([options dictionary][@"__Actions"]))) {
                [lString appendFormat:@"%@\n", [url absoluteString]];
                if([app transformURL:url]) {
                    // Craft new request
                    bundleID                  = [app substituteBundleID];
                    NSMutableDictionary *opts = [NSMutableDictionary new];
                    opts[@"__PayloadURL"]     = [app transformURL:url];
                    opts[@"__PayloadOptions"] = [options dictionary][@"__PayloadOptions"];
                    [options setDictionary:opts];
                }
            }
        }
        [lString appendFormat:@"\nTo: %@\n%@\n", bundleID, options];
    }

    logString(lString);
    %orig;
}

%end
