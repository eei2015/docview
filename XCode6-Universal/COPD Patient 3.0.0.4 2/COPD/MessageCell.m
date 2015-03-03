#import "MessageCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        bodyFrame = [[[UIView alloc] initWithFrame: CGRectZero] autorelease];
        bodyFrame.layer.borderColor = [UIColor colorWithRed: 0.676 green: 0.684 blue: 0.686 alpha: 1].CGColor;
        bodyFrame.layer.borderWidth = 1;
        bodyFrame.layer.cornerRadius = 11;
        [self.contentView addSubview: bodyFrame];
        
        bodyLabel = [[[UILabel alloc] initWithFrame: CGRectZero] autorelease];
        bodyLabel.backgroundColor = [UIColor clearColor];
        bodyLabel.font = [UIFont systemFontOfSize: 28];//14
        bodyLabel.numberOfLines = 0;
        bodyLabel.shadowColor = [UIColor colorWithWhite: 1 alpha: 0.5];
        bodyLabel.shadowOffset = CGSizeMake(1, 1);
        [self.contentView addSubview: bodyLabel];
        
        statusLabel = [[[UILabel alloc] initWithFrame: CGRectZero] autorelease];
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.font = [UIFont boldSystemFontOfSize: 24];
        statusLabel.textAlignment = UITextAlignmentRight;
        statusLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview: statusLabel];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = self.contentView.frame.size.width;
    CGFloat h = self.contentView.frame.size.height;
    
    CGFloat sh = 40;//20
    CGFloat spad = 10;//5
    CGFloat pad = 20;//10 - Jatin Chauhan 28-Nov-2013
    
    bodyFrame.frame = CGRectMake(pad, spad, w - pad*2, h - sh - spad*3);
    
    
    
    bodyLabel.frame = CGRectInset(bodyFrame.frame, pad, pad);
    statusLabel.frame = CGRectMake(pad, h - sh - spad*2, w - pad*2, sh+20); // spad*2 added by Jatin Chauhan 28-Nov-2013
}

- (void)updateWithBody:(NSString *)body status:(NSString *)status highlighted:(BOOL)highlighted
{
    bodyLabel.text = body;
    statusLabel.text = status;
    
    if (highlighted)
    {
        bodyFrame.backgroundColor = [UIColor colorWithRed:(0xD1 / 255.0) green:(0xF2 / 255.0) blue:(0xA5 / 255.0) alpha:1.0];
    }
    else
    {
        bodyFrame.backgroundColor = [UIColor colorWithWhite: 0.96 alpha: 1];
    }
}


@end
