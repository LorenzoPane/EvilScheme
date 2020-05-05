#import <UIKit/UIKit.h>
#import "../L0Prefs/L0Prefs.h"
#import "EVSAppAlternativeVC.h"

@interface EVSRootVC : L0PrefVC <UITableViewDelegate, UITableViewDataSource, L0PrefVCDelegate>
- (void)saveSettings;
@end
