#import "L0EditTextCell.h"

@implementation L0EditTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if((self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier])) {
        [[self detailTextLabel] setHidden:YES];

        UITextField *field = [[UITextField alloc] init];
        [field setDelegate:self];

        [field setTextAlignment:NSTextAlignmentRight];
        [field setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self contentView] addSubview:field];
        [self setField:field];
        [[self contentView] addConstraint:[NSLayoutConstraint constraintWithItem:[self field]
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:[self textLabel]
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1
                                                                        constant:16]];
        [[self contentView] addConstraint:[NSLayoutConstraint constraintWithItem:[self field]
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:[self textLabel]
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1
                                                                        constant:0]];
        [[self contentView] addConstraint:[NSLayoutConstraint constraintWithItem:[self field]
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:[self textLabel]
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1
                                                                        constant:0]];
        [[self contentView] addConstraint:[NSLayoutConstraint constraintWithItem:[self field]
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:[self contentView]
                                                                       attribute:NSLayoutAttributeTrailingMargin
                                                                      multiplier:1
                                                                        constant:-8]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return NO;
}

- (void)setFieldPlaceholder:(NSString *)fieldPlaceholder {
    [[self field] setPlaceholder:fieldPlaceholder];
}

- (NSString *)fieldPlaceholder {
    return [[self field] placeholder];
}

- (void)setLabelText:(NSString *)labelText {
    [[self textLabel] setText:labelText];
}

- (NSString *)labelText {
    return [[self textLabel] text];
}

- (void)setDelegate:(id<L0TextCellDelegate>)delegate {
    _delegate = delegate;
    [[self field] addTarget:delegate
                     action:@selector(textFieldDidChange:)
           forControlEvents:UIControlEventEditingChanged];
}

@end
