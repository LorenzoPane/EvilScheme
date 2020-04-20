#import <UIKit/UIKit.h>

@protocol L0TextCellDelegate <UITextFieldDelegate>
- (void)textFieldDidChange:(UITextField *)field;
@end

@interface L0EditTextCell : UITableViewCell <UITextFieldDelegate>
@property (nonatomic) UITextField *field;
@property (nonatomic) NSString *labelText;
@property (nonatomic) NSString *fieldPlaceholder;
@property (nonatomic) id<L0TextCellDelegate> delegate;
@end
