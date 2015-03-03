#import <UIKit/UIKit.h>

@class YesNoSwitch;

typedef enum {
    YesNoSwitchStyleSmall,
    YesNoSwitchStyleLarge
} YesNoSwitchStyle;

@protocol YesNoSwitchDelegate <NSObject>

- (void)yesNoSwitchWasToggled:(YesNoSwitch *)yesNoSwitch;

@end

@interface YesNoSwitch : UIView
{
    UIImageView * toddler;
    CGFloat oldX;
    CGFloat dX;
    UIScrollView * scrollView;
    
    UILabel * yesLabel;
    UILabel * noLabel;
    
    UILabel * yesToddlerLabel;
    UILabel * noToddleLabel;
    YesNoSwitchStyle style;
    UIView * toddlerPlaceholder;
    BOOL allowNext;
}


- (id)initWithStyle:(YesNoSwitchStyle)style;

@property (nonatomic, assign) id<YesNoSwitchDelegate> delegate;
@property (nonatomic, assign) BOOL yes;

- (void)setYes:(BOOL)yes animated:(BOOL)animated;
- (void)wobble;

@end
