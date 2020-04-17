#import <UIKit/UIKit.h>
#import <Preferences/PSViewController.h>
#import "EVSAppAlternativeVC.h"

#define LINK_COLOR [UIColor colorWithRed:0.776 green:0.471 blue:0.867 alpha:1]

@interface EVSRootVC : PSViewController <UITableViewDelegate, UITableViewDataSource, EVSAppAlternativeVCDelegate>
@property (nonatomic, retain) UITableView *tableView;
- (void)saveSettings;
@end
