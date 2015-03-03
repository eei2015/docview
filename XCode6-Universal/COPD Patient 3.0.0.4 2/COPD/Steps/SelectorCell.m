#import "SelectorCell.h"

@implementation SelectorCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier: reuseIdentifier];
    if (self) 
    {
        UIImageView * bgView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"grey.png"]] autorelease];
        [self addSubview: bgView];
        
        label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        label.font = [UIFont systemFontOfSize:32];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.shadowColor = [UIColor colorWithWhite: 1.0 alpha: 0.5];
        label.shadowOffset = CGSizeMake(1, 1);
        label.numberOfLines = 0;
        label.textAlignment = UITextAlignmentCenter;
        
        [self addSubview: label];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    label.text = title;
}

- (NSString *)title
{
    return label.text;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    label.frame = self.bounds;
}

@end
