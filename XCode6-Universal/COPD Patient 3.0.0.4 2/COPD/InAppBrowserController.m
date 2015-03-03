#import "InAppBrowserController.h"
#import "TSAlertView.h"


@interface ShadowView : UIView
{
	UITextField * textField;
}
@property (nonatomic, retain) UITextField * textField;
@end

@implementation ShadowView

@synthesize textField;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[textField resignFirstResponder];
}

- (void)dealloc
{
	[super dealloc];
}

@end




@implementation UIWebViewWithSafeDealloc

- (void)dealloc
{
    @try 
    {
        [super dealloc];
    }
    
    @catch ( NSException *e ) 
    {
        NSLog(@"[UIWebView dealloc] %@",e);
    }
    
    @finally 
    {
        
    }
    
}

@end



@implementation InAppBrowserController

@synthesize barsTintColor,titleColor,username, password, startUrl;


- (void)showShadow:(BOOL)show
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.25];
	shadow.alpha = (show ? 0.8 : 0.0);
	[UIView commitAnimations];
}


- (void)updateBackForward
{
	[[[bottomBar items] objectAtIndex: 0] setEnabled: webView.canGoBack];
	[[[bottomBar items] objectAtIndex: 2] setEnabled: webView.canGoForward];
}

- (void)updateStopReload:(BOOL)stop
{
	NSArray * itemsToSet = (stop ? stopItems : reloadItems);
	if (bottomBar.items != itemsToSet)
	{
		[bottomBar setItems:itemsToSet animated:YES];
	}
}


- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	CGFloat padding = 5;
	CGFloat titleHeight = 24;
	CGFloat doneButtonWidth = 60;
	CGFloat doneButtonHeight = 32;
	
	
	CGFloat topToolbarHeight = titleHeight+doneButtonHeight+padding;
	CGFloat bottomBarWidth = 44*4;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		padding = 7;
	}
	
	titleLabel = [[[UILabel alloc] initWithFrame: CGRectMake(padding, 0, self.view.frame.size.width - padding*2 , titleHeight)] autorelease];
	titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	titleLabel.font = [UIFont boldSystemFontOfSize:12];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.opaque = NO;
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.textColor = [UIColor colorWithRed: 0 green: 0 blue:0 alpha: 0.6];
	
	textField = [[[UITextField alloc] initWithFrame: CGRectMake(padding, titleHeight, self.view.frame.size.width - padding*3 - doneButtonWidth, doneButtonHeight)] autorelease];
	textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	textField.borderStyle = UITextBorderStyleRoundedRect;
	textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	textField.keyboardType = UIKeyboardTypeURL;
	textField.returnKeyType = UIReturnKeyGo;
	textField.font = [UIFont systemFontOfSize: 15];
	textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	textField.delegate = self;
	textField.textColor = [UIColor darkGrayColor];
	
	activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
	
	doneButton = [[[UISegmentedControl alloc] initWithItems:
									 [NSArray arrayWithObjects:
									  @"Close",
									  nil]] autorelease];
	[doneButton addTarget:self action:@selector(doneButtonPushed:) forControlEvents:UIControlEventValueChanged];
	doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
	doneButton.frame = CGRectMake(self.view.frame.size.width - padding - doneButtonWidth, titleHeight, doneButtonWidth, doneButtonHeight);
	doneButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	doneButton.momentary = YES;


	topBar = [[[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, topToolbarHeight)] autorelease];
	topBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //akhil 23-10-13
	//[topBar addSubview: textField];
    //akhil 23-10-13
	[topBar addSubview: doneButton];
	
	
	
	webView  = [[[UIWebViewWithSafeDealloc alloc] initWithFrame: CGRectMake(0, topToolbarHeight + 1, self.view.frame.size.width, self.view.frame.size.height - topToolbarHeight)] autorelease];
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	webView.delegate = self;
	webView.scalesPageToFit = YES;
    webView.dataDetectorTypes = UIDataDetectorTypeLink;

	
	shadow = [[[ShadowView alloc] initWithFrame: self.view.bounds] autorelease];
	shadow.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	shadow.alpha = 0;
	shadow.backgroundColor = [UIColor blackColor];
	shadow.textField = textField;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
	{
		bottomBar = [[[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, bottomBarWidth, topToolbarHeight)] autorelease];
		CGRect b = bottomBar.bounds;
		b.origin.y -= 8;
		bottomBar.bounds = b;
	}
	else
	{
		bottomBar = self.navigationController.toolbar;
		self.navigationController.toolbarHidden = NO;
	}

	
	UIBarButtonItem * space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil] autorelease];
	UIBarButtonItem * prev = [[[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"browser-nav-prev.png"] style: UIBarButtonItemStylePlain target:self action:@selector(prevPushed)] autorelease];
	UIBarButtonItem * next = [[[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"browser-nav-next.png"] style: UIBarButtonItemStylePlain target:self action:@selector(nextPushed)] autorelease];
	UIBarButtonItem * reload = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRefresh target: self action:@selector(reloadPushed)] autorelease];
	UIBarButtonItem * stop = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemStop target: self action:@selector(stopPushed)] autorelease];
	UIBarButtonItem * action = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAction target: self action:@selector(actionPushed:)] autorelease];
	
	//stopItems = [[NSArray arrayWithObjects: prev,space, next, space,stop,space,action, nil] retain];
	//reloadItems = [[NSArray arrayWithObjects: prev,space, next, space,reload,space,action, nil] retain];
    
    //akhil 23-10-13
    stopItems = [[NSArray arrayWithObjects: prev,space, next, space,stop,space, nil] retain];
	reloadItems = [[NSArray arrayWithObjects: prev,space, next, space,reload,space, nil] retain];
    //akhil 23-10-13

	
	bottomBar.items = stopItems;
	
	[self.view addSubview: webView];
	[self.view  addSubview: shadow];
	[self.view  addSubview: topBar];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		[self.view  addSubview: bottomBar];
	}
	
	[self.view  addSubview: titleLabel];
	
	if (barsTintColor)
	{
		self.barsTintColor = barsTintColor;
	}
	
	if (titleColor)
	{
		self.titleColor = titleColor;
	}
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		topBar.frame = CGRectMake(bottomBarWidth, 0, self.view.frame.size.width - bottomBarWidth, topToolbarHeight) ;
		self.navigationController.toolbarHidden = YES;
		topBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	}
	
	[self updateBackForward];
}


