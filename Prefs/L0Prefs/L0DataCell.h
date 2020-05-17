#import <UIKit/UIKit.h>

@interface L0DataCell : UITableViewCell

@property (atomic, strong) UIView *detailView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                   detailView:(UIView *)detailView;
@end
