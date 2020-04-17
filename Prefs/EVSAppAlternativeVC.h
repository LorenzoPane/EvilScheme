#import <UIKit/UIKit.h>
#import <Preferences/PSViewController.h>
#import "EVSAppAlternativeWrapper.h"
#import "EVSOutlineVC.h"
#import "EVSEditTextCell.h"

#define LINK_COLOR [UIColor colorWithRed:0.776 green:0.471 blue:0.867 alpha:1]

@class EVSAppAlternativeVC;

@protocol EVSAppAlternativeVCDelegate <NSObject>
- (void)controllerDidChangeModel:(EVSAppAlternativeVC *)viewController;
@end

@interface EVSAppAlternativeVC : PSViewController <EVSEditTextCellDelegate, UITableViewDelegate, UITableViewDataSource, EVSOutlineVSDelegate>
@property (nonatomic, retain) UITableView *tableView;
@property EVSAppAlternativeWrapper *appAlternative;
@property (weak) id<EVSAppAlternativeVCDelegate> delegate;
@property NSInteger index;
- (void)showPresetView;
@end
