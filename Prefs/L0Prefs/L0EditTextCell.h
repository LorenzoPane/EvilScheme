#import "L0DataCell.h"

@protocol L0TextCellDelegate <UITextFieldDelegate>
@optional
- (void)textFieldDidChange:(UITextField *)field;
@end

@interface L0EditTextCell : L0DataCell <UITextFieldDelegate>
@property (nonatomic) UITextField *field;
@property (nonatomic) id<L0TextCellDelegate> delegate;
@end
