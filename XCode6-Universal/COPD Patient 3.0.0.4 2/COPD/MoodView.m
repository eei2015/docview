#import "MoodView.h"
#import <QuartzCore/QuartzCore.h>
#import "Content.h"
@interface MoodView ()

@property (nonatomic, readonly) CAShapeLayer * shapeLayer;

@end

@implementation MoodView
@synthesize selectedSmileIndex = _selectedSmileIndex, delegate = _delegate;

- (void)addSmileWithImageName:(NSString *)imageName
{
    UIImageView * imageView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: imageName]] autorelease];
    
    imageView.userInteractionEnabled = YES;
    [smiles addObject: imageView];
    [self addSubview: imageView];
    
    UITapGestureRecognizer * g = [[[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTap:)] autorelease];
    [imageView addGestureRecognizer: g];
}

- (void)addIndicatorLabelWithText:(NSString *)text
{
    UILabel * indicatorLabel = [[[UILabel alloc] initWithFrame: CGRectZero] autorelease];
    indicatorLabel.backgroundColor = [UIColor clearColor];
    indicatorLabel.text = text;
    indicatorLabel.textAlignment = UITextAlignmentCenter;
    indicatorLabel.font = [UIFont systemFontOfSize: 22];
    [indicators addObject: indicatorLabel];
    [self addSubview: indicatorLabel];
}
-(id)initWithFrameWithOptions:(CGRect)frame Options:(NSMutableArray*)options
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _selectedSmileIndex = -1;
        smiles = [[NSMutableArray alloc] init];
        
        self.shapeLayer.fillColor = [UIColor colorWithWhite: 0 alpha: 0.6].CGColor;
        self.shapeLayer.lineWidth = 0;
        self.shapeLayer.shadowColor = [UIColor colorWithWhite: 0.3 alpha: 0.9].CGColor;
        self.shapeLayer.shadowOpacity = 1;
        self.shapeLayer.shadowOffset = CGSizeZero;
        self.shapeLayer.shadowRadius = 2;
        //2015-01-19 Vipul ios8 upgradation
        NSString * strVersion = [[UIDevice currentDevice] systemVersion];
        int intVersion = [strVersion integerValue];        
        //2015-01-19 Vipul ios8 upgradation
        
        // NSLog(@"Options:  %@",options);
        for (int i=0; i<[options count]; i++) {
            QuestionOptions *opt=(QuestionOptions*)[options objectAtIndex:i];
            // NSLog(@"Title: %@",opt.qOptionTitle);
            if ([opt.qOptionTitle isEqualToString:@"Good"]) {
                
                //2015-01-19 Vipul ios8 upgradation
                //[self addSmileWithImageName: @"good@2x.png"];
                if(intVersion > 7)
                {
                    [self addSmileWithImageName: @"good@2x_ios8.png"];
                }
                else
                {
                    [self addSmileWithImageName: @"good@2x.png"];
                }
                //2015-01-19 Vipul ios8 upgradation
            }
            else if ([opt.qOptionTitle isEqualToString:@"Normal"]) {
                //2015-01-19 Vipul ios8 upgradation
                if(intVersion > 7)
                {
                    [self addSmileWithImageName: @"normal@2x_ios8.png"];
                }
                else
                {
                    [self addSmileWithImageName: @"normal@2x.png"];
                }
                //2015-01-19 Vipul ios8 upgradation
                
            } else if ([opt.qOptionTitle isEqualToString:@"Bad"]) {
                //2015-01-19 Vipul ios8 upgradation
                if(intVersion > 7)
                {
                    [self addSmileWithImageName: @"bad@2x_ios8.png"];
                }
                else
                {
                    [self addSmileWithImageName: @"bad@2x.png"];
                }
                //2015-01-19 Vipul ios8 upgradation
            }
            
        }
        
        
        
        // indicators = [[NSMutableArray alloc] init];
        
        //        for (NSInteger i = 5; i >= 1; i--)
        //        {
        //            [self addIndicatorLabelWithText: [NSString stringWithFormat: @"%d",i]];
        //        }
    }
    return self;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _selectedSmileIndex = -1;
        smiles = [[NSMutableArray alloc] init];
        
        self.shapeLayer.fillColor = [UIColor colorWithWhite: 0 alpha: 0.6].CGColor;
        self.shapeLayer.lineWidth = 0;
        self.shapeLayer.shadowColor = [UIColor colorWithWhite: 0.3 alpha: 0.9].CGColor;
        self.shapeLayer.shadowOpacity = 1;
        self.shapeLayer.shadowOffset = CGSizeZero;
        self.shapeLayer.shadowRadius = 2;
                
        //2015-01-19 Vipul ios8 upgradation
        NSString * strVersion = [[UIDevice currentDevice] systemVersion];
        int intVersion = [strVersion integerValue];
        //2015-01-19 Vipul ios8 upgradation
        
        //2015-01-19 Vipul ios8 upgradation
        if(intVersion > 7)
        {
            [self addSmileWithImageName: @"good@2x_ios8.png"];
            [self addSmileWithImageName: @"normal@2x_ios8.png"];
            [self addSmileWithImageName: @"bad@2x_ios8.png"];
        }
        else{
            [self addSmileWithImageName: @"good@2x.png"];
            [self addSmileWithImageName: @"normal@2x.png"];
            [self addSmileWithImageName: @"bad@2x.png"];
        }
        
        
        indicators = [[NSMutableArray alloc] init];
        
        //        for (NSInteger i = 5; i >= 1; i--)
        //        {
        //            [self addIndicatorLabelWithText: [NSString stringWithFormat: @"%d",i]];
        //        }
    }
    return self;
}

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (CAShapeLayer *)shapeLayer
{
    return (CAShapeLayer *)self.layer;
}

