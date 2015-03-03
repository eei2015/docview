#import "PivotView.h"

@interface PivotView () <UIScrollViewDelegate>

@end

@implementation PivotView
@synthesize delegate = _delegate, visiblePageIndex = _visiblePageIndex, rightMargin = _rightMargin;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        contentScrollView = [[[UIScrollView alloc] initWithFrame: self.bounds] autorelease];
        contentScrollView.delegate = self;
        contentScrollView.showsHorizontalScrollIndicator = NO;
        contentScrollView.alwaysBounceHorizontal = YES;
        contentScrollView.scrollsToTop = NO;
        contentView = [[[UIView alloc] initWithFrame: CGRectZero] autorelease];
        
        [self addSubview: contentScrollView];
        [contentScrollView addSubview: contentView];
        
        visibleCells = [[NSMutableArray alloc] init];
        reusableCells = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [visibleCells release];
    [reusableCells release];
    [super dealloc];
}

#pragma mark - reload

- (CGFloat)cellWidth
{
    CGFloat cellWidth = 45.0f;
    if ([self.delegate respondsToSelector: @selector(widthOfColumnInPivotView:)]) 
    {
        cellWidth = [self.delegate widthOfColumnInPivotView: self];
    }
    return cellWidth;
}


- (void)loadCurrentCells
{
    NSInteger numberOfColumns = [self.delegate numberOfColumnsInPivotView: self];
    
    CGFloat cx = contentScrollView.contentOffset.x;
    CGFloat w = [self cellWidth];
    
    NSInteger firstVisibleCell,lastVisibleCell;
    
    if ([self.delegate respondsToSelector: @selector(firstVisibleCellInPivotView:)]) 
    {
        firstVisibleCell = [self.delegate firstVisibleCellInPivotView: self];
    }
    else
    {
        firstVisibleCell = cx/w;
    }
       
    
    if ([self.delegate respondsToSelector: @selector(lastVisibleCellInPivotView:)]) 
    {
        lastVisibleCell = [self.delegate lastVisibleCellInPivotView: self];
    }
    else
    {
        lastVisibleCell = (cx + contentScrollView.frame.size.width)/w;
    }
    
    if (firstVisibleCell < 0)
    {
        firstVisibleCell = 0;
    }
    
    if (lastVisibleCell > numberOfColumns - 1)
    {
        lastVisibleCell = numberOfColumns - 1;
    }
    
    NSMutableArray * invisibleCells = [NSMutableArray array];
    
    for (PivotViewCell * cell in visibleCells)
    {
        if (!(cell.index >= firstVisibleCell && cell.index <= lastVisibleCell))
        {
            [invisibleCells addObject: cell];
        }
    }
    
    for (PivotViewCell * cell in invisibleCells) 
    {
        if (cell.reuseIdentifier)
        {
            cell.index = -1;
            [reusableCells addObject: cell];
            [visibleCells removeObject: cell];
            [cell removeFromSuperview];
        }
    }
    
    
    for (NSInteger i = firstVisibleCell; i <= lastVisibleCell; i++)
    {
        BOOL alreadyLoaded = NO;
        for (PivotViewCell * cell in visibleCells)
        {
            if (cell.index == i)
            {
                alreadyLoaded = YES;
                break;
            }
        }
        
        if (!alreadyLoaded)
        {
            PivotViewCell * cell = [self.delegate pivotView: self cellForColumnAtIndex: i];
            cell.index = i;
            cell.frame = CGRectMake(i*w, 0, w, contentScrollView.frame.size.height);
            [cell setNeedsLayout];
            [contentView addSubview: cell];
            [reusableCells removeObject: cell];
            [visibleCells addObject: cell];
        }
    }
}

