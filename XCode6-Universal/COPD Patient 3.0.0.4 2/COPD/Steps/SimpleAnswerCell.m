#import "SimpleAnswerCell.h"
#import "Content.h"
@implementation SimpleAnswerCell
@synthesize segmentedControl = _segmentedControl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundView = [[[UIView alloc] initWithFrame: CGRectZero] autorelease];
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame: CGRectZero] autorelease];
        
        _segmentedControl = [[[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObjects: @"YES", @"NO", nil]] autorelease];
        
        [self.contentView addSubview: self.segmentedControl];
    }
    return self;
}
- (id)initWithStyleWithOptions:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Options:(NSMutableArray *)options
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundView = [[[UIView alloc] initWithFrame: CGRectZero] autorelease];
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame: CGRectZero] autorelease];
        
        NSMutableArray *arrItems=[NSMutableArray array];
        for (int i=0; i<[options count]; i++) {
            QuestionOptions *opt=(QuestionOptions*)[options objectAtIndex:i];
            [arrItems addObject:opt.qOptionTitle];
            
        }
        
        //NSLog(@"Items: %@",arrItems);
        _segmentedControl = [[[UISegmentedControl alloc] initWithItems: arrItems] autorelease];
        [self.contentView addSubview: self.segmentedControl];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds; 
    self.backgroundView.frame = self.bounds;
    self.selectedBackgroundView.frame = self.bounds;
    
    [self.segmentedControl sizeToFit];
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    CGFloat bw = 600; // 300 - Jatin Chauhan 26-Nov-2013
    CGFloat bh = 55;  // 34 - Jatin Chauhan 26-Nov-2013
    
    self.segmentedControl.frame =  CGRectMake(roundf((w - bw)/2), roundf((h - bh)/2), bw, bh);
    
    
    // Jatin Chauhan 27-Nov-2013
 
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:30], UITextAttributeFont, nil];
    [self.segmentedControl setTitleTextAttributes:textAttributes forState:UIControlStateNormal];

    
    // -Jatin Chauhan 27-Nov-2013

    
}

@end
