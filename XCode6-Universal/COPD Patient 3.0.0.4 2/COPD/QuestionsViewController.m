#import "QuestionsViewController.h"
#import "UIViewController+Branding.h"
#import "StepsProgressView.h"
#import "LayoutView.h"
#import "BaseQuestionController.h"
#import "Content.h"
#import "BreathlessnessQuestionController.h"
#import "SputumQuantityQuestionController.h"
#import "SputumColorQuestionController.h"
#import "SputumConsistencyQuestionController.h"
#import "DigitsQuestionController.h"
#import "TempQuestionController.h"
#import "OthersQuestionController.h"
#import "SummaryViewController.h"
#import "SubmitViewController.h"
#import "SelectorQuestionController.h"
#import "MoodQuestionController.h"
#import "CHFBreathQuestionController.h"
#import "SimpleQuestionController.h"
#import "BodyQuestionController.h"
#import "TSAlertView.h"
#import "Crittercism.h"

#if COPD
#import "InAppBrowserController.h"
#else
#import "HelpViewController.h"
#endif

#define BUTTON_HEIGHT 42.0f
#define STEPS_PROGRESS_VIEW_HEIGHT 42.0f

@interface QuestionsViewController () <LayoutViewDelegate, UINavigationControllerDelegate>

- (void)updateControls:(BOOL)animated;
- (UIViewController *)loadQuestionControllerForIndex:(NSInteger)index;

@end

@implementation QuestionsViewController
@synthesize record,questions,patientRecordSet;
//akhil 27-11-13

@synthesize patientRecordSet_temp;
//@synthesize patientRecordSet_after_body;
// Jatin Chauhan 05-Dec-2013


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.record = [[[COPDRecord alloc] init] autorelease];
        self.questions=[[Content shared] questions];
        self.patientRecordSet=[[[NSMutableArray alloc] init] autorelease];
        //akhil 27-11-13
        self.patientRecordSet_temp=[[[NSMutableArray alloc] init] autorelease];
        
        // Jatin Chauhan 05-Dec-2013
        
   //     self.patientRecordSet_after_body=[[[NSMutableArray alloc] init] autorelease];
        
        // -Jatin Chauhan 05-Dec-2013
        navigationController = [[UINavigationController alloc] initWithRootViewController: [self loadQuestionControllerForIndex: 0]];
         navigationController.navigationBarHidden = YES;
        navigationController.delegate = self;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) dealloc
{
    self.record = nil;
    self.questions=nil;
    self.patientRecordSet=nil;
    self.patientRecordSet_temp=Nil;
    
    [navigationController release];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [super dealloc];
}

#pragma mark - utils

- (BaseQuestionController *)lastController
{
    return [navigationController.viewControllers lastObject];
}

#pragma mark - actions

- (void)cancelClicked
{
    // Jatin Chauhan - 26-Nov-2013
    
    TSAlertView* alert = [[[TSAlertView alloc] initWithTitle: @"Please Confirm" message: @"Do you really want to cancel?" delegate: self cancelButtonTitle:@"No" otherButtonTitles: @"Yes", nil] autorelease];
    
    
    
    //    alert = [UIFont fontWithName:@"Arial" size:18];
  

//    alert = [UIFont fontWithName:@"Arial" size:18];
  
    
    // Jatin Chauhan - 26-Nov-2013

    
    
    alert.tag = 1;
    [alert show];
}

- (void)helpClicked
{
#if COPD
    [InAppBrowserController showFromViewController: self withUrl: [[self lastController] helpUrl]];
#else
	HelpViewController *help = [[[HelpViewController alloc] init] autorelease];
	help.url = [[self lastController] helpUrl];
	[self.navigationController pushViewController:help animated:YES];
#endif
}

- (void)doneClicked
{
    [self dismissModalViewControllerAnimated: YES];
}

- (void)prevClicked
{ 
    if ([navigationController.viewControllers count] > 1)
    {
        [self errorWasFixed];
        [navigationController popViewControllerAnimated: YES];
    }
}

- (void)showError:(NSString *)error
{
    errorPopup.text = error;
    [UIView animateWithDuration: 0.2 animations:^{
        errorPopup.alpha = 1;
//        errorPopup.frame = CGRectMake(0, 1 , self.view.frame.size.width, STEPS_PROGRESS_VIEW_HEIGHT - 1);
        
        
        // Jatin Chauhan 26-Nov-2013
        
          errorPopup.frame = CGRectMake(0, 1 , 640, STEPS_PROGRESS_VIEW_HEIGHT);
        
        // -Jatin Chauhan 26-Nov-2013
        
    }];
}

- (void)errorWasFixed
{
    if (errorPopup.alpha < 0.1)
    {
        return;
    }
    
    [UIView animateWithDuration: 0.4  animations:^{
        errorPopup.alpha = 0;
        errorPopup.frame = CGRectMake(0, STEPS_PROGRESS_VIEW_HEIGHT , self.view.frame.size.width, STEPS_PROGRESS_VIEW_HEIGHT - 1);
    }];
}

#if COPD
- (void)nextClicked
{
    if (![[self lastController] canGoNext]) 
    {
        [self showError: [ [self lastController] errorText]];
        return;
    }
    
    int lastIndex = [self lastController].index;
    int newIndex = lastIndex+1;
    
    if (lastIndex == 7 && !reportConfirmed)
    {
        TSAlertView* alert = [[[TSAlertView alloc] initWithTitle: @"Please Confirm" message: @"Is this summary info correct?" delegate: self cancelButtonTitle:@"No" otherButtonTitles: @"Yes", nil] autorelease];
        [alert show];
        return;
    }
    
    if (lastIndex == 1 && self.record.sputumQuantity == 0)
    {
        newIndex = 4;
    }
    
    
    
    [navigationController pushViewController: [self loadQuestionControllerForIndex: newIndex] animated: YES];
    
    if (newIndex == 8)
    {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        
        [UIView animateWithDuration: 0.25 animations:^{
            prevButton.alpha = 0;
            nextButton.alpha = 0;
        }];
    }
}
#endif

