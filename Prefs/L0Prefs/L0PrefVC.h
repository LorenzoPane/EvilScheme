#import <UIKit/UIKit.h>
#import <Preferences/PSViewController.h>

/// Default tint color
#define TINT_COLOR [UIColor colorWithRed:0.776 green:0.471 blue:0.867 alpha:1]

/// Default reuse identifiers
#define LINK_CELL_ID           @"L0LinkCell"
#define BASIC_CELL_ID          @"L0BasicCell"
#define PROSE_CELL_ID          @"L0ProseCell"
#define PICKER_CELL_ID         @"L0PickerCell"
#define BUTTON_CELL_ID         @"L0ButtonCell"
#define TOGGLE_CELL_ID         @"L0ToggleCell"
#define STEPPER_CELL_ID        @"L0StepperCell"
#define EDIT_TEXT_CELL_ID      @"L0EditTextCell"
#define PURE_EDIT_TEXT_CELL_ID @"L0PureEditTextCell"

@class L0PrefVC;

@protocol L0PrefVCDelegate <NSObject>

/// Method to be called when a member of the implementing delegate controller has changed it's model
/// @param controller View controller that has been changed
@required - (void)controllerDidChangeModel:(L0PrefVC *)controller;

@optional - (BOOL)controller:(L0PrefVC *)controller canMoveFromKey:(NSString *)from toKey:(NSString *)to;
@optional - (void)controller:(L0PrefVC *)controller willMoveFromKey:(NSString *)from toKey:(NSString *)to;

@end

/// Abstract class for all view table view controllers
@interface L0PrefVC : PSViewController <L0PrefVCDelegate, UITableViewDelegate, UITableViewDataSource>

/// Delegate to implement model changes
@property (atomic, weak) id<L0PrefVCDelegate> delegate;

/// Primary view
@property (atomic, strong) UITableView *tableView;

/// Dictionary of reuse identifiers and corrosponding classes
@property (atomic, strong) NSDictionary<NSString *, Class> *cells;

/// Convenience method for finding the apps key window
+ (UIWindow *)keyWindow;

/// Method to be overridden if the subclass is the root view controller
- (BOOL)isRootVC;

- (void)setupTable;

@end
