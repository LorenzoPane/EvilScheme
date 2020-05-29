#import "L0PureEditTextCell.h"

@implementation L0PureEditTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    UITextField *textField = [UITextField new];
    [textField setDelegate:self];
    [textField setReturnKeyType:UIReturnKeyDone];
    [textField setTextAlignment:NSTextAlignmentLeft];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    if((self = [super initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:reuseIdentifier])) {
        _field = textField;
        [[self contentView] addSubview:_field];
        [[self contentView] addConstraint:[NSLayoutConstraint constraintWithItem:_field
                                                                       attribute:NSLayoutAttributeCenterY
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:[self contentView]
                                                                       attribute:NSLayoutAttributeCenterY
                                                                      multiplier:1
                                                                        constant:0]];
        [[self contentView] addConstraint:[NSLayoutConstraint constraintWithItem:_field
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:[self contentView]
                                                                       attribute:NSLayoutAttributeLeading
                                                                      multiplier:1
                                                                        constant:16]];


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