#if HFBASE
- (void)nextClicked
{
    if (![[self lastController] canGoNext])
    {
        [self showError: [ [self lastController] errorText]];
        return;
    }
    
    int lastIndex = [self lastController].index;
    int newIndex = lastIndex+1;
    
    if (lastIndex == [self.questions count]-1 && !reportConfirmed)
    {
       // UIAlertView* alert = [[[UIAlertView alloc] initWithTitle: @"Please Confirm" message: @"Are you ready to send this report?" delegate: self cancelButtonTitle:@"No" otherButtonTitles: @"Yes", nil] autorelease];
       // [alert show];
        TSAlertView* alert = [[[TSAlertView alloc] initWithTitle: @"Please Confirm" message: @"Are you ready to send this report?"  delegate: self cancelButtonTitle:@"No" otherButtonTitles: @"Yes", nil] autorelease];
        [alert show];
        return;
    }
    
    if (newIndex == 5) //[self.record.CHF_isSwallen boolValue] == NO)
    {
        PatientRecord *pr=(PatientRecord*)[[self patientRecordSet] objectAtIndex:4];
        
        if ([pr.checkInValue intValue]==0)
        {
            //akhil
            //self.patientRecordSet
           /* for (int i =0; i<self.patientRecordSet.count; i++)
            {
                PatientRecord *prec=(PatientRecord*)[self.patientRecordSet objectAtIndex:i];
                if (i>4)
                {//19DCAE34-9837-495E-B634-1696E2B3E4A9
                    NSLog(@"obje delete");
                    NSLog(@"prec id = %@",prec.questionID);
                    if ([prec.questionID isEqualToString:@"3BA5BEBF-F8BD-432D-BB40-960D042BC149"]||
                        [prec.questionID isEqualToString:@"DA56E37B-4044-4484-88D5-EE1CC8AD7441"]||
                        [prec.questionID isEqualToString:@"93290BCA-6C44-41E4-B978-68D619287795"]||
                        [prec.questionID isEqualToString:@"6CF3AD09-19EC-4181-A031-83D11CF88A05"]||
                        [prec.questionID isEqualToString:@"357A405B-42FE-47B5-A7A6-E96E5305B280"]||
                        prec.questionID == @"19dcae34-9837-495e-b634-1696e2b3e4a9")
                    {
                        NSLog(@"match obj delete");
                        [self.patientRecordSet removeObject:prec];

                    }
                    if ([prec.questionID isEqual:@"19dcae34-9837-495e-b634-1696e2b3e4a9"])
                    {
                         NSLog(@"match obj delete");
                    }
                    //[self.patientRecordSet removeObjectAtIndex:i];
                    //[self.patientRecordSet removeObject:prec];
                }
            
            }*/
           /* NSLog(@"new index afted deleted record = %d",newIndex);
             NSLog(@"after delete patient record = %d",[self.patientRecordSet count]);
            NSLog(@"patient record temp = %d",[self.patientRecordSet_temp count]);*/

            //akhil
            
            Questions *q=(Questions*)[self.questions objectAtIndex:newIndex];
            
           // NSLog(@"OP: %@",q.questionOptions);
            PatientRecord *pRecord=nil;
            for (QuestionOptions *qp in q.questionOptions) {
                NSLog(@"qu title = %@",qp.qOptionTitle);
            
                //NSLog(@"QuestionOptions title = %@",q.questionOptions);
                if ([qp.qOptionTitle isEqualToString:@"-"]) {
                    pRecord=[[[PatientRecord alloc] init] autorelease];
                    pRecord.questionID=qp.questionID;
                    NSLog(@"pRecord.questionID = %@",pRecord.questionID);
                    pRecord.qOptionID=qp.qOptionID;
                    pRecord.checkInValue=qp.qOptionValue;
                    break;
                }
            }
            if (pRecord)
            {
                //akhil
                 //[self.questions addObject:q];
                //akhil
                NSLog(@"precord add in next click");
                
                //2013-12-10 Vipul
                //[self.patientRecordSet addObject:pRecord];
                
                //akhil 27-11-13
               //[self.patientRecordSet_temp addObject:pRecord];                
                int i = 0;
                for (i=0;i<[self.patientRecordSet count];i++)
                {
                    if([(PatientRecord *)[self.patientRecordSet objectAtIndex:i] init].questionID == pRecord.questionID)
                    {
                        [self.patientRecordSet removeObjectAtIndex:i];
                        [self.patientRecordSet insertObject:pRecord atIndex:i];
                        //flag = 1;
                        break;                        
                    }                    
                }
                if(i == [self.patientRecordSet count])
                    [self.patientRecordSet addObject:pRecord];
                //2013-12-10 Vipul
            }
            
            //now here update
            //akhil 27-11-13
            
            
        
            
            //2013-12-10 Vipul
//            if (self.patientRecordSet.count>6)
//            {
//                [self.patientRecordSet removeAllObjects];
//                NSLog(@"now patient set array count = %d",self.patientRecordSet.count);
//                NSLog(@"now patient test count = %d",self.patientRecordSet_temp.count);
//               // NSLog(@"now patient record set after body = %d",self.patientRecordSet_after_body.count);
//                for (int i=0; i<self.patientRecordSet_temp.count; i++)
//                {
//                    [self.patientRecordSet addObject:[self.patientRecordSet_temp objectAtIndex:i]];
//                }
//            }
        //
            //now here update
        
            
            // Jatin Chauhan 05-Dec-2013
            
            
        /*    for (int i =0 ; i<[self.patientRecordSet_after_body count]; i++)
            {
                [self.patientRecordSet addObject:[self.patientRecordSet_after_body objectAtIndex:i]];
            }
                        // -Jatin Chauhan 05-Dec-2013
            
*/
            
            newIndex = 6;
         
            
        }
        
        
        
    }
    
    [navigationController pushViewController: [self loadQuestionControllerForIndex: newIndex] animated: YES];
    
    if (newIndex == [self.questions count])
    {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        
        [UIView animateWithDuration: 0.25 animations:^{
            prevButton.alpha = 0;
            nextButton.alpha = 0;
        }];
    }

    
    /*if (![[self lastController] canGoNext])
    {
        [self showError: [ [self lastController] errorText]];
        return;
    }
    
    int lastIndex = [self lastController].index;
    int newIndex = lastIndex+1;
    
    if (lastIndex == 9 && !reportConfirmed)
    {
        TSAlertView* alert = [[[TSAlertView alloc] initWithTitle: @"Please Confirm" message: @"Are you ready to send this report?" delegate: self cancelButtonTitle:@"No" otherButtonTitles: @"Yes", nil] autorelease];
        [alert show];
        return;
    }

    
    if (newIndex == 5 && [self.record.CHF_isSwallen boolValue] == NO)
    {
        newIndex = 7;
    }
    
    [navigationController pushViewController: [self loadQuestionControllerForIndex: newIndex] animated: YES];
    
    if (newIndex == 10)
    {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        
        [UIView animateWithDuration: 0.25 animations:^{
            prevButton.alpha = 0;
            nextButton.alpha = 0;
        }];
    }*/
}
#endif

#if HFB
- (void)nextClicked
{
    if (![[self lastController] canGoNext]) 
    {
        [self showError: [ [self lastController] errorText]];
        return;
    }
    
    int lastIndex = [self lastController].index;
    int newIndex = lastIndex+1;
    
    if (lastIndex == 12 && !reportConfirmed)
    {
        TSAlertView* alert = [[[TSAlertView alloc] initWithTitle: @"Please Confirm" message: @"Are you ready to send this report?" delegate: self cancelButtonTitle:@"No" otherButtonTitles: @"Yes", nil] autorelease];
        [alert show];
        return;
    }

    
    if (newIndex == 6 && [self.record.CHF_isSwallen boolValue] == NO)
    {
        newIndex = 8;
    }
    
    [navigationController pushViewController: [self loadQuestionControllerForIndex: newIndex] animated: YES];
    
    if (newIndex == [self.questions count])
    {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        
        [UIView animateWithDuration: 0.25 animations:^{
            prevButton.alpha = 0;
            nextButton.alpha = 0;
        }];
    }
}
#endif


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self updateControls: animated];
}

#pragma mark - loading

#if COPD

- (UIViewController *)loadQuestionControllerForIndex:(NSInteger)index
{
    BaseQuestionController * vc = nil;
    
    switch (index)
    {
        case 0:{
            vc = [[[BreathlessnessQuestionController alloc] init] autorelease];
            NSLog(@"case 0 %@",vc);
             }
            break;
        case 1:
            {
            vc = [[[SputumQuantityQuestionController alloc] init] autorelease];
                NSLog(@"case 1 %@",vc);
             }
            break;
        case 2:
        {
            vc = [[[SputumColorQuestionController alloc] init] autorelease];
              
        }
            break;
        case 3:
        {
            vc = [[[SputumConsistencyQuestionController alloc] init] autorelease];
              
        }
            break;
        case 4:
        {
            NSDictionary * field1Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"peakFlowMeasurement1", kDigitsQuestionController_Field_KeyPath_Key,
                                           [NSNumber numberWithInt: 60], kDigitsQuestionController_Field_RangeBegin_Key,
                                           [NSNumber numberWithInt: 800], kDigitsQuestionController_Field_RangeEnd_Key,
                                           @"Enter first attempt value (60-800)", kDigitsQuestionController_Field_Prompt_Key,
                                           @"Your first measurement is out of range. Please enter a value between 60 and 800.",kDigitsQuestionController_Field_Error_Key,nil];
            
            NSDictionary * field2Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"peakFlowMeasurement2", kDigitsQuestionController_Field_KeyPath_Key,
                                           [NSNumber numberWithInt: 60], kDigitsQuestionController_Field_RangeBegin_Key,
                                           [NSNumber numberWithInt: 800], kDigitsQuestionController_Field_RangeEnd_Key,
                                           @"Enter second attempt value (60-800)", kDigitsQuestionController_Field_Prompt_Key,
                                           @"Your second measurement is out of range. Please enter a value between 60 and 800.",kDigitsQuestionController_Field_Error_Key, nil];
            
            NSDictionary * field3Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"peakFlowMeasurement3", kDigitsQuestionController_Field_KeyPath_Key,
                                           [NSNumber numberWithInt: 60], kDigitsQuestionController_Field_RangeBegin_Key,
                                           [NSNumber numberWithInt: 800], kDigitsQuestionController_Field_RangeEnd_Key,
                                           @"Enter third attempt value (60-800)", kDigitsQuestionController_Field_Prompt_Key,
                                           @"Your third measurement is out of range. Please enter a value between 60 and 800.",kDigitsQuestionController_Field_Error_Key, nil];
            
            
            NSArray * fieldsConfig = [NSArray arrayWithObjects: field1Config, field2Config, field3Config, nil];
            
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"Peak Flow Measurements", kDigitsQuestionController_Title_Key,
                                     @"http://help.docviewsolutions.com/copd-app/help.html#peakflow", kDigitsQuestionController_HelpUrl_Key,
                                     @"peakFlowSelectedField", kDigitsQuestionController_SelectedFieldKeyPath_Key,
                                     fieldsConfig, kDigitsQuestionController_Fields_Key,
                                     nil];
            
            vc = [[[DigitsQuestionController alloc] initWithConfig: config] autorelease];
             
        }
            break;
        case 5:
        {
            vc = [[[TempQuestionController alloc] init] autorelease];
             
            break;
        }
        case 6:
        {
            vc = [[[OthersQuestionController alloc] init] autorelease];
             
            break;
        }
        case 7:
        {
            vc = [[[SummaryViewController alloc] init] autorelease];
             
            break;
        }
        case 8:
        {
            vc = [[[SubmitViewController alloc] init] autorelease];
             
        }
            break;
        default:
            break;
    }
    vc.index = index;
    vc.record = self.record;
    vc.questionsViewController = self;
    return vc;
}

