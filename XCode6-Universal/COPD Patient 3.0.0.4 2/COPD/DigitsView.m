#import "DigitsView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DigitsView
@synthesize selectedField = _selectedField, delegate = _delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<DigitsViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.delegate = delegate;
        fields = [[NSMutableArray alloc] init];
        buttons = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [self.delegate numberOfFieldsInDigitView]; i++)
        {
            UIButton * field = [UIButton buttonWithType: UIButtonTypeRoundedRect];
            [field setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
            
            if ([field respondsToSelector: @selector(setTintColor:)]) 
            {
                [field setTintColor: [UIColor colorWithRed: 0.90 green: 0.45 blue: 0.14 alpha: 1]];
            }
            field.titleLabel.font =  [UIFont boldSystemFontOfSize: 48]; // - 12    Jatin Chauhan 27-Nov-2013
            [field addTarget: self action: @selector(fieldClicked:) forControlEvents: UIControlEventTouchUpInside];
            [fields addObject: field];
            
            UIView * border = [[[UIView alloc] initWithFrame: field.bounds] autorelease];
            border.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            border.layer.borderColor = [UIColor colorWithRed: 0.91 green: 0.14 blue: 0.13 alpha: 1].CGColor;
            border.layer.borderWidth = 3;
            border.layer.cornerRadius = 10;
            border.userInteractionEnabled = NO;
            border.tag = -1;
            border.alpha = 0;
            [field addSubview: border];
            [self addSubview: field];
        }
        
        if ([self.delegate digitsViewShouldHaveDivider: self]) 
        {
            fieldDividers = [[NSMutableArray alloc] init];
            for (int i = 0; i < [self.delegate numberOfFieldsInDigitView] - 1; i++)
            {
                UIView * v = [self.delegate fieldsDividerViewForDigitsView: self];
                [fieldDividers addObject: v];
                [self addSubview: v];
            }
        }
        
        //2015-01-19 Vipul ios8 upgradation
        NSString * strVersion = [[UIDevice currentDevice] systemVersion];
        int intVersion = [strVersion integerValue];
        //2015-01-19 Vipul ios8 upgradation
                      
        //2015-01-19 Vipul ios8 upgradation
        if(intVersion > 7)
        {
            headerView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"message-bar@2x_ios8.png"]] autorelease];
        }
        else
        {
            headerView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"message-bar@2x.png"]] autorelease];
        }
        //2015-01-19 Vipul ios8 upgradation
        
        [self addSubview: headerView];
        
        //2015-01-19 Vipul ios8 upgradation
        if(intVersion > 7)
        {
            redHeaderView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"red-message-bar@2x_ios8.png"]] autorelease];
        }
        else
        {
            redHeaderView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"red-message-bar@2x.png"]] autorelease];   
        }
        redHeaderView.alpha = 0;
        

 
        [self addSubview: redHeaderView];
        
        fieldTitleView = [[[UILabel alloc] initWithFrame: CGRectZero] autorelease];
        fieldTitleView.font = [UIFont boldSystemFontOfSize: 32]; // 16 - Jatin chauhan 27-Nov-2013
        fieldTitleView.shadowColor = [UIColor colorWithWhite: 0 alpha: 0.5];
        fieldTitleView.shadowOffset = CGSizeMake(0, 1);
        fieldTitleView.textColor = [UIColor whiteColor];
        fieldTitleView.backgroundColor = [UIColor clearColor];
        
        
        [self addSubview: fieldTitleView];
        
        fieldErrorView = [[[UILabel alloc] initWithFrame: CGRectZero] autorelease];
        fieldErrorView.font = [UIFont boldSystemFontOfSize: 28]; //  14 - Jatin chauhan 27-Nov-2013
        fieldErrorView.shadowColor = [UIColor colorWithWhite: 0 alpha: 0.5];
        fieldErrorView.shadowOffset = CGSizeMake(0, 1);
        fieldErrorView.textColor = [UIColor whiteColor];
        fieldErrorView.backgroundColor = [UIColor clearColor];
        fieldErrorView.text = @"Value must be in 60-800 range.";
        fieldErrorView.alpha = 0;
        
        [self addSubview: fieldErrorView];

        //2015-01-19 Vipul ios8 upgradation
        if(intVersion > 7)
        {
            carrotView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"carrot_ios8.png"]] autorelease];
        }
        else
        {
            carrotView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"carrot.png"]] autorelease];
        }
        //2015-01-19 Vipul ios8 upgradation

        [self addSubview: carrotView];
        
        //2015-01-19 Vipul ios8 upgradation
        if(intVersion > 7)
        {
            redCarrotView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"red-carrot_ios8.png"]] autorelease];
        }
        else{
            redCarrotView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"red-carrot.png"]] autorelease];
        }
        //2015-01-19 Vipul ios8 upgradation
        
        redCarrotView.alpha = 0;
        [self addSubview: redCarrotView];
        
        
        for (int i = 0; i < 12;  i++)
        {
            UIButton * button = [UIButton buttonWithType: UIButtonTypeCustom];
            
            NSString * imageName = nil;
            
            if (i%3 == 0)
            {
                if (i/3 == 3)
                {
                    imageName = @"Bottom-left";
                }
                else
                {
                    imageName = @"left";
                }
            }
            else if (i%3 == 1)
            {
                imageName = @"middle";
            }
            else
            {
                if (i/3 == 3)
                {
                    imageName = @"bottom-right";
                }
                else
                {
                    imageName = @"right";
                }
            }
            
            //2015-01-19 Vipul ios8 upgradation
            if(intVersion > 7)
            {
                [button setBackgroundImage: [UIImage imageNamed: [NSString stringWithFormat: @"%@@2x_ios8.png",imageName]] forState: UIControlStateNormal];
                [button setBackgroundImage: [UIImage imageNamed: [NSString stringWithFormat: @"%@-active@2x_ios8.png",imageName]] forState: UIControlStateHighlighted];
            }
            else
            {
                [button setBackgroundImage: [UIImage imageNamed: [NSString stringWithFormat: @"%@@2x.png",imageName]] forState: UIControlStateNormal];
                [button setBackgroundImage: [UIImage imageNamed: [NSString stringWithFormat: @"%@-active@2x.png",imageName]] forState: UIControlStateHighlighted];
            }
            //2015-01-19 Vipul ios8 upgradation
            
            if (i == 9)
            {
                button.adjustsImageWhenHighlighted = NO;
                
                //2015-01-19 Vipul ios8 upgradation
                if(intVersion > 7)
                {
                    [button setImage: [UIImage imageNamed: @"delete@2x_ios8.png"] forState:UIControlStateNormal];
                }
                else
                {
                    [button setImage: [UIImage imageNamed: @"delete@2x.png"] forState:UIControlStateNormal];
                }
                //2015-01-19 Vipul ios8 upgradation
            }
            else if (i == 10)
            {
                button.titleLabel.font = [UIFont boldSystemFontOfSize: 56]; // 28 - Jatin Chauhan 26-Nov-2013
                [button setTitle: @"0" forState: UIControlStateNormal];
            }
            else if (i == 11)
            {
                if ([fields count] > 1)
                {
                    [button setTitle: @"ENTER" forState: UIControlStateNormal];
                    [button setTitleShadowColor: [UIColor colorWithWhite: 0 alpha: 0.5] forState: UIControlStateNormal];
                    button.titleLabel.shadowOffset = CGSizeMake(0, 1);
                    button.titleLabel.font = [UIFont systemFontOfSize: 32]; //16 - Jatin Chauhan 26-Nov-2013
                }
                else
                {
                    [button setTitle: @"" forState: UIControlStateNormal];
                    [button setTitleShadowColor: [UIColor colorWithWhite: 0 alpha: 0.5] forState: UIControlStateNormal];
                    button.titleLabel.shadowOffset = CGSizeMake(0, 1);
                    button.titleLabel.font = [UIFont boldSystemFontOfSize: 30]; //15 - Jatin Chauhan 26-Nov-2013
                    button.userInteractionEnabled = NO;
                }
            }
            else
            {
                button.titleLabel.font = [UIFont boldSystemFontOfSize: 56]; //28 - Jatin Chauhan 26-Nov-2013
                [button setTitle:[NSString stringWithFormat: @"%d", i + 1] forState: UIControlStateNormal];
            }
            
            [button addTarget: self action: @selector(buttonClicked:) forControlEvents: UIControlEventTouchUpInside];
            [button sizeToFit];
            [self addSubview: button];
            [buttons addObject: button];
        }
        _selectedField = -1;
        self.selectedField = 0;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = self.frame.size.width;
    
    CGFloat leftPadding = 5;
    CGFloat rightPadding = 10;
    CGFloat fieldHeight = 108; // 54 - Jatin Chauhan 27-Nov-2013
    CGFloat fieldDist = 20;

    NSInteger count = [self.delegate numberOfFieldsInDigitView];
    
    CGFloat distLen = fieldDist*(count -1);
    if (fieldDividers)
    {
        distLen = 0;
        for (UIView * v in fieldDividers)
        {
            distLen += v.frame.size.width;
        }
    }
    
    CGFloat fieldWidth = roundf((w - leftPadding - rightPadding - distLen)/count);
        
    int i = 0;
    CGFloat x = leftPadding;
    
    for (UIView * field in fields)
    {
        if (fieldDividers)
        {
            if (i < count - 1)
            {
                UIView * divider = [fieldDividers objectAtIndex: i];
                fieldDist = divider.frame.size.width;
                divider.frame = CGRectMake(x + fieldWidth, 0, divider.frame.size.width, fieldHeight);
            }
        }
        field.frame = CGRectMake(x, 0, fieldWidth, fieldHeight);
        x += fieldWidth + fieldDist;
        i++;
    }
    
    redHeaderView.frame = headerView.frame = CGRectMake(leftPadding, fieldHeight + carrotView.frame.size.height/2 - 2, headerView.frame.size.width, headerView.frame.size.height);
    
    fieldErrorView.frame = fieldTitleView.frame = CGRectMake(leftPadding*2, fieldHeight + carrotView.frame.size.height/2 - 2, headerView.frame.size.width - leftPadding*4, headerView.frame.size.height);
    
    
    redCarrotView.center = carrotView.center = CGPointMake(leftPadding +  self.selectedField*(fieldWidth + fieldDist) + fieldWidth/2, fieldHeight);
    
    CGPoint nextOrigin = CGPointMake(leftPadding, CGRectGetMaxY(headerView.frame));
    
    for (UIButton * btn in buttons)
    {
        CGRect fr =  btn.frame;
        fr.origin = nextOrigin;
        btn.frame = fr;
        nextOrigin.x += btn.frame.size.width;
        if (nextOrigin.x >= self.frame.size.width - 20)
        {
            nextOrigin.x = leftPadding;
            nextOrigin.y += btn.frame.size.height;
        }
    }
}

