#import <UIKit/UIKit.h>
#import <EvilKit/EvilKit.h>
#import <Preferences/PSViewController.h>
#import "EVSEditTextCell.h"

@class EVSOutlineVC;

@protocol EVSOutlineVSDelegate <NSObject>
- (void)controllerDidChangeModel:(EVSOutlineVC *)viewController;
@end

@interface EVSOutlineVC : PSViewController <EVSEditTextCellDelegate, UITableViewDelegate, UITableViewDataSource>
@property id<EVSOutlineVSDelegate> delegate;
@property NSMutableArray<id<EVKURLPortion>> *outline;
@property NSString *regex;
@property NSString *key;
@property UITableView *tableView;
@end
