#import <UIKit/UIKit.h>

@protocol EVSEditTextCellDelegate <UITextFieldDelegate>
- (void)textFieldDidChange:(UITextField *)field;
@end

@interface EVSEditTextCell : UITableViewCell <UITextFieldDelegate>
@property (nonatomic) UITextField *field;
@property (nonatomic) NSString *labelText;
@property (nonatomic) NSString *fieldPlaceholder;
@property (nonatomic) id<EVSEditTextCellDelegate> delegate;
@end
