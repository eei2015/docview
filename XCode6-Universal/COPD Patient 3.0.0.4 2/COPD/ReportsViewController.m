#import "ReportsViewController.h"
#import "Content.h"
#import "UIViewController+Branding.h"
#import "RecordCell.h"
#import "AnswerViewController.h"
#import "ReportViewController.h"
#import "TSAlertView.h"


@implementation ReportsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - actions

- (void)reload
{
    Content *content=[Content shared];
    [content queryPatientAllReports:^(NSError *errorOrNil) {
        //
        if (errorOrNil==nil) {
             [self.tableView reloadData];
        }
    }];
   
}


#pragma mark - View lifecycle

- (UILabel *)titleLabel
{
    UILabel* l = [[[UILabel alloc] initWithFrame:CGRectMake(50, 0, 600, 60)] autorelease];// (20, 0, 300, 30)
    l.font = [UIFont boldSystemFontOfSize:34];// 17 Jatin Chauhan 28-Nov-2013
    l.backgroundColor = [UIColor clearColor];
    l.textColor = [UIColor whiteColor];
    l.shadowColor = [UIColor blackColor];
    l.shadowOffset = CGSizeMake(0, 1);
    return l;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadBrandingViews];

    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reload) name: kDataWasUpdated object: nil];
    
     [self reload];
}


- (void)viewDidUnload
{
    self.tableView.frame = CGRectMake(65, 50, 640, 832);

    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)viewWillAppear:(BOOL)animated
{

    
    [super viewWillAppear:animated];
   
}

- (void)viewDidAppear:(BOOL)animated
{
    self.tableView.frame = CGRectMake(65, 50, 640, 832);

    [super viewDidAppear:animated];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Jatin Chauhan 28-Nov-2013

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 75;
}


// -Jatin Chauhan 28-Nov-2013

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"All Check-Ins & Responses";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{    
    UILabel * l = [self titleLabel];
    l.text = [self tableView: tableView titleForHeaderInSection: section];
    
    UIView* v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 600, 70)] autorelease]; //(0, 0, 320, 35)Jatin Chauhan 28-NOv-2013
    v.backgroundColor = [UIColor clearColor];
    [v addSubview: l];
    return v;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[Content shared].records count];
}


// Jatin Chauhan 28-Nov-2013
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    return 75;
}
// -Jatin Chauhan 28-Nov-2013



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    COPDRecord * rec = [[Content shared].records objectAtIndex: indexPath.row];
    
    
#if COPD
    RecordCell * cell = (RecordCell *)[tableView dequeueReusableCellWithIdentifier: @"recCell"];
    if (!cell)
    {
        cell = [[[RecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"recCell"] autorelease];
    }
    
    [cell updateWithRecordForHistory: rec];
#else
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"recCell"];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: @"recCell"] autorelease];
        cell.textLabel.font = [UIFont boldSystemFontOfSize: 30];//15 - Jatin chauhan 28-Nov-2013;
        cell.detailTextLabel.font = [UIFont systemFontOfSize: 26];// 13 - Jatin chauhan 28-Nov-2013
    }
    
    if (rec.reportStatus == ReportStatusUserAcknowledged)
    {
        cell.detailTextLabel.text = @"Response received";
    }
    else if (rec.reportStatus == ReportStatusSentToPatient)
    {
        cell.detailTextLabel.text = @"NEW: Response received";
    }
    else
    {
        cell.detailTextLabel.text = @"Awaiting response from nurse";
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle: NSDateFormatterLongStyle];
    [formatter setTimeStyle: NSDateFormatterShortStyle];
    cell.textLabel.text = [formatter stringFromDate: rec.reportDate];
    
#endif
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    COPDRecord * rec = [[Content shared].records objectAtIndex: indexPath.row];

    if (rec.reportStatus == ReportStatusSentToPatient)
    {
        
/*#if COPD
        AnswerViewController * vc  = [[[AnswerViewController alloc] init] autorelease];
        
#else
        ReportViewController * vc  = [[[ReportViewController alloc] initWithStyle: UITableViewStyleGrouped] autorelease];
#endif*/
        
        [[Content shared] queryPatientReportById:rec.reportId WithBlock:^(COPDRecord *record, NSMutableDictionary *medications,NSError *errorOrnil) {
            
            //
            if (record) {
                 ReportViewController * vc  = [[[ReportViewController alloc] initWithStyle: UITableViewStyleGrouped] autorelease];
                vc.record = record;
                NSMutableArray *arrPMeds=[medications valueForKey:@"profile"];
                NSMutableArray *arrIMeds=[medications valueForKey:@"intervene"];
                
                vc.pMedications=arrPMeds;
                vc.iMedications=arrIMeds;
                
                [self.navigationController pushViewController: vc animated: YES];
            }
        }];
         
       
    }
    else if  (rec.reportStatus == ReportStatusUserAcknowledged)
    {
        [[Content shared] queryPatientReportById:rec.reportId WithBlock:^(COPDRecord *record, NSMutableDictionary *medications,NSError *errorOrnil) {
            
            //
            if (record) {
                ReportViewController * vc  = [[[ReportViewController alloc] initWithStyle: UITableViewStyleGrouped] autorelease];
                vc.record = record;
                NSMutableArray *arrPMeds=[medications valueForKey:@"profile"];
                NSMutableArray *arrIMeds=[medications valueForKey:@"intervene"];
                
                vc.pMedications=arrPMeds;
                vc.iMedications=arrIMeds;
                [self.navigationController pushViewController: vc animated: YES];
            }
        }];

      /*  ReportViewController * vc  = [[[ReportViewController alloc] initWithStyle: UITableViewStyleGrouped] autorelease];
         
        vc.record = rec;
        [self.navigationController pushViewController: vc animated: YES];*/
    }
    else
    {
        
        [   [[[TSAlertView alloc] initWithTitle:@"DocView iT3"
                                     message:@"This report has not yet been reviewed." 
                                    delegate:nil 
                           cancelButtonTitle:@"OK" 
                           otherButtonTitles:nil] autorelease] show];
            [tableView deselectRowAtIndexPath: indexPath animated: YES];
            }
}

@end

