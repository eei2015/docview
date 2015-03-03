#import "MainViewController.h"
#import "UIViewController+Branding.h"
#import "COPDAppDelegate.h"
#import "COPDBackend.h"
#import "Content.h"
#import <Parse/Parse.h>
#import "RecordCell.h"
#import "NIFMailSender.h"
#import "QuestionsViewController.h"
#import "AnswerViewController.h"
#import "ReportViewController.h"
#import "ReportsViewController.h"
#import "ChatViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TSAlertView.h"
#include "Crittercism.h"
#include "HFMessagesViewController.h"
#import "InAppBrowserController.h"

//akhil 17-10-13
//add header file
#import "SurveyBanner.h"
#import "SBJson.h"
//akhil 17-10-13

#ifndef COPD
#import "HelpViewController.h"
#endif


@interface MainViewController () <TSAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSString * lastUpdatedRecordId;

- (NSInteger)numberOfUnreadReports;

@end

@implementation MainViewController
@synthesize lastUpdatedRecordId, tableView;
@synthesize strImageid;

- (id)init
{
    self = [super init];
    if (self) 
    {
		self.tableView = [[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped] autorelease];
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		self.tableView.backgroundColor = [UIColor clearColor];
        
            // Jatin Chauhan 22-Nov-2013
        
        
        //self.tableView.backgroundView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"bg.png"]] autorelease];
        self.tableView.backgroundView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"bg@2x.png"]] autorelease];
        
//        self.tableView.backgroundView.layer.borderWidth = 1;
//        self.tableView.backgroundView.layer.borderColor= [[UIColor redColor]CGColor];
        
            // -Jatin Chauhan 22-Nov-2013
        
        
            }
    return self;
}

- (void)dealloc
{
	self.tableView.delegate = nil;
	self.tableView.dataSource = nil;
	self.tableView = nil;
#ifndef COPD
	[sendMessageButton release];
	[statusLabel release];
#endif
    self.lastUpdatedRecordId = nil;
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - actions

- (void)helpClicked
{
#if COPD
    [InAppBrowserController showFromViewController: self withUrl: @"http://help.docviewsolutions.com/copd-app/help.html"];
#elif HFBASE
	HelpViewController *help = [[[HelpViewController alloc] init] autorelease];
	help.url = @"http://help.docviewsolutions.com/chf-app/help.html";
	[self.navigationController pushViewController:help animated:YES];
#elif HFB
	HelpViewController *help = [[[HelpViewController alloc] init] autorelease];
	help.url = @"http://www.barnabashealth.org/services/cardiac/education/chf_diagnosing.html";
	[self.navigationController pushViewController:help animated:YES];
#endif
}

- (void)logoutClicked
{
    
    //akhil 5-11-14
    //auto logout
    [Content shared].login_status=0;
    //akhil 5-11-14
    //auto logout 
    
    allVisible = NO;
    myInboxVisible = NO;
    [[Content shared] handleLogout];
    //[PFUser logOut];
    COPDAppDelegate * appDelegate = (COPDAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)reload
{
    @try {
        
        
        BOOL newMyInboxVisible = [self numberOfUnreadReports] > 0;
        BOOL newAllVisible = [Content shared].reloadOccured;
       // NSInteger maxSection = 1;
        
#ifndef COPD
        newMyInboxVisible = NO;
        myInboxVisible = NO;
#endif
        
        /*if (allVisible == NO && myInboxVisible == NO && newMyInboxVisible == YES && newAllVisible == YES)
        {
            [self.tableView insertSections: [NSIndexSet indexSetWithIndexesInRange: NSMakeRange(0, maxSection + 1)]  withRowAnimation: UITableViewRowAnimationFade];
        }
        if (allVisible == NO && myInboxVisible == NO && newMyInboxVisible == NO && newAllVisible == YES)
        {
            [self.tableView insertSections: [NSIndexSet indexSetWithIndexesInRange: NSMakeRange(0, maxSection)]  withRowAnimation: UITableViewRowAnimationFade];
        }
        else if (allVisible == YES && myInboxVisible == NO && newMyInboxVisible == YES && newAllVisible == YES)
        {
            [self.tableView insertSections: [NSIndexSet indexSetWithIndexesInRange: NSMakeRange(0, 1)]  withRowAnimation: UITableViewRowAnimationFade];
        }
        else if (allVisible == YES && myInboxVisible == YES && newMyInboxVisible == NO && newAllVisible == YES)
        {
            [self.tableView deleteSections: [NSIndexSet indexSetWithIndexesInRange: NSMakeRange(0, 1)]  withRowAnimation: UITableViewRowAnimationFade];
        }
        else
        {*/
            [self.tableView reloadData];
        //}
        
        allVisible =  newAllVisible;
        myInboxVisible = newMyInboxVisible;
        
        
        int unread = [Content shared].chatCount + [[Content shared] reportCount];
        
        /*for (COPDObject * message in [Content shared].messages)
        {
            if (![[message objectForKey: @"IsFromPatient"] boolValue] )
            {
                if (![[message objectForKey: @"IsPatientAcknowledged"] boolValue])
                {
                    unread++;
                }
            }
        }
        
#ifndef COPD
        unread += [self numberOfUnreadReports];
#endif*/
        
        statusLabel.text = [NSString stringWithFormat: @"%d",unread];
        
        // Jatin Chauhan 29-Nov-2013
      //  statusLabel.font = [UIFont systemFontOfSize:34];
                // Jatin Chauhan 29-Nov-2013
        
        statusLabel.hidden = unread == 0;

        [statusLabel sizeToFit];
       // statusLabel.frame = CGRectMake(sendMessageButton.frame.size.width - 16 - statusLabel.frame.size.width,  - statusLabel.frame.size.height/2 + 2, statusLabel.frame.size.width + 28, statusLabel.frame.size.height + 1); //statusLabel.frame.size.width + 28
        
        if(IS_IPHONE_4_OR_LESS)
        {
             statusLabel.frame = CGRectMake(sendMessageButton.frame.size.width - 5 - statusLabel.frame.size.width,  - statusLabel.frame.size.height/2 + 2, statusLabel.frame.size.width + 14, statusLabel.frame.size.height +1); //statusLabel.frame.size.width + 28
              statusLabel.font = [UIFont systemFontOfSize:17];
           // statusLabel.backgroundColor = [UIColor clearColor];
            
        }
        else if (IS_IPHONE_5)
        {
             statusLabel.frame = CGRectMake(sendMessageButton.frame.size.width - 20 - statusLabel.frame.size.width,  - statusLabel.frame.size.height/2 + 2, statusLabel.frame.size.width + 13, statusLabel.frame.size.height +1);
              statusLabel.font = [UIFont systemFontOfSize:17];
        }
        
        else
        {
             statusLabel.frame = CGRectMake(sendMessageButton.frame.size.width - 16 - statusLabel.frame.size.width,  - statusLabel.frame.size.height/2 + 2, statusLabel.frame.size.width + 28, statusLabel.frame.size.height + 1); //statusLabel.frame.size.width + 28
              statusLabel.font = [UIFont systemFontOfSize:34];
        }

        statusLabel.layer.cornerRadius = roundf(statusLabel.frame.size.height/2);
        statusLabel.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect: statusLabel.bounds cornerRadius: statusLabel.layer.cornerRadius].CGPath;
        
       
        
    }
    @catch (NSException *exception) {
        //
        NSLog(@"Exception: %@",exception);
    }
    @finally {
        //
    }
    
    
}

- (void)responseReceived
{
    [[Content shared] reload];
}

- (void)switchToLastReport
{
	if (self.modalViewController)
	{
		[self dismissModalViewControllerAnimated:YES];
	}

    //commented 29 march 13
	/*for (COPDRecord *rec in [Content shared].records)
	{
		if ([rec.Id isEqualToString:self.lastUpdatedRecordId])
		{
			ReportViewController *vc  = [[[ReportViewController alloc] initWithStyle: UITableViewStyleGrouped] autorelease];

			vc.record = rec;
			[self.navigationController pushViewController:vc animated:YES];
			break;
		}
	}*/
}

- (void)alertView:(TSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self switchToLastReport];
}

