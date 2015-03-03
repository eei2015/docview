#import "MoodCell.h"
#import "MoodView.h"

@implementation MoodCell
@synthesize moodView = _moodView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundView = [[[UIView alloc] initWithFrame: CGRectZero] autorelease];
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame: CGRectZero] autorelease];
        
        _moodView = [[[MoodView alloc] initWithFrame: CGRectZero] autorelease];
        [self.contentView addSubview: self.moodView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds; 
    self.backgroundView.frame = self.bounds;
    self.selectedBackgroundView.frame = self.bounds;
    _moodView.frame = CGRectMake(20, (self.frame.size.height - 58)/2, 280, 58);
}

@end
