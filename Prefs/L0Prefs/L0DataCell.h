#import <UIKit/UIKit.h>

@interface L0DataCell : UITableViewCell

@property (atomic, strong) UIView *detailView;
@property (nonatomic, strong) NSString *labelText;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                   detailView:(UIView *)detailView;
@end