#endif


#if HFBASE
- (UIViewController *)loadQuestionControllerForIndex:(NSInteger)index
{
    NSUInteger recordIndex=index;
    Questions *q=nil;
    PatientRecord *pRecord=nil;
    BaseQuestionController * vc = nil;
    if (index <= self.questions.count-1) {    // if questions are out of index then dont create an object
        q=(Questions*)[self.questions objectAtIndex:index];
        
        pRecord=[[[PatientRecord alloc] init] autorelease];
        pRecord.questionID=q.questionID;
            
        NSLog(@"QID=%@",q.questionID);
        
        NSUInteger intQType=q.questionTypeID;
        NSUInteger intQTemp=q.questionTemplateID;
        
        NSLog(@"QID=%d",intQType);
        
        switch (intQTemp) {
            case 1:
                //
            {
                switch (intQType) {
                    case 4: //Range
                    {
                        /*NSDictionary * field1Config = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"CHF_weightToday", kDigitsQuestionController_Field_KeyPath_Key,
                         [NSNumber numberWithInt: 60], kDigitsQuestionController_Field_RangeBegin_Key,
                         [NSNumber numberWithInt: 600], kDigitsQuestionController_Field_RangeEnd_Key,
                         @"Enter your value", kDigitsQuestionController_Field_Prompt_Key,
                         @"Enter a value between 60 and 600.",kDigitsQuestionController_Field_Error_Key, nil];
                         
                         
                         NSArray * fieldsConfig = [NSArray arrayWithObjects: field1Config, nil];
                         
                         NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys:
                         q.questionTitle, kDigitsQuestionController_Title_Key,
                         @"http://help.docviewsolutions.com/chf-app/help.html#weight", kDigitsQuestionController_HelpUrl_Key,
                         fieldsConfig, kDigitsQuestionController_Fields_Key,
                         nil];*/
                        
                        vc = [[[DigitsQuestionController alloc] initWithQuestion:q] autorelease];
                        // vc = [[[SimpleQuestionController alloc] initWithQuestion:q] autorelease];
                    }
                        break;
                    case 5:
                    {
                        /* NSDictionary * field1Config = [NSDictionary dictionaryWithObjectsAndKeys:
                         q.questionID, kSimpleQuestionController_KeyPath_Key,
                         q.questionTitle, kSimpleQuestionController_Title_Key,nil];
                         
                         
                         NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"http://help.docviewsolutions.com/chf-app/help.html#weight-change", kSimpleQuestionController_HelpUrl_Key,
                         @"Please tap YES or NO.", kSimpleQuestionController_Error_Key,
                         [NSArray arrayWithObjects: field1Config, nil], kSimpleQuestionController_Questions_Key,
                         nil];*/
                        
                        vc = [[[SimpleQuestionController alloc] initWithQuestion:q] autorelease];
                        
                    }
                    default:
                        break;
                }
                
            }
                break;
            case 2:
                //
                break;
            case 3:
                //
                break;
            case 4://@"CHF_feelToday"
            {
                /* NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys:
                 pRecord.questionID,kMoodQuestionController_KeyPath_Key,
                 q.questionTitle, kMoodQuestionController_Title_Key,
                 @"http://help.docviewsolutions.com/chf-app/help.html#feeling-today", kMoodQuestionController_HelpUrl_Key,
                 @"Please tap on one of the faces.", kMoodQuestionController_Error_Key,
                 @"YES"
                 ,kMoodQuestionController_Field_Emergency_Key,
                 nil];
                 vc = [[[MoodQuestionController alloc] initWithConfig: config] autorelease];*/
                
                vc=[[[MoodQuestionController alloc] initWithQuestion:q] autorelease];
            }
                //
                break;
            case 5:
                //
                vc = [[[BodyQuestionController alloc] initWithQuestion: q] autorelease];
                break;
            default:
                break;
        }
        
        NSLog(@"index get in last load queston contr = %d",index);
        NSLog(@"self.patientRecordSet.count = %d",self.patientRecordSet.count);
        NSLog(@"count of patient set test= %d",self.patientRecordSet_temp.count);

        
        if (self.patientRecordSet.count==index)
        { // if not added in the recordset
            NSLog(@"obj added if condition");
           // NSLog(@"p record title = %@",)
            [self.patientRecordSet addObject:pRecord];
            
            //akhil 27-11-13
            if (self.patientRecordSet_temp.count<5)
            {
                /*if (self.patientRecordSet_temp.count>4)
                {
                    PatientRecord *pr=(PatientRecord*)[[self patientRecordSet] objectAtIndex:4];
                    if ([pr.checkInValue intValue]==0)
                    {
                        NSLog(@"OBJ NOT CALL");
                    }
                    else
                    {
                        NSLog(@"OBJ ADDED NEW ARRAY");
                        [self.patientRecordSet_temp addObject:pRecord];
                    }

                }
                else
                {
                    NSLog(@"OBJ ADDED ELSE OUT SIDE NEW ARRAY");
                    [self.patientRecordSet_temp addObject:pRecord];
                }*/
                NSLog(@"OBJ ADDED NEW ARRAY");
                [self.patientRecordSet_temp addObject:pRecord];

            }
             //akhil 27-11-13
        }
        
        else if (index>self.patientRecordSet.count)
        {  // if skip
            NSLog(@"obj added else if condition");

            [self.patientRecordSet addObject:pRecord];
            recordIndex=self.patientRecordSet.count-1;
        }
        //akhil 26-11
       /* else if(index==7)
        {
             NSLog(@"obj added else ");
             [self.patientRecordSet addObject:pRecord];
        }*/
        //akhil 26-11
        
        
        
        // Jatin Chauhan 05-Dec-2013
        
        
     /*   if (index>5)
        {
            
            if (index==6)
            {
                PatientRecord *pr=(PatientRecord*)[[self patientRecordSet] objectAtIndex:4];
                if ([pr.checkInValue intValue]==0)
                {
                    NSLog(@"not add in array");
                }
                else
                {
                    [self.patientRecordSet_after_body addObject:pRecord];
                    
                }
                
            }
            else
            {
                [self.patientRecordSet_after_body addObject:pRecord];
            }
            NSLog(@"after body array count = %d",self.patientRecordSet_after_body.count);
        }
        
        
        */
        
        
        // -Jatin Chauhan 05-Dec-2013
        
        
        
        
        vc.question=q;
        vc.pRecord=(PatientRecord*)[self.patientRecordSet objectAtIndex:recordIndex];//pRecord;//
        
    } else { // after completion
        vc = [[[SubmitViewController alloc] init] autorelease];
        vc.patientRecordSet=self.patientRecordSet;
    }
    
    vc.index = index;
    vc.record = self.record;
    vc.questionsViewController = self;
    return vc;

}


