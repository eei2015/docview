#import "HitView.h"

@implementation HitView
@synthesize view;

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView * result = [super hitTest: point withEvent: event];
    if (result)
    {
        
        result = view;
    }
    return result;
}

@end
