#import "SelectorQuestionController.h"
#import "PivotView.h"
#import "SelectorCell.h"
#import <QuartzCore/QuartzCore.h>
#import "HitView.h"

NSString * const kSelectorViewController_KeyPath_Key = @"kSelectorViewController_KeyPath_Key";
NSString * const kSelectorViewController_Title_Key = @"kSelectorViewController_Title_Key";
NSString * const kSelectorViewController_RangeBegin_Key = @"kSelectorViewController_RangeBegin_Key";
NSString * const kSelectorViewController_RangeEnd_Key = @"kSelectorViewController_RangeEnd_Key";
NSString * const kSelectorViewController_Subtitle_Key = @"kSelectorViewController_Subtitle_Key";
NSString * const kSelectorViewController_HelpUrl_Key = @"kSelectorViewController_HelpUrl_Key";

@interface SelectorQuestionController () <PivotViewDelegate>



@end

@implementation SelectorQuestionController



- (NSInteger)beginRange
{
    return [[self.config objectForKey: kSelectorViewController_RangeBegin_Key] intValue];
}

- (NSInteger)endRange
{
    return [[self.config objectForKey: kSelectorViewController_RangeEnd_Key] intValue];
}

- (CGFloat)cellWidth
{
    return 62;
}

#pragma mark - overrides

- (NSString*)titleForHeaderAtSection:(NSInteger)section
{
    return [self.config objectForKey: kSelectorViewController_Title_Key];
}

- (NSString *)helpUrl
{
    return [self.config objectForKey: kSelectorViewController_HelpUrl_Key];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    HitView * hitView = [[[HitView alloc] initWithFrame: CGRectMake(0, 65, 320, 69)] autorelease];
    hitView.clipsToBounds = YES;
    
    selectorView = [[[PivotView alloc] initWithFrame: CGRectMake((320 - [self cellWidth])/2, 0, [self cellWidth], 69)] autorelease];
    selectorView.clipsToBounds = NO;
    selectorView.scrollView.clipsToBounds = NO;
    selectorView.scrollView.bounces = NO;
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(-1, 0)];
    [path addLineToPoint: CGPointMake(160-15, 0)];
    [path addLineToPoint: CGPointMake(160, 10)];
    [path addLineToPoint: CGPointMake(160+15, 0)];
    [path addLineToPoint: CGPointMake(160-15, 0)];
    [path addLineToPoint: CGPointMake(321, 0)];
    [path addLineToPoint: CGPointMake(321, 69)];
    [path addLineToPoint: CGPointMake(-1, 69)];
    [path addLineToPoint: CGPointMake(-1, 0)];
    
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    hitView.layer.mask = layer;
    hitView.backgroundColor = [UIColor lightGrayColor];
    
    
    [hitView addSubview: selectorView];
    
    UITapGestureRecognizer * tgr = [[[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTap:)] autorelease];
    [hitView addGestureRecognizer: tgr];
    
    currentIndex = [[self.record valueForKey: [self.config objectForKey: kSelectorViewController_KeyPath_Key]] intValue] - [self beginRange];
    
    [selectorView scrollToCellAtIndex: currentIndex  animated: NO]; 
    selectorView.delegate = self;
    hitView.view = selectorView.scrollView;
    [self.view addSubview: hitView];
    
    layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    [hitView.layer addSublayer: layer];
    
    UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 50)] autorelease];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:(0xB3 / 255.0) green:(0xB3 / 255.0) blue:(0xB3 / 255.0) alpha:1.0];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.text = [self.config objectForKey: kSelectorViewController_Subtitle_Key];
    label.numberOfLines = 0;
    
    UIView* v = [[[UIView alloc] initWithFrame:CGRectMake(0, 135, 320, 50)] autorelease];
    [v addSubview:  label];
    
    [self.view addSubview: v];
}

- (void)pivotViewDidScroll:(PivotView *)pivotView
{
    NSInteger index = (pivotView.contentOffset.x + [self cellWidth]*0.5)/[self cellWidth];
    if (currentIndex != index)
    {
        currentIndex = index;
        NSInteger begin = [[self.config objectForKey: kSelectorViewController_RangeBegin_Key] intValue];
        [self.record setValue: [NSNumber numberWithInt: (begin + index)] forKey: [self.config objectForKey: kSelectorViewController_KeyPath_Key]];
        
        [[Content shared] playSound: @"click.wav"];
    }
}

- (NSInteger)numberOfColumnsInPivotView:(PivotView *)pivotView
{
    return [self endRange] - [self beginRange];
}

- (PivotViewCell *)pivotView:(PivotView *)pivotView cellForColumnAtIndex:(NSInteger)index
{
    static NSString *CellIdentifier = @"Cell"; 
    SelectorCell * cell = [pivotView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (!cell)
    {
        cell = [[[SelectorCell alloc] initWithReuseIdentifier: CellIdentifier] autorelease];
        
        
    }
    cell.title = [NSString stringWithFormat: @"%d", [self beginRange] + index];
    return cell;
}

- (CGFloat)widthOfColumnInPivotView:(PivotView *)pivotView
{
    return [self cellWidth];
}

- (NSInteger)firstVisibleCellInPivotView:(PivotView *)pivotView
{
    return pivotView.scrollView.contentOffset.x/[self cellWidth] - 3;
}

- (NSInteger)lastVisibleCellInPivotView:(PivotView *)pivotView
{
    return ((pivotView.scrollView.contentOffset.x + pivotView.scrollView.frame.size.width)/[self cellWidth]) + 3;
}

- (void)pivotViewWillEndDragging:(PivotView *)pivotView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    targetContentOffset->x = roundf(targetContentOffset->x/[self cellWidth])* [self cellWidth];
}

- (void)handleTap:(UITapGestureRecognizer *)tgr
{
    for (SelectorCell * cell in [selectorView visibleCells])
    {
        if (CGRectContainsPoint(cell.bounds, [tgr locationInView: cell]))
        {
            [selectorView  scrollToCellAtIndex: cell.index animated: YES];
            break;
        }
    }
    
}

@end