- (void)reloadData
{
    for (PivotViewCell * cell in visibleCells) 
    {
        cell.index = -1;
        if (cell.reuseIdentifier)
        {
            [reusableCells addObject: cell];
        }
        [cell removeFromSuperview];
    }
    [visibleCells removeAllObjects];
    
    if (self.delegate)
    {
        contentScrollView.contentSize = CGSizeMake([self cellWidth] * [self.delegate numberOfColumnsInPivotView: self]  + self.rightMargin,  contentScrollView.frame.size.height);
        contentView.frame = CGRectMake(0, 0, contentScrollView.contentSize.width, contentScrollView.contentSize.height);
        [self loadCurrentCells];
    }
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)reuseIdentifier
{
    if (reuseIdentifier)
    {
        for (PivotViewCell * cell in reusableCells) 
        {
            if ([cell.reuseIdentifier isEqualToString: reuseIdentifier])
            {
                return cell;
            }
        }
    }
    return nil;
}

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self loadCurrentCells];
    
    if ([self.delegate respondsToSelector: @selector(pivotViewDidScroll:)]) 
    {
        [self.delegate pivotViewDidScroll: self];
    }
    
 
    int newVisiblePageIndex = (scrollView.contentOffset.x + scrollView.frame.size.width/2)/scrollView.frame.size.width;
    
    if (newVisiblePageIndex < 0)
    {
        newVisiblePageIndex = 0;
    }
    
    NSInteger numberOfColumns = [self.delegate numberOfColumnsInPivotView: self];
    
    if (newVisiblePageIndex > numberOfColumns - 1)
    {
        newVisiblePageIndex = numberOfColumns - 1;
    }
    if (newVisiblePageIndex != self.visiblePageIndex) 
    {
        _visiblePageIndex = newVisiblePageIndex;
        if ([self.delegate respondsToSelector: @selector(pivotViewVisiblePageChanged:)]) 
        {
            [self.delegate pivotViewVisiblePageChanged: self];
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset 
{
    if ([self.delegate respondsToSelector: @selector(pivotViewWillEndDragging:withVelocity:targetContentOffset:)]) 
    {
        [self.delegate pivotViewWillEndDragging: self withVelocity: velocity targetContentOffset: targetContentOffset];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(self.frame, oldFrame)) 
    {
        oldFrame = self.frame;
        contentScrollView.frame = self.bounds;
        [self reloadData];
        
        if (!initialLayoutOccured) 
        {
            initialLayoutOccured = YES;
            [self scrollToCellAtIndex: initialCellIndex animated: NO];
        }
    }
}

- (UIScrollView *)scrollView
{
    return contentScrollView;
}

#pragma mark - 

- (void)scrollToCellAtIndex:(NSInteger)index animated:(BOOL)animated
{
    if (initialLayoutOccured) 
    {
        NSInteger numberOfColumns = [self.delegate numberOfColumnsInPivotView: self];
        CGFloat w = [self cellWidth];
        
        CGPoint pt = CGPointMake([self cellWidth] * index, 0);
        if (pt.x < 0) 
        {
            pt.x = 0;
        }
        CGFloat maxX = w*numberOfColumns - self.frame.size.width;
        if (pt.x > maxX) 
        {
            pt.x = maxX;
        }
        
        if (contentScrollView.contentSize.width > self.frame.size.width) 
        {
            [contentScrollView setContentOffset: pt animated: animated];
        }
    }
    else
    {
        initialCellIndex = index;
    }
}

- (id)cellAtIndex:(NSInteger)index
{
    for (PivotViewCell * cell in visibleCells) 
    {
        if (cell.index == index)
        {
            return cell;
        }
    }
    return nil;
}

- (CGPoint)contentOffset
{
    return contentScrollView.contentOffset;
}

- (void)setShowsScrollIndicator:(BOOL)showsScrollIndicator
{
    contentScrollView.showsHorizontalScrollIndicator = showsScrollIndicator;
}

- (BOOL)showsScrollIndicator
{
    return contentScrollView.showsHorizontalScrollIndicator;
}

- (void)setPagingEnabled:(BOOL)pagingEnabled
{
    contentScrollView.pagingEnabled = pagingEnabled;
}

- (BOOL)pagingEnabled
{
    return contentScrollView.pagingEnabled;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    contentScrollView.scrollEnabled = scrollEnabled;
}

- (BOOL)scrollEnabled
{
    return contentScrollView.scrollEnabled;
}


- (void)setBounces:(BOOL)bounces
{
    contentScrollView.bounces = bounces;
}

- (BOOL)bounces
{
    return contentScrollView.bounces;
}

- (void)setRightMargin:(CGFloat)rightMargin
{
    _rightMargin = rightMargin;
    [self setNeedsLayout];
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    contentScrollView.contentOffset = contentOffset;
}

- (NSArray *)visibleCells
{
    return visibleCells;
}

- (void)deleteCellAtIndex:(NSInteger)index animated:(BOOL)animated
{
    CGPoint oldOffset = contentScrollView.contentOffset;
    [self reloadData];
    CGPoint newOffset = contentScrollView.contentOffset;
    contentScrollView.contentOffset = oldOffset;

    CGFloat w = [self cellWidth];
    
    for (PivotViewCell * cell in visibleCells)
    {
        if (cell.index < index) 
        {
            cell.frame = CGRectMake(cell.index*w, 0, w, contentScrollView.frame.size.height);
        }
        else
        {
            cell.frame = CGRectMake((cell.index + 1)*w, 0, w, contentScrollView.frame.size.height);
        }

    }
    
    [UIView animateWithDuration: (animated ? 0.3 : 0) animations:^{
        for (PivotViewCell * cell in visibleCells)
        {
            cell.frame = CGRectMake(cell.index*w, 0, w, contentScrollView.frame.size.height);
        } 
    }];
    
    [contentScrollView setContentOffset: newOffset animated: animated];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView * result = [super hitTest: point withEvent: event];
    if (result)
    {
        return contentScrollView;
    }
    return nil;
}

@end


@implementation PivotViewCell
@synthesize reuseIdentifier = _reuseIdentifier, index = _index;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithFrame: CGRectZero];
    if (self)
    {
        _reuseIdentifier = [reuseIdentifier copy];
        self.index = -1;
    }
    return self;
}

- (void)dealloc
{
    [_reuseIdentifier release];
    [super dealloc];
}

@end