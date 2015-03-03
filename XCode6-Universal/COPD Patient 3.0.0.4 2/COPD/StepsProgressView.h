#import <UIKit/UIKit.h>

@interface StepsProgressView : UIView
{
    UIImageView * currImageView;
    UIImageView * prevImageView;

	NSInteger cellsNumber;
}

@property (nonatomic, assign) NSInteger currentStep;

- (void)setCurrentStep:(int)currentStep animated:(BOOL)animated;
- (void)setCellsNumber:(NSInteger)numbeOfCells;

@end