- (void)recordNeedsToBeDisplayed:(NSNotification *)n
{
    self.lastUpdatedRecordId = [Content shared].lastUpdatedRecordId;
    if ([Content shared].recordUpdateReceivedWhileAppWasRunning)
    {
		[[[[TSAlertView alloc] initWithTitle: @"Response received" message: @"You have received important instructions from your nurse." delegate: self cancelButtonTitle:nil otherButtonTitles:@"View Now",nil] autorelease] show];
    }
    else
    {
        [self switchToLastReport];
    }
}


- (void)checkInClicked
{
   __block BOOL hasUnreadResponse = NO;
   // COPDRecord * record=nil;
    
    
    /*if ([[Content shared].records count] > 0)
    {
        record = [[Content shared].records objectAtIndex: 0];  // need to change
        if(record.reportStatus == ReportStatusSentToPatient)
        {
            [[[[TSAlertView alloc] initWithTitle: @"You have an unread message in your inbox. Please review before checking in again." message: nil delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil] autorelease] show];
            hasUnreadResponse=TRUE;
        } if (record.reportStatus==ReportStatusRecommendedByNurse || record.reportStatus==ReportStatusApprovedBySupervisor) {
            [[[[TSAlertView alloc] initWithTitle: @"Your intervention is in process, you can not checkin again this time." message: nil delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil] autorelease] show];
             hasUnreadResponse=YES;
        }
        //hasUnreadResponse = record.reportStatus == ReportStatusSentToPatient;
    }*/
    
    //================
    //akhil 24-10-13
    //akhil check suvery pedding or not
    COPDAppDelegate * obj_dele = (COPDAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSLog(@"obj delegate ary =%@",obj_dele.ary_survey);
    
    if ([obj_dele.ary_survey count]>0)
    {
         //[[[[TSAlertView alloc] initWithTitle: @"Action Required!" message: @"Please completed all questionnaires" delegate: self cancelButtonTitle:nil otherButtonTitles:@"OK",nil] autorelease] show];
        
        [[[[TSAlertView alloc] initWithTitle: @"Action Required!" message: @"Please completed all questionnaires" delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil] autorelease] show];
        
    }
    else
    {
        //================================
        //====== ACTUAL code
        [[COPDBackend sharedBackend] queryPatientActiveReportStatus:[[COPDBackend sharedBackend] currentUser].objectId WithBlock:^(COPDQuery *query, NSError *errorOrNil) {
            //
            if (query.rows.count>0) {
                //
                NSUInteger status=[[query.rows objectAtIndex:0] integerValue];
                //  NSLog(@"Status: %d",status);
                if (status==ReportStatusSentToPatient) {
                    [[[[TSAlertView alloc] initWithTitle: @"You have an unread message in your inbox. Please review before checking in again." message: nil delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil] autorelease] show];
                    hasUnreadResponse=YES;
                    
                }else if (status==ReportStatusRecommendedByNurse || status==ReportStatusApprovedBySupervisor) {
                    [[[[TSAlertView alloc] initWithTitle: @"Your intervention is in process, you can not checkin again this time." message: nil delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil] autorelease] show];
                    hasUnreadResponse=YES;
                }
            }
            
            if (hasUnreadResponse==NO)
            {
                
                
                Content *shared= [Content shared];
                
                [shared getQuestions:^(NSError *errorOrNil) {
                    if (errorOrNil==nil) {
                        QuestionsViewController * vc  = [[[QuestionsViewController alloc] init] autorelease];
                        UINavigationController * nc = [[[UINavigationController alloc] initWithRootViewController: vc] autorelease];
                        [self presentModalViewController: nc animated: YES];
                    }
                    //
                    //NSLog(@"%@",query.rows);
                    //backend.currentQuery=query;
                    //NSLog(@"%@",backend.currentQuery.rows);
                    
                }];
                
                /* QuestionsViewController * vc  = [[[QuestionsViewController alloc] init] autorelease];
                 
                 UINavigationController * nc = [[[UINavigationController alloc] initWithRootViewController: vc] autorelease];
                 [self presentModalViewController: nc animated: YES];*/
            }
            
            
        }];

        
        //====== ACTUAL code
        //================================
        
    }
    //akhil 24-10-13
    //akhil check suvery pedding or not
    //================
    
    
      
    
       
}

- (void)sendMessageClicked
{
#if COPD
	ChatViewController *vc = [[[ChatViewController alloc] initWithStyle: UITableViewStylePlain] autorelease];
#else
	HFMessagesViewController *vc = [[[HFMessagesViewController alloc] init] autorelease];
#endif

	[self.navigationController pushViewController: vc animated: YES];
}

#pragma mark - View lifecycle

- (UILabel *)titleLabel
{
    
    
    // Jatin Chauhan 22-nov-2013
    
    //UILabel* l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 30)] autorelease];
    
  //  UILabel* l = [[[UILabel alloc] initWithFrame:CGRectMake(35, 0, 300, 45)] autorelease];
    UILabel* l = [[[UILabel alloc] init] autorelease];


    // -Jatin Chauhan 22-nov-2013
    
    if(IS_IPHONE_4_OR_LESS)
    {
        l.frame = CGRectMake(10, 5, 145, 22);
        l.font = [UIFont boldSystemFontOfSize:15];
    }
    else if (IS_IPHONE_5)
    {
        l.frame = CGRectMake(10, 5, 145, 22);
        l.font = [UIFont boldSystemFontOfSize:15];
    }
    
    else
    {
        l.frame = CGRectMake(300, 2, 330, 45);
        l.font = [UIFont boldSystemFontOfSize:30];
    }

    l.layer.borderWidth=1;
   // l.font = [UIFont boldSystemFontOfSize:30];
    l.backgroundColor = [UIColor clearColor];
    l.textColor = [UIColor whiteColor];
    l.shadowColor = [UIColor blackColor];
    l.shadowOffset = CGSizeMake(0, 1);
    return l;
}

//2014-09-11 Vipul add Track, Target, treat lable
- (UILabel *)titleTextLable
{  
    
   // UILabel* l = [[[UILabel alloc] initWithFrame:CGRectMake(300, 2, 330, 45)] autorelease];
     UILabel* l = [[[UILabel alloc] init] autorelease];
    
    if(IS_IPHONE_4_OR_LESS)
    {
        l.frame = CGRectMake(155, 5, 160, 22);
         l.font = [UIFont boldSystemFontOfSize:13];
    }
    else if (IS_IPHONE_5)
    {
        l.frame = CGRectMake(155, 5, 170, 22);
         l.font = [UIFont boldSystemFontOfSize:13];
    }
    
    else
    {
        l.frame = CGRectMake(300, 2, 330, 45);
         l.font = [UIFont boldSystemFontOfSize:27];
    }

    l.layer.borderWidth=2;
    //l.font = [UIFont boldSystemFontOfSize:27];
    l.backgroundColor = [UIColor clearColor];
    l.textColor = [UIColor colorWithRed:92/255.0 green:148/255.0 blue:177/255.0 alpha:1.0];
    l.shadowColor = [UIColor blackColor];
    l.shadowOffset = CGSizeMake(0, 1);
    return l;
}
//2014-09-11 Vipul add Track, Target, treat lable

- (void)loadHeaderView
{
    UILabel * l = [self titleLabel];
#if COPD
    l.text = @"DocView iT3 COPD";
#elif HF
    l.text = @"iT3 Heart Failure";
#endif
   
    //2014-09-11 Vipul add Track, Target, treat lable
    UILabel *ltext = [self titleTextLable];
    ltext.text = @"TRACK, TARGET, TREAT";
    //2014-09-11 Vipul add Track, Target, treat lable
    
    UIButton * checkinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //checkinButton.frame = CGRectMake(0, 35, 144, 45);
    //akhil 4-2-15
    //IOS Upgradation
    
    if(IS_IPHONE_4_OR_LESS)
    {
       checkinButton.frame = CGRectMake(0, 35, 144, 45);
       
     //   self.tableView.layer.borderWidth = 1;
        //self.tableView.layer.borderColor = [[UIColor redColor]CGColor];
    }
    else if (IS_IPHONE_5)
    {
        checkinButton.frame = CGRectMake(0, 35, 160, 45);

    }
    
    else
    {
        
    }
    //}
    //akhil 4-2-15
    //IOS Upgradation

    [checkinButton setBackgroundImage:[UIImage imageNamed:@"blue-btn"] forState:UIControlStateNormal];
    [checkinButton setTitle:@"CHECK IN" forState:UIControlStateNormal];
    
    [checkinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkinButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [checkinButton setTitleShadowColor:[UIColor colorWithWhite: 0 alpha: 0.5] forState:UIControlStateNormal];
    checkinButton.titleLabel.shadowOffset = CGSizeMake(1, 0);
    checkinButton.titleLabel.font = [UIFont boldSystemFontOfSize: 14];
    [checkinButton addTarget:self action:@selector(checkInClicked) forControlEvents:UIControlEventTouchUpInside];
    
    sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
  //  sendMessageButton.frame = CGRectMake(166, 35, 288, 90);
    //akhil 4-2-15
    //IOS Upgradation
    
    if(IS_IPHONE_4_OR_LESS)
    {
       sendMessageButton.frame = CGRectMake(10, 35, 140, 45);
    }
    else if (IS_IPHONE_5)
    {
         sendMessageButton.frame = CGRectMake(10, 35, 165, 45);
    }
    
    else
    {
         sendMessageButton.frame = CGRectMake(166, 35, 288, 90);
    }
    //}
    //akhil 4-2-15
    //IOS Upgradation

    [sendMessageButton setBackgroundImage:[UIImage imageNamed:@"grey-btn"] forState:UIControlStateNormal];
    [sendMessageButton setTitle:@"MESSAGES" forState:UIControlStateNormal];
    [sendMessageButton setTitleColor:[UIColor colorWithWhite: 0.43 alpha: 1] forState:UIControlStateNormal];
    [sendMessageButton setTitleColor:[UIColor colorWithWhite: 0.2 alpha: 1] forState:UIControlStateHighlighted];
    [sendMessageButton setTitleShadowColor:[UIColor colorWithWhite: 1 alpha: 0.5] forState:UIControlStateNormal];
    [sendMessageButton setTitleShadowColor:[UIColor colorWithWhite: 0.5 alpha: 0.5] forState:UIControlStateHighlighted];
    sendMessageButton.titleLabel.shadowOffset = CGSizeMake(1, 0);
    sendMessageButton.titleLabel.font = [UIFont boldSystemFontOfSize: 28];
    [sendMessageButton addTarget:self action:@selector(sendMessageClicked) forControlEvents:UIControlEventTouchUpInside];
    
    statusLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    //statusLabel.frame = CGRectMake(0, 0, 20, 20);
    statusLabel.layer.borderWidth=2;
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.shadowColor = [UIColor colorWithWhite: 1 alpha: 0.5];
    statusLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    statusLabel.layer.borderWidth = 2;
    statusLabel.layer.shadowOpacity = 1;
    statusLabel.layer.shadowOffset = CGSizeMake(2, 2);
    statusLabel.layer.shadowRadius = 10;
    statusLabel.backgroundColor = [UIColor redColor];
    statusLabel.font = [UIFont boldSystemFontOfSize: 15];
    statusLabel.textAlignment = UITextAlignmentCenter;
    statusLabel.baselineAdjustment = UIBaselineAdjustmentNone;
    
    [sendMessageButton addSubview: statusLabel];

#ifdef COPD
	UIView * header = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 85)] autorelease];
    [header addSubview: l];
    [header addSubview: checkinButton];
    [header addSubview: sendMessageButton];

    self.tableView.tableHeaderView = header;
