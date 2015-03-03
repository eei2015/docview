#import "MedicationCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MedicationCell
@synthesize delegate;

- (UIButton *)createButton
{
    UIButton * btn = [UIButton buttonWithType: UIButtonTypeCustom];
    [btn setBackgroundImage: [UIImage imageNamed: @"cell-button.png"] forState: UIControlStateNormal];
    [btn setBackgroundImage: [UIImage imageNamed: @"cell-button-active.png"] forState: UIControlStateHighlighted];
    [btn setTitleColor: [UIColor darkGrayColor] forState: UIControlStateNormal];
    [btn setTitleColor: [UIColor whiteColor] forState: UIControlStateHighlighted];              
    [btn addTarget: self action: @selector(btnClicked:) forControlEvents: UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize: 22];// 11 - Jatin Chauhan 28-Nov-2013
    btn.titleLabel.numberOfLines = 2;
    btn.titleLabel.textAlignment = UITextAlignmentCenter;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 2);
    [self.contentView addSubview: btn];
    return btn;
}



- (UIView *)createSeparator
{
    UIView * sep = [[[UIView alloc] initWithFrame: CGRectZero] autorelease];
    sep.backgroundColor = [UIColor colorWithWhite: 0.792 alpha: 1];
    [self.contentView addSubview: sep];
    return sep;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier hasDuration:(BOOL)hd
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        medicationButton = [self createButton];
        dosageButton = [self createButton];
        freqButton = [self createButton];
        hasDuration = hd;
        
        if (hasDuration)
        {
            durationButton = [self createButton];
        }
        
        
        sep1 = [self createSeparator];
        sep2 = [self createSeparator];
        sep3 = [self createSeparator];
        sep4 = [self createSeparator];
        
        if (hasDuration) 
        {
            sep5 = [self createSeparator];
            sep5.alpha = 0;
        }
        else
        {
            sep4.alpha = 0;
        }
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    CGFloat cellPadding = 16;
//    self.backgroundView.frame = CGRectMake(cellPadding, 0, self.frame.size.width - cellPadding*2, self.frame.size.height);
//    
//    CGFloat editingPadding = (self.editing ? 32 : 0);
//    self.contentView.frame = CGRectMake(cellPadding + 1 + editingPadding, 0, self.frame.size.width - cellPadding*2 - 2 - editingPadding, self.frame.size.height - 1);
    
    CGFloat w = self.contentView.frame.size.width;
    CGFloat h = self.contentView.frame.size.height;
    CGFloat padding = 8;
    sep1.alpha = 1;
    if (!self.editing)
    {
        padding = 0;
        sep1.alpha = 0;
    }
    
    CGFloat firstWidth = (w - padding)*0.4;
    
    CGFloat btnWidth = roundf((w - padding - firstWidth)/(hasDuration ? 3.0f : 2.0f));
    
    medicationButton.frame = CGRectMake(padding, 0, firstWidth, h);
    dosageButton.frame = CGRectMake(padding + firstWidth, 0, btnWidth, h);
    
    if (hasDuration)
    {
        freqButton.frame = CGRectMake(padding + btnWidth + firstWidth, 0, btnWidth, h);
        CGFloat x =padding + 2.0f*btnWidth + firstWidth;
        durationButton.frame = CGRectMake(x, 0, w - x , h);
    }
    else
    {
        CGFloat x =padding + btnWidth + firstWidth;
        freqButton.frame = CGRectMake(x, 0, w - x , h);
    }

    
    sep1.frame = CGRectMake(padding, 0, 1, h);
    sep2.frame = CGRectMake(padding + firstWidth, 0, 1, h);
    sep3.frame = CGRectMake(padding + firstWidth + btnWidth, 0, 1, h);
    sep4.frame = CGRectMake(padding + firstWidth + btnWidth*2, 0, 1, h);
    
    if (hasDuration)
    {
        sep5.frame = CGRectMake(padding + firstWidth + btnWidth*3, 0, 1, h);
    }
    
    
    medicationButton.userInteractionEnabled = self.editing;
    dosageButton.userInteractionEnabled = self.editing;
    freqButton.userInteractionEnabled = self.editing;
    durationButton.userInteractionEnabled = self.editing;
    
    if (self.editing)
    {
        [medicationButton setBackgroundImage: [UIImage imageNamed: @"cell-button.png"] forState: UIControlStateNormal];
        [dosageButton setBackgroundImage: [UIImage imageNamed: @"cell-button.png"] forState: UIControlStateNormal];
        [freqButton setBackgroundImage: [UIImage imageNamed: @"cell-button.png"] forState: UIControlStateNormal];
        [durationButton setBackgroundImage: [UIImage imageNamed: @"cell-button.png"] forState:UIControlStateNormal];
    }
    else
    {
        [medicationButton setBackgroundImage: nil forState: UIControlStateNormal];
        [dosageButton setBackgroundImage: nil forState: UIControlStateNormal];
        [freqButton setBackgroundImage: nil forState: UIControlStateNormal];
        [durationButton setBackgroundImage: nil forState: UIControlStateNormal];
    }
}

- (void)btnClicked:(UIButton *)btn
{
    if (btn == medicationButton)
    {
        [delegate medicationClickedInCell: self button: btn];
    }
    else if (btn == dosageButton)
    {
        [delegate dosageClickedInCell: self button: btn];
    }
    else if (btn == freqButton)
    {
        [delegate frequenceClickedInCell: self button: btn];
    }
    else
    {
        [delegate durationClickedInCell: self button: btn];
    }
}

- (void)checkTitleForDash:(UIButton *)btn
{
    if ([[btn titleForState: UIControlStateNormal] isEqualToString: @"–"])
    {
        [btn setContentHorizontalAlignment: UIControlContentHorizontalAlignmentCenter];
    }
    else
    {
        [btn setContentHorizontalAlignment: UIControlContentHorizontalAlignmentLeft];
    }
}

- (void)updateWithMedication:(NSString *)medication dosage:(NSString *)dosage frequency:(NSString *)frequency duration:(NSString *)duration
{
    [medicationButton setTitle: medication forState: UIControlStateNormal];
    [dosageButton setTitle: dosage forState: UIControlStateNormal];
    [freqButton setTitle: frequency forState: UIControlStateNormal];
    [durationButton setTitle: duration forState: UIControlStateNormal];
    
    //[self checkTitleForDash: medicationButton];
    
}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState: state];
    if (state & UITableViewCellStateShowingDeleteConfirmationMask) 
    {
        if (hasDuration)
        {
            sep5.alpha = 1;
        }
        else
        {
            sep4.alpha = 1;
        }
    }
}

- (void)didTransitionToState:(UITableViewCellStateMask)state
{
    if (!(state & UITableViewCellStateShowingDeleteConfirmationMask)) 
    {
        if (hasDuration)
        {
            sep5.alpha = 0;
        }
        else
        {
            sep4.alpha = 0;
        }
        
    }
}

@end
