#import "L0Prefs.h"

@implementation L0ButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [[self textLabel] setTextColor:TINT_COLOR];
    }

    return self;
}

@end