#else
	// IN HF targets header is actually a cell
	// ha-ha
	// So just retain buttons we need
	[sendMessageButton retain];
	[statusLabel retain];
#endif
}

- (void)loadFooterView
{
#if HFM
    //Added by Pankil : 09-24-2013
    NSLog(@"account code : %@", [COPDBackend sharedBackend].accountcode);
    NSString *accountCode = [COPDBackend sharedBackend].accountcode;
    //Added by Pankil : 09-24-2013
    UIView * footer = [[[UIView alloc] initWithFrame: CGRectZero] autorelease];
   // footer.layer.borderWidth = 1;
    //Added by Pankil : 09-24-2013
    CGFloat lastY = 0;
    CGFloat padding = 0;
    CGFloat imgWidth = 0;
    CGFloat imgHeight = 0;
    UIButton * adView = [UIButton buttonWithType: UIButtonTypeCustom];
    
    adView = [UIButton buttonWithType: UIButtonTypeCustom];
    //[adView addTarget: self action: @selector(adViewClicked3) forControlEvents: UIControlEventTouchUpInside];
    //2014-04-15 Vipul Add smiley Image
    //adView setImage: [UIImage imageNamed: @"app_logo@2x.png"] forState: UIControlStateNormal];
    [adView setImage: [UIImage imageNamed: @"GoodSmily.png"] forState: UIControlStateNormal];
    //2014-04-15 Vipul Add smiley Image
    imgWidth = adView.currentImage.size.width;
    imgHeight = adView.currentImage.size.height;
    //adView.frame = CGRectMake((620 - imgWidth)/2, lastY + padding, imgWidth, imgHeight);
    
    //akhil 4-2-15
    //IOS Upgradation
    
    if(IS_IPHONE_4_OR_LESS)
    {
        adView.frame = CGRectMake(240/2 , lastY + padding, 80, 80);

    }
    else if (IS_IPHONE_5)
    {
        adView.frame = CGRectMake(250/2 , lastY + padding, 80, 80);

    }
    
    else
    {
        adView.frame = CGRectMake((620 - imgWidth)/2, lastY + padding, imgWidth, imgHeight);

    }
    adView.layer.borderWidth=1;
    //}
    //akhil 4-2-15
    //IOS Upgradation

    [footer addSubview: adView];
    
    //2014-04-15 Vipul Add Smiley Image
    UILabel *lbl = [[UILabel alloc] init];
   // lbl.frame = CGRectMake(195, 165, 250, 32);
    
    //akhil 4-2-15
    //IOS Upgradation
    
    if(IS_IPHONE_4_OR_LESS)
    {
        lbl.frame = CGRectMake(0, 80, 320, 20);
         lbl.font = [UIFont boldSystemFontOfSize:15];
        lbl.textAlignment = NSTextAlignmentCenter;

    }
    else if (IS_IPHONE_5)
    {
        lbl.frame = CGRectMake(0, 80, self.view.frame.size.width, 22);
        lbl.font = [UIFont boldSystemFontOfSize:15];
        lbl.textAlignment = NSTextAlignmentCenter;

    }
    
    else
    {
        lbl.frame = CGRectMake(195, 165, 250, 32);
         lbl.font = [UIFont boldSystemFontOfSize:30];

    }
    //}
    //akhil 4-2-15
    //IOS Upgradation
    lbl.layer.borderWidth=2;
    lbl.text = @"Have a nice day!";
    lbl.textColor = [UIColor whiteColor];
    lbl.backgroundColor = [UIColor clearColor];
   // lbl.font = [UIFont boldSystemFontOfSize:30];
    [footer addSubview:lbl];
    //2014-04-15 Vipul Add Smiley Image
    
    
    //2014-10-16 Vipul
    //if([accountCode isEqualToString:@"morr"] || [accountCode isEqualToString:@"hcar"])
    if([accountCode rangeOfString:@"morr"].location != NSNotFound || [accountCode rangeOfString:@"newt"].location != NSNotFound || [accountCode rangeOfString:@"ovrl"].location != NSNotFound || [accountCode rangeOfString:@"chil"].location != NSNotFound)
    {
        //akhil 29-11-14
        //add click as per account code
        adView = [UIButton buttonWithType: UIButtonTypeCustom];
        [adView addTarget: self action: @selector(adViewClicked2) forControlEvents: UIControlEventTouchUpInside];
        //2014-06-19 Vipul 2x changes
        //[adView setImage: [UIImage imageNamed: @"ahs.png"] forState: UIControlStateNormal];
        //[adView setImage: [UIImage imageNamed: @"ahs@2x.png"] forState: UIControlStateNormal];
        
        
        //2015-01-19 Vipul ios8 Upgradation
        NSString *strVersion = [[UIDevice currentDevice] systemVersion];
        int intVersion = [strVersion integerValue];
        
        if(intVersion > 7)
        {
            [adView setImage: [UIImage imageNamed: @"ahs@2x_ios8.png"] forState: UIControlStateNormal];
        }
        else
        {
            [adView setImage: [UIImage imageNamed: @"ahs@2x.png"] forState: UIControlStateNormal];
        }
        //2015-01-19 Vipul ios8 Upgradation
        
        imgWidth = adView.currentImage.size.width;
        imgHeight = adView.currentImage.size.height;
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        //CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        
        //2014-06-19 Vipul 2x changes
        //adView.frame = CGRectMake((320 - imgWidth)/2, lastY + padding, imgWidth, imgHeight);
       // adView.frame = CGRectMake((640 - imgWidth)/2, (screenHeight)/2, imgWidth, imgHeight);
        
        //akhil 4-2-15
        //IOS Upgradation
        
        if(IS_IPHONE_4_OR_LESS)
        {
              adView.frame = CGRectMake((320 - imgWidth)/2, (screenHeight)/2, imgWidth, imgHeight);
        }
        else if (IS_IPHONE_5)
        {
              adView.frame = CGRectMake((375 - imgWidth)/2, (screenHeight)/2, imgWidth, imgHeight);
        }
        
        else
        {
              adView.frame = CGRectMake((640 - imgWidth)/2, (screenHeight)/2, imgWidth, imgHeight);
        }
        //}
        //akhil 4-2-15
        //IOS Upgradation

        
        [footer addSubview: adView];
        
        lastY = CGRectGetMaxY(adView.frame);
        
        padding = 20;
        //akhil 29-11-14
        //add click as per account code
        
        
        /* [adView addTarget: self action: @selector(adViewClicked1) forControlEvents: UIControlEventTouchUpInside];
         //2014-06-19 Vipul 2x changes
         //[adView setImage: [UIImage imageNamed: @"ahs-hsp.png"] forState: UIControlStateNormal];
         [adView setImage: [UIImage imageNamed: @"ahs-hsp@2x.png"] forState: UIControlStateNormal];
         imgWidth = adView.currentImage.size.width;
         imgHeight = adView.currentImage.size.height;
         //2014-06-19 Vipul 2x changes
         //adView.frame = CGRectMake((320 - imgWidth)/2, 10, imgWidth, imgHeight);
         adView.frame = CGRectMake((640 - imgWidth)/2, 10, imgWidth, imgHeight);
         
         
         [footer addSubview: adView];
         
         lastY = CGRectGetMaxY(adView.frame);
         
         padding = 20;
         
         adView = [UIButton buttonWithType: UIButtonTypeCustom];
         [adView addTarget: self action: @selector(adViewClicked2) forControlEvents: UIControlEventTouchUpInside];
         //2014-06-19 Vipul 2x changes
         //[adView setImage: [UIImage imageNamed: @"ahs.png"] forState: UIControlStateNormal];
         [adView setImage: [UIImage imageNamed: @"ahs@2x.png"] forState: UIControlStateNormal];
         imgWidth = adView.currentImage.size.width;
         imgHeight = adView.currentImage.size.height;
         //2014-06-19 Vipul 2x changes
         //adView.frame = CGRectMake((320 - imgWidth)/2, lastY + padding, imgWidth, imgHeight);
         adView.frame = CGRectMake((640 - imgWidth)/2, lastY + padding, imgWidth, imgHeight);
         
         [footer addSubview: adView];
         */
        //        lastY = CGRectGetMaxY(adView.frame);
        //
        //        if ([Content shared].userIsSmoker)
        //        {
        //            adView = [UIButton buttonWithType: UIButtonTypeCustom];
        //            [adView addTarget: self action: @selector(adViewClicked3) forControlEvents: UIControlEventTouchUpInside];
        //            //2014-06-19 Vipul 2x changes
        //            //[adView setImage: [UIImage imageNamed: @"ala.png"] forState: UIControlStateNormal];
        //            [adView setImage: [UIImage imageNamed: @"ala@2x.png"] forState: UIControlStateNormal];
        //            imgWidth = adView.currentImage.size.width;
        //            imgHeight = adView.currentImage.size.height;
        //            //2014-06-19 Vipul 2x changes
        //            //adView.frame = CGRectMake((320 - imgWidth)/2, lastY + padding, imgWidth, imgHeight);
        //            adView.frame = CGRectMake((640 - imgWidth)/2, lastY + padding, imgWidth, imgHeight);
        //            [footer addSubview: adView];
        //            
        //            lastY = CGRectGetMaxY(adView.frame);
        //        }
    }
    //Added by Pankil : 09-24-2013
    
    
    footer.frame = CGRectMake(0, 0, 320, lastY + 5);
    
    footer.layer.borderWidth = 2;
    footer.layer.borderColor = [[UIColor yellowColor]CGColor];
    self.tableView.tableFooterView = footer;

	/*UIButton *banner = [UIButton buttonWithType:UIButtonTypeCustom];
	[banner addTarget:self action:@selector(adViewClicked4) forControlEvents:UIControlEventTouchUpInside];
	[banner setImage:[UIImage imageNamed:@"health_savings_pass_banner.png"] forState:UIControlStateNormal];
	CGFloat bannerWidth = banner.currentImage.size.width;
	CGFloat bannerHeight = banner.currentImage.size.height;
	banner.frame = CGRectMake((320 - bannerWidth)/2, self.view.frame.size.height - bannerHeight, bannerWidth, bannerHeight);
	[self.view addSubview:banner];*/

#endif
    
#if HFB
    UIButton * adView = [UIButton buttonWithType: UIButtonTypeCustom];
    [adView addTarget: self action: @selector(adViewClicked1) forControlEvents: UIControlEventTouchUpInside];
    [adView setImage: [UIImage imageNamed: @"bh.png"] forState: UIControlStateNormal];
    CGFloat imgWidth = adView.currentImage.size.width;
    CGFloat imgHeight = adView.currentImage.size.height;
    adView.frame = CGRectMake((320 - imgWidth)/2, 5, imgWidth, imgHeight);
    UIView * footer = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, imgHeight+5)] autorelease];
    [footer addSubview: adView];
    self.tableView.tableFooterView = footer;
