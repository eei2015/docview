#import <UIKit/UIKit.h>

@interface SimpleAnswerCell : UITableViewCell

@property (nonatomic, readonly) UISegmentedControl * segmentedControl;

-(id)initWithStyleWithOptions:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  Options:(NSMutableArray*)options;

@end
