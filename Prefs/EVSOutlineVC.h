#import <UIKit/UIKit.h>
#import <EvilKit/EvilKit.h>
#import "L0EditTextCell.h"
#import "L0PrefVC.h"

@class EVSOutlineVC;

@protocol EVSOutlineVSDelegate <NSObject>
- (void)controllerDidChangeModel:(EVSOutlineVC *)viewController;
@end

@interface EVSOutlineVC : L0PrefVC <L0TextCellDelegate, UITableViewDelegate, UITableViewDataSource>
@property id<EVSOutlineVSDelegate> delegate;
@property NSMutableArray<id<EVKURLPortion>> *outline;
@property NSString *regex;
@property NSString *key;
@end
