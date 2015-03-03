#import <UIKit/UIKit.h>


@interface HelpViewController : UIViewController
{
	UIWebView *browser;

	NSString *url;
}

@property(nonatomic, retain) NSString *url;

@end
