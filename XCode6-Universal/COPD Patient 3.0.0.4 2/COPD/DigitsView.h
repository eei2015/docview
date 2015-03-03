#import <UIKit/UIKit.h>

@class DigitsView;

@protocol DigitsViewDelegate <NSObject>

- (NSInteger)numberOfFieldsInDigitView;
- (void)digitsView:(DigitsView *)digitsView fieldValueChangedAtIndex:(NSInteger )index;
- (NSString *)digitsView:(DigitsView *)digitsView promptForFieldAtIndex:(NSInteger )index;
- (void)digitsViewFieldChanged:(DigitsView *)digitsView;
- (void)digitsViewTryToGoNext:(DigitsView *)digitsView;
- (BOOL)digitsViewShouldHaveDivider:(DigitsView *)digitsView;
- (BOOL)digitsView:(DigitsView *)digitsView valueIsValidAtIndex:(NSInteger )index;
@optional
- (UIView *)fieldsDividerViewForDigitsView:(DigitsView *)digitsView;

@end

@interface DigitsView : UIView
{
    NSMutableArray * fields;
    NSMutableArray * buttons;
    
    NSMutableArray * fieldDividers;
    
    UIImageView * carrotView;
    UIImageView * redCarrotView;
    UIImageView * headerView;
    UIImageView * redHeaderView;
    UILabel * fieldTitleView;
    UILabel * fieldErrorView;
    BOOL fireDelegate;
    BOOL limitError;
}

@property (nonatomic, assign) id<DigitsViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedField;

- (id)initWithFrame:(CGRect)frame delegate:(id<DigitsViewDelegate>) delegate;

- (void)setSelectedField:(NSInteger)selectedField animated:(BOOL)animated;
- (void)showFirstLimitError;
- (void)setValue:(NSString *) value forFieldAtIndex:(NSInteger)index;
- (NSString *)valueForFieldAtIndex:(NSInteger)index;

@end
