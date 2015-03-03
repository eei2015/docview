#import "StepsProgressView.h"

@interface StepsProgressView (PrivatePethods)
- (UIImage*)prepareImageForStep:(NSInteger)step;
@end


@implementation StepsProgressView
@synthesize currentStep = _currentStep;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
		cellsNumber = 9;

        prevImageView = [[[UIImageView alloc] initWithFrame: CGRectZero] autorelease];
        [self addSubview: prevImageView];

        currImageView = [[[UIImageView alloc] initWithFrame: CGRectZero] autorelease];
        [self addSubview: currImageView];
        
        self.currentStep = 0;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    currImageView.frame = self.bounds;
    prevImageView.frame = self.bounds;
}

- (void)setCurrentStep:(int)currentStep animated:(BOOL)animated
{
    UIImage *img = [self prepareImageForStep:currentStep];
	currImageView.image = img;
    
    
    [UIView animateWithDuration: (animated ? 0.25 : 0) delay: 0 options: 0 animations:^{
        currImageView.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) 
        {
            prevImageView.image = currImageView.image;
            currImageView.alpha = 0;
        }
    }];
}

- (void)setCurrentStep:(NSInteger)currentStep
{
    [self setCurrentStep:currentStep animated: NO];
}

- (void)setCellsNumber:(NSInteger)numbeOfCells
{
	if (numbeOfCells <= 0)
	{
		return;
	}
	
	cellsNumber = numbeOfCells;
}

- (UIImage*)prepareImageForStep:(NSInteger)step
{
	CGFloat width = self.frame.size.width;
	CGFloat height = self.frame.size.height;

	CGFloat startTileWidth = 18.0;
	CGFloat endTileWidth = 21.0;
	CGFloat barTileWidth = 1.0;
	CGFloat barStartTileWidth = 2.0;
	CGFloat barEndTileWidth = 2.0;

	// Artwork for empty cells
	// imageNamed uses a sort of caching, so that's ok to ask for those images over & over
	UIImage *startEmptyImg = [UIImage imageNamed:@"start-empty.png"];
	UIImage *endEmptyImg = [UIImage imageNamed:@"end-empty.png"];
	UIImage *barEmptyImg = [UIImage imageNamed:@"bar-empty.png"];
	UIImage *barEndEmptyImg = [UIImage imageNamed:@"bar-end-empty.png"];
	UIImage *barStartEmptyImg = [UIImage imageNamed:@"bar-start-empty.png"];


	// Artwork for full cells
	UIImage *startFullImg = [UIImage imageNamed:@"start-full.png"];
	UIImage *endFullImg = [UIImage imageNamed:@"end-full.png"];
	UIImage *barFullImg = [UIImage imageNamed:@"bar-full.png"];
	UIImage *barEndFullImg = [UIImage imageNamed:@"bar-end-full.png"];
	UIImage *barStartFullImg = [UIImage imageNamed:@"bar-start-full.png"];


	// Scale, to support retima display
	CGFloat scale = [[UIScreen mainScreen] scale];

	CGContextRef ctx = CGBitmapContextCreate(nil, width * scale, height * scale, 8, width * scale * 8, CGImageGetColorSpace([startEmptyImg CGImage]), kCGImageAlphaPremultipliedLast);

	CGContextScaleCTM(ctx, scale, scale);
	CGContextClearRect(ctx, CGRectMake(0, 0, width, height));

	// current rendering position
	CGFloat currentXPos = 0.0;

	CGFloat sectionLength = (width - startTileWidth - endTileWidth + (barStartTileWidth) + (barEndTileWidth)) / (CGFloat)cellsNumber;

	// draw a start tile
	if (step > 0)
	{
		CGContextDrawImage(ctx, CGRectMake(currentXPos, 0, startTileWidth, height), [startFullImg CGImage]);
	}
	else 
	{
		CGContextDrawImage(ctx, CGRectMake(currentXPos, 0, startTileWidth, height), [startEmptyImg CGImage]);
	}
	currentXPos += startTileWidth;

	for (NSInteger section = 0; section < cellsNumber; section++) 
	{
		// draw separators for all cells, except the first one
		if (section > 0)
		{
			if (step > section)
			{
				CGContextDrawImage(ctx, CGRectMake(currentXPos, 0, barStartTileWidth, height), [barStartFullImg CGImage]);
			}
			else 
			{
				CGContextDrawImage(ctx, CGRectMake(currentXPos, 0, barStartTileWidth, height), [barStartEmptyImg CGImage]);
			}
			currentXPos += barStartTileWidth;
		}

		for (NSInteger x = 0; x < sectionLength - barStartTileWidth - barEndTileWidth; x++)
		{
			if (step > section)
			{
				CGContextDrawImage(ctx, CGRectMake(currentXPos, 0, barTileWidth, height), [barFullImg CGImage]);
			}
			else 
			{
				CGContextDrawImage(ctx, CGRectMake(currentXPos, 0, barTileWidth, height), [barEmptyImg CGImage]);
			}
			currentXPos += barTileWidth;
		}

		// draw separators for every cell, except for the last one
		if (section < cellsNumber - 1)
		{
			if (step > section)
			{
				CGContextDrawImage(ctx, CGRectMake(currentXPos, 0, barEndTileWidth, height), [barEndFullImg CGImage]);
			}
			else
			{
				CGContextDrawImage(ctx, CGRectMake(currentXPos, 0, barEndTileWidth, height), [barEndEmptyImg CGImage]);
			}
			currentXPos += barEndTileWidth;
		}
	}

	// draw end tile
	if (step >= cellsNumber)
	{
		CGContextDrawImage(ctx, CGRectMake(width - endTileWidth, 0, endTileWidth, height), [endFullImg CGImage]);
	}
	else 
	{
		CGContextDrawImage(ctx, CGRectMake(width - endTileWidth, 0, endTileWidth, height), [endEmptyImg CGImage]);
	}

	CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
	UIImage* resultImage = [[[UIImage alloc] initWithCGImage:cgImage scale:scale orientation:UIImageOrientationUp] autorelease];

	CGContextRelease(ctx);
	CGImageRelease(cgImage);

	return resultImage;	
}

@end
