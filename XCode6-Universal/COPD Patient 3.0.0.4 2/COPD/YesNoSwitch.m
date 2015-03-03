#import "YesNoSwitch.h"

@interface YesNoSwitch () <UIGestureRecognizerDelegate, UIScrollViewDelegate>
- (void)setYes:(BOOL)yes animated:(BOOL)animated fireDelegate:(BOOL)fireDelegate doOffset:(BOOL)doOffset;
@end

@implementation YesNoSwitch
@synthesize yes = _yes, delegate = _delegate;

- (UILabel *)labelWithYes:(BOOL)yes active:(BOOL)active
{
    UILabel * label = [[[UILabel alloc] initWithFrame: CGRectZero] autorelease];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = active ? [UIColor whiteColor] : [UIColor colorWithWhite: 0.7 alpha: 1];
    label.font = [UIFont systemFontOfSize: style == YesNoSwitchStyleSmall ? 16 : 24 ];
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor colorWithWhite: 0.5 alpha: 0.5];
    label.shadowOffset = CGSizeMake(0, 1);
    label.text = yes ? @"YES" : @"NO";

    return label;
}

- (id)initWithStyle:(YesNoSwitchStyle)s
{
    self = [super initWithFrame:CGRectZero];
    if (self) 
    {
        style = s;
        UIImage * bg = nil;
        UIImage * slide = nil;
        if (style == YesNoSwitchStyleSmall)
        {
            bg = [UIImage imageNamed: @"small-bg.png"];
            slide = [UIImage imageNamed: @"small-slide-bg.png"];
        }
        else
        {
            bg = [UIImage imageNamed: @"large-bg.png"];
            slide = [UIImage imageNamed: @"slide-bg.png"];
        }
        
        CGFloat width = bg.size.width;
        CGFloat height = bg.size.height;
        
        self.frame = CGRectMake(0, 0, width, height);
        
        UIImageView * bgView = [[[UIImageView alloc] initWithImage: bg] autorelease];

        [self addSubview: bgView];
        
        
        scrollView = [[[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, width/2, height)] autorelease];
        scrollView.contentSize = CGSizeMake(width, height);
        scrollView.bounces = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.clipsToBounds = NO;
        scrollView.delegate = self;
        [self addSubview: scrollView];
        
        toddler = [[[UIImageView alloc] initWithImage: slide] autorelease];
        toddler.frame = CGRectMake(width/2, 0, toddler.frame.size.width, toddler.frame.size.height);
        [scrollView addSubview: toddler];
        
        yesLabel = [self labelWithYes: YES active: NO];
        yesLabel.frame = CGRectMake(0, 0, width/2, height);
        noLabel = [self labelWithYes: NO active: NO];
        noLabel.frame = CGRectMake(width/2, 0, width/2, height);
        [bgView addSubview: yesLabel];
        [bgView addSubview: noLabel];
        
        toddlerPlaceholder = [[[UIView alloc] initWithFrame: toddler.bounds] autorelease];
        
        yesToddlerLabel = [self labelWithYes: YES active: YES];
        yesToddlerLabel.alpha = 0;
        noToddleLabel = [self labelWithYes: NO active: YES];
        yesToddlerLabel.frame = noToddleLabel.frame = toddler.bounds;
        [toddlerPlaceholder addSubview: yesToddlerLabel];
        [toddlerPlaceholder addSubview: noToddleLabel];
        
        [toddler addSubview: toddlerPlaceholder];
        
        
        UILongPressGestureRecognizer * lpgr = [[[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(handleLongPress:)] autorelease];
        lpgr.minimumPressDuration = 0;
        lpgr.delegate = self;
        [self addGestureRecognizer: lpgr];
        _yes = NO;
        
        [self wobble];
    }
    return self; 
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithStyle: YesNoSwitchStyleSmall];
}

- (void)highlightToddler:(BOOL)highlight
{
    [UIView animateWithDuration:0.15 animations:^{
        toddlerPlaceholder.alpha = highlight ? 0.7 : 1;
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)lpgr
{
    CGPoint pt = [lpgr locationInView: self];
    switch (lpgr.state) {
        case UIGestureRecognizerStateBegan:
        {
            oldX = pt.x;
            [self highlightToddler: YES];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            [self highlightToddler: NO];
            
            CGFloat diff = fabs(pt.x - oldX);
            if (diff < 15)
            {
                [self setYes: (pt.x <  self.frame.size.width/2) animated: YES fireDelegate: YES doOffset: YES];
            }
        }
            break;
        default:
            break;
    }  
}


- (void)setYes:(BOOL)yes animated:(BOOL)animated fireDelegate:(BOOL)fireDelegate doOffset:(BOOL)doOffset
{
    if (_yes != yes)
    {
        _yes = yes;
        
        if (doOffset)
        {
            if (animated)
            {
                scrollView.scrollEnabled = NO;
            }
            [scrollView setContentOffset: CGPointMake(yes ? scrollView.frame.size.width : 0 ,0) animated: animated];
        }
        
        if (fireDelegate)
        { 
            [self.delegate yesNoSwitchWasToggled: self];
        }

    }
}

- (void)setYes:(BOOL)yes animated:(BOOL)animated
{
    [self setYes: yes animated: animated fireDelegate: NO doOffset: YES];
}

- (void)setYes:(BOOL)yes
{
    [self setYes: yes animated: NO];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView * result = [super hitTest: point withEvent: event];
    if (result)
    {
        return scrollView;
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)sv
{
    BOOL yes = scrollView.contentOffset.x > scrollView.frame.size.width/2;
    
    if (fabs(yesToddlerLabel.alpha - yes) > 0.1)
    {
        [UIView animateWithDuration:0.15 animations:^{
            yesToddlerLabel.alpha = yes;
            noToddleLabel.alpha = !yes;
        }];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)sv
{
    scrollView.scrollEnabled = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)sv willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        BOOL yes = scrollView.contentOffset.x > scrollView.frame.size.width/2;
        [self setYes: yes animated: NO fireDelegate: YES doOffset: NO];
    }
    else
    {
        allowNext = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sv
{
    if (allowNext)
    {
        allowNext = NO;
        BOOL yes = scrollView.contentOffset.x > scrollView.frame.size.width/2;
        [self setYes: yes animated: NO fireDelegate: YES doOffset: NO];
    }
}

- (void)wobble
{
    toddler.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration: 0.25 delay: 0.25 options:0 animations:^{
        toddler.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration: 0.25 animations:^{
            toddler.transform = CGAffineTransformIdentity;
        }];
    }];
}

@end
