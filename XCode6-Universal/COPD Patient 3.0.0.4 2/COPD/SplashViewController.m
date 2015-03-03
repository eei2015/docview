#import "SplashViewController.h"



@implementation SplashHolder

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
    if (self) 
	{
        frame = CGRectMake(0, 0, 320, 568);
    
        NSLog(@"frame = %0.2f",frame.size.height);
		imageView = [[[UIImageView alloc] initWithFrame: frame] autorelease];
        imageView.contentMode = UIViewContentModeBottom;

        
		[self addSubview: imageView];
		UIActivityIndicatorViewStyle style = UIActivityIndicatorViewStyleWhite;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		
		
		UIActivityIndicatorView * activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style] autorelease];
		activityIndicator.center = CGPointMake(self.center.x, self.frame.size.height - 75);

		
		activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
		[imageView addSubview:activityIndicator];
		[activityIndicator startAnimating];
        

    }
	return self;
}



-(void)layoutSubviews
{
	imageView.frame = self.bounds;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
    {
        if (self.frame.size.height > self.frame.size.width)
        {
            imageView.image = [UIImage imageNamed:@"Default-Portrait.png"];
        }
        else
        {
            imageView.image = [UIImage imageNamed:@"Default-Landscape.png"];
        }
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"Default.png"];
    }
}
@end


@implementation SplashViewController

- (void)viewDidLoad
{
    SplashHolder * splashView = [[[SplashHolder alloc] initWithFrame: self.view.bounds] autorelease];
    
   splashView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  //  splashView.frame = CGRectMake(0, 0, 320, 568);
    [self.view addSubview: splashView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		return YES;
	}
	return (toInterfaceOrientation == UIInterfaceOrientationPortrait); 
}

@end




