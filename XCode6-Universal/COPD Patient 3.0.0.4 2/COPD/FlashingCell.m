#import "FlashingCell.h"

#import <QuartzCore/QuartzCore.h>


@interface FlashingCell (PrivateMethods)
- (void)flash:(id)object;
@end

@implementation FlashingCell

@synthesize flashingLabel, buttonImage, flashingBackground;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self)
	{
		self.clipsToBounds = YES;

		//self.flashingBackground = [[[UIView alloc] initWithFrame:CGRectMake(0, -100, self.contentView.bounds.size.width - 20, self.contentView.bounds.size.height + 100)] autorelease];
        
        NSLog(@"w %f",self.contentView.bounds.size.width);
        NSLog(@"h %f",self.contentView.bounds.size.height);
        
       // self.flashingBackground = [[[UIView alloc] initWithFrame:CGRectMake(-1,0,564 ,80 )] autorelease];
		self.flashingBackground = [[[UIView alloc] initWithFrame:CGRectMake(-1, 0, self.contentView.bounds.size.width +244, self.contentView.bounds.size.height + 36)] autorelease];
        NSLog(@"w %f",self.contentView.bounds.size.width);
        NSLog(@"h %f",self.contentView.bounds.size.height);
        
		CALayer *layer = [self.flashingBackground layer];
		layer.masksToBounds = YES;
		layer.cornerRadius = 8.0f;
		//2014-09-03 Vipul Change Background color
		//self.flashingBackground.backgroundColor = [UIColor colorWithRed:116.0/255 green:204.0/255 blue:235.0/255 alpha:0.7];
        self.flashingBackground.backgroundColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0.2];
        //2014-09-03 Vipul Change Background color

		[self.contentView addSubview:self.flashingBackground];

		self.buttonImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button-action@2x.png"]] autorelease];
		//self.buttonImage.frame = CGRectMake(20, 3, self.contentView.bounds.size.width - 20 - 40, self.contentView.bounds.size.height - 6);
        self.buttonImage.frame = CGRectMake(40, 6, 564 - 40 - 40, 80 - 6);
		[self.contentView addSubview:self.buttonImage];

		//self.flashingLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width - 20, self.contentView.bounds.size.height - 3)] autorelease];
        self.flashingLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 564, 80- 3)] autorelease];
		self.flashingLabel.text = @"Acknowledge Instructions";
		[self.flashingLabel setTextAlignment:UITextAlignmentCenter];
		[self.flashingLabel setFont:[UIFont boldSystemFontOfSize:30]];// 15 - Jatin Chauhan 29-Nov-2013
		[self.flashingLabel setTextColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
		self.flashingLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:self.flashingLabel];

		[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(flash:) userInfo:nil repeats:NO];
	}
	return self;
}

- (void)dealloc
{
	self.flashingBackground = nil;
	self.buttonImage = nil;
	self.flashingLabel = nil;
	[super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
}

- (void)flash:(id)object
{
	[UIView animateWithDuration:1.0 delay:1.0 options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse) animations:^
	{
		[self.flashingBackground setAlpha:0.0];
	}
	completion:nil];
}

@end
