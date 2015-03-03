#import "AnswerViewController.h"
#import "UIViewController+Branding.h"
#import "QuestionsViewController.h"
#import <Parse/Parse.h>

@implementation AnswerViewController
@synthesize record,removeCheckInController;

- (void)dealloc
{
    [record release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (int)level:(CGFloat)score
{
    if (score < 1.0)
    {
        return 0;
    }
    else if (score >= 1.0 && score < 2.0)
    {
        return 1;
    }
    else if (score >= 2.0 && score < 3.0)
    {
        return 2;
    }
    else
    {
        return 3;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadBrandingViews];
    
    NSString * treatment = record.treatment;
    CGFloat score = record.score;
    int level =  [self level: score];
    
    NSDictionary* d = [[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] 
                                                                    pathForResource:@"answer" 
                                                                    ofType:@"plist"]] objectForKey:@"answers"] objectAtIndex: level];
    
    if (level == 0)
    {
        treatment = @"You're doing fine. Thanks for checking in!";
    }
    UIImageView* hdr = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[d objectForKey:@"header"]]] autorelease];
    hdr.frame = CGRectMake(3, 10, 315, 43);
    [self.view addSubview:hdr];
    
    UIImageView* bg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-dark"]] autorelease];
    bg.frame = CGRectMake(3, 53, 315, 182);
    bg.userInteractionEnabled = YES;
    [self.view addSubview:bg];
    
    UILabel* ltitle = [[[UILabel alloc] initWithFrame:CGRectMake(15, 13, 248, 23)] autorelease];
    ltitle.text = [d objectForKey:@"title"];
    ltitle.textColor = [UIColor whiteColor];
    ltitle.font = [UIFont boldSystemFontOfSize:14];
    ltitle.backgroundColor = [UIColor clearColor];
    [hdr addSubview:ltitle];
    
    UILabel* lscore = [[[UILabel alloc] initWithFrame:CGRectMake(275, 10, 30, 29)] autorelease];
    lscore.textAlignment = UITextAlignmentCenter;
    //lscore.text = [NSString stringWithFormat: @"%.1f",score];
    lscore.textColor = [UIColor whiteColor];
    lscore.font = [UIFont boldSystemFontOfSize:14];
    lscore.backgroundColor = [UIColor clearColor];
    [hdr addSubview:lscore];
    
    
    UITextView * treatmentView = [[[UITextView alloc] initWithFrame: CGRectMake(7, 0, bg.frame.size.width - 13, bg.frame.size.height)] autorelease];
    treatmentView.text = treatment;
    treatmentView.textColor = [UIColor whiteColor];
    treatmentView.font = [UIFont boldSystemFontOfSize:14];
    treatmentView.backgroundColor = [UIColor clearColor];
    [bg addSubview: treatmentView];

    /*
    UILabel* l2 = [[[UILabel alloc] init] autorelease];
    l2.numberOfLines = 10;
    l2.textAlignment = UITextAlignmentLeft;
    l2.text = [d objectForKey:@"text2"];
    l2.textColor = [UIColor whiteColor];
    l2.font = [UIFont systemFontOfSize:13];
    l2.backgroundColor = [UIColor clearColor];
    float y = 15 + size1.height + 20;
    CGSize size2 = [l2.text sizeWithFont:l2.font constrainedToSize:CGSizeMake(285, 182-y-5)];
    l2.frame = CGRectMake(15, y, 285, size2.height);
    [bg addSubview:l2];
    //*/
    
    /*
    UIButton* b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = CGRectMake(3, 235, 315, 53);
    [b setBackgroundImage:[UIImage imageNamed:@"button-action"] forState:UIControlStateNormal];
    [b setTitle:[d objectForKey:@"button-title"] forState:UIControlStateNormal];
    [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [b setImage:[UIImage imageNamed:[d objectForKey:@"button-icon"]] forState:UIControlStateNormal];
    b.titleLabel.shadowOffset = CGSizeMake(1, 0);
    b.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    b.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [self.view addSubview:b];
    //*/
    
#ifdef COPD
    if (record.reportStatus != ReportStatusUserAcknowledged)
    {
        for (PFObject * rec in [Content shared].rawRecords)
        {
            if ([rec.objectId isEqualToString: record.Id])
            {
                [rec setObject: [NSNumber numberWithInt: ReportStatusUserAcknowledged] forKey: @"status"];
                [rec saveInBackground];
                
                NSMutableDictionary *data = [[[NSMutableDictionary alloc] init] autorelease];
                [data setObject: [NSString stringWithFormat: @"%@ acknowledged treatment", [[Content shared].user valueForKey: @"username"]] forKey:@"alert"];
                [data setObject:[NSNumber numberWithInt:1] forKey:@"badge"];
                [data setObject: [Content shared].user.objectId forKey:@"userId"];
                NSError * error = nil;
                [PFPush sendPushDataToChannel: @"" withData: data error: &error];
                
                break;
            }
        }
    }
    record.reportStatus = ReportStatusUserAcknowledged;
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    if (self.removeCheckInController)
    {
        self.removeCheckInController = NO;
        NSMutableArray * a = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
        
        for (UIViewController * vc in a)
        {
            if ([vc isKindOfClass: [QuestionsViewController class]]) 
            {
                [a removeObject: vc];
                [self.navigationController setViewControllers: a animated: NO];
                break;
            }
        }
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(doneClicked)] autorelease];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)doneClicked
{
    [self dismissModalViewControllerAnimated: YES];
}

@end
