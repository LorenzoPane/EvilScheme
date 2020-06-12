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


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self becomeFirstResponder];

    CGPoint point = [[touches anyObject] locationInView:[self contentView]];
    UIMenuController *shared = [UIMenuController sharedMenuController];
    [shared setMenuItems:@[
        [[UIMenuItem alloc] initWithTitle:@"Copy" action:@selector(copyText)]
    ]];
    [shared showMenuFromView:[self textLabel] rect:CGRectMake(point.x, point.y, 0, 0)];

    [super touchesEnded:touches withEvent:event];
}

- (BOOL)canBecomeFirstResponder { return YES; }

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return action == @selector(copyText);
}

- (void)copyText {
    [[UIPasteboard generalPasteboard] setString:[[self textLabel] text]];
}

@end
