#import "UITableViewCell+Inset.h"
#import <objc/runtime.h>

static char UITableViewCell_Inset_Key;

@implementation UITableViewCell (Inset)


- (void)setFrame:(CGRect)frame {
    frame.origin.x += self.inset;
    frame.size.width -= 2 * self.inset;
    [super setFrame:frame];
}

- (void)setInset:(CGFloat)inset
{
    objc_setAssociatedObject(self, &UITableViewCell_Inset_Key, [NSNumber numberWithFloat: inset], OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)inset
{
    return [objc_getAssociatedObject(self, &UITableViewCell_Inset_Key) floatValue];
}

@end
