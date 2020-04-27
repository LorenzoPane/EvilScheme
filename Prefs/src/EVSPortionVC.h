#import <UIKit/UIKit.h>
#import <EvilKit/EvilKit.h>
#import "../L0Prefs/L0Prefs.h"
#import "EVSPortionVM.h"

@interface EVSPortionVC : L0PrefVC <L0TextCellDelegate, L0ToggleCellDelegate, UITableViewDelegate, UITableViewDataSource>
@property NSInteger index;
@property EVSPortionVM *portion;
@end
