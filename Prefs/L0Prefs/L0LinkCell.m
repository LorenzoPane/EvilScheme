#import "L0Prefs.h"

@implementation L0LinkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }

    return self;
}

@end