#endif

#if HFX
	UIButton *adView = [UIButton buttonWithType:UIButtonTypeCustom];
	[adView addTarget:self action:@selector(adViewClicked1) forControlEvents:UIControlEventTouchUpInside];
	[adView setImage:[UIImage imageNamed:@"hearthouse.png"] forState:UIControlStateNormal];
	CGFloat imgWidth = adView.currentImage.size.width;
	CGFloat imgHeight = adView.currentImage.size.height;
	adView.frame = CGRectMake((320 - imgWidth)/2, 5, imgWidth, imgHeight);

	UIView *footer = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, imgHeight + 5)] autorelease];
	[footer addSubview:adView];
	self.tableView.tableFooterView = footer;

	UIButton *banner = [UIButton buttonWithType:UIButtonTypeCustom];
	[banner addTarget:self action:@selector(adViewClicked2) forControlEvents:UIControlEventTouchUpInside];
	[banner setImage:[UIImage imageNamed:@"health_savings_pass_banner.png"] forState:UIControlStateNormal];
	CGFloat bannerWidth = banner.currentImage.size.width;
	CGFloat bannerHeight = banner.currentImage.size.height;
	banner.frame = CGRectMake((320 - bannerWidth)/2, self.view.frame.size.height - bannerHeight, bannerWidth, bannerHeight);
	[self.view addSubview:banner];
