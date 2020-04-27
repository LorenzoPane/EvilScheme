#import "L0Prefs.h"

@implementation L0EditTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    UITextField *textField = [UITextField new];
    [textField setDelegate:self];
    [textField setReturnKeyType:UIReturnKeyDone];
    [textField setTextAlignment:NSTextAlignmentRight];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    if((self = [super initWithStyle:UITableViewCellStyleValue1
                    reuseIdentifier:reuseIdentifier
                         detailView:textField])) {
        _field = textField;
        [[self contentView] addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                                  initWithTarget:_field
                                                  action:@selector(becomeFirstResponder)]];
    }

    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return NO;
}

- (void)setDelegate:(id<L0TextCellDelegate>)delegate {
    _delegate = delegate;
    if([delegate respondsToSelector:@selector(textFieldDidChange:)]) {
        [[self field] addTarget:delegate
                         action:@selector(textFieldDidChange:)
               forControlEvents:UIControlEventEditingChanged];
    }
}

@end
