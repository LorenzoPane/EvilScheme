#import "L0EditTextCell.h"

@interface L0PickerCell : L0EditTextCell <UIPickerViewDelegate, UIPickerViewDataSource>

@property (atomic, strong) UIPickerView *picker;
@property (atomic, strong) NSArray<NSString *> *options;

- (void)selectIndex:(NSUInteger)idx;
- (void)selectObject:(NSString *)obj;

@end