#endif
    
}

- (id) infoPlistValueForKey:(NSString *)key
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}

- (void)adViewClicked1
{
#if HFM
    
//    Nilay
//    NSString *errorDesc = nil;
//    NSPropertyListFormat format;
//    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:[[NSBundle mainBundle] pathForResource:@"Info-Stage" ofType:@"plist"]];
//    NSMutableDictionary *properties = (NSMutableDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
//    errorDesc = [NSString stringWithFormat:@"%@",[properties valueForKey:@"imageid"]];
    
//    strImageid = [self infoPlistValueForKey:@"imageid"];
//    if (![strImageid isEqualToString:@"BP-1"]) {
        [InAppBrowserController showFromViewController:self withUrl:@"http://www.atlantichealth.org/gagnon/our+services/treatment+services/heart+success+program/"];
//    }
	
#elif HFB
	[InAppBrowserController showFromViewController:self withUrl:@"http://www.barnabashealth.org/services/cardiac/education/chf_diagnosing.html"];
#elif HFX
	[InAppBrowserController showFromViewController:self withUrl:@"http://www.cadvhearthouse.com/"];
#endif
    // XXX
    //[InAppBrowserController showFromViewController: self withUrl: @"http://www.lungusa.org/lung-disease/copd/"];
}

- (void)adViewClicked2
{
#if HFM
	[InAppBrowserController showFromViewController:self withUrl:@"http://www.atlantichealth.org/morristown/"];
#elif HFX
	[InAppBrowserController showFromViewController:self withUrl:@"http://www.cvs.com/"];
#endif
}

- (void)adViewClicked3
{
#if HFM
	[InAppBrowserController showFromViewController:self withUrl:@"http://www.lung.org/stop-smoking/"];
#elif HFB
    
#endif

}

- (void)adViewClicked4
{
#if HFM
	[InAppBrowserController showFromViewController:self withUrl:@"http://www.cvs.com/"];
#endif
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    //akhil 16-2-15
    //ios update remwove above space on table view
    //self.tableView.tableHeaderView.layer.borderWidth = 2;
    //  self.tableView.tableFooterView.layer.borderWidth = 2;
    
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //akhil 16-2-15
    //ios update remwove above space on table view

	[self loadBrandingViews];
    
    // Jatin Chauhan 22-Nov-2013
    //	self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
       // self.tableView.frame = CGRectMake(65, 50, 640, 832);
    // -Jatin Chauhan 22-Nov-2013
    
    //akhil 4-2-15
    //IOS Upgradation
    
    if(IS_IPHONE_4_OR_LESS)
    {
         self.tableView.frame = CGRectMake(0, 65, 320, 410);
        self.tableView.layer.borderWidth = 1;
        self.tableView.layer.borderColor = [[UIColor redColor]CGColor];
    }
    else if (IS_IPHONE_5)
    {
        self.tableView.frame = CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65);
        self.tableView.layer.borderWidth = 1;
        self.tableView.layer.borderColor = [[UIColor redColor]CGColor];

    }
    
    else
    {
        self.tableView.frame = CGRectMake(65, 50, 640, 832);
    }
    //}
    //akhil 4-2-15
    //IOS Upgradation


    [self.view addSubview:self.tableView];

	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle: @"Help" style: UIBarButtonItemStyleBordered target: self action: @selector(helpClicked)] autorelease];   
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle: @"Log Out" style: UIBarButtonItemStyleBordered target: self action: @selector(logoutClicked)] autorelease];

	[self loadFooterView];
	[self loadHeaderView];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reload) name: kDataWasUpdated object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(recordNeedsToBeDisplayed:) name: kRecordNeedsToBeDisplayed object: nil];
   
    
    
    
	/*[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reload) name: kDataWasUpdated object: nil];
	//[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(responseReceived) name: kResponseReceived object: nil];
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(recordNeedsToBeDisplayed:) name: kRecordNeedsToBeDisplayed object: nil];
	[[Content shared] reload];

#if HFM
	//[[Content shared] checkIfUserSmokerWithCompletiotionBlock:^{
		if ([Content shared].userIsSmoker)
		{
			[self loadFooterView];
			[self loadHeaderView];
		}
	//}];
#endif

	//[self reload];*/
    
    
    //akhil 17-10-13
    //creat method for survey banner
   
    NSString *accountCode = [COPDBackend sharedBackend].accountcode;
    NSLog(@"account code : %@", [COPDBackend sharedBackend].accountcode);
    
    //self.copdUser.objectId
     if(![accountCode isEqualToString:@"morr"] || ![accountCode isEqualToString:@"hcar"])
     {
          if ([[Content shared] handleInternetConnectivity])
          {
               //===workin code
              //akhil 23-10-13
             /* COPDAppDelegate * obj_dele = (COPDAppDelegate *)[[UIApplication sharedApplication]delegate];
              
              [obj_dele.ary_survey removeAllObjects];
              
               COPDUser *user = [COPDBackend sharedBackend].currentUser ;
              NSLog(@"patient id = %@",user.objectId);
              [SurveyBanner get_survey_update:user.objectId target:self selector:@selector(survey_get_fail:error:)];
              
              NSLog(@"obj delegate ary =%@",obj_dele.ary_survey);*/
              //===workin code
              //akhil 23-10-13

              COPDAppDelegate * obj_dele = (COPDAppDelegate *)[[UIApplication sharedApplication]delegate];
              
              [obj_dele.ary_survey removeAllObjects];
              
              NSString *strBaseURL=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"BaseUrl"];
              AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:strBaseURL]] autorelease];
              
              COPDUser *user_new = [COPDBackend sharedBackend].currentUser ;
              NSLog(@"patient id = %@",user_new.objectId);
              
              // NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:user.objectId,@"Patient_ID",@"B7A9AC43-54C8-4AF3-91BB-FB8AF415EB81",@"SurveyID", nil];
              NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:user_new.objectId,@"Patient_ID", nil];
              
              
              [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
              [client setDefaultHeader:@"Accept" value:@"application/json"];
              client.parameterEncoding = AFJSONParameterEncoding;
              
              NSLog(@"%@",param);
              //NSString *strError;
             // [client postPath:@"RegisterForSurvey" parameters:param                       success:^(AFHTTPRequestOperation *operation, id responseObject)
            [client getPath:[NSString stringWithFormat:GET_SURVEY_NEW, user_new.objectId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
               {
                   NSLog(@"RES: %@",[responseObject objectForKey:@"CheckForSurveyResult"]);
                   
                  // NSDictionary *response=[responseObject objectForKey:@"CheckForSurveyResult"];
                   NSDictionary *response=[[[responseObject objectForKey:@"CheckForSurveyResult"] objectForKey:@"Data"] JSONValue];
                   
                   if (response.count>0)
                   {
                       
                       NSMutableDictionary * dict = [[response valueForKey:@"data"]valueForKey:@"Survey"];
                       NSLog(@"dict = %@",dict);
                       NSLog(@"count = %d",dict.count);
                       
                     /*
                       if (![obj_dele.ary_survey containsObject:dict])
                       {
                           [obj_dele.ary_survey addObject:dict];
                       }
                       
                       ///[obj_dele.ary_survey addObject:dict];
                       NSLog(@"obj dele =%@",obj_dele.ary_survey);
                       NSLog(@"obj dele count =%d",obj_dele.ary_survey.count);
                       */
                       
                       if ([dict isKindOfClass:[NSArray class]])
                       {
                           for (NSDictionary *r in dict)
                           {
                               [obj_dele.ary_survey addObject:r];
                               
                           }
                       } else
                       {
                           [obj_dele.ary_survey addObject:dict];
                       }
                       NSLog(@"obj dele =%@",obj_dele.ary_survey);
                       NSLog(@"obj dele count =%d",obj_dele.ary_survey.count);
                       
                       
                   }
                   
                   if (obj_dele.ary_survey>0)
                   {
                       [self load_suevey_footer];
                   }

                   //NSUInteger error=[[responseObject objectForKey:@"Error"] intValue];
                   //strServeyURL =
                   
                  /* strServeyList=[responseObject objectForKey:@"CheckForSurveyResult"] ;
                   
                                   
                   NSLog(@"strServryURL %@",strServeyURL);
                   strServeyList=[[responseObject objectForKey:@"CheckForSurveyResult"]objectForKey:@"data"]; ;
                    NSLog(@"strServryURL %@",strServeyURL);*/
                  // [InAppBrowserController showFromViewController:self withUrl:strServeyURL];
                   
                   // NSLog(@"ERROR: %@",strError);
                   
                   // block(nil);
               }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error)
               {
                   NSLog(@"ERR: %@",error.description);
                   //  block(error);
               }];
              

              
          }
          else
          {
             
          }
     }
    
     [[Content shared] reload];
    //akhil 17-10-13
    
}
- (void)survey_get_fail:(COPDUser*)u error:(NSError**)error
{
    NSLog(@"CALLLLLLLL");
    /*[self showLoading: NO];
    if (u)
    {
        //[Content shared].user = u;
        [Content shared].copdUser = u;
        [self presentMainScreen];
    }
    else
    {*/
       // [self showError:@"Incorrect username or password"];
    [[[[TSAlertView alloc] initWithTitle: @"Response received" message: @"Incorrect username or password" delegate: self cancelButtonTitle:nil otherButtonTitles:@"View Now",nil] autorelease] show];
    //}

}