#endif
/*- (UIViewController *)loadQuestionControllerForIndex:(NSInteger)index
{
    BaseQuestionController * vc = nil;
 
    switch (index)
    {
        case 0:
        {
 
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"CHF_feelToday",kMoodQuestionController_KeyPath_Key,
                                     @"How do you feel today?", kMoodQuestionController_Title_Key,
                                     @"http://help.docviewsolutions.com/chf-app/help.html#feeling-today", kMoodQuestionController_HelpUrl_Key,
                                     @"Please tap on one of the faces.", kMoodQuestionController_Error_Key,
                                     @"YES"
                                     ,kMoodQuestionController_Field_Emergency_Key,
                                     nil];
            vc = [[[MoodQuestionController alloc] initWithConfig: config] autorelease];              
        }
            break;
        case 1:
        {
            NSDictionary * field1Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"CHF_weightToday", kDigitsQuestionController_Field_KeyPath_Key,
                                           [NSNumber numberWithInt: 60], kDigitsQuestionController_Field_RangeBegin_Key,
                                           [NSNumber numberWithInt: 600], kDigitsQuestionController_Field_RangeEnd_Key,
                                           @"Enter your value", kDigitsQuestionController_Field_Prompt_Key,
                                           @"Enter a value between 60 and 600.",kDigitsQuestionController_Field_Error_Key, nil];
            
            
            NSArray * fieldsConfig = [NSArray arrayWithObjects: field1Config, nil];
            
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"What is your weight today?", kDigitsQuestionController_Title_Key,
                                     @"http://help.docviewsolutions.com/chf-app/help.html#weight", kDigitsQuestionController_HelpUrl_Key,
                                     fieldsConfig, kDigitsQuestionController_Fields_Key,
                                     nil];
            
            vc = [[[DigitsQuestionController alloc] initWithConfig: config] autorelease];
              
        }
            break;
        case 2:
        {
            
            NSDictionary * field1Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"CHF_weightChanged", kSimpleQuestionController_KeyPath_Key,
                                           @"Has your weight changed by\n2 pounds in the past day, or by\n5 pounds in the past week?", kSimpleQuestionController_Title_Key,nil];
            
            
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"http://help.docviewsolutions.com/chf-app/help.html#weight-change", kSimpleQuestionController_HelpUrl_Key,
                                     @"Please tap YES or NO.", kSimpleQuestionController_Error_Key,
                                     [NSArray arrayWithObjects: field1Config, nil], kSimpleQuestionController_Questions_Key,
                                     nil];
            
            vc = [[[SimpleQuestionController alloc] initWithConfig: config] autorelease];
              
        }
            break;
        case 3:
        {
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"CHF_breathingTodayAtRest",kMoodQuestionController_KeyPath_Key,
                                     @"How is your breathing today at rest?", kMoodQuestionController_Title_Key,
                                     @"http://help.docviewsolutions.com/chf-app/help.html#breathing", kMoodQuestionController_HelpUrl_Key,
                                     @"Please tap on one of the faces.", kMoodQuestionController_Error_Key,
                                     nil];
            vc = [[[MoodQuestionController alloc] initWithConfig: config] autorelease];
              
        }
            break;
        case 4:
        {  
            NSDictionary * field1Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"CHF_isSwallen", kSimpleQuestionController_KeyPath_Key,
                                           @"Are you feeling more swollen than usual?", kSimpleQuestionController_Title_Key,nil];
            
            
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"http://help.docviewsolutions.com/chf-app/help.html#swollen", kSimpleQuestionController_HelpUrl_Key,
                                     @"Please tap YES or NO.", kSimpleQuestionController_Error_Key,
                                     [NSArray arrayWithObjects: field1Config, nil], kSimpleQuestionController_Questions_Key,
                                     nil];
            
            vc = [[[SimpleQuestionController alloc] initWithConfig: config] autorelease];
              
        }
            break;
        case 5:
        {
            
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"CHF_bodyPartsWithPain",kBodyQuestionController_KeyPath_Key,
                                     @"Where do you feel swollen?", kBodyQuestionController_Title_Key,
                                     @"http://help.docviewsolutions.com/chf-app/help.html#swollen", kBodyQuestionController_HelpUrl_Key,
                                     @"Please tap on the body parts where you feel swollen.", kBodyQuestionController_Error_Key,
                                     nil];
            vc = [[[BodyQuestionController alloc] initWithConfig: config] autorelease];
              
            

        }
            break;
        case 6:
        {
            NSDictionary * field1Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"CHF_haveNausea", kSimpleQuestionController_KeyPath_Key,
                                           @"Are you having nausea?", kSimpleQuestionController_Title_Key,nil];
            
            
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"http://help.docviewsolutions.com/chf-app/help.html#nausea", kSimpleQuestionController_HelpUrl_Key,
                                     @"Please tap YES or NO.", kSimpleQuestionController_Error_Key,
                                     [NSArray arrayWithObjects: field1Config, nil], kSimpleQuestionController_Questions_Key,
                                     nil];
            
            vc = [[[SimpleQuestionController alloc] initWithConfig: config] autorelease];
              
        }
            break;
        case 7:
        {
            NSDictionary * field1Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"CHF_beenTakingMedications", kSimpleQuestionController_KeyPath_Key,
                                           @"Have you been taking your medications as prescribed?", kSimpleQuestionController_Title_Key,nil];
            
            
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"http://help.docviewsolutions.com/chf-app/help.html#taking-meds", kSimpleQuestionController_HelpUrl_Key,
                                     @"Please tap YES or NO.", kSimpleQuestionController_Error_Key,
                                     [NSArray arrayWithObjects: field1Config, nil], kSimpleQuestionController_Questions_Key,
                                     nil];
            
            vc = [[[SimpleQuestionController alloc] initWithConfig: config] autorelease];
              
        }
            break;
        case 8:
        {
            NSDictionary * field1Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"CHF_somebodyChangedWaterPills", kSimpleQuestionController_KeyPath_Key,
                                           @"Has anyone changed your water pill since our last contact?", kSimpleQuestionController_Title_Key,nil];
            
            NSDictionary * field2Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"CHF_somebodyChangedHeartMeds", kSimpleQuestionController_KeyPath_Key,
                                           @"Has anyone changed your heart meds since our last contact?", kSimpleQuestionController_Title_Key,nil];
            
            
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"http://help.docviewsolutions.com/chf-app/help.html#change-in-meds", kSimpleQuestionController_HelpUrl_Key,
                                     @"Please tap YES or NO for all questions.", kSimpleQuestionController_Error_Key,
                                     [NSArray arrayWithObjects: field1Config, field2Config, nil], kSimpleQuestionController_Questions_Key,
                                     nil];
            
            vc = [[[SimpleQuestionController alloc] initWithConfig: config] autorelease];
              
        }
            break;
        case 9:
        {
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"CHF_experienceRate",kMoodQuestionController_KeyPath_Key,
#if HFM
                                     @"How would you rate your experience with the Heart Success Program?",
#else
                                     @"How would you rate your experience with this program?",
#endif
                                     kMoodQuestionController_Title_Key,
                                     @"http://help.docviewsolutions.com/chf-app/help.html#rating", kMoodQuestionController_HelpUrl_Key,
                                     @"Please tap on one of the faces.", kMoodQuestionController_Error_Key,
                                     nil];
            vc = [[[MoodQuestionController alloc] initWithConfig: config] autorelease];
             
        }   
            break;
        case 10:
        {
            vc = [[[SubmitViewController alloc] init] autorelease];
             
        }
            break;
        default:
            break;
    }
    vc.index = index;
    vc.record = self.record;
    vc.questionsViewController = self;
    return vc;
}*/


