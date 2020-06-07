#import "L0ProseCell.h"

@implementation L0ProseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [[self textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
        [[self textLabel] setNumberOfLines:0];
    }

    return self;
}

@end
