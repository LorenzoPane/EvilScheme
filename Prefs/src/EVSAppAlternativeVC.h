#import <UIKit/UIKit.h>
#import "../L0Prefs/L0Prefs.h"
#import "EVSAppAlternativeWrapper.h"
#import "EVSOutlineVC.h"

@interface EVSAppAlternativeVC : L0PrefVC <L0PrefVCDelegate, L0TextCellDelegate, UITableViewDelegate, UITableViewDataSource>

@property (atomic, strong) EVSAppAlternativeWrapper *appAlternative;
@property (atomic, assign) NSInteger index;

- (void)showPresetView;

@end