-(void)load_suevey_footer
{
    COPDAppDelegate * obj_dele = (COPDAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSLog(@"obj delegate ary =%@",obj_dele.ary_survey);
    
    UIView * footer_new = [[[UIView alloc] initWithFrame: CGRectZero] autorelease];
    CGFloat lastY = 0;
    
    /*if ([obj_dele.ary_survey count]>0)
     {
     NSMutableDictionary * dict =[[NSMutableDictionary alloc]init] ;
     for (int i =0; i<[obj_dele.ary_survey count]; i++)
     {
     dict = [obj_dele.ary_survey objectAtIndex:i];
     }
     NSLog(@"dict we get = %@",dict);
     NSLog(@"dict = %@",[dict valueForKey:@"SurveyID"]);
     NSLog(@"dict = %@",[dict valueForKey:@"name"]);
     for (int j =0; j<[dict count]; j++)
     {
     NSLog(@"dict = %@",[[dict valueForKey:@"SurveyID"]objectAtIndex:j]);
     NSLog(@"dict = %@",[dict valueForKey:@"SurveyID"]);
     NSLog(@"dict = %@",[dict valueForKey:@"name"]);
     }
     
     UIButton * btn = [UIButton buttonWithType: UIButtonTypeRoundedRect];
     [btn addTarget: self action: @selector(survey_btn_click:) forControlEvents: UIControlEventTouchUpInside];
     // btn.titleLabel.text = [dict valueForKey:@"name"];
     
     CGFloat imgWidth = 0;
     CGFloat imgHeight = 0;
     
     //[btn setImage: [UIImage imageNamed: @"ahs-hsp.png"] forState: UIControlStateNormal];
     //btn.titleLabel.text = @"text";
     
     [btn setTitle:[dict valueForKey:@"name"] forState:UIControlStateNormal];
     imgWidth = btn.currentImage.size.width;
     NSLog(@"img width = %0.2f",imgWidth);
     imgHeight = btn.currentImage.size.height;
     NSLog(@"img height = %0.2f",imgHeight);
     
     // btn.frame = CGRectMake((320 - imgWidth)/2, 10, imgWidth, imgHeight);
     btn.frame = CGRectMake((320 - 300)/2, 10+lastY, 300, 43);
     
     
     [footer_new addSubview:btn];
     
     lastY = CGRectGetMaxY(btn.frame)+10;
     
     }*/
   
    
    if ([obj_dele.ary_survey count]>0)
    {
        UIButton * adView = [UIButton buttonWithType: UIButtonTypeCustom];
        CGFloat imgWidth = 0;
        CGFloat imgHeight = 0;
        CGFloat padding = 0;
        
        NSMutableDictionary * dict =[[NSMutableDictionary alloc]init] ;
        NSMutableArray * ary_survey_name = [[NSMutableArray alloc]init];
        NSMutableArray * ary_survey_id = [[NSMutableArray alloc]init];

        for (int i =0; i<[obj_dele.ary_survey count]; i++)
        {
            [ary_survey_name addObject:[[obj_dele.ary_survey objectAtIndex:i]objectForKey:@"name"]];
            [ary_survey_id addObject:[[obj_dele.ary_survey objectAtIndex:i]objectForKey:@"SurveyID"]];

            dict = [[obj_dele.ary_survey objectAtIndex:i]objectForKey:@"name"];
        }
        NSLog(@"ary name=%@",ary_survey_name);
        NSLog(@"ary id=%@",ary_survey_id);

        
        // NSMutableDictionary * dict = [obj_dele.ary_survey objectAtIndex:i];
         NSLog(@"dict we get = %@",dict);
        //NSLog(@"dict count = %d",[dict count]);
        //NSLog(@"dict = %@",[dict objectForKey:@"SurveyID"]);
        //NSLog(@"dict = %@",[dict objectForKey:@"name"]);
        
        
              
        //for (int j =0; j<[dict count]; j++)
        for (int j =0; j<[ary_survey_name count]; j++)
        {
           // NSMutableDictionary * dict_test = dict
            
            if (j==0)
            {
                adView = [UIButton buttonWithType: UIButtonTypeCustom];
                //[adView addTarget: self action: @selector(adViewClicked3) forControlEvents: UIControlEventTouchUpInside];
                //2014-04-15 Vipul Add smiley Image
                //adView setImage: [UIImage imageNamed: @"app_logo@2x.png"] forState: UIControlStateNormal];
                [adView setImage: [UIImage imageNamed: @"GoodSmily.png"] forState: UIControlStateNormal];
                //2014-04-15 Vipul Add smiley Image
                imgWidth = adView.currentImage.size.width;
                imgHeight = adView.currentImage.size.height;
                adView.frame = CGRectMake((640 - imgWidth)/2, lastY + padding, imgWidth, imgHeight);
                [footer_new addSubview: adView];
                lastY = CGRectGetMaxY(adView.frame);
             
                //2014-04-15 Vipul Add Smiley Image
                UILabel *lbl = [[UILabel alloc] init];
                lbl.frame = CGRectMake(195, 165, 250, 32);
                lbl.text = @"Have a nice day!";
                lbl.textColor = [UIColor whiteColor];
                lbl.backgroundColor = [UIColor clearColor];
                lbl.font = [UIFont boldSystemFontOfSize:30];
                [footer_new addSubview:lbl];
                //2014-04-15 Vipul Add Smiley Image
            }
            
            UIButton * btn = [UIButton buttonWithType: UIButtonTypeRoundedRect];
            [btn addTarget: self action: @selector(survey_btn_click:) forControlEvents: UIControlEventTouchUpInside];
            // btn.titleLabel.text = [dict valueForKey:@"name"];
            
            
            
            //[btn setImage: [UIImage imageNamed: @"ahs-hsp.png"] forState: UIControlStateNormal];
            //btn.titleLabel.text = @"text";
            
            imgWidth = btn.currentImage.size.width;
            // NSLog(@"img width = %0.2f",imgWidth);
            imgHeight = btn.currentImage.size.height;
            // NSLog(@"img height = %0.2f",imgHeight);
            
            // btn.frame = CGRectMake((320 - imgWidth)/2, 10, imgWidth, imgHeight);
            
            /*CGSize stringsize = [[[dict valueForKey:@"name"]objectAtIndex:j] sizeWithFont:[UIFont systemFontOfSize:14]];
            btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [btn setFrame:CGRectMake((320 - 300)/2,10+lastY,300, stringsize.height)];*/
            
            ///[btn setTitle:[[dict valueForKey:@"name"]objectAtIndex:j] forState:UIControlStateNormal];
           /* if ([dict count]>1)
            {
                NSLog(@"more than one obj");
                btn.titleLabel.text = [[dict objectForKey:@"name"]objectAtIndex:j];
            }
            else
            {
                NSLog(@"only one obj");
                btn.titleLabel.text = [dict objectForKey:@"name"];

            }*/
            // orignal
             //btn.titleLabel.text = [dict objectForKey:@"name"];
              btn.titleLabel.text = [ary_survey_name objectAtIndex:j];
            // orignal
           // btn.titleLabel.text = [[dict objectForKey:@"name"]objectAtIndex:j];
            
            
           // [btn setTitle:[[dict valueForKey:@"name"]objectAtIndex:j];
            

            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 600,90)];
            titleLabel.font = [UIFont boldSystemFontOfSize:28];
            titleLabel.backgroundColor = [UIColor clearColor];
            //titleLabel.layer.borderWidth = 1;
            titleLabel.textAlignment = NSTextAlignmentCenter;
           // titleLabel.text = [[dict objectForKey:@"name"]objectAtIndex:j];
            
           // titleLabel.text = [dict objectForKey:@"name"];
             titleLabel.text = [ary_survey_name objectAtIndex:j];
            titleLabel.numberOfLines = 2;
            titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
            [btn addSubview:titleLabel];
           // btn.frame = titleLabel.frame;
            
            //2014-04-15 Vipul Add New Smiley
            if(j==0)
            {
                btn.frame = CGRectMake((340 - 300)/2, 20+lastY + 45, 600, 90);
            }
            else
            {
                btn.frame = CGRectMake((340 - 300)/2, 20+lastY, 600, 90);
            }
            //2014-04-15 Vipul Add New Smiley
            
            [footer_new addSubview:btn];
            
            lastY = CGRectGetMaxY(btn.frame)+10;
        }
        
        
    }
    
    if ([obj_dele.ary_survey count]>0)
    {
        // footer_new.frame = CGRectMake(0, 0, 320, 200);
        footer_new.frame = CGRectMake(0, 0, 320, lastY + 5);
        
        self.tableView.tableFooterView = footer_new;
    }

}

