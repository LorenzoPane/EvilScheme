#import "L0Prefs.h"

@implementation L0DataCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                   detailView:(UIView *)detailView {
    if((self = [super initWithStyle:UITableViewCellStyleValue1
                    reuseIdentifier:reuseIdentifier])) {
        [[self detailTextLabel] setHidden:YES];

        _detailView = detailView;

        [_detailView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self contentView] addSubview:[self detailView]];
        [[self contentView] addConstraint:[NSLayoutConstraint constraintWithItem:_detailView
                                                                       attribute:NSLayoutAttributeCenterY
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:[self contentView]
                                                                       attribute:NSLayoutAttributeCenterY
                                                                      multiplier:1
                                                                        constant:0]];
        [[self contentView] addConstraint:[NSLayoutConstraint constraintWithItem:_detailView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:[self contentView]
                                                                       attribute:NSLayoutAttributeTrailingMargin
                                                                      multiplier:1
                                                                        constant:0]];
        [[self contentView] addConstraint:[NSLayoutConstraint constraintWithItem:_detailView
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                          toItem:[self textLabel]
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1
                                                                        constant:16]];

        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    return self;
}

@end
