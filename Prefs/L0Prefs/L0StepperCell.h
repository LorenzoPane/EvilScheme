#import "L0DataCell.h"

@protocol L0StepperCellDelegate <NSObject>
- (void)stepperValueDidChange:(UIStepper *)stepper;
@end

@interface L0StepperCell : L0DataCell
@property (atomic, strong) UIStepper *stepper;
@property (atomic, strong) NSString *prefix;
@property (atomic, weak) id<L0StepperCellDelegate> delegate;

- (void)stepperValueDidChange:(UIStepper *)stepper;
@end