- (void)dealloc
{
    [smiles release];
    [indicators release];
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(self.frame, oldFrame))
    {
        initialLayout = YES;
        oldFrame = self.frame;
        CGFloat w = self.frame.size.width;
        CGFloat h = self.frame.size.height;
        NSInteger cnt = [smiles count];
        CGFloat centerX = h/2;
        CGFloat centerY = h/2;
        CGFloat distance = (w - h)/(cnt - 1);
        
        
        int i = 0;
        for (UIImageView * smile in smiles)
        {
            smile.frame = CGRectMake(roundf(centerX + i*distance - smile.image.size.width/2), roundf(centerY - smile.image.size.height/2), smile.image.size.width,smile.image.size.height);
            i++;
        }
        [self updatedSelectedSmile: NO];
        
        CGFloat iw = w/5;
        
        i = 0;
        for (UILabel * indicatorLabel in indicators)
        {
            indicatorLabel.frame = CGRectMake(i * iw, h + 20, iw, 20);
            i++;
        }
    }
    
}

- (void)updatedSelectedSmile:(BOOL)animated
{
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    UIBezierPath * holderPath = [UIBezierPath bezierPathWithRoundedRect: self.bounds cornerRadius: h/2];
    
    NSInteger cnt = [smiles count];
    CGFloat centerX = h/2;
    CGFloat centerY = h/2;
    CGFloat distance = (w - h)/(cnt - 1);
    
    
    
    
    [UIView animateWithDuration: animated ? 0.3 : 0 animations:^{
        int i = 0;
        for (UIImageView * smile in smiles)
        {
            CGFloat scale = (i == self.selectedSmileIndex ? 1.0: 0.65);
            smile.transform = CGAffineTransformMakeScale(scale, scale);
            smile.alpha = (i == self.selectedSmileIndex ? 1.0: 0.6);
            CGFloat radius = (i == self.selectedSmileIndex ? 40: h/2);
            CGRect r = CGRectMake((centerX + i*distance) - radius, centerY - radius, radius*2, radius*2);
            UIBezierPath * cirlePath = [UIBezierPath bezierPathWithOvalInRect: r];
            [holderPath appendPath: cirlePath];
            i++;
        }
        
        i = 0;
        
        NSInteger indicatorSelectedIndex = -1;
        if (self.selectedSmileIndex == 0)
        {
            indicatorSelectedIndex = 0;
        }
        else if (self.selectedSmileIndex == 1)
        {
            indicatorSelectedIndex = 2;
        }
        else if (self.selectedSmileIndex == 2)
        {
            indicatorSelectedIndex = 4;
        }
        
        for (UILabel * indicatorLabel in indicators)
        {
            BOOL selected = i == indicatorSelectedIndex;
            CGFloat scale = (selected ? 1.0: 0.65);
            indicatorLabel.transform = CGAffineTransformMakeScale(scale, scale);
            indicatorLabel.textColor = selected ? [UIColor whiteColor] : [UIColor grayColor];
            i++;
        }
    }];
    
    if (animated)
    {
        {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
            animation.duration = 0.3;
            animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
            animation.fromValue = (id)[self.shapeLayer.presentationLayer path];
            animation.toValue = (id)holderPath.CGPath;
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            [self.shapeLayer addAnimation:animation forKey:@"animatePath"];
        }
        
        {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
            animation.duration = 0.3;
            animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
            animation.fromValue = (id)[self.shapeLayer.presentationLayer shadowPath];
            animation.toValue = (id)holderPath.CGPath;
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            [self.shapeLayer addAnimation:animation forKey:@"animateShadowPath"];
        }
    }
    else
    {
        self.shapeLayer.path = holderPath.CGPath;
        self.shapeLayer.shadowPath = holderPath.CGPath;
    }
    
    
}

