#import <UIKit/UIKit.h>
#import "EVSAppAlternativeVC.h"
#import "../L0Prefs/L0Prefs.h"

@interface EVSRootVC : L0PrefVC <UITableViewDelegate, UITableViewDataSource, L0PrefVCDelegate>
- (void)saveSettings;
@end
