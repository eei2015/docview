#import <UIKit/UIKit.h>


@protocol LayoutViewDelegate <NSObject>

- (void)layoutSubviewsInView:(UIView *)view;

@end

@interface LayoutView : UIView 
{
    id<LayoutViewDelegate> layoutViewDelegate;
}

@property (nonatomic, assign)  id<LayoutViewDelegate> layoutViewDelegate;

@end
