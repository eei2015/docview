#import "HelpViewController.h"


@interface HelpViewController ()
- (void)closeHelp;
@end


@implementation HelpViewController

@synthesize url;

- (id)init
{
	self = [super init];

	self.title = @"Help";
	browser = [[UIWebView alloc] init];
	self.url = nil;

	return self;
}

- (void)dealloc
{
	self.url = nil;
	[browser release];
	[super dealloc];
}

- (void)viewDidLoad
{
	[self.navigationItem setHidesBackButton:YES];
	[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(closeHelp)] autorelease]];

    browser.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    browser.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  
//    browser.layer.borderWidth=3;
//    browser.layer.borderColor=[[UIColor redColor]CGColor];
  
	[self.view addSubview:browser];
    


    

	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{

	if (self.url)
	{
		[browser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
	}

	[super viewWillAppear:animated];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)closeHelp
{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
