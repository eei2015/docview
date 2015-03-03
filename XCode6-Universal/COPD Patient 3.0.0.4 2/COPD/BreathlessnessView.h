#import <UIKit/UIKit.h>

@class BreathlessnessView;

@protocol BreathlessnessViewDelegate <NSObject>

- (void)breathlessnessViewValueChanged:(BreathlessnessView *)breathlessnessView;

@end

@interface BreathlessnessView : UIView
{
    NSMutableArray * buttons;
}


@property (nonatomic, assign) id<BreathlessnessViewDelegate> delegate;
@property (nonatomic, assign) NSInteger value;

@end
