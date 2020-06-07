#import "L0EditTextCell.h"

@interface L0PureEditTextCell : UITableViewCell <UITextFieldDelegate>

@property (atomic, strong) UITextField *field;
@property (nonatomic, weak) id<L0TextCellDelegate> delegate;

@end
