#import "BreathlessnessView.h"

@implementation BreathlessnessView
@synthesize delegate, value = _value;

- (void)addButtonWithValue:(NSString *)value title:(NSString *)title arrow:(NSString *)arrow
{
    UIButton * btn = [UIButton buttonWithType: UIButtonTypeCustom];
    [btn setBackgroundImage: [UIImage imageNamed: [NSString stringWithFormat: @"%@.png",value]] forState: UIControlStateNormal];
    [btn setBackgroundImage: [UIImage imageNamed: [NSString stringWithFormat: @"%@-active.png",value]] forState: UIControlStateSelected];
    [btn addTarget: self action: @selector(btnClicked:) forControlEvents: UIControlEventTouchUpInside];
    [btn setTitle: value forState: UIControlStateNormal];
    [btn setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [btn setTitleShadowColor: [UIColor colorWithWhite: 0.5 alpha: 0.5] forState: UIControlStateNormal];
    [btn setTitleColor: [UIColor colorWithWhite: 0.9 alpha: 1] forState: UIControlStateSelected];
    [btn setTitleShadowColor: [UIColor colorWithWhite: 0 alpha: 0.5] forState: UIControlStateSelected];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize: 28];
    btn.titleLabel.shadowOffset = CGSizeMake(1, 1);
    btn.titleEdgeInsets = UIEdgeInsetsMake(-12, 0, 0, 0);
    [btn sizeToFit];
    
    UILabel * titleView = [[[UILabel alloc] initWithFrame: CGRectMake(0, 30, btn.frame.size.width, btn.frame.size.height - 30)] autorelease];
    titleView.textAlignment = UITextAlignmentCenter;
    titleView.textColor = [UIColor blackColor];
    titleView.font = [UIFont systemFontOfSize:12];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.shadowColor = [UIColor colorWithWhite: 0.5 alpha: 0.5];
    titleView.shadowOffset = CGSizeMake(1, 1);
    titleView.text = title;
    titleView.tag = -1;
    [btn addSubview: titleView];
    
    if (arrow)
    {
        UIImage * normalImg = [UIImage imageNamed: [NSString stringWithFormat: @"%@.png", arrow]];
        UIImage * selectedImg = [UIImage imageNamed: [NSString stringWithFormat: @"%@-white.png", arrow]];
        UIImageView * arrowView = [[[UIImageView alloc]  initWithImage: normalImg highlightedImage: selectedImg] autorelease];
        arrowView.tag = -2;
        arrowView.center = CGPointMake(btn.frame.size.width/2, btn.frame.size.height/2 + 7);
        [btn addSubview: arrowView];
    }
    
    [self addSubview: btn];
    [buttons addObject: btn];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        buttons = [[NSMutableArray alloc] init];
        
        [self addButtonWithValue: @"0" title: @"None" arrow: nil];
        [self addButtonWithValue: @"0.5" title: @"Very Mild" arrow: nil];
        [self addButtonWithValue: @"1" title: @"Less Mild" arrow: @"arrow-left"];
        [self addButtonWithValue: @"2" title: @"Mild" arrow: nil];
        [self addButtonWithValue: @"3" title: @"More Mild" arrow: @"arrow-right"];
        [self addButtonWithValue: @"4" title: @"Less Moderate" arrow: @"arrow-left"];
        [self addButtonWithValue: @"5" title: @"Moderate" arrow: nil];
        [self addButtonWithValue: @"6" title: @"More Moderate" arrow: @"arrow-right"];
        [self addButtonWithValue: @"7" title: @"Less Severe" arrow: @"arrow-left"];
        [self addButtonWithValue: @"8" title: @"Severe" arrow: nil];
        [self addButtonWithValue: @"9" title: @"More Severe" arrow: @"arrow-right"];
        [self addButtonWithValue: @"10" title: @"Extreme" arrow: nil];
        
        _value = -1;
    }
    return self;
}

- (void)dealloc
{
    [buttons release];
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = self.frame.size.width;
    
    CGPoint nextOrigin = CGPointZero;
    for (UIButton * btn in buttons)
    {
        CGRect fr =  btn.frame;
        fr.origin = nextOrigin;
        btn.frame = fr;
        nextOrigin.x += btn.frame.size.width;
        if (nextOrigin.x >= w - 20)
        {
            nextOrigin.x = 0;
            nextOrigin.y += btn.frame.size.height;
        }
    }
}

- (void)setButtonAtIndex:(NSInteger) index selected:(BOOL)selected
{
    UIButton * btn = [buttons objectAtIndex: index];
    btn.selected = selected;
    
    UILabel * titleView = (UILabel *)[btn viewWithTag: -1];
    if (selected)
    {
        titleView.textColor = [UIColor colorWithWhite: 0.9 alpha: 1];
        titleView.shadowColor = [UIColor colorWithWhite: 0 alpha: 0.5];
    }
    else
    {
        titleView.textColor = [UIColor blackColor];
        titleView.shadowColor = [UIColor colorWithWhite: 0.5 alpha: 0.5];
    }
    
    UIImageView * arrowView = (UIImageView *)[btn viewWithTag: -2];
    arrowView.highlighted = selected;
}

- (void)setValue:(NSInteger)value
{
    if (_value != -1)
    {
        [self setButtonAtIndex: _value selected:  NO];
    }
    _value = value;
    if (_value != -1)
    {
        [self setButtonAtIndex: _value selected:  YES];
    }
}

- (void)btnClicked:(UIButton *)btn
{
    int newValue = [buttons indexOfObject: btn];
    if (newValue != self.value) 
    {
        self.value = newValue;
        [delegate breathlessnessViewValueChanged: self];
    }
}

@end
