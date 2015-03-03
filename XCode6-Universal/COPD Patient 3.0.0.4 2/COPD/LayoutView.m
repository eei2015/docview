#import "LayoutView.h"


@implementation LayoutView
@synthesize layoutViewDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [layoutViewDelegate layoutSubviewsInView: self];
}

- (void)dealloc
{
    [super dealloc];
}

@end
