#import "SubmitViewController.h"
#import "AnswerViewController.h"
#import "QuestionsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RecordCell.h"

@interface SubmitViewController () <UITableViewDelegate, UITableViewDataSource>


@end

@implementation SubmitViewController


#pragma mark - View lifecycle

#if COPD
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite] autorelease];
    [activityIndicatorView startAnimating];
    [self.view addSubview: activityIndicatorView];
    
    
    activityIndicatorView.center = CGPointMake(20,20);
    
    waitingLabel = [[[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 40)] autorelease];
    waitingLabel.textAlignment = UITextAlignmentLeft;
    waitingLabel.text = @"Submitting your report…";
    waitingLabel.textColor = [UIColor whiteColor];
    waitingLabel.font = [UIFont boldSystemFontOfSize:14];
    waitingLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:waitingLabel];
    
    if (self.record.sputumQuantity == 0) 
    {
        self.record.sputumColor = 0;
        self.record.sputumConsistency = 0;
    }    
    
    dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        [[Content shared] sendRecord: self.record]; 
        self.record.date = [NSDate date];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.record.score < 1)
            {
                AnswerViewController * vc  = [[[AnswerViewController alloc] init] autorelease];
                 
                vc.record = self.record;
                vc.removeCheckInController = YES;
                [self.questionsViewController.navigationController pushViewController: vc animated: YES];
            }
            else
            {
                [activityIndicatorView removeFromSuperview];
                [waitingLabel removeFromSuperview];
                
                UITableView * tableView = [[[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 60) style:UITableViewStyleGrouped] autorelease];
                tableView.scrollEnabled = NO;
                tableView.dataSource = self;
                tableView.backgroundView = nil;
                tableView.backgroundColor = nil;
                tableView.userInteractionEnabled = NO;
                [self.view addSubview: tableView];
                
                UILabel * text1 = [[[UILabel alloc] initWithFrame:CGRectMake(13, 70, 300, 200)] autorelease];
                text1.textAlignment = UITextAlignmentLeft;
                text1.text = @"Your report has been submitted.\n\nWe will review and respond soon. A notification will be sent to your phone.\n\nTap the Done button above to return to the main screen.";
                text1.textColor = [UIColor whiteColor];
                text1.font = [UIFont boldSystemFontOfSize:14];
                text1.backgroundColor = [UIColor clearColor];
                text1.numberOfLines = 0;
                [text1 sizeToFit];
                [self.view addSubview:text1];
                [self.questionsViewController reportSent];
            }
            
            [[Content shared] reload];
            
        });
    });
}

#endif

#if HF
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite] autorelease];
    [activityIndicatorView startAnimating];
    [self.view addSubview: activityIndicatorView];
    
    
    activityIndicatorView.center = CGPointMake(20,37); // (20,20) - Jatin Chauhan 27-Nov-2013
    
