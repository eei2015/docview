#import <UIKit/UIKit.h>


@interface FlashingCell : UITableViewCell
{
	UILabel *flashingLabel;
	UIImageView *buttonImage;
	UIView *flashingBackground;
}

@property(nonatomic, retain) UILabel *flashingLabel;
@property(nonatomic, retain) UIImageView *buttonImage;
@property(nonatomic, retain) UIView *flashingBackground;

@end
