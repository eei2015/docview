#import "HFMessagesViewController.h"
#import "DischargeFormViewController.h"
#import "ChatViewController.h"
#import "ReportViewController.h"
#import "Content.h"



@interface HFMessagesViewController ()
{
    BOOL showLoading;
}
- (void)changeView;
- (void)showLoading:(BOOL)show;
-(BOOL)showDischargeForm;

@end


@implementation HFMessagesViewController

- (id)init
{
	self = [super init];

	noReportsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
	[noReportsLabel setBackgroundColor:[UIColor clearColor]];
	[noReportsLabel setTextColor:[UIColor whiteColor]];
	[noReportsLabel setTextAlignment:UITextAlignmentCenter];
	noReportsLabel.text = @"";
    
	[self.view addSubview:noReportsLabel];

     UIBarButtonItem *spacing = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    
    // Jatin Chauhan 27-Nov-2013
    
      //  spacing.width = 280;
    
    // -Jatin Chauhan 27-Nov-2013
    
    
    
    if ([self showDischargeForm]) {
        segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Instructions", @"Chat",@"Discharge" ,nil]];
       
    } else {
        segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Instructions", @"Chat" ,nil]];
        spacing.width = 320 / 2 - segmentedControl.frame.size.width / 2 - 5; 
        
    }
	
    UIBarButtonItem *segCtrl = [[[UIBarButtonItem alloc] initWithCustomView:segmentedControl] autorelease];
   
    //spacing.width = 320 / 2 - segmentedControl.frame.size.width / 2 - 5; // no need
    UIBarButtonItem *spacing2 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    // Jatin Chauhan 27-Nov-2013
    
    
   // spacing2.width = 280;
    
    
    
    // -Jatin Chauhan 27-Nov-2013    
    
    
	[segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
	segmentedControl.selectedSegmentIndex = 0;
	[segmentedControl addTarget:self action:@selector(changeView) forControlEvents:UIControlEventValueChanged];

    
    
	

	chatController = [[ChatViewController alloc] init];
	instructionsController = [[ReportViewController alloc] initWithStyle:UITableViewStyleGrouped];
    dischargeFormViewController=[[DischargeFormViewController alloc] init];
    
	self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spacing, segCtrl, spacing2, nil];

    
    
    
	return self;
}

- (void)dealloc
{
	[segmentedControl release];
	[noReportsLabel release];

	[chatController release];
	[instructionsController release];

    [dischargeFormViewController release];
	[super dealloc];
}
- (void)showLoading:(BOOL)show
{
    showLoading = show;
    if (showLoading)
    {
        UIView * v = [[[UIView alloc] initWithFrame: self.view.bounds] autorelease];
        
        UIActivityIndicatorView * av = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite] autorelease];
        av.center = v.center;
        av.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
        [v addSubview: av];
        [av startAnimating];
        [self.view addSubview: av];
    }
    else
    {
        [[self.view.subviews lastObject] removeFromSuperview];
    }
}
-(BOOL)showDischargeForm
{
    if ([[Content shared] infoPlistValueForKey:@"DischargeForm"] && [[[Content shared] infoPlistValueForKey:@"DischargeForm"] isEqualToString:@"1"]) {
        return TRUE;
    }
    return FALSE;
}
- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self changeView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)changeView
{
    Content *content=[Content shared];
    if ([self showDischargeForm]) {
        [content queryDischargeFormType:^(NSMutableArray *arrFormType, NSError *errorOrnil) {
            
            if (arrFormType.count>0) {
                DischargeFormType *dft=(DischargeFormType*)[arrFormType objectAtIndex:0];
                if (dft.DFormStatus==FALSE) {
                    [segmentedControl removeSegmentAtIndex:2 animated:YES];
                } else {
                    dischargeFormViewController.formTypeArray=[arrFormType copy];
                    dischargeFormViewController.parentController=self.navigationController;
                }
            } else {
                [segmentedControl removeSegmentAtIndex:2 animated:YES];
            }            
        }];
    }
    
	noReportsLabel.text = @"";
	if ([chatController.view superview])
	{
		[chatController.view removeFromSuperview];
	}
	if ([instructionsController.view superview])
	{
		[instructionsController.view removeFromSuperview];
	}
    if ([dischargeFormViewController.view superview])
	{
		[dischargeFormViewController.view removeFromSuperview];
	}
    
    
    
    
    // Jatin Chauhan 27-Nov-2013
    
    

        instructionsController.view.frame = CGRectMake(65, 50, 640, 832);
        
        
    

        // -Jatin Chauhan 27-Nov-2013
    
    
    
    
    
    
    
    
    
    
	//instructionsController.view.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
	//instructionsController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	chatController.view.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
	chatController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    dischargeFormViewController.view.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
	dischargeFormViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);


    
	if (segmentedControl.selectedSegmentIndex == 0)
	{
        [self showLoading:YES];
        
        if (!content.activeRecord) {
            [content queryPatientReportById:[content activeReportId] WithBlock:^(COPDRecord *record, NSMutableDictionary *medications,NSError *errorOrnil) {
                
                 [self showLoading:NO];
                //
                if (record) {
                    //
                    content.activeRecord=record;
                    NSMutableArray *arrPMeds=[medications valueForKey:@"profile"];
                    NSMutableArray *arrIMeds=[medications valueForKey:@"intervene"];
                    
                    if (dischargeFormViewController) {
                        dischargeFormViewController.iMedications=[NSMutableArray arrayWithArray:arrIMeds];
                        dischargeFormViewController.pMedications=[NSMutableArray arrayWithArray:arrPMeds];
                        
                    }
                    instructionsController.pMedications=arrPMeds;
                    instructionsController.iMedications=arrIMeds;
                        instructionsController.record =record;
                    instructionsController.shouldShowReportsList = YES;
                    instructionsController.parentController = self.navigationController;
                    [self.view addSubview:instructionsController.view];
                } else {
                    noReportsLabel.text = @"No Reports Found";
                    return;
                }
            }];
        } else {
            instructionsController.record =[content activeRecord]; //[[[Content shared] records] objectAtIndex:0];
            instructionsController.shouldShowReportsList = YES;
            instructionsController.parentController = self.navigationController;
            [self.view addSubview:instructionsController.view];
        }
        
        
        
		/*if (![[Content shared].records count])
		{
			noReportsLabel.text = @"No Reports Found";
			return;
		}

		instructionsController.record =[[Content shared] activeRecord]; //[[[Content shared] records] objectAtIndex:0];
		instructionsController.shouldShowReportsList = YES;
		instructionsController.parentController = self.navigationController;
		[self.view addSubview:instructionsController.view   ];*/
        
	}
	else if (segmentedControl.selectedSegmentIndex == 1)
	{
        [self showLoading:NO];
        /*if (content.recordUpdateReceivedWhileAppWasRunning == YES) {
            [content queryChatHistoryWithPatientId:^(NSError *errorOrNil) {
                //
                if (errorOrNil==nil) {
                    [self.view addSubview:chatController.view];
                }
            }];

        } else {
            [self.view addSubview:chatController.view];
        }*/
        [self.view addSubview:chatController.view];
    
	} else {
        [self showLoading:NO];
        [self.view addSubview:dischargeFormViewController.view];
            
        
            
       
         
    }
}

@end