- (void)setSelectedSmileIndex:(NSInteger)selectedSmileIndex animated:(BOOL)animated
{
    if (_selectedSmileIndex != selectedSmileIndex)
    {
        _selectedSmileIndex = selectedSmileIndex;
        if (initialLayout)
        {
            [self updatedSelectedSmile: animated];
        }
        [self.delegate moodViewDidChanged: self];
    }
}

- (void)setSelectedSmileIndex:(NSInteger)selectedSmileIndex
{
    [self setSelectedSmileIndex: selectedSmileIndex animated: NO];
}

- (void)handleTap:(UITapGestureRecognizer *)g
{
    if (g.state == UIGestureRecognizerStateRecognized)
    {
        [self setSelectedSmileIndex: [smiles indexOfObject: g.view] animated: YES];
    }
}

@end



/*#import "MoodView.h"
#import <QuartzCore/QuartzCore.h>

@interface MoodView ()

@property (nonatomic, readonly) CAShapeLayer * shapeLayer;

- (void)updatedSelectedSmile:(BOOL)animated;

@end


@implementation MoodView
@synthesize selectedSmileIndex = _selectedSmileIndex, delegate = _delegate;

- (void)addSmileWithImageName:(NSString *)imageName
{
    UIImageView * imageView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: imageName]] autorelease];
    imageView.userInteractionEnabled = YES;
    [smiles addObject: imageView];
    [self addSubview: imageView];
    
    UITapGestureRecognizer * g = [[[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTap:)] autorelease];
    [imageView addGestureRecognizer: g];
}

- (void)addIndicatorLabelWithText:(NSString *)text
{
    UILabel * indicatorLabel = [[[UILabel alloc] initWithFrame: CGRectZero] autorelease];
    indicatorLabel.backgroundColor = [UIColor clearColor];
    indicatorLabel.text = text;
    indicatorLabel.textAlignment = UITextAlignmentCenter;
    indicatorLabel.font = [UIFont systemFontOfSize: 22];
    [indicators addObject: indicatorLabel];
    [self addSubview: indicatorLabel];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        _selectedSmileIndex = -1;
        smiles = [[NSMutableArray alloc] init];
        
        self.shapeLayer.fillColor = [UIColor colorWithWhite: 0 alpha: 0.6].CGColor;
        self.shapeLayer.lineWidth = 0;
        self.shapeLayer.shadowColor = [UIColor colorWithWhite: 0.3 alpha: 0.9].CGColor;
        self.shapeLayer.shadowOpacity = 1;
        self.shapeLayer.shadowOffset = CGSizeZero;
        self.shapeLayer.shadowRadius = 2;
        
        [self addSmileWithImageName: @"good.png"];
        [self addSmileWithImageName: @"normal.png"];
        [self addSmileWithImageName: @"bad.png"];
       
        
        indicators = [[NSMutableArray alloc] init];
        
//        for (NSInteger i = 5; i >= 1; i--)
//        {
//            [self addIndicatorLabelWithText: [NSString stringWithFormat: @"%d",i]];
//        }
    }
    return self;
}

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (CAShapeLayer *)shapeLayer
{
    return (CAShapeLayer *)self.layer;
}

- (void)dealloc
{
    [smiles release];
    [indicators release];
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(self.frame, oldFrame)) 
    {
        initialLayout = YES;
        oldFrame = self.frame;
        CGFloat w = self.frame.size.width;
        CGFloat h = self.frame.size.height;
        NSInteger cnt = [smiles count];
        CGFloat centerX = h/2;
        CGFloat centerY = h/2;
        CGFloat distance = (w - h)/(cnt - 1);
        
        
        int i = 0;
        for (UIImageView * smile in smiles)
        {
            smile.frame = CGRectMake(roundf(centerX + i*distance - smile.image.size.width/2), roundf(centerY - smile.image.size.height/2), smile.image.size.width,smile.image.size.height);
            i++;
        }
        [self updatedSelectedSmile: NO];
        
        CGFloat iw = w/5;
        
        i = 0;
        for (UILabel * indicatorLabel in indicators)
        {
            indicatorLabel.frame = CGRectMake(i * iw, h + 20, iw, 20);
            i++;
        }
    }

}

- (void)updatedSelectedSmile:(BOOL)animated
{
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    UIBezierPath * holderPath = [UIBezierPath bezierPathWithRoundedRect: self.bounds cornerRadius: h/2];
    
    NSInteger cnt = [smiles count];
    CGFloat centerX = h/2;
    CGFloat centerY = h/2;
    CGFloat distance = (w - h)/(cnt - 1);
    
    
    
    
    [UIView animateWithDuration: animated ? 0.3 : 0 animations:^{
        int i = 0;
        for (UIImageView * smile in smiles)
        {
            CGFloat scale = (i == self.selectedSmileIndex ? 1.0: 0.65);
            smile.transform = CGAffineTransformMakeScale(scale, scale);
            smile.alpha = (i == self.selectedSmileIndex ? 1.0: 0.6);
            CGFloat radius = (i == self.selectedSmileIndex ? 40: h/2);
            CGRect r = CGRectMake((centerX + i*distance) - radius, centerY - radius, radius*2, radius*2);
            UIBezierPath * cirlePath = [UIBezierPath bezierPathWithOvalInRect: r];
            [holderPath appendPath: cirlePath];
            i++;
        }
        
        i = 0;
        
        NSInteger indicatorSelectedIndex = -1;
        if (self.selectedSmileIndex == 0)
        {
            indicatorSelectedIndex = 0;
        }
        else if (self.selectedSmileIndex == 1)
        {
            indicatorSelectedIndex = 2;
        }
        else if (self.selectedSmileIndex == 2)
        {
            indicatorSelectedIndex = 4;
        }
        
        for (UILabel * indicatorLabel in indicators)
        {
            BOOL selected = i == indicatorSelectedIndex;
            CGFloat scale = (selected ? 1.0: 0.65);
            indicatorLabel.transform = CGAffineTransformMakeScale(scale, scale);
            indicatorLabel.textColor = selected ? [UIColor whiteColor] : [UIColor grayColor];
            i++;
        }
    }];
    
    if (animated)
    {
        {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
            animation.duration = 0.3;
            animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
            animation.fromValue = (id)[self.shapeLayer.presentationLayer path];
            animation.toValue = (id)holderPath.CGPath;
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            [self.shapeLayer addAnimation:animation forKey:@"animatePath"];
        }
        
        {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
            animation.duration = 0.3;
            animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
            animation.fromValue = (id)[self.shapeLayer.presentationLayer shadowPath];
            animation.toValue = (id)holderPath.CGPath;
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            [self.shapeLayer addAnimation:animation forKey:@"animateShadowPath"];
        }
    }
    else
    {
        self.shapeLayer.path = holderPath.CGPath;
        self.shapeLayer.shadowPath = holderPath.CGPath;
    }
    
    
}

- (void)setSelectedSmileIndex:(NSInteger)selectedSmileIndex animated:(BOOL)animated
{
    if (_selectedSmileIndex != selectedSmileIndex)
    {
        _selectedSmileIndex = selectedSmileIndex;
        if (initialLayout)
        {
            [self updatedSelectedSmile: animated];
        }
        [self.delegate moodViewDidChanged: self];
    }
}

- (void)setSelectedSmileIndex:(NSInteger)selectedSmileIndex
{
    [self setSelectedSmileIndex: selectedSmileIndex animated: NO];
}

- (void)handleTap:(UITapGestureRecognizer *)g
{
    if (g.state == UIGestureRecognizerStateRecognized)
    {
        [self setSelectedSmileIndex: [smiles indexOfObject: g.view] animated: YES];
    }
}

@end*/
