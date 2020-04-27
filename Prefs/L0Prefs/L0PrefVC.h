#import <UIKit/UIKit.h>
#import <Preferences/PSViewController.h>

#define LINK_COLOR [UIColor colorWithRed:0.776 green:0.471 blue:0.867 alpha:1]

@class L0PrefVC;

@protocol L0PrefVCDelegate <NSObject>
/// Method to be called when a member of the implementing delegate controller has changed it's model
/// @param controller View controller that has been changed
- (void)controllerDidChangeModel:(L0PrefVC *)controller;
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
