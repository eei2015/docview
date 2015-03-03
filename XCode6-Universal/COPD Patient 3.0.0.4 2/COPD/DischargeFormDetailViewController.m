//
//  PatientDischargeFormDetailViewController.m
//  COPD
//
//  Created by Abbas Agha on 15/05/13.
//  Copyright (c) 2013 TKInteractive. All rights reserved.
//

#import "DischargeFormDetailViewController.h"
#import "Content.h"

#import <EventKit/EKEvent.h>
#import <EventKit/EKEventStore.h>

@interface DischargeFormDetailViewController ()<UIWebViewDelegate>
{
    UIWebView *webview;
    NSMutableArray *formData;
    NSString *strCardiacDischargeFormDate;
}
@property(nonatomic,retain)NSMutableArray *formData;
@property(nonatomic,assign)NSString *strCardiacDischargeFormDate;
-(void)loadPatientInstructionForm;
-(void)loadCardiacDischargeForm;
@end

@implementation DischargeFormDetailViewController
@synthesize formType,pMedications,formData;
@synthesize eventStore,strCardiacDischargeFormDate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize an event store object with the init method. Initilize the array for events.
    self.eventStore = [[[EKEventStore alloc] init] autorelease];
    
    
}
-(void)dealloc
{
    eventStore=nil;
    
    webview=nil;
    strCardiacDischargeFormDate=nil;
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    __block NSString *htmlFile=@"";
    webview=[[UIWebView alloc] initWithFrame:self.view.frame];
    [webview setBackgroundColor:[UIColor grayColor]];
    webview.delegate=self;
    [self.view addSubview:webview];
    
    Content *content=[Content shared];
    
    [content queryDischargeFormDetail:self.formType WithBlock:^(NSMutableArray *data, NSError *errorOrnil) {
        //
        self.formData=[NSMutableArray arrayWithArray:data];
        //NSLog(@"Count: %d",data.count);
        NSString* htmlString=@"";
        switch (formType) {
            case 2:
                //
                htmlFile = [[NSBundle mainBundle] pathForResource:@"patient-family-instructions" ofType:@"html"];
                htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
                break;
                
            case 3:
                //
                
            {
                //2013-12-05 Vipul
                //DischargeFormContent *df=(DischargeFormContent*)[self.formData objectAtIndex:0];
                //htmlString =df.DFormValue;
                htmlFile = [[NSBundle mainBundle] pathForResource:@"Wellness-Pateint-EducationForm" ofType:@"html"];
                htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
                break;
                //2013-12-05 Vipul
            }
                
                break;
            case 4:
                //
                htmlFile = [[NSBundle mainBundle] pathForResource:@"cardiac-discharge-instructions" ofType:@"html"];
                htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
                break;
            default:
                break;
        }
        
        
        
        [webview setDataDetectorTypes: UIDataDetectorTypeAll];
        [[webview scrollView] setBounces:FALSE];
        
        [webview loadHTMLString:htmlString baseURL:nil];
        
        //NSString *replace = @\"some replacement text\";
        //NSLog(@"DFormTitle: %@",object.DFormTitle);
    }];
    
    
    
    //[webView loadHTMLString:htmlString baseURL:nil];
}
-(void)loadPatientInstructionForm
{
    NSMutableString *strScript=[[[NSMutableString alloc] init] autorelease];
    NSArray *arrDOB=[[[Content shared].copdUser objectForKey:@"Patient_DOB"]  componentsSeparatedByString:@" "];
    NSString *strDOB=@"";
    if (arrDOB && arrDOB.count>1) {
        strDOB=[arrDOB objectAtIndex:0];
    }
    
    
    //2013-12-03 Vipul
    //[strScript appendFormat:@"document.getElementById('dischargeValue').innerHTML='%@ ';", [[Content shared] userDischargedDate]];
    //2013-12-03 Vipul;
    [strScript appendFormat:@"document.getElementById('pnameValue').innerHTML='%@ %@ ';", [[Content shared] userFirstName], [[Content shared] userLastName]];
    [strScript appendFormat:@"document.getElementById('dobValue').innerHTML='%@ ';",strDOB];
    
    NSMutableString *strMeds=[[[NSMutableString alloc] init] autorelease];
    
    
    
    //[strMeds appendFormat:@"%@",@"<table border=\"1\"><tr><td>HELLO</td></tr>"];
    
    [strMeds appendFormat:@"%@",@"<table  width=\"100%\" border=\"1\" class=\"mediTable\"><tr bgcolor=\"#ccc\">"];
    [strMeds appendString:@"<th width=\"34%\">Medications</th>"];
    [strMeds appendString:@"<th width=\"33%\">Dosage</th>"];
//Nilay    [strMeds appendString:@"<th width=\"33%\">Fequency</th>"];
    [strMeds appendString:@"<th width=\"33%\">Frequency</th>"];
    [strMeds appendString:@"</tr>"];
    
    if (self.pMedications.count>0) {
        for (int i=0; i<self.pMedications.count; i++) {
            Medication *med=[self.pMedications objectAtIndex:i];
            [strMeds appendFormat:@"%@",@"<tr>"];
            [strMeds appendFormat:@"<td>%@</td>",med.MedicationTitle];
            [strMeds appendFormat:@"<td>%@</td>",med.MedicationDosageValue];
            [strMeds appendFormat:@"<td>%@</td>",med.FrequencyCode];
            [strMeds appendFormat:@"%@",@"</tr>"];
            
        }
    }
    [strMeds appendFormat:@"%@",@"</table>"];
    
    //  NSLog(@"Meds: %@",strMeds);
    DischargeFormContent *object=(DischargeFormContent*)[self.formData objectAtIndex:0];
    
    
    //2013-12-03 Vipul
    //[strScript appendFormat:@"document.getElementById('medTitle').innerHTML='%@';", object.DFormTitle];
    //[strScript appendFormat:@"document.getElementById('medValue').innerHTML='%@';", object.DFormValue];
    NSError *error = nil;
    NSRegularExpression *regex =
    [NSRegularExpression
     regularExpressionWithPattern:@"'"
     options:NSRegularExpressionCaseInsensitive
     error:&error];
    
    // Replace the matches
    NSString *modifiedString =
    [regex stringByReplacingMatchesInString:object.DFormValue options:0 range:NSMakeRange(0, [object.DFormValue length]) withTemplate:@"\""];
    [strScript appendFormat:@"document.getElementById('medValue').innerHTML='%@';", modifiedString];
    //2013-12-03 Vipul

    
    //Medications
    [strScript appendFormat:@"document.getElementById('tableMedication').innerHTML='%@';", strMeds];
    
    
    object=(DischargeFormContent*)[self.formData objectAtIndex:1];
    [strScript appendFormat:@"document.getElementById('dailyweightTitle').innerHTML='%@';", object.DFormTitle];
    [strScript appendFormat:@"document.getElementById('dailyweightValue').innerHTML='%@';", object.DFormValue];
    
    //2013-12-03 Vipul
    //    object=(DischargeFormContent*)[self.formData objectAtIndex:2];
    //    [strScript appendFormat:@"document.getElementById('exerciseTitle').innerHTML='%@';", object.DFormTitle];
    //    [strScript appendFormat:@"document.getElementById('exerciseValue').innerHTML='%@';", object.DFormValue];
    //
    //    object=(DischargeFormContent*)[self.formData objectAtIndex:3];
    //    [strScript appendFormat:@"document.getElementById('dietTitle').innerHTML='%@';", object.DFormTitle];
    //    [strScript appendFormat:@"document.getElementById('dietValue').innerHTML='%@';", object.DFormValue];
    //
    //    object=(DischargeFormContent*)[self.formData objectAtIndex:4];
    //    [strScript appendFormat:@"document.getElementById('nosmokingTitle').innerHTML='%@';", object.DFormTitle];
    //    [strScript appendFormat:@"document.getElementById('nosmokingValue').innerHTML='%@';", object.DFormValue];
    //
    //    object=(DischargeFormContent*)[self.formData objectAtIndex:5];
    //    [strScript appendFormat:@"document.getElementById('alcoholTitle').innerHTML='%@';", object.DFormTitle];
    //    [strScript appendFormat:@"document.getElementById('alcoholValue').innerHTML='%@';", object.DFormValue];
    //2013-12-03 Vipul
    
    //2013-12-05 Vipul
    //object=(DischargeFormContent*)[self.formData objectAtIndex:6];
    object=(DischargeFormContent*)[self.formData objectAtIndex:2];
    [strScript appendFormat:@"document.getElementById('callTitle').innerHTML='%@';", object.DFormTitle];
    [strScript appendFormat:@"document.getElementById('callValue').innerHTML='%@';", object.DFormValue];
    
    //2013-12-05 Vipul
    //object=(DischargeFormContent*)[self.formData objectAtIndex:7];
    object=(DischargeFormContent*)[self.formData objectAtIndex:3];
    [strScript appendFormat:@"document.getElementById('appointTitle').innerHTML='%@';", object.DFormTitle];
    [strScript appendFormat:@"document.getElementById('appointValue').innerHTML='%@';", object.DFormValue];
    
    //2013-12-05 Vipul
    //object=(DischargeFormContent*)[self.formData objectAtIndex:8];
    object=(DischargeFormContent*)[self.formData objectAtIndex:4];
    [strScript appendFormat:@"document.getElementById('dateTitle').innerHTML='%@';", object.DFormTitle];
    [strScript appendFormat:@"document.getElementById('dateValue').innerHTML='%@';", object.DFormValue];
    
    //2013-12-03 Vipul
    //    object=(DischargeFormContent*)[self.formData objectAtIndex:9];
    //    [strScript appendFormat:@"document.getElementById('labworkTitle').innerHTML='%@: ';", object.DFormTitle];
    //    [strScript appendFormat:@"document.getElementById('labworkValue').innerHTML='%@';", object.DFormValue];
    //
    //    object=(DischargeFormContent*)[self.formData objectAtIndex:10];
    //    [strScript appendFormat:@"document.getElementById('testingTitle').innerHTML='%@: ';", object.DFormTitle];
    //    [strScript appendFormat:@"document.getElementById('testingValue').innerHTML='%@';", object.DFormValue];
    //2013-12-03 Vipul
    
    NSMutableString *newStrScript = [[strScript componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    
    [webview stringByEvaluatingJavaScriptFromString:newStrScript];
    
}
-(void)loadCardiacDischargeForm
{
    NSMutableString *strScript=[[[NSMutableString alloc] init] autorelease];
    // Jatin Chauhan 06-Dec-2013
    //  [strScript appendFormat:@"document.getElementById('dischargeValue').innerHTML='%@ ';", [[Content shared] userDischargedDate]];
    // -Jatin Chauhan 06-Dec-2013;
    [strScript appendFormat:@"document.getElementById('pnameValue').innerHTML='%@ %@ ';", [[Content shared] userFirstName], [[Content shared] userLastName]];
    
    // Jatin Chauhan 06-Dec-2013
    NSArray *arrDOB=[[[Content shared].copdUser objectForKey:@"Patient_DOB"]  componentsSeparatedByString:@" "];
    NSString *strDOB=@"";
    if (arrDOB && arrDOB.count>1) {
        strDOB=[arrDOB objectAtIndex:0];
    }
    [strScript appendFormat:@"document.getElementById('dobValue').innerHTML='%@' ;", strDOB];
    // -Jatin Chauhan 06-Dec-2013
    
    DischargeFormContent *object=(DischargeFormContent*)[self.formData objectAtIndex:0];
    // Jatin Chauhan 06-Dec-2013
    NSString *CardiacData = [[NSString alloc] initWithString:object.DFormValue];
    
    CardiacData = [[CardiacData componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    CardiacData = [CardiacData stringByReplacingOccurrencesOfString:@"Activation of EMS - 911" withString:@"<center><font size=\"3\">Activation of EMS - 911</font></center>"];
    CardiacData = [CardiacData stringByReplacingOccurrencesOfString:@"Warning Signs and Symptoms" withString:@"<center><font size=\"3\">Warning Signs and Symptoms</font></center>"];
    CardiacData = [NSString stringWithFormat:@"%@%@%@", @"<font size=\"2\">",CardiacData , @"</font>"];
    
    CardiacData = [CardiacData stringByReplacingOccurrencesOfString:@"<td" withString:@"<td style=\"font-size:12px;\""];
    CardiacData = [CardiacData stringByReplacingOccurrencesOfString:@"<th" withString:@"<th style=\"font-size:12px;\""];
    // [strScript appendFormat:@"document.getElementById('activityTitle').innerHTML='%@';", object.DFormTitle];
    [strScript appendFormat:@"document.getElementById('divCarddiacDischargeForm').innerHTML='%@';", CardiacData];//('activityValue').innerHTML
    // -Jatin Chauhan 06-Dec-2013
    
    
    //2014-01-28 Vipul (Merged application of 2.5)
//    object=(DischargeFormContent*)[self.formData objectAtIndex:1];
//    [strScript appendFormat:@"document.getElementById('drivingTitle').innerHTML='%@';", object.DFormTitle];
//    [strScript appendFormat:@"document.getElementById('drivingValue').innerHTML='%@';", object.DFormValue];
//    
//    object=(DischargeFormContent*)[self.formData objectAtIndex:2];
//    [strScript appendFormat:@"document.getElementById('bathingTitle').innerHTML='%@';", object.DFormTitle];
//    [strScript appendFormat:@"document.getElementById('bathingValue').innerHTML='%@';", object.DFormValue];
//    
//    object=(DischargeFormContent*)[self.formData objectAtIndex:3];
//    [strScript appendFormat:@"document.getElementById('walkingTitle').innerHTML='%@';", object.DFormTitle];
//    [strScript appendFormat:@"document.getElementById('walkingValue').innerHTML='%@';", object.DFormValue];
//    
//    object=(DischargeFormContent*)[self.formData objectAtIndex:4];
//    [strScript appendFormat:@"document.getElementById('returnWorkTitle').innerHTML='%@';", object.DFormTitle];
//    [strScript appendFormat:@"document.getElementById('returnWorkValue').innerHTML='%@';", object.DFormValue];
//    
//    object=(DischargeFormContent*)[self.formData objectAtIndex:5];
//    [strScript appendFormat:@"document.getElementById('returnActiveTitle').innerHTML='%@';", object.DFormTitle];
//    [strScript appendFormat:@"document.getElementById('returnActiveValue').innerHTML='%@';", object.DFormValue];
//    
//    object=(DischargeFormContent*)[self.formData objectAtIndex:6];
//    [strScript appendFormat:@"document.getElementById('precautionsTitle').innerHTML='%@';", object.DFormTitle];
//    [strScript appendFormat:@"document.getElementById('precautionsValue').innerHTML='%@';", object.DFormValue];
//    
//    object=(DischargeFormContent*)[self.formData objectAtIndex:7];
//    [strScript appendFormat:@"document.getElementById('dietTitle').innerHTML='%@';", object.DFormTitle];
//    [strScript appendFormat:@"document.getElementById('dietValue').innerHTML='%@';", object.DFormValue];
//    
//    object=(DischargeFormContent*)[self.formData objectAtIndex:8];
//    [strScript appendFormat:@"document.getElementById('spclInstructionTitle').innerHTML='%@';", object.DFormTitle];
//    [strScript appendFormat:@"document.getElementById('spclInstructionValue').innerHTML='%@';", object.DFormValue];
//    
//    object=(DischargeFormContent*)[self.formData objectAtIndex:9];
//    [strScript appendFormat:@"document.getElementById('pneumTitle').innerHTML='%@';", object.DFormTitle];
//    [strScript appendFormat:@"document.getElementById('pneumValue').innerHTML='%@';", object.DFormValue];
//    
//    object=(DischargeFormContent*)[self.formData objectAtIndex:10];
//    [strScript appendFormat:@"document.getElementById('influenzaTitle').innerHTML='%@';", object.DFormTitle];
//    [strScript appendFormat:@"document.getElementById('influenzaValue').innerHTML='%@';", object.DFormValue];
//    
//    
//    object=(DischargeFormContent*)[self.formData objectAtIndex:11];
//    
//    [strScript appendFormat:@"document.getElementById('followUpDoctorValue').innerHTML='%@';", object.DFormValue];
//    
//    object=(DischargeFormContent*)[self.formData objectAtIndex:12];
//    [strScript appendFormat:@"document.getElementById('followUpTitle').innerHTML='%@';", object.DFormTitle];
//    [strScript appendFormat:@"document.getElementById('followUpDateValue').innerHTML='%@';", object.DFormValue];
//    
//    self.strCardiacDischargeFormDate=object.DFormValue; // store date
//    
//    //  NSLog(@"Date:%@",self.strCardiacDischargeFormDate);
//    
//    object=(DischargeFormContent*)[self.formData objectAtIndex:13];
//    [strScript appendFormat:@"document.getElementById('followUpContactValue').innerHTML='%@';", object.DFormValue];
//    
//2014-01-28 Vipul (Merged application of 2.5)
    
    NSMutableString *newStrScript = [[strScript componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    
    [webview stringByEvaluatingJavaScriptFromString:newStrScript];
         
}
//2013-12-05 Vipul
-(void)loadWellnessPateintEducationForm
{
    NSMutableString *strScript=[[[NSMutableString alloc] init] autorelease];
    NSArray *arrDOB=[[[Content shared].copdUser objectForKey:@"Patient_DOB"]  componentsSeparatedByString:@" "];
    NSString *strDOB=@"";
    if (arrDOB && arrDOB.count>1) {
        strDOB=[arrDOB objectAtIndex:0];
    }
    [strScript appendFormat:@"document.getElementById('pnameValue').innerHTML='%@ %@ ';", [[Content shared] userFirstName], [[Content shared] userLastName]];
    [strScript appendFormat:@"document.getElementById('dobValue').innerHTML='%@';", strDOB];
    
    NSString *strFormData = [[[NSMutableString alloc] init] autorelease];
    for (int i=0; i< [self.formData count]; i++) {
        DischargeFormContent *object=(DischargeFormContent*)[self.formData objectAtIndex:i];
        strFormData = [[[strFormData stringByAppendingString:@"<p><b>"] stringByAppendingString:object.DFormTitle] stringByAppendingString:@"</b><br/>"];
        strFormData = [[strFormData stringByAppendingString:object.DFormValue] stringByAppendingString:@"</p>"];
    }
    
    [strScript appendFormat:@"document.getElementById('DivPWEContent').innerHTML='%@';", strFormData];
    
    NSMutableString *newStrScript = [[strScript componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    
    [webview stringByEvaluatingJavaScriptFromString:newStrScript];
}
//2013-12-05 Vipul
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (formType==PatientInstructionForm) {
        [self loadPatientInstructionForm];
    } else if(formType==CardiacDischargeForm)
    {
        [self loadCardiacDischargeForm];
    }
    //2013-12-05 Vipul
    else if(formType==Wellness_Pateint_EducationForm)
    {
        [self loadWellnessPateintEducationForm];
    }
    //2013-12-05 Vipul
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if(navigationType==UIWebViewNavigationTypeLinkClicked)
    {
        NSString *strLink=[request.URL fragment];
        
        if ([strLink isEqualToString:@"date"]) {
            //
            [self addEvent];
            return TRUE;
        }
        
    }
    
    return  TRUE;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma EVENT KIT

// If event is nil, a new event is created and added to the specified event store. New events are
// added to the default calendar. An exception is raised if set to an event that is not in the
// specified event store.
- (void)addEvent {
	// When add button is pushed, create an EKEventEditViewController to display the event.
	EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
	EKEvent * event = [EKEvent eventWithEventStore:eventStore];
    
    //NSLog(@"Date:%@",self.strCardiacDischargeFormDate);
    NSArray *arrDate=[self.strCardiacDischargeFormDate componentsSeparatedByString:@"/"];
    if ([arrDate count]>2) {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:[[arrDate objectAtIndex:2] integerValue]];
        [comps setMonth:[[arrDate objectAtIndex:0] integerValue]];
        [comps setDay:[[arrDate objectAtIndex:1] integerValue]];
        //  [comps setHour:0];
        //[comps setMinute:0];
        [comps setTimeZone:[NSTimeZone systemTimeZone]];
        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *eventDateAndTime = [cal dateFromComponents:comps];
        
        // NSDate *duedate = [NSDate date];
        event.startDate =eventDateAndTime;
        event.endDate= eventDateAndTime;//[[NSDate alloc] initWithTimeInterval:600 sinceDate:duedate];
        
        addController.event = event;
        
    }
    
    addController.eventStore = self.eventStore;
    
    // present EventsAddViewController as a modal view controller
    [self presentModalViewController:addController animated:YES];
    
    addController.editViewDelegate = self;
    [addController release];
    
    /* [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
     if (granted){
     // Set the Date and Time for the Event
     // set the addController's event store to the current event store.
     
     addController.eventStore = self.eventStore;
     
     // present EventsAddViewController as a modal view controller
     [self presentModalViewController:addController animated:YES];
     
     addController.editViewDelegate = self;
     [addController release];
     }else
     
     {
     
     // NSLog(@"%@",error);
     
     
     //UIAlertView *alert=[[[UIAlertView alloc] initWithTitle:@"Information" message:@"This app does not have access to your calendars. You can enable access in privacy settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
     
     //[alert show];
     
     // [webview reload];
     //----- code here when user does NOT allow your app to access their calendar.
     [event setCalendar:[eventStore defaultCalendarForNewEvents]];
     NSError *err;
     [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
     
     
     }
     }];*/
    
}

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller
          didCompleteWithAction:(EKEventEditViewAction)action {
	
	NSError *error = nil;
	EKEvent *thisEvent = controller.event;
	
	switch (action) {
		case EKEventEditViewActionCanceled:
			// Edit action canceled, do nothing.
			break;
			
		case EKEventEditViewActionSaved:
			// When user hit "Done" button, save the newly created event to the event store,
			// and reload table view.
			// If the new event is being added to the default calendar, then update its
			// eventsList.
			
			[controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
			break;
			
		case EKEventEditViewActionDeleted:
			// When deleting an event, remove the event from the event store,
			// and reload table view.
			// If deleting an event from the currenly default calendar, then update its
			// eventsList.
			
			[controller.eventStore removeEvent:thisEvent span:EKSpanThisEvent error:&error];
			
			break;
			
		default:
			break;
	}
	// Dismiss the modal view controller
	[controller dismissModalViewControllerAnimated:YES];
    
	
}



#pragma END EVENT KIT
@end