- (void)viewDidAppear:(BOOL)animated
{
	//[self.tableView reloadData];
    [super viewDidAppear:animated];
}
-(IBAction)survey_btn_click:(UIButton*)sender
{
    //NSLog(@"survery btn tect = %@",[sender titleLabel]);
    
    NSLog(@"The button title is= %@",sender.titleLabel.text);
    COPDAppDelegate * obj_dele = (COPDAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSLog(@"obj delegate ary =%@",obj_dele.ary_survey);
    
    NSString * str_survey_id;
    
    NSMutableArray * ary_survey_name = [[NSMutableArray alloc]init];
    NSMutableArray * ary_survey_id = [[NSMutableArray alloc]init];
    
    if ([obj_dele.ary_survey count]>0)
    {
               
        NSMutableDictionary * dict =[[NSMutableDictionary alloc]init] ;
        for (int i =0; i<[obj_dele.ary_survey count]; i++)
        {
            [ary_survey_name addObject:[[obj_dele.ary_survey objectAtIndex:i]objectForKey:@"name"]];
            [ary_survey_id addObject:[[obj_dele.ary_survey objectAtIndex:i]objectForKey:@"SurveyID"]];
            dict = [obj_dele.ary_survey objectAtIndex:i];
        }
        
        NSLog(@"ary name=%@",ary_survey_name);
        NSLog(@"ary id=%@",ary_survey_id);

        
        // NSMutableDictionary * dict = [obj_dele.ary_survey objectAtIndex:i];
        // NSLog(@"dict we get = %@",dict);
        //NSLog(@"dict = %@",[dict valueForKey:@"SurveyID"]);
        //   NSLog(@"dict = %@",[dict valueForKey:@"name"]);
        
        //for (int j =0; j<[dict count]; j++)
        for (int j =0; j<[ary_survey_name count]; j++)
        {
             NSLog(@"The button title is= %@",sender.titleLabel.text);
             NSLog(@"survey name= %@",[ary_survey_name objectAtIndex:j]);
            NSLog(@"survey id= %@",[ary_survey_id objectAtIndex:j]);

            
            if ([sender.titleLabel.text isEqualToString:[ary_survey_name objectAtIndex:j]])
            {
                NSLog(@"match at = %d",j);
                str_survey_id = [NSString stringWithFormat:@"%@",[ary_survey_id objectAtIndex:j]];
                NSLog(@"str survey id = %@",str_survey_id);
                break;
            }
        }
            
    }
    
    
    NSString *strBaseURL=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"BaseUrl"];
    AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:strBaseURL]] autorelease];
    
    COPDUser *user = [COPDBackend sharedBackend].currentUser ;
    NSLog(@"patient id = %@",user.objectId);

   // NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:user.objectId,@"Patient_ID",@"B7A9AC43-54C8-4AF3-91BB-FB8AF415EB81",@"SurveyID", nil];
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:user.objectId,@"Patient_ID",str_survey_id,@"SurveyID", nil];
    
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    client.parameterEncoding = AFJSONParameterEncoding;
    
    NSLog(@"%@",param);
    //NSString *strError;
    [client postPath:@"RegisterForSurvey" parameters:param
             success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"RES: %@",[responseObject objectForKey:@"ValidatePatientResult"]);
         //NSUInteger error=[[responseObject objectForKey:@"Error"] intValue];
         //strServeyURL =
         
       
         
         // Edited By Jatin Chauhan 11-29-2013

         
         
         
         strServeyURL=[responseObject objectForKey:@"RegisterForSurveyResult"] ;
         NSLog(@"strServryURL %@",strServeyURL);
         [InAppBrowserController showFromViewController:self withUrl:strServeyURL];
       
         
         
         
         
         
//         strServeyURL=[responseObject objectForKey:@"RegisterForSurveyResult"] ;
//         NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",strServeyURL]];
//         //   NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//         [[UIApplication sharedApplication] openURL:url];
//         

         
         
         //- Edited By Jatin Chauhan 11-29-2013
         
         

         
         
         
         
         // NSLog(@"ERROR: %@",strError);
         
         // block(nil);
     }
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERR: %@",error.description);
         //  block(error);
     }];


    
   // NSString * url_new = [NSString stringWithFormat:@"%@",[COPDBackend sharedBackend].baseUrl] ;
   // url_new = [url_new stringByAppendingFormat:@"RegisterForSurvey"];
    
    /*SurveyID = "78F6AB28-252B-4806-8893-0EF382A31BFD";
    name = "Kansas City Cardiomyopathy Questionnaire";
    

    SurveyID = "F768F9FA-5FB8-49A7-934D-6949BFDE7280";
    name = "Moriskey-8";


    SurveyID = "B7A9AC43-54C8-4AF3-91BB-FB8AF415EB81";
    name = "Patient Health Questionnaire(PHQ-2)";*/
    
   
    ///status code
   /* NSURL *url = [NSURL URLWithString:@"http://stackoverflow.com/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
    
   // NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request                                                                  delegate:self];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         
         dispatch_async(dispatch_get_main_queue(), ^{
            // exampleLabel.text = [NSString stringWithFormat:@"%d", httpResponse.statusCode];
             NSLog(@"responce = %d",httpResponse.statusCode);
             NSLog(@"data = %@",data);
         });
     }];*/
    ///status code
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfUnreadReports
{
    NSInteger n = 0;
    for (COPDRecord * record in [Content shared].records)
    {
        if (record.reportStatus == ReportStatusSentToPatient)
        {
            n++;
        }
    }
    return n;
}

- (NSArray *)unreadReports
{
    NSMutableArray * a = [NSMutableArray array];
    
    for (COPDRecord * record in [Content shared].records)
    {
        if (record.reportStatus == ReportStatusSentToPatient)
        {
            [a addObject: record];
        }
    }
    return a;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)table
{
	if (![Content shared].reloadOccured)
	{
		return 0;
	}

#if COPD
	if ([self numberOfUnreadReports] > 0)
	{
		return 2;
	}

	return 1;
#else

	return 1;
#endif

}

