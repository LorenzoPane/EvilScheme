#import "L0EditTextCell.h"

@interface L0PickerCell : L0EditTextCell <UIPickerViewDelegate, UIPickerViewDataSource>

@property UIPickerView *picker;
@property NSArray<NSString *> *options;

@end