// Jatin Chauhan 27-Nov-2013
    //waitingLabel = [[[UILabel alloc] initWithFrame:CGRectMake(50, 0, 250, 40)] autorelease];

    
    
    waitingLabel = [[[UILabel alloc] initWithFrame:CGRectMake(50, 0, 600, 70)] autorelease];
    
    
    // -Jatin Chauhan 27-Nov-2013
    
    waitingLabel.textAlignment = UITextAlignmentLeft;
    waitingLabel.text = @"Submitting your report…";
    waitingLabel.textColor = [UIColor whiteColor];
    waitingLabel.font = [UIFont boldSystemFontOfSize:38]; // Jatin Chauhan 27-Nov-2013
    waitingLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:waitingLabel];
    
    if (self.record.sputumQuantity == 0) 
    {
        self.record.sputumColor = 0;
        self.record.sputumConsistency = 0;
    }    
    NSMutableArray *arrMutiple=nil;
    for (int i=0; i<self.patientRecordSet.count; i++) {
        PatientRecord *prec=(PatientRecord*)[self.patientRecordSet objectAtIndex:i];
        if(prec.multipleSet && prec.multipleSet.count>0) // If multiple selection remove the real object and add all the selected options
        {
           // NSLog(@"%@",prec.multipleSet);
            arrMutiple=[[[prec.multipleSet allObjects] copy] autorelease];
            [self.patientRecordSet removeObject:prec];
            
        }
        
    }
    
    
    //NSLog(@"Check In: %@",prec.bodyPartsWithPain);
    for (int iNew=0; iNew<arrMutiple.count; iNew++) {
        PatientRecord *newRec=[[[PatientRecord alloc] init] autorelease];
        QuestionOptions *qo=(QuestionOptions*)[arrMutiple objectAtIndex:iNew];
       // NSLog(@"Title: %@",qo.qOptionTitle);
        //NSLog(@"Value: %d",[qo.qOptionValue intValue]);
        newRec.qOptionID=qo.qOptionID;
        newRec.checkInValue=qo.qOptionValue;
        newRec.questionID=qo.questionID;
        [self.patientRecordSet addObject:newRec];
    }
   // NSLog(@"RS: %@",self.patientRecordSet);
    
    //return;
    dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
    
    [[Content shared] sendReport:self.patientRecordSet Block:^(NSError *errorOrNil) {
        
        if (errorOrNil==nil) {
            [activityIndicatorView removeFromSuperview];
            [waitingLabel removeFromSuperview];
            
            
            // Jatin Chauhan 27-Nov-2013
            
//            UILabel * text1 = [[[UILabel alloc] initWithFrame:CGRectMake(13, 10, 300, 200)] autorelease];
            
            
            
            UILabel * text1 = [[[UILabel alloc] initWithFrame:CGRectMake(13, 10, 600, 400)] autorelease];

    // -Jatin Chauhan 27-Nov-2013
            
            
            text1.textAlignment = UITextAlignmentLeft;
            
            if ([[Content shared] isGreen:self.patientRecordSet])
            {
                //2014-01-09 Vipul 2.5.0.2 replace Heart Success to health
                text1.text = @"Your results are great!\n\nPlease continue with your current treatment plan and check in again at your next scheduled time.\n\nThank you for participating in the health program powered by DocView iT3.";
                
            }
            else
            {
                //2014-01-09 Vipul 2.5.0.2
                //text1.text = @"Based on your results a nurse will be calling you soon.\n\nThank you for participating in the Heart Success Program powered by DocView iT3.";
                text1.text = @"Based on your results a nurse will be contacting you soon.\n\nThank you for participating in the health program powered by DocView iT3.";
                //2014-01-09 Vipul 2.5.0.2
            }
            
            text1.textColor = [UIColor whiteColor];
            text1.font = [UIFont boldSystemFontOfSize:38]; // 19 - Jatin Chauhan 27-Nov-2013
            text1.backgroundColor = [UIColor clearColor];
            text1.numberOfLines = 0;
            [text1 sizeToFit];
            [self.view addSubview:text1];
            
            UIImage * img = [UIImage imageNamed:@"blue-btn"];
            img = [img stretchableImageWithLeftCapWidth: img.size.width/2 topCapHeight: img.size.height/2];
            
            UIButton * doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];

            // Jatin Chauhan 27-nov-2013
            
            //doneBtn.frame = CGRectMake(13, CGRectGetMaxY(text1.frame) + 30, 294, 45);

            
            doneBtn.frame = CGRectMake(13, CGRectGetMaxY(text1.frame) + 80, 610, 75);
            
            // -Jatin Chauhan 27-nov-2013
            
            [doneBtn setBackgroundImage: img forState:UIControlStateNormal];
            [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
            [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [doneBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [doneBtn setTitleShadowColor:[UIColor colorWithWhite: 0 alpha: 0.5] forState:UIControlStateNormal];
            doneBtn.titleLabel.shadowOffset = CGSizeMake(1, 0);
            doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize: 36];// 18 - Jatin Chauhan 27-Nov-2013
            [doneBtn addTarget:self.questionsViewController action: @selector(doneClicked) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview: doneBtn];
            
            
            [self.questionsViewController reportSent];
        }
       
       // [[Content shared] reload];
    }];
  
     });  

    //commented on 24 march
    /*dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        [[Content shared] sendReport:self.patientRecordSet];
        //self.record.date = [NSDate date];
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityIndicatorView removeFromSuperview];
            [waitingLabel removeFromSuperview];
            UILabel * text1 = [[[UILabel alloc] initWithFrame:CGRectMake(13, 10, 300, 200)] autorelease];
            text1.textAlignment = UITextAlignmentLeft;
            
            if ([[Content shared] isGreen:self.patientRecordSet])
            {
                text1.text = @"Your results are great!\n\nPlease continue with your current treatment plan and check in again at your next scheduled time.\n\nThank you for participating in the Heart Success Program powered by DocView iT3.";
            }
            else
            {
                text1.text = @"Based on your results a nurse will be calling you soon.\n\nThank you for participating in the Heart Success Program powered by DocView iT3.";
            }
            
            text1.textColor = [UIColor whiteColor];
            text1.font = [UIFont boldSystemFontOfSize:19];
            text1.backgroundColor = [UIColor clearColor];
            text1.numberOfLines = 0;
            [text1 sizeToFit];
            [self.view addSubview:text1];
            
            UIImage * img = [UIImage imageNamed:@"blue-btn"];
            img = [img stretchableImageWithLeftCapWidth: img.size.width/2 topCapHeight: img.size.height/2];
            
            UIButton * doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            doneBtn.frame = CGRectMake(13, CGRectGetMaxY(text1.frame) + 30, 294, 45);
            [doneBtn setBackgroundImage: img forState:UIControlStateNormal];
            [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
            [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [doneBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [doneBtn setTitleShadowColor:[UIColor colorWithWhite: 0 alpha: 0.5] forState:UIControlStateNormal];
            doneBtn.titleLabel.shadowOffset = CGSizeMake(1, 0);
            doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
            [doneBtn addTarget:self.questionsViewController action: @selector(doneClicked) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview: doneBtn];
            
            [self.questionsViewController reportSent];
            [[Content shared] reload];
            
        });
    });*/
    

   /* dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        [[Content shared] sendRecord: self.record]; 
        self.record.date = [NSDate date];
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityIndicatorView removeFromSuperview];
            [waitingLabel removeFromSuperview];
            UILabel * text1 = [[[UILabel alloc] initWithFrame:CGRectMake(13, 10, 300, 200)] autorelease];
            text1.textAlignment = UITextAlignmentLeft;
            
            
#if HFM
            if ([self.record isGreen])
            {
                text1.text = @"Your results are great!\n\nPlease continue with your current treatment plan and check in again at your next scheduled time.\n\nThank you for participating in the Heart Success Program powered by DocView iT3.";
            }
            else
            {
                text1.text = @"Based on your results a nurse will be calling you soon.\n\nThank you for participating in the Heart Success Program powered by DocView iT3.";
            }

#else
            if ([self.record isGreen])
            {
                text1.text = @"Your results are great!\n\nPlease continue with your current treatment plan and check in again at your next scheduled time.\n\nThank you for participating in this program powered by DocView iT3.";
            }
            else
            {
                text1.text = @"Based on your results a nurse will be calling you soon.\n\nThank you for participating in this program powered by DocView iT3.";
            }
#endif
            text1.textColor = [UIColor whiteColor];
            text1.font = [UIFont boldSystemFontOfSize:19];
            text1.backgroundColor = [UIColor clearColor];
            text1.numberOfLines = 0;
            [text1 sizeToFit];
            [self.view addSubview:text1];
            
            UIImage * img = [UIImage imageNamed:@"blue-btn"];
            img = [img stretchableImageWithLeftCapWidth: img.size.width/2 topCapHeight: img.size.height/2];
            
            UIButton * doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            doneBtn.frame = CGRectMake(13, CGRectGetMaxY(text1.frame) + 30, 294, 45);
            [doneBtn setBackgroundImage: img forState:UIControlStateNormal];
            [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
            [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [doneBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [doneBtn setTitleShadowColor:[UIColor colorWithWhite: 0 alpha: 0.5] forState:UIControlStateNormal];
            doneBtn.titleLabel.shadowOffset = CGSizeMake(1, 0);
            doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
            [doneBtn addTarget:self.questionsViewController action: @selector(doneClicked) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview: doneBtn];
            
            [self.questionsViewController reportSent];
            [[Content shared] reload];
            
        });
    });*/
}
#endif


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordCell * cell = cell = [[[RecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: nil] autorelease];
    [cell updateWithRecordForReport: self.record];
    return cell;
}

@end