/*#if HFB
- (UIViewController *)loadQuestionControllerForIndex:(NSInteger)index
{
    BaseQuestionController * vc = nil;
    
    switch (index)
    {
        case 0:
        {
            
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"CHF_feelToday",kMoodQuestionController_KeyPath_Key,
                                     @"How do you feel today?", kMoodQuestionController_Title_Key,
                                     @"http://help.docviewsolutions.com/chf-app/help.html#feeling-today", kMoodQuestionController_HelpUrl_Key,
                                     @"Please tap on one of the faces.", kMoodQuestionController_Error_Key,
                                     @"YES"
                                     ,kMoodQuestionController_Field_Emergency_Key,
                                     nil];
            vc = [[[MoodQuestionController alloc] initWithConfig: config] autorelease];           
        }
            break;
        case 1:
        {
            NSDictionary * field1Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"CHF_weightToday", kDigitsQuestionController_Field_KeyPath_Key,
                                           [NSNumber numberWithInt: 60], kDigitsQuestionController_Field_RangeBegin_Key,
                                           [NSNumber numberWithInt: 600], kDigitsQuestionController_Field_RangeEnd_Key,
                                           @"Enter your value", kDigitsQuestionController_Field_Prompt_Key,
                                           @"Enter a value between 60 and 600.",kDigitsQuestionController_Field_Error_Key, nil];
            
            
            NSArray * fieldsConfig = [NSArray arrayWithObjects: field1Config, nil];
            
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"What is your weight today?", kDigitsQuestionController_Title_Key,
                                     @"http://help.docviewsolutions.com/chf-app/help.html#weight", kDigitsQuestionController_HelpUrl_Key,
                                     fieldsConfig, kDigitsQuestionController_Fields_Key,
                                     nil];
            
            vc = [[[DigitsQuestionController alloc] initWithConfig: config] autorelease];
              
        }
            break;
        case 2:
        {
            
            NSDictionary * field1Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"CHF_weightChanged", kSimpleQuestionController_KeyPath_Key,
                                           @"Has your weight changed by\n2 pounds in the past day, or by\n5 pounds in the past week?", kSimpleQuestionController_Title_Key,nil];
            
            
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"http://help.docviewsolutions.com/chf-app/help.html#weight-change", kSimpleQuestionController_HelpUrl_Key,
                                     @"Please tap YES or NO.", kSimpleQuestionController_Error_Key,
                                     [NSArray arrayWithObjects: field1Config, nil], kSimpleQuestionController_Questions_Key,
                                     nil];
            
            vc = [[[SimpleQuestionController alloc] initWithConfig: config] autorelease];
              
        }
            break;
        case 3:
        {
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"CHF_breathingTodayAtRest",kMoodQuestionController_KeyPath_Key,
                                     @"How is your breathing today at rest?", kMoodQuestionController_Title_Key,
                                     @"http://help.docviewsolutions.com/chf-app/help.html#breathing", kMoodQuestionController_HelpUrl_Key,
                                     @"Please tap on one of the faces.", kMoodQuestionController_Error_Key,
                                     nil];
            vc = [[[MoodQuestionController alloc] initWithConfig: config] autorelease];
              
        }
            break;
        case 4:
        {
            
            NSDictionary * field1Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"CHF_lowSaltDiet", kSimpleQuestionController_KeyPath_Key,
                                           @"Have you been following a low salt diet?", kSimpleQuestionController_Title_Key,nil];
            
            
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"http://help.docviewsolutions.com/chf-app/help.html", kSimpleQuestionController_HelpUrl_Key,
                                     @"Please tap YES or NO.", kSimpleQuestionController_Error_Key,
                                     [NSArray arrayWithObjects: field1Config, nil], kSimpleQuestionController_Questions_Key,
                                     nil];
            
            vc = [[[SimpleQuestionController alloc] initWithConfig: config] autorelease];
              
        }
            break;
        case 5:
        {  
            NSDictionary * field1Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"CHF_isSwallen", kSimpleQuestionController_KeyPath_Key,
                                           @"Are you feeling more swollen than usual?", kSimpleQuestionController_Title_Key,nil];
            
            
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"http://help.docviewsolutions.com/chf-app/help.html#swollen", kSimpleQuestionController_HelpUrl_Key,
                                     @"Please tap YES or NO.", kSimpleQuestionController_Error_Key,
                                     [NSArray arrayWithObjects: field1Config, nil], kSimpleQuestionController_Questions_Key,
                                     nil];
            
            vc = [[[SimpleQuestionController alloc] initWithConfig: config] autorelease];
              
        }
            break;
        case 6:
        {
            
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"CHF_bodyPartsWithPain",kBodyQuestionController_KeyPath_Key,
                                     @"Where do you feel swollen?", kBodyQuestionController_Title_Key,
                                     @"http://help.docviewsolutions.com/chf-app/help.html#swollen", kBodyQuestionController_HelpUrl_Key,
                                     @"Please tap on the body parts where you feel swollen.", kBodyQuestionController_Error_Key,
                                     nil];
            vc = [[[BodyQuestionController alloc] initWithConfig: config] autorelease];
              
            
            
        }
            break;
        case 7:
        {
            NSDictionary * field1Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"CHF_haveNausea", kSimpleQuestionController_KeyPath_Key,
                                           @"Are you having nausea?", kSimpleQuestionController_Title_Key,nil];
            
            NSDictionary * field2Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"CHF_haveTroubleInBed", kSimpleQuestionController_KeyPath_Key,
                                           @"Do you have trouble lying in bed at night?", kSimpleQuestionController_Title_Key,nil];
            
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"http://help.docviewsolutions.com/chf-app/help.html#nausea", kSimpleQuestionController_HelpUrl_Key,
                                     @"Please tap YES or NO for all questions.", kSimpleQuestionController_Error_Key,
                                     [NSArray arrayWithObjects: field1Config, field2Config, nil], kSimpleQuestionController_Questions_Key,
                                     nil];
            
            vc = [[[SimpleQuestionController alloc] initWithConfig: config] autorelease];
              
        }
            break;
            
        case 8:
        {
            NSDictionary * field1Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"CHF_filledPrescriptions", kSimpleQuestionController_KeyPath_Key,
                                           @"Have you filled your prescriptions?", kSimpleQuestionController_Title_Key,nil];
            
            NSDictionary * field2Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"CHF_understandShedule", kSimpleQuestionController_KeyPath_Key,
                                           @"Do you understand your medication schedule and doses?", kSimpleQuestionController_Title_Key,nil];
            
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"http://help.docviewsolutions.com/chf-app/help.html", kSimpleQuestionController_HelpUrl_Key,
                                     @"Please tap YES or NO for all questions.", kSimpleQuestionController_Error_Key,
                                     [NSArray arrayWithObjects: field1Config, field2Config, nil], kSimpleQuestionController_Questions_Key,
                                     nil];
            
            vc = [[[SimpleQuestionController alloc] initWithConfig: config] autorelease];
              
        }
            break;
        case 9:
        {
            NSDictionary * field1Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"CHF_beenTakingMedications", kSimpleQuestionController_KeyPath_Key,
                                           @"Have you been taking your medications as prescribed?", kSimpleQuestionController_Title_Key,nil];
			
			NSDictionary * field2Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"CHF_nurseVisit", 
												kSimpleQuestionController_KeyPath_Key,
                                           @"Have you been seen by a visiting nurse?", kSimpleQuestionController_Title_Key,nil];
            
            
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"http://help.docviewsolutions.com/chf-app/help.html#taking-meds", kSimpleQuestionController_HelpUrl_Key,
                                     @"Please tap YES or NO.", kSimpleQuestionController_Error_Key,
                                     [NSArray arrayWithObjects: field1Config, field2Config, nil], kSimpleQuestionController_Questions_Key,
                                     nil];
            
            vc = [[[SimpleQuestionController alloc] initWithConfig: config] autorelease];
              
        }
            break;
        case 10:
        {
            NSDictionary * field1Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"CHF_somebodyChangedWaterPills", kSimpleQuestionController_KeyPath_Key,
                                           @"Has anyone changed your water pill since our last contact?", kSimpleQuestionController_Title_Key,nil];
            
            NSDictionary * field2Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"CHF_somebodyChangedHeartMeds", kSimpleQuestionController_KeyPath_Key,
                                           @"Has anyone changed your heart meds since our last contact?", kSimpleQuestionController_Title_Key,nil];
            
            
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"http://help.docviewsolutions.com/chf-app/help.html#change-in-meds", kSimpleQuestionController_HelpUrl_Key,
                                     @"Please tap YES or NO for all questions.", kSimpleQuestionController_Error_Key,
                                     [NSArray arrayWithObjects: field1Config, field2Config, nil], kSimpleQuestionController_Questions_Key,
                                     nil];
            
            vc = [[[SimpleQuestionController alloc] initWithConfig: config] autorelease];
              
        }
            break;
        case 11:
        {
            NSDictionary * field1Config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                           @"CHF_needHelp", kSimpleQuestionController_KeyPath_Key,
                                           @"Is there anything we can discuss with you to help you better manage your care?", kSimpleQuestionController_Title_Key,nil];
            
            
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"http://help.docviewsolutions.com/chf-app/help.html", kSimpleQuestionController_HelpUrl_Key,
                                     @"Please tap YES or NO.", kSimpleQuestionController_Error_Key,
                                     [NSArray arrayWithObjects: field1Config, nil], kSimpleQuestionController_Questions_Key,
                                     nil];
            
            vc = [[[SimpleQuestionController alloc] initWithConfig: config] autorelease];
              
        }
            break;             
        case 12:
        {
            NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     @"CHF_experienceRate",kMoodQuestionController_KeyPath_Key,
                                     @"How would you rate your experience with this program?", kMoodQuestionController_Title_Key,
                                     @"http://help.docviewsolutions.com/chf-app/help.html#rating", kMoodQuestionController_HelpUrl_Key,
                                     @"Please tap on one of the faces.", kMoodQuestionController_Error_Key,
                                     nil];
            vc = [[[MoodQuestionController alloc] initWithConfig: config] autorelease];
              
        }   
            break;
        case 13:
        {
            vc = [[[SubmitViewController alloc] init] autorelease];
             
        }
            break;
        default:
            break;
    }
    vc.index = index;
    vc.record = self.record;
    vc.questionsViewController = self;
    return vc;
}
#endif*/
#if HFB
- (UIViewController *)loadQuestionControllerForIndex:(NSInteger)index
{
    
    //  NSLog(@"Index: %d",index);
    // NSLog(@"Count: %d",self.patientRecordSet.count);
    
    NSUInteger recordIndex=index;
    Questions *q=nil;
    PatientRecord *pRecord=nil;
    BaseQuestionController * vc = nil;
    if (index <= self.questions.count-1) {    // if questions are out of index then dont create an object
        q=(Questions*)[self.questions objectAtIndex:index];
        
        pRecord=[[[PatientRecord alloc] init] autorelease];
        pRecord.questionID=q.questionID;
        
        // NSLog(@"QID=%@",q.questionID);
        
        NSUInteger intQType=q.questionTypeID;
        NSUInteger intQTemp=q.questionTemplateID;
        
        //NSLog(@"QID=%d",intQType);
        switch (intQTemp) {
            case 1:
                //
            {
                switch (intQType) {
                    case 4: //Range
                    {
                        /*NSDictionary * field1Config = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"CHF_weightToday", kDigitsQuestionController_Field_KeyPath_Key,
                         [NSNumber numberWithInt: 60], kDigitsQuestionController_Field_RangeBegin_Key,
                         [NSNumber numberWithInt: 600], kDigitsQuestionController_Field_RangeEnd_Key,
                         @"Enter your value", kDigitsQuestionController_Field_Prompt_Key,
                         @"Enter a value between 60 and 600.",kDigitsQuestionController_Field_Error_Key, nil];
                         
                         
                         NSArray * fieldsConfig = [NSArray arrayWithObjects: field1Config, nil];
                         
                         NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys:
                         q.questionTitle, kDigitsQuestionController_Title_Key,
                         @"http://help.docviewsolutions.com/chf-app/help.html#weight", kDigitsQuestionController_HelpUrl_Key,
                         fieldsConfig, kDigitsQuestionController_Fields_Key,
                         nil];*/
                        
                        vc = [[[DigitsQuestionController alloc] initWithQuestion:q] autorelease];
                        // vc = [[[SimpleQuestionController alloc] initWithQuestion:q] autorelease];
                    }
                        break;
                    case 5:
                    {
                        /* NSDictionary * field1Config = [NSDictionary dictionaryWithObjectsAndKeys:
                         q.questionID, kSimpleQuestionController_KeyPath_Key,
                         q.questionTitle, kSimpleQuestionController_Title_Key,nil];
                         
                         
                         NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"http://help.docviewsolutions.com/chf-app/help.html#weight-change", kSimpleQuestionController_HelpUrl_Key,
                         @"Please tap YES or NO.", kSimpleQuestionController_Error_Key,
                         [NSArray arrayWithObjects: field1Config, nil], kSimpleQuestionController_Questions_Key,
                         nil];*/
                        
                        vc = [[[SimpleQuestionController alloc] initWithQuestion:q] autorelease];
                        
                    }
                    default:
                        break;
                }
                
            }
                break;
            case 2:
                //
                break;
            case 3:
                //
                break;
            case 4://@"CHF_feelToday"
            {
                /* NSDictionary * config = [NSDictionary dictionaryWithObjectsAndKeys:
                 pRecord.questionID,kMoodQuestionController_KeyPath_Key,
                 q.questionTitle, kMoodQuestionController_Title_Key,
                 @"http://help.docviewsolutions.com/chf-app/help.html#feeling-today", kMoodQuestionController_HelpUrl_Key,
                 @"Please tap on one of the faces.", kMoodQuestionController_Error_Key,
                 @"YES"
                 ,kMoodQuestionController_Field_Emergency_Key,
                 nil];
                 vc = [[[MoodQuestionController alloc] initWithConfig: config] autorelease];*/
                
                vc=[[[MoodQuestionController alloc] initWithQuestion:q] autorelease];
            }
                //
                break;
            case 5:
                //
                vc = [[[BodyQuestionController alloc] initWithQuestion: q] autorelease];
                break;
            default:
                break;
        }
        if (self.patientRecordSet.count==index) { // if not added in the recordset
            [self.patientRecordSet addObject:pRecord];
        } else if (index>self.patientRecordSet.count) {  // if skip
            [self.patientRecordSet addObject:pRecord];
            recordIndex=self.patientRecordSet.count-1;
        }
        
        vc.question=q;
        vc.pRecord=(PatientRecord*)[self.patientRecordSet objectAtIndex:recordIndex];//pRecord;//
        
    } else { // after completion
        vc = [[[SubmitViewController alloc] init] autorelease];
        vc.patientRecordSet=self.patientRecordSet;
    }
    
    vc.index = index;
    vc.record = self.record;
    vc.questionsViewController = self;
    return vc;
    
}
#endif