- (void)dealloc
{
    [fieldDividers release];
    [fields release];
    [buttons release];
    [super dealloc];
}

- (BOOL)checkFieldLimit:(NSInteger )index
{
    return [self.delegate digitsView: self valueIsValidAtIndex: index];
}

- (NSInteger)nextFieldWithError
{
    for (int i = 0; i < [self.delegate numberOfFieldsInDigitView]; i++)
    {
        if (![self checkFieldLimit: i])
        {
            return i;
        }
    }
    return 0;
}

- (void)showLimitErrorForIndex:(NSInteger)index
{
    UIView * border = [[fields objectAtIndex: index] viewWithTag: -1];
    border.alpha = 0.2;
    [UIView beginAnimations: nil context: fieldErrorView];
    [UIView setAnimationRepeatCount: 2.5];
    [UIView setAnimationDuration: 0.5];
    [UIView setAnimationRepeatAutoreverses: YES];
    border.alpha = 1;
    [UIView commitAnimations];
    
    self.selectedField = index;
    
    limitError = YES;
}

- (void)showFirstLimitError
{
    NSInteger index = [self nextFieldWithError];
    [self showLimitErrorForIndex: index];
}



- (void)hideLimitError
{
    limitError = NO;
    fieldErrorView.alpha = 0;
    for (UIView * field in fields) 
    {
        UIView * border = [field viewWithTag: -1];
        border.alpha = 0;
    }
    fieldTitleView.alpha = 1;
    redCarrotView.alpha = 0;
    redHeaderView.alpha = 0;
}

