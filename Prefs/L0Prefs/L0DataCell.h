#import <UIKit/UIKit.h>

@interface L0DataCell : UITableViewCell

@property UIView *detailView;
@property (nonatomic) NSString *labelText;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                   detailView:(UIView *)detailView;
@end