- (void)loadPrevButton
{
    prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //prevButton.frame = CGRectMake(0, contentView.frame.size.height - STEPS_PROGRESS_VIEW_HEIGHT - BUTTON_HEIGHT-40, contentView.frame.size.width/2, BUTTON_HEIGHT+18);
    //akhil 26-2-15
    //IOS Upgradation
    
    if(IS_IPHONE_4_OR_LESS)
    {
        prevButton.frame = CGRectMake(0, contentView.frame.size.height - STEPS_PROGRESS_VIEW_HEIGHT - BUTTON_HEIGHT-12, contentView.frame.size.width/2, BUTTON_HEIGHT-10);
    }
    else if (IS_IPHONE_5)
    {
        prevButton.frame = CGRectMake(0, contentView.frame.size.height - STEPS_PROGRESS_VIEW_HEIGHT - BUTTON_HEIGHT-12, contentView.frame.size.width/2, BUTTON_HEIGHT-10);
        
    }
    
    else
    {
        prevButton.frame = CGRectMake(0, contentView.frame.size.height - STEPS_PROGRESS_VIEW_HEIGHT - BUTTON_HEIGHT-40, contentView.frame.size.width/2, BUTTON_HEIGHT+18);
    }
    //akhil 26-2-15
    //IOS Upgradation
    NSLog(@"pre x = %0.2f",prevButton.frame.origin.x);
    NSLog(@"pre y = %0.2f",prevButton.frame.origin.y);
    NSLog(@"pre he = %0.2f",prevButton.frame.size.height);
    NSLog(@"pre wid= %0.2f",prevButton.frame.size.width);
    // Jatin Chauhan 26-Nov-2013
    
//    NSLog(@"view x = %0.2f",prevButton.frame.origin.x);
//    NSLog(@"view y = %0.2f",prevButton.frame.origin.y);
//    NSLog(@"view widht = %0.2f",prevButton.frame.size.width);
//    NSLog(@"view height = %0.2f",prevButton.frame.size.height);
    prevButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [prevButton setBackgroundImage:[UIImage imageNamed:@"prev"] forState:UIControlStateNormal];
    [prevButton setBackgroundImage:[UIImage imageNamed:@"prev-active"] forState:UIControlStateSelected];
    [prevButton setTitle:@"Previous" forState:UIControlStateNormal];
    [prevButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [prevButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    prevButton.titleLabel.shadowOffset = CGSizeMake(1, 0);
    //prevButton.titleLabel.font = [UIFont systemFontOfSize: 44]; //22 - Jatin Chauhan 26-Nov-2013
    //akhil 26-2-15
    //IOS Upgradation
    
    if(IS_IPHONE_4_OR_LESS)
    {
         prevButton.titleLabel.font = [UIFont systemFontOfSize: 22];
    }
    else if (IS_IPHONE_5)
    {
        prevButton.titleLabel.font = [UIFont systemFontOfSize: 22];
        
    }
    
    else
    {
         prevButton.titleLabel.font = [UIFont systemFontOfSize: 44];
    }
    //akhil 26-2-15
    //IOS Upgradation

    [prevButton addTarget:self action:@selector(prevClicked) forControlEvents:UIControlEventTouchUpInside];

    [contentView addSubview: prevButton];
}

- (void)loadNextButton
{
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //nextButton.frame = CGRectMake(roundf(contentView.frame.size.width/2), roundf(contentView.frame.size.height - STEPS_PROGRESS_VIEW_HEIGHT - BUTTON_HEIGHT-40), roundf(contentView.frame.size.width/2), BUTTON_HEIGHT+18);
    
    //akhil 26-2-15
    //IOS Upgradation
    
    if(IS_IPHONE_4_OR_LESS)
    {
        nextButton.frame = CGRectMake(roundf(contentView.frame.size.width/2), roundf(contentView.frame.size.height - STEPS_PROGRESS_VIEW_HEIGHT - BUTTON_HEIGHT-12), roundf(contentView.frame.size.width/2), BUTTON_HEIGHT-10);
    }
    else if (IS_IPHONE_5)
    {
        nextButton.frame = CGRectMake(roundf(contentView.frame.size.width/2), roundf(contentView.frame.size.height - STEPS_PROGRESS_VIEW_HEIGHT - BUTTON_HEIGHT-12), roundf(contentView.frame.size.width/2), BUTTON_HEIGHT-10);
        
    }
    
    else
    {
        nextButton.frame = CGRectMake(roundf(contentView.frame.size.width/2), roundf(contentView.frame.size.height - STEPS_PROGRESS_VIEW_HEIGHT - BUTTON_HEIGHT-40), roundf(contentView.frame.size.width/2), BUTTON_HEIGHT+18);
    }
    //akhil 26-2-15
    //IOS Upgradation

    
        // Jatin Chauhan 26-Nov-2013
    
    
    NSLog(@"view x = %0.2f",nextButton.frame.origin.x);
    NSLog(@"view y = %0.2f",nextButton.frame.origin.y);
    NSLog(@"view widht = %0.2f",nextButton.frame.size.width);
    NSLog(@"view height = %0.2f",nextButton.frame.size.height);

    
    
    nextButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [nextButton setBackgroundImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"next-active"] forState:UIControlStateSelected];
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    nextButton.titleLabel.shadowOffset = CGSizeMake(1, 0);
    nextButton.titleLabel.font = [UIFont systemFontOfSize: 44];//22 - Jatin Chauhan 26-Nov-2013
    //akhil 26-2-15
    //IOS Upgradation
    
    if(IS_IPHONE_4_OR_LESS)
    {
        nextButton.titleLabel.font = [UIFont systemFontOfSize: 22];
    }
    else if (IS_IPHONE_5)
    {
        nextButton.titleLabel.font = [UIFont systemFontOfSize: 22];
        
    }
    
    else
    {
        nextButton.titleLabel.font = [UIFont systemFontOfSize: 44];
    }
    //akhil 26-2-15
    //IOS Upgradation

    [nextButton addTarget:self action:@selector(nextClicked) forControlEvents:UIControlEventTouchUpInside];
  

    [contentView addSubview: nextButton];
}

- (void)loadErrorPopup
{
    errorPopup = [[[UILabel alloc] initWithFrame: CGRectMake(0, STEPS_PROGRESS_VIEW_HEIGHT , self.view.frame.size.width, STEPS_PROGRESS_VIEW_HEIGHT - 1)] autorelease];
    errorPopup.backgroundColor = [UIColor colorWithRed: 0.7 green: 0 blue: 0  alpha: 1];
    errorPopup.textColor = [UIColor whiteColor];
    errorPopup.textAlignment = UITextAlignmentCenter;
    errorPopup.shadowColor = [UIColor colorWithWhite: 0.5 alpha: 0.5];
    errorPopup.shadowOffset = CGSizeMake(0, 1);
    errorPopup.font = [UIFont boldSystemFontOfSize: 13];
    errorPopup.text = @"There is an error";
    errorPopup.numberOfLines = 0;
    errorPopup.alpha = 0;
    [stepsProgressView addSubview: errorPopup];
}

#if COPD
- (void)updateControls:(BOOL)animated
{
    BOOL notFirst = ([navigationController.viewControllers count] > 1);
    
    prevButton.enabled = notFirst;
    
    [UIView animateWithDuration: (animated ? 0.25 : 0) animations:^{
        prevButton.alpha = notFirst ? 1.0f : 0.6f;
        
        stepsProgressView.alpha = [self lastController].index < 8 ? 1 : 0;
    }];
    
    
    [stepsProgressView setCurrentStep:([self lastController].index + 1) animated: animated];
}
#endif

#if HFBASE
- (void)updateControls:(BOOL)animated
{
   /* BOOL notFirst = ([navigationController.viewControllers count] > 1);
    
    prevButton.enabled = notFirst;
    
    [UIView animateWithDuration: (animated ? 0.25 : 0) animations:^{
        prevButton.alpha = notFirst ? 1.0f : 0.6f;
        
        stepsProgressView.alpha = [self lastController].index < 10 ? 1 : 0;
    }];

    [stepsProgressView setCurrentStep:([self lastController].index + 1) animated: animated];*/

        BOOL notFirst = ([navigationController.viewControllers count] > 1);
        
        prevButton.enabled = notFirst;
        
        [UIView animateWithDuration: (animated ? 0.25 : 0) animations:^{
            prevButton.alpha = notFirst ? 1.0f : 0.6f;
            stepsProgressView.alpha = [self lastController].index < [self.questions count] ? 1 : 0;
        }];
        
        [stepsProgressView setCurrentStep:([self lastController].index+1) animated: animated];

}
#endif

#if HFB
- (void)updateControls:(BOOL)animated
{
    BOOL notFirst = ([navigationController.viewControllers count] > 1);
    
    prevButton.enabled = notFirst;
    
    [UIView animateWithDuration: (animated ? 0.25 : 0) animations:^{
        prevButton.alpha = notFirst ? 1.0f : 0.6f;
        
        stepsProgressView.alpha = [self lastController].index < 13 ? 1 : 0;
    }];
    
    [stepsProgressView setCurrentStep:([self lastController].index + 1) animated: animated];
}
#endif


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadBrandingViews];
    
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle: @"Help" style: UIBarButtonItemStyleBordered target: self action: @selector(helpClicked)] autorelease];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle: @"Cancel" style: UIBarButtonItemStylePlain target: self action: @selector(cancelClicked)] autorelease];
    
    
    
    
    
    
    
    // Jatin Chauhan 25-Nov-2013
    
  // LayoutView * rootView = [[[LayoutView alloc] initWithFrame: self.view.bounds] autorelease];
    
    
    LayoutView * rootView;

    rootView = [[[LayoutView alloc] initWithFrame: CGRectMake(64, 50, 640, 935)] autorelease];
     // rootView = [[[LayoutView alloc] initWithFrame: CGRectMake(0, 65, 320, 420)] autorelease];
    rootView.layoutViewDelegate = self;
    