- (void)setSelectedField:(NSInteger)selectedField animated:(BOOL)animated
{
    if (selectedField == _selectedField)
    {
        fireDelegate = NO;
        return;
    }
    
    if (limitError)
    {
        [self hideLimitError];
    }
    
    _selectedField = selectedField;

    
    fieldTitleView.text = [self.delegate digitsView: self promptForFieldAtIndex: selectedField];
    
    [UIView animateWithDuration: (animated ? 0.25 : 0) animations:^{
        [self layoutSubviews];
    }];
    
    if (fireDelegate)
    {
        fireDelegate = NO;
        [self.delegate digitsViewFieldChanged: self];
    }
}

- (void)setSelectedField:(NSInteger)selectedField
{
    [self setSelectedField: selectedField animated: NO];
}

- (void)buttonClicked:(UIButton *)btn
{
    NSInteger btnIndex = [buttons indexOfObject: btn];
    
    if (btnIndex == 11 && [fields count] > 1)
    {
        NSInteger newSelectedField = self.selectedField + 1;
        if (newSelectedField >= [fields count])
        {
            [self.delegate digitsViewTryToGoNext: self];
        }
        else
        {
            if ([self checkFieldLimit: self.selectedField])
            {
                fireDelegate = YES;
                [self setSelectedField: newSelectedField animated: YES];
            }
            else
            {
                [self.delegate digitsViewTryToGoNext: self];
            }
        }
        
    }
    else
    {
        UIButton * field = [fields objectAtIndex: self.selectedField];
        NSString * oldText = [field titleForState: UIControlStateNormal];
        if (!oldText) 
        {
            oldText = @"";
        }
        NSString * newText = oldText;
        
        if (btnIndex == 9)
        {
            if ([oldText length] > 1)
            {
                newText = [oldText substringToIndex: [oldText length] - 1];
            }
            else
            {
                newText = @"0";
            }
        }
        else if (btnIndex == 11)
        {
            newText = @"0";
        }
        else 
        {
            if ([oldText length] < 4)
            {
                NSString * toAppend = nil;
                if (btnIndex == 10) 
                {
                    toAppend = @"0";
                }
                else
                {
                    toAppend = [NSString stringWithFormat: @"%d", btnIndex+1];
                }
                
                if ([oldText isEqualToString: @"0"] || [oldText isEqualToString: @"—"])
                {
                    newText = toAppend;
                }
                else
                {
                    newText = [oldText stringByAppendingString: toAppend];
                }
            }
        }
        
        if (![newText isEqualToString: oldText]) 
        {
            fireDelegate = YES;
            
            [self setValue: newText forFieldAtIndex: self.selectedField];
            
            if (limitError)
            {
                [self hideLimitError];
            }
        }
    }
}

- (void)fieldClicked:(UIButton *)btn
{
    NSInteger newIndex = [fields indexOfObject: btn];
    if (newIndex != self.selectedField)
    {
        
        if ([self checkFieldLimit: self.selectedField] || [self checkFieldLimit: newIndex])
        {
            fireDelegate = YES;
            [self setSelectedField: newIndex animated: YES];
        }
        else
        {
            if (![self checkFieldLimit: self.selectedField]) 
            {
                [self showLimitErrorForIndex: self.selectedField];
            }
            else if (![self checkFieldLimit: newIndex])
            {
                [self showLimitErrorForIndex: newIndex];
            }
        }
    }
}

- (void)setValue:(NSString *) value forFieldAtIndex:(NSInteger)index
{
    UIButton * field = [fields objectAtIndex: index];
    [field setTitle: value forState: UIControlStateNormal];
    
    if (fireDelegate)
    {
        fireDelegate = NO;
        [self.delegate digitsView: self fieldValueChangedAtIndex: index];
    }
}

- (NSString *)valueForFieldAtIndex:(NSInteger)index
{
    UIButton * field = [fields objectAtIndex: index];
    return [field titleForState: UIControlStateNormal];
}

@end
