#import <UIKit/UIKit.h>

@class ShadowView;

@interface UIWebViewWithSafeDealloc: UIWebView

@end

@interface InAppBrowserController : UIViewController<UIWebViewDelegate, UIActionSheetDelegate, UITextFieldDelegate>
{
	UIWebView * webView;
	UITextField * textField;
	UILabel * titleLabel;
	UIToolbar * topBar;
	UIToolbar * bottomBar;
	UISegmentedControl * doneButton;
	UIColor * tintColor;
	UIColor * titleColor;
	UIActivityIndicatorView * activityView;
	NSArray * stopItems;
	NSArray * reloadItems;
	ShadowView * shadow;
	NSString * prevUrl;
	BOOL ignoreNextStartLoad;
	NSString * username;
	NSString * password;
	NSString * startUrl;
	BOOL doLogin;
}

@property (nonatomic, retain) UIColor * barsTintColor;
@property (nonatomic, retain) UIColor * titleColor;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * startUrl;

- (void)loadUrl:(NSString *)url;
- (void)loadUrl:(NSString *)url username:(NSString *)username password:(NSString *)password;

+ (void)showFromViewController:(UIViewController *)vc withUrl:(NSString *)url;

@end
