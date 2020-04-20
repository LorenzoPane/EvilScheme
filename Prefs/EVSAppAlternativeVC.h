#import <UIKit/UIKit.h>
#import "L0PrefVC.h"
#import "EVSAppAlternativeWrapper.h"
#import "EVSOutlineVC.h"
#import "L0EditTextCell.h"

#define LINK_COLOR [UIColor colorWithRed:0.776 green:0.471 blue:0.867 alpha:1]

@class EVSAppAlternativeVC;

@protocol EVSAppAlternativeVCDelegate <NSObject>
- (void)controllerDidChangeModel:(EVSAppAlternativeVC *)viewController;
@end

@interface EVSAppAlternativeVC : L0PrefVC <L0TextCellDelegate, UITableViewDelegate, UITableViewDataSource, EVSOutlineVSDelegate>
@property EVSAppAlternativeWrapper *appAlternative;
@property (weak) id<EVSAppAlternativeVCDelegate> delegate;
@property NSInteger index;
- (void)showPresetView;
@end