//    rootView.center = CGPointMake ( self.view.center.x, rootView.center.y );
//    NSLog(@"view center x = %0.2f",self.view.center.x);
//    NSLog(@"view center x = %0.2f",rootView.center.y);
//    rootView.center = CGPointMake(self.view.center.y, rootView.center.x);
//    NSLog(@"view center x = %0.2f",self.view.center.y);
//    NSLog(@"view center x = %0.2f",rootView.center.x);
    //rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview: rootView];


    
    
  
    
    
    
    
    
    
   // [self.view addSubview:rootView];
    
    
    // Jatin Chauhan 25-Nov-2013    
    
    
    
    
    rootView.layoutViewDelegate = self;
   // rootView = [[[LayoutView alloc] initWithFrame: CGRectMake(64, 50, 640, 935)] autorelease];

   // rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //akhil 26-2-15
    //IOS Upgradation
    
     if(IS_IPHONE_4_OR_LESS)
     {
     rootView = [[[LayoutView alloc] initWithFrame: CGRectMake(0, 65, self.view.frame.size.height, self.view.frame.size.height-65)] autorelease];
     }
     else if (IS_IPHONE_5)
     {
     rootView = [[[LayoutView alloc] initWithFrame: CGRectMake(0, 65, self.view.frame.size.height, self.view.frame.size.height-65)] autorelease];
     
     }
     
     else
     {
     rootView = [[[LayoutView alloc] initWithFrame: CGRectMake(64, 50, 640, 935)] autorelease];
     
     }

    [self.view addSubview: rootView];
    
    
    // Jatin Chauhan 25-Nov-2013

    
  //  contentView = [[[UIView alloc] initWithFrame: self.view.bounds] autorelease];
    
   contentView = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 640, 840)] autorelease];
    //akhil 26-2-15
    //IOS Upgradation
    
    if(IS_IPHONE_4_OR_LESS)
    {
        contentView.frame = CGRectMake(0, 22, 320, self.view.frame.size.height-65);
        contentView.layer.borderWidth = 1;
        contentView.layer.borderColor = [[UIColor redColor]CGColor];
    }
    else if (IS_IPHONE_5)
    {
        contentView.frame = CGRectMake(0, 22, self.view.frame.size.width, self.view.frame.size.height-65);
        contentView.layer.borderWidth = 1;
        contentView.layer.borderColor = [[UIColor redColor]CGColor];
        
    }
    
    else
    {
        contentView = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 640, 840)] autorelease];

    }
    //}
    //akhil 26-2-15
    //IOS Upgradation


    // Jatin Chauhan 25-Nov-2013


    
    [rootView addSubview: contentView];
    
   // [self loadPrevButton];
  //  [self loadNextButton];
    
    stepsProgressView = [[[StepsProgressView alloc] initWithFrame: CGRectMake(1, contentView.frame.size.height - STEPS_PROGRESS_VIEW_HEIGHT-22, contentView.frame.size.width, STEPS_PROGRESS_VIEW_HEIGHT)] autorelease];
    stepsProgressView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;//UIViewAutoresizingFlexibleTopMargin;
    [self loadPrevButton];
    [self loadNextButton];

    
    
    
    
    [contentView addSubview: stepsProgressView];
	
