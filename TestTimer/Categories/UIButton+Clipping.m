#import "UIButton+Clipping.h"

@implementation UIButton (Clipping)

- (void)adjustButtonTitle {

    self.titleLabel.numberOfLines = 1;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.lineBreakMode = NSLineBreakByClipping;
}

@end
