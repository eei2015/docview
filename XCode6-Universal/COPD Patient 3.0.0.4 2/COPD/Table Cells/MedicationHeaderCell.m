#import "MedicationHeaderCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MedicationHeaderCell
@synthesize simpleHeader;

- (UILabel *)createLabelWithTitle:(NSString *)title
{
    UILabel * label = [[[UILabel alloc] initWithFrame: CGRectZero] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize: 26];// 13 - Jatin Chauhan 28-Nov-2013
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = title;
    [self.contentView addSubview: label];
    return label;
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
        hasDuration = hd;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        medicationLabel = [self createLabelWithTitle: @"Medication"];
        dosageLabel= [self createLabelWithTitle: @"Dosage"];
        freqLabel = [self createLabelWithTitle: @"Frequency"];
        durationLabel = [self createLabelWithTitle: @"Duration"];
        
        if (hasDuration)
        {
            durationLabel.layer.borderWidth = 0;
            durationLabel.backgroundColor = [UIColor clearColor];
        }
        else
        {
            freqLabel.layer.borderWidth = 0;
            freqLabel.backgroundColor = [UIColor clearColor]; 
        }
        
        sep1 = [self createSeparator];
        sep2 = [self createSeparator];
        sep3 = [self createSeparator];
        if (hasDuration)
        {
            sep4 = [self createSeparator];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat w = self.contentView.frame.size.width;
    CGFloat h = self.contentView.frame.size.height + 2;
    CGFloat padding = 40;
    sep1.alpha = 1;
    if (self.simpleHeader)
    {
        padding = 0;
        sep1.alpha = 0;
    }
    
    CGFloat firstWidth = (w - padding)*0.4;
    CGFloat btnWidth = roundf((w - padding - firstWidth)/(hasDuration ? 3.0f : 2.0f));
    
    medicationLabel.frame = CGRectMake(padding, 0, firstWidth, h);
    dosageLabel.frame = CGRectMake(padding + firstWidth, 0, btnWidth, h);
    
    if (hasDuration)
    {
        freqLabel.frame = CGRectMake(padding + btnWidth + firstWidth, 0, btnWidth, h);
        CGFloat x = padding + 2.0f*btnWidth + firstWidth;
        durationLabel.frame = CGRectMake(x, 0, w - x , h);
    }
    else
    {
        CGFloat x =padding + btnWidth + firstWidth;
        freqLabel.frame = CGRectMake(x, 0, w - x , h);
    }

    
    sep1.frame = CGRectMake(padding, 0, 1, h);
    sep2.frame = CGRectMake(padding + firstWidth, 0, 1, h);
    sep3.frame = CGRectMake(padding + btnWidth + firstWidth, 0, 1, h);
    sep4.frame = CGRectMake(padding + btnWidth*2 + firstWidth, 0, 1, h);
}

@end
