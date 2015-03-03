#import "RecordCell.h"
#import <QuartzCore/QuartzCore.h>

@interface RecordCell ()
- (void)updateWithRecord:(COPDRecord *)record;
@end

@implementation RecordCell
@synthesize scoreView = _scoreView,scoreHolderView = _scoreHolderView, dateView = _dateView, statusView = _statusView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _scoreHolderView = [[[UIView alloc] initWithFrame: CGRectZero] autorelease];
        self.scoreHolderView.layer.cornerRadius = 5;
        [self.contentView addSubview: self.scoreHolderView];
        
        _scoreView = [[[UILabel alloc] initWithFrame: CGRectZero] autorelease];
        self.scoreView.backgroundColor = [UIColor clearColor];
        self.scoreView.textColor = [UIColor whiteColor];
        self.scoreView.textAlignment = UITextAlignmentCenter;
        self.scoreView.font = [UIFont systemFontOfSize: 14];
        [self.scoreHolderView addSubview: self.scoreView];
        
        _dateView = [[[UILabel alloc] initWithFrame: CGRectZero] autorelease];
        self.dateView.backgroundColor = [UIColor clearColor];
        self.dateView.textAlignment = UITextAlignmentLeft;
        self.dateView.font = [UIFont boldSystemFontOfSize: 15];
        [self.contentView addSubview: self.dateView];
        
        _statusView = [[[UILabel alloc] initWithFrame: CGRectZero] autorelease];
        self.statusView.backgroundColor = [UIColor clearColor];
        self.statusView.textAlignment = UITextAlignmentLeft;
        self.statusView.font = [UIFont systemFontOfSize: 13];
        [self.contentView addSubview: self.statusView];
    }
    return self;
}

- (void)makeLabelsWhite:(BOOL)white
{
    if (white)
    {
        self.dateView.textColor = [UIColor whiteColor];
        self.statusView.textColor = [UIColor whiteColor];
    }
    else
    {
        self.dateView.textColor = [UIColor blackColor];
        self.statusView.textColor = [UIColor grayColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    UIColor * color = [[self.scoreHolderView.backgroundColor retain] autorelease];
    [super setSelected:selected animated:animated];
    [self makeLabelsWhite: selected];
    self.scoreHolderView.backgroundColor = color;
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    UIColor * color = [[self.scoreHolderView.backgroundColor retain] autorelease];
    [super setHighlighted: highlighted animated: animated];
    
    if (self.selectionStyle != UITableViewCellSelectionStyleNone)
    {
        [self makeLabelsWhite: highlighted];
    }
    self.scoreHolderView.backgroundColor = color;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = self.contentView.frame.size.width;
    CGFloat h = self.contentView.frame.size.height;
    CGFloat sw = 30;
    CGFloat sh = 30;
    CGFloat padding = 7;
    self.scoreHolderView.frame = CGRectMake( padding, (h - sh)/2, sw, sh);
    self.scoreView.frame = self.scoreHolderView.bounds;
    
    self.dateView.frame = CGRectMake(padding + sw + padding + 3, 4, w - padding*3 - sw, 18);
    self.statusView.frame = CGRectMake(padding + sw + padding + 3, 22, w - padding*3 - sw, 15);
}




- (void)updateWithRecordForHistory:(COPDRecord *)record
{
    [self updateWithRecord: record];
    
    self.scoreHolderView.alpha = 1;
    if (record.reportStatus == ReportStatusUserAcknowledged)
    {
        self.statusView.text = @"Response received";
    }
    else if (record.reportStatus == ReportStatusSentToPatient)
    {
        self.statusView.text = @"NEW. Response received";
        
        [UIView animateWithDuration: 0.5 delay: 0 options: UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
            self.scoreHolderView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        self.statusView.text = @"Awaiting response from nurse";
    }

    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}


- (void)updateWithRecord:(COPDRecord *)record
{
    NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle: NSDateFormatterLongStyle];
    [formatter setTimeStyle: NSDateFormatterShortStyle];
    self.dateView.text = [formatter stringFromDate: record.date];
    
    int level = [record level];
    
    UIColor * color = nil;
    
    if (level == 0)
    {
        color = [UIColor colorWithRed: 0.31 green: 0.63 blue: 0.32 alpha: 1]; 
    }
    else if (level == 1)
    {
        color = [UIColor colorWithRed: 0.71 green: 0.54 blue: 0.17 alpha: 1]; 
    }
    else if (level == 2)
    {
        color = [UIColor colorWithRed: 0.70 green: 0.32 blue: 0.15 alpha: 1];
    }
    else if (level == 3)
    {
        color = [UIColor colorWithRed: 0.72 green: 0.125 blue: 0.145 alpha: 1];
    }
    
    self.scoreHolderView.backgroundColor = color;
    //self.scoreView.text = [NSString stringWithFormat: @"%.1f", record.score];
}

- (void)updateWithRecordForReport:(COPDRecord *)record
{
    [self updateWithRecord: record];
    NSString * levelText = nil;
    int level = [record level];
    if (level == 0)
    {
        levelText = @"Normal";
    }
    else if (level == 1)
    {
        levelText = @"Mild";
    }
    else if (level == 2)
    {
        levelText = @"Moderate";
    }
    else if (level == 3)
    {
        levelText = @"Severe";
    }
    
    self.statusView.text = levelText;
}

@end
