#import "L0DataCell.h"

@protocol L0ToggleCellDelegate <NSObject>
- (void)switchValueDidChange:(UISwitch *)toggle;
@end

@interface L0ToggleCell : L0DataCell
@property (atomic, strong) UISwitch *toggle;
@property (atomic, weak) id<L0ToggleCellDelegate> delegate;
@end
