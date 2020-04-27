#import "L0DataCell.h"

@protocol L0ToggleCellDelegate <NSObject>
- (void)switchValueDidChange:(UISwitch *)toggle;
@end

@interface L0ToggleCell : L0DataCell
@property UISwitch *toggle;
@property id<L0ToggleCellDelegate> delegate;
@end
