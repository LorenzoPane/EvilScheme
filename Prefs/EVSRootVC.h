#import <UIKit/UIKit.h>
#import "EVSAppAlternativeVC.h"
#import "L0PrefVC.h"

#define LINK_COLOR [UIColor colorWithRed:0.776 green:0.471 blue:0.867 alpha:1]

@interface EVSRootVC : L0PrefVC <UITableViewDelegate, UITableViewDataSource, EVSAppAlternativeVCDelegate>
- (void)saveSettings;
@end
