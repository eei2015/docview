#import <UIKit/UIKit.h>

@class MoodView;

@protocol MoodViewDelegate <NSObject>

- (void)moodViewDidChanged:(MoodView *)moodView;

@end

@interface MoodView : UIView
{
    NSMutableArray * smiles;
    NSMutableArray * indicators;
    CGRect oldFrame;
    BOOL initialLayout;
}

@property (nonatomic, assign) id<MoodViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedSmileIndex;

- (void)setSelectedSmileIndex:(NSInteger)selectedSmileIndex animated:(BOOL)animated;
-(id)initWithFrameWithOptions:(CGRect)frame Options:(NSMutableArray*)options;
@end