- (void)viewWillAppear:(BOOL)animated
{

	
}

- (void)setBarsTintColor:(UIColor *)color
{
	[barsTintColor release];
	barsTintColor = [color retain];
	topBar.tintColor = barsTintColor;
	bottomBar.tintColor = barsTintColor;
	doneButton.tintColor = barsTintColor;
	self.view.backgroundColor = barsTintColor;
}

- (void)setTitleColor:(UIColor *)color
{
	[titleColor release];
	titleColor = [color retain];
	titleLabel.textColor = titleColor;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return YES;
}


- (void)dealloc
{
	self.username = nil;
	self.password = nil;
	self.startUrl = nil;
	[prevUrl release];
	[stopItems release];
	[reloadItems release];
	[activityView release];
	[barsTintColor release];
	[titleColor release];
    [super dealloc];
}



#pragma mark handlers

- (void)doneButtonPushed:(id)sender
{
	if (textField.editing)
	{
		textField.text = prevUrl;
		[textField resignFirstResponder];
	}
	else
	{
		[self dismissModalViewControllerAnimated: YES];
	}

	
}

- (void)showLoading:(BOOL)show
{
	if (textField.editing)
	{
		return;
	}
	
	if (show)
	{
		if (textField.rightView != activityView) 
		{
			textField.rightViewMode = UITextFieldViewModeAlways;
			textField.rightView = activityView;
			[activityView startAnimating];
		}
		
	}
	else
	{
		textField.rightViewMode = UITextFieldViewModeNever;
		textField.rightView = nil;
		[activityView stopAnimating];
	}

}

- (void)prevPushed
{
	[webView goBack];
}

- (void)nextPushed
{
	[webView goForward];
}

- (void)stopPushed
{
	[webView stopLoading];
}

- (void)reloadPushed
{
	[webView reload];
}

- (void)actionPushed:(id)sender 
{
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Share Link" delegate:nil 
											  cancelButtonTitle:@"Cancel" 
										 destructiveButtonTitle:nil 
											  otherButtonTitles:@"Open in Safari", nil];
	[sheet setDelegate:self];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		[sheet showFromBarButtonItem: sender animated: YES];
	}
	else
	{
		// was causing message and cancel button was not clickable (bottom part of it):
		/*
		 Presenting action sheet clipped by its superview. Some controls might not respond to touches. On iPhone try -[UIActionSheet showFromTabBar:] or -[UIActionSheet showFromToolbar:] instead of -[UIActionSheet showInView:].
		 */
		//[sheet showInView:self.view];
		[sheet showFromToolbar:bottomBar];
	}
}


