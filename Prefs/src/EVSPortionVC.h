#import <UIKit/UIKit.h>
#import <EvilKit/EvilKit.h>
#import "../L0Prefs/L0Prefs.h"
#import "EVSPortionVM.h"

@interface EVSPortionVC : L0PrefVC <L0TextCellDelegate, L0ToggleCellDelegate, UITableViewDelegate, UITableViewDataSource, L0StepperCellDelegate>

@property (atomic, assign) NSInteger index;
@property (atomic, strong) EVSPortionVM *portion;

- (instancetype)initWithPortion:(EVSPortionVM *)portion withIndex:(NSInteger)idx;

@end
