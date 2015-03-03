#import <UIKit/UIKit.h>

@class PivotView;
@class PivotViewCell;

@protocol PivotViewDelegate<NSObject>

@required
- (NSInteger)numberOfColumnsInPivotView:(PivotView *)pivotView;
- (PivotViewCell *)pivotView:(PivotView *)pivotView  cellForColumnAtIndex:(NSInteger)index;

@optional
- (CGFloat)widthOfColumnInPivotView:(PivotView *)pivotView;
- (void)pivotViewDidScroll:(PivotView *)pivotView;
- (void)pivotViewVisiblePageChanged:(PivotView *)pivotView;

- (NSInteger)firstVisibleCellInPivotView:(PivotView *)pivotView;
- (NSInteger)lastVisibleCellInPivotView:(PivotView *)pivotView;
- (void)pivotViewWillEndDragging:(PivotView *)pivotView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;

@end


@interface PivotView : UIView
{
    UIScrollView * contentScrollView;
    UIView * contentView;
    NSMutableArray * visibleCells;
    NSMutableArray * reusableCells;
    NSInteger initialCellIndex;
    BOOL initialLayoutOccured;
    
    CGRect oldFrame;
}

@property (nonatomic, assign) id<PivotViewDelegate> delegate;
@property (nonatomic, assign) BOOL showsScrollIndicator;
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, assign) BOOL scrollEnabled;
@property (nonatomic, assign) CGFloat rightMargin;
@property (nonatomic, assign) CGPoint contentOffset;

- (id)dequeueReusableCellWithIdentifier:(NSString *)reuseIdentifier;
- (void)reloadData;
- (void)scrollToCellAtIndex:(NSInteger)index animated:(BOOL)animated;
- (id)cellAtIndex:(NSInteger)index;
- (UIScrollView *)scrollView;
- (NSArray *)visibleCells;
- (void)deleteCellAtIndex:(NSInteger)index animated:(BOOL)animated;


@property (nonatomic, assign) BOOL pagingEnabled;
@property (nonatomic, readonly) NSInteger visiblePageIndex;

@end


@interface PivotViewCell : UIView
{
    NSString * _reuseIdentifier;
    NSInteger _index;
}

@property (nonatomic, readonly) NSString * reuseIdentifier;
@property (nonatomic, assign) NSInteger index;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end


