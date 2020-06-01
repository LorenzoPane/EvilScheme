#import "L0Prefs.h"

@implementation L0StepperCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    UIStepper *stepper = [UIStepper new];
    if((self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier
                         detailView:stepper])) {
        _prefix = @"";
        _stepper = stepper;
        [_stepper addTarget:self
                    action:@selector(stepperValueDidChange:)
          forControlEvents:UIControlEventValueChanged];
    }

    return self;
}

- (void)stepperValueDidChange:(UIStepper *)stepper {
    [[self textLabel] setText:[NSString stringWithFormat:@"%@: %d", [self prefix], (int)[stepper value]]];
    [[self delegate] stepperValueDidChange:stepper];
}

@end

