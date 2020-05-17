#import "L0Prefs.h"

@implementation L0ToggleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    UISwitch *toggle = [UISwitch new];
    if((self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier
                         detailView:toggle])) {
        _toggle = toggle;
        [_toggle addTarget:self
                    action:@selector(switchValueDidChange:)
          forControlEvents:UIControlEventValueChanged];
    }

    return self;
}

- (void)switchValueDidChange:(UISwitch *)toggle {
    [[self delegate] switchValueDidChange:toggle];
}

@end

