#import "L0PrefVC.h"

@implementation L0PrefVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

+ (UIWindow *)keyWindow {
    NSArray *windows = [[UIApplication sharedApplication]windows];
    UIWindow *ret = nil;
    for (UIWindow *window in windows) {
        if (window.isKeyWindow) {
            ret = window;
            break;
        }
    }
    return ret;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIWindow *window = [L0PrefVC keyWindow];
    if (!window) {
        window = [[[UIApplication sharedApplication] windows] firstObject];
    }
    if ([window respondsToSelector:@selector(setTintColor:)]) {
        [window setTintColor:LINK_COLOR];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIWindow *window = [L0PrefVC keyWindow];
    if (!window) {
        window = [[[UIApplication sharedApplication] windows] firstObject];
    }
    if ([window respondsToSelector:@selector(setTintColor:)]) {
        [window setTintColor:nil];
    }
}

@end