#pragma mark load url


- (void)loadUrl:(NSString *)url
{
	self.startUrl = url;
	self.username = nil;
	self.password = nil;
	textField.text = url;
	doLogin = NO;
	[webView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: url]]];
}

- (void)loadUrl:(NSString *)url username:(NSString *)u password:(NSString *)p
{
	
	self.startUrl = url;
	self.username = u;
	self.password = p;
	doLogin = YES;
	[webView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: url]]];
}


#pragma mark UIWebViewDelegate methods

- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	
	[self updateBackForward];
	
	
	if (![[request.URL absoluteString] hasPrefix:@"http"] && ![[request.URL absoluteString] hasPrefix:@"about:blank"]) 
	{
		[[UIApplication sharedApplication] openURL: request.URL];
		return NO;
	}
	else
	{
		titleLabel.text = @"Loading...";
		[self showLoading: YES];
		[self updateStopReload: YES];
		
		if (!textField.editing) 
		{
			if (![[request.URL absoluteString] hasPrefix:@"about:blank"]) {
				textField.text = [request.URL absoluteString];
			}
			
		}
	}


	return YES;
}

- (void)updateAfterLoad
{
	titleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"]; 
	[self showLoading: NO];
	[self updateBackForward];
	[self updateStopReload: NO];
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error
{
	[self updateAfterLoad];
    
    if ([error code] != kCFURLErrorCancelled)
    {
             [[[[TSAlertView alloc] initWithTitle: [error localizedFailureReason] message: [error localizedDescription] delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil] autorelease] show];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)wv
{
	[self updateAfterLoad];
	
	if (doLogin) 
	{
		doLogin = NO;
	}
}


- (void)webViewDidStartLoad:(UIWebView *)wv
{
	if (ignoreNextStartLoad)
	{
		ignoreNextStartLoad = NO;
		return;
	}
	
	if (!textField.editing) 
	{
		NSString * url =  [webView.request.URL absoluteString];
		if ([url length] > 0) 
		{
			textField.text = url;
		}
	}
	
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)tf
{
	textField.textColor = [UIColor blackColor];
	[prevUrl release];
	prevUrl = [tf.text copy];
	[self showLoading: NO];
	[self showShadow: YES];
	textField.clearButtonMode = UITextFieldViewModeAlways;
	[doneButton setTitle:@"Cancel" forSegmentAtIndex:0];
	
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)tf
{
	textField.textColor = [UIColor darkGrayColor];
	[doneButton setTitle:@"Close" forSegmentAtIndex:0];
	textField.clearButtonMode = UITextFieldViewModeNever;
	[self showShadow: NO];
	if ([textField.text length] == 0)
	{
		textField.text = prevUrl;
	}
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)tf
{
	
	[self showLoading: webView.loading];
}

- (BOOL)textFieldShouldReturn:(UITextField *)tf {
	
	if ([textField.text length] == 0)
	{
		textField.text = prevUrl;
	}
	
	NSURL * url = [NSURL URLWithString: textField.text];
	if (![url scheme])
	{
		url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@",tf.text]];
	}
	[textField resignFirstResponder];
	

	
	
	textField.text = [url absoluteString];
	
	[webView loadRequest: [NSURLRequest requestWithURL: url] ];

	ignoreNextStartLoad = YES;
	return YES;
}

#pragma mark -
#pragma mark Action Sheet Delegate


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) 
	{
		[[UIApplication sharedApplication] openURL:[webView.request URL]];
	} 
}

+ (void)showFromViewController:(UIViewController *)vc withUrl:(NSString *)url
{
    InAppBrowserController * inappBrowser = [[[InAppBrowserController alloc] init] autorelease];
   	UINavigationController * nav = [[[UINavigationController alloc] initWithRootViewController:inappBrowser] autorelease];
	nav.navigationBarHidden = YES;
	inappBrowser.barsTintColor = [UIColor colorWithWhite:0 alpha: 1.0];
	inappBrowser.titleColor = [UIColor colorWithWhite: 1.0 alpha: 0.8];
	[vc presentModalViewController: nav animated: YES];
	[inappBrowser loadUrl: url];
}


@end