#ifdef HFB
	[stepsProgressView setCellsNumber:[self.questions count]];
#endif
	
#ifdef HFBASE
	[stepsProgressView setCellsNumber:[self.questions count]];//
#endif
	
#ifdef COPD
	[stepsProgressView setCellsNumber:[self.questions count]];
#endif
    // Jatin Chauhan 25-NOv-2013
    
    
    UIView * separatorView = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, contentView.frame.size.width, 1)] autorelease];
   
   //  UIView * separatorView = [[[UIView alloc] initWithFrame: CGRectMake(0, -10,640,1)] autorelease];
    
    
        // Jatin Chauhan 25-NOv-2013
    
    separatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    separatorView.backgroundColor = [UIColor colorWithWhite: 0.54 alpha: 1];
 
    [stepsProgressView addSubview: separatorView];
    
    
    
    // Jatin Chauhan 25-NOv-2013
 
    
    
    
   //  navigationController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - STEPS_PROGRESS_VIEW_HEIGHT - BUTTON_HEIGHT - keyboardHeight);
    
    
    navigationController.view.frame = CGRectMake(0, 0, 640, 680);

    
    [contentView addSubview:navigationController.view];
    [rootView addSubview: navigationController.view];

    
    
    // Jatin Chauhan 25-NOv-2013

    
    
    [self loadErrorPopup];
    [self updateControls: NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - layout


- (void)doLayout
{
//    contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight);
//    navigationController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - STEPS_PROGRESS_VIEW_HEIGHT - BUTTON_HEIGHT - keyboardHeight);
//
    
    
    
    
    // Jatin Chauhan 25-Nov-2013
    
    
//    contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight);
//    navigationController.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height - STEPS_PROGRESS_VIEW_HEIGHT - BUTTON_HEIGHT - keyboardHeight);
//    
//    
    
    
    
    
  //  contentView.frame = CGRectMake(0, 50, 640, 840);
 //       navigationController.view.frame = CGRectMake(0, 0, 640, 780);
    //akhil 26-2-15
    //IOS Upgradation
    
    if(IS_IPHONE_4_OR_LESS)
    {
        contentView.frame = CGRectMake(0, 22, 320, self.view.frame.size.height-65);
        contentView.layer.borderWidth = 1;
        contentView.layer.borderColor = [[UIColor redColor]CGColor];
         navigationController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 350);
    }
    else if (IS_IPHONE_5)
    {
        contentView.frame = CGRectMake(0, 22, self.view.frame.size.width, self.view.frame.size.height-65);
        contentView.layer.borderWidth = 1;
        contentView.layer.borderColor = [[UIColor redColor]CGColor];
        navigationController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 350);

        
    }
    
    else
    {
        contentView = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 640, 840)] autorelease];
        navigationController.view.frame = CGRectMake(0, 0, 640, 780);

        
    }
    //}
    //akhil 26-2-15
    //IOS Upgradation

 
    
    

    
    
    
    
        // Jatin Chauhan 25-Nov-2013
    
//
//    
//   contentView.center = CGPointMake ( self.view.center.x, (contentView.center.y) );
//    contentView.center = CGPointMake(self.view.center.y, contentView.center.x);
//    navigationController.view.center = CGPointMake ( self.view.center.x,navigationController.view.center.y+50 );
//    navigationController.view.center = CGPointMake(self.view.center.y+50, navigationController.view.center.x);
//
//    
    
}

- (void)layoutSubviewsInView:(UIView *)view
{
    [self doLayout];
}

#pragma mark - keyboard

- (void)keyboardWillShow:(NSNotification *)n
{
    keyboardHeight = [[[n userInfo] valueForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    
    [UIView beginAnimations: nil context:nil];
    [UIView setAnimationCurve:[[[n userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationDuration:[[[n userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    
    [self doLayout];
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *) n
{
    keyboardHeight = 0;
    [self doLayout];
}


- (void)alertView:(TSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{        
    if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
            [self dismissModalViewControllerAnimated: YES];
        }
    }
    else
    {
        if (buttonIndex == 1)
        {
            reportConfirmed = YES;
            [self nextClicked];
        }
    }
}

- (void)reportSent
{
#if COPD
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(doneClicked)] autorelease];
#endif
}

@end