- (NSString *)tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section
{
#if COPD
    if ([self numberOfUnreadReports] > 0 && section == 0)
    {
        return @"My Inbox";
    }
#else
	if (section == 0)
	{
		return @"iT3 Heart Failure";
        
	}
    #endif
    return nil;
}

//2014-09-11 Vipul Add track, target, treat lable
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.text = [tableViewHeaderFooterView.textLabel.text capitalizedString];
        tableViewHeaderFooterView.layer.borderWidth=2;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(IS_IPHONE_4_OR_LESS)
    {
        return 25;
    }
    else if (IS_IPHONE_5)
    {
       return 25;
    }
    
    else
    {
        return 50;
        
    }

}
//2014-09-11 Vipul Add track, target, treat lable

- (UIView *)tableView:(UITableView *)table viewForHeaderInSection:(NSInteger)section
{    
    UILabel * l = [self titleLabel];
    l.text = [self tableView:table titleForHeaderInSection: section];

    //2014-09-11 Vipul Add track, target, treat lable
    //UIView* v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)] autorelease];
    //UIView* v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 620, 35)] autorelease];
    UIView* v = [[[UIView alloc] init] autorelease];

    v.backgroundColor = [UIColor clearColor];
    
    if(IS_IPHONE_4_OR_LESS)
    {
        v.frame = CGRectMake(0, 0, 320, 10);
    }
    else if (IS_IPHONE_5)
    {
        v.frame = CGRectMake(0, 0, self.view.frame.size.width, 18);

    }
    
    else
    {
        v.frame = CGRectMake(0, 0, 620, 35);

    }

    
    //2014-09-11 Vipul Add track, target, treat lable
    UILabel * ltext = [self titleTextLable];
    ltext.text = @"TRACK, TARGET, TREAT";
    [v addSubview:ltext];
    //2014-09-11 Vipul Add track, target, treat lable
    v.layer.borderWidth = 2;
    [v addSubview: l];
    return v;
}








- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
#if COPD
    if ([self numberOfUnreadReports] > 0 && section == 0)
    {
        return [self numberOfUnreadReports];
    }
#endif
	return 1;
}





// Jatin Chauhan 22-nov-13

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(IS_IPHONE_4_OR_LESS)
    {
       return 60;
        
    }
    else if (IS_IPHONE_5)
    {
          return 60;
    }
    
    else
    {
        return 120;
    }
  return 0;

  //  return 120;
}

// -Jatin Chauhan 22-nov-13





- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#if COPD
    if (indexPath.section == 0 && [self numberOfUnreadReports] > 0)
    {

        COPDRecord * rec = [[self unreadReports] objectAtIndex: indexPath.row];

        RecordCell * cell = (RecordCell *)[table dequeueReusableCellWithIdentifier: @"recCell"];
        if (!cell)
        {
            cell = [[[RecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"recCell"] autorelease];
        }
        [cell updateWithRecordForHistory: rec];

        return cell;
    }
	else
    {
        UITableViewCell * cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: nil] autorelease];
        cell.textLabel.text = @"View all check-ins & responses";
        cell.textLabel.font = [UIFont boldSystemFontOfSize: 30];//15 - Jatin Chauhan 28-Nov-2013
        
        if ([[Content shared].records count] == 0)
        {
            cell.detailTextLabel.text = @"You haven't checked in yet.";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = [NSString stringWithFormat: @"You have completed %d check-ins", [[Content shared].records count]];
        }
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize: 26];// 13 - Jatin Chauhan 28-Nov-2013
        
        cell.imageView.image = [UIImage imageNamed: @"calendar.png"];
        return cell;
    }
    return nil;
#else
    
    
    
    
    
    
	if (indexPath.section == 0)
	{
		UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
        
        NSLog(@"Testing Of Cell text new %@",cell);
        
        // Jatin Chauhan 22-Nov-2013
        
//        [cell setFrame:CGRectMake(100, 100, 100, 100)];
//
 //       cell.layer.borderWidth =1;
   //     cell.layer.borderColor = [[UIColor orangeColor]CGColor];
//        
        // -Jatin Chauhan 22-Nov-2013
      /*  if(IS_IPHONE_4_OR_LESS)
        {
            [cell setFrame:CGRectMake(0, 50, self.view.frame.size.width, 45)];
        }
        else if (IS_IPHONE_5)
        {
            
        }
        
        else
        {
            
        }*/

        
        
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor clearColor];
		cell.contentView.backgroundColor = [UIColor clearColor];

		UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        

        // Jatin Chauhan
//        
//            UIView *backView = [[[UIView alloc] initWithFrame:CGRectMake(500, 500, 500, 500)] autorelease];
//        NSLog(@"Dimension is :%@",backView);
//
        
        // -Jatin Chauhan
        
		backView.backgroundColor = [UIColor clearColor];
		cell.backgroundView = backView;
        
//        backView.layer.borderWidth=8;
//        backView.layer.borderColor=[[UIColor blueColor]CGColor];

      
		UIButton *checkinButton = [UIButton buttonWithType:UIButtonTypeCustom];
		//checkinButton.frame = CGRectMake(-20, 15, 288, 90);
        //checkinButton.frame = CGRectMake(0, 35, 144, 45);
        //akhil 4-2-15
        //IOS Upgradation
        
        if(IS_IPHONE_4_OR_LESS)
        {
            checkinButton.frame = CGRectMake(10, 7, self.view.frame.size.width/2-15, 45);
            checkinButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        }
        else if (IS_IPHONE_5)
        {
            checkinButton.frame = CGRectMake(10, 7, self.view.frame.size.width/2-15, 45);
            checkinButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        }
        
        else
        {
            checkinButton.frame = CGRectMake(-20, 15, 288, 90);
            checkinButton.titleLabel.font = [UIFont boldSystemFontOfSize:28];
        }
        //}
        //akhil 4-2-15
        //IOS Upgradation

        
		[checkinButton setBackgroundImage:[UIImage imageNamed:@"blue-btn@2x"] forState:UIControlStateNormal];
		[checkinButton setTitle:@"CHECK IN" forState:UIControlStateNormal];

		[checkinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[checkinButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
		[checkinButton setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.5] forState:UIControlStateNormal];
		checkinButton.titleLabel.shadowOffset = CGSizeMake(1, 0);
		//checkinButton.titleLabel.font = [UIFont boldSystemFontOfSize:28];
		[checkinButton addTarget:self action:@selector(checkInClicked) forControlEvents:UIControlEventTouchUpInside];

		//sendMessageButton.frame = CGRectMake(295, 15, 288, 90);
        
        //akhil 4-2-15
        //IOS Upgradation
        
        if(IS_IPHONE_4_OR_LESS)
        {
            sendMessageButton.frame = CGRectMake(160, 7, self.view.frame.size.width/2-15, 45);
            sendMessageButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];

        }
        else if (IS_IPHONE_5)
        {
            sendMessageButton.frame = CGRectMake(160, 7, self.view.frame.size.width/2-15, 45);
               sendMessageButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        }
        
        else
        {
            sendMessageButton.frame = CGRectMake(-20, 15, 288, 90);
        }
        //}
        //akhil 4-2-15
        //IOS Upgradation

        
      

        cell.layer.borderWidth = 2;
        cell.layer.borderColor = [[UIColor redColor]CGColor];
        
		[cell.contentView addSubview:checkinButton];
		[cell.contentView addSubview:sendMessageButton];
        return cell;
	}
	return nil;
#endif
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifndef COPD
	return;
#endif

    if (indexPath.section == 0 && [self numberOfUnreadReports] > 0)
    {
        COPDRecord * rec = [[self unreadReports] objectAtIndex: indexPath.row];

        AnswerViewController * vc  = [[[AnswerViewController alloc] init] autorelease];

		vc.record = rec;
        [self.navigationController pushViewController: vc animated: YES];
    }
    else
    {
        ReportsViewController * vc  = [[[ReportsViewController alloc] initWithStyle: UITableViewStyleGrouped] autorelease];
         
        [self.navigationController pushViewController: vc animated: YES];
    }
}

@end
