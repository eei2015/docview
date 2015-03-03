#import "ReportViewController.h"
#import "UIViewController+Branding.h"
#import "RecordCell.h"
#import <Parse/Parse.h>
#import "DetailsCell.h"
#import  <Bully/Bully.h>
#import "FlashingCell.h"
#import "ReportsViewController.h"
#import "SBJson.h"
#import "COPDBackend.h"
#import "MedicationCell.h"
#import "MedicationHeaderCell.h"
#import "UITableViewCell+Inset.h"


#if COPD
static NSString * cols[] =
{
    @"Breathlessness",
    @"Sputum",
    @"Peak Flow",
    @"Temperature Over 100˚?",
    @"Symptoms"
};
#elif HFBASE
static NSString * cols[] =
{
    @"Overall",
    @"Weight",
    @"Weight Change",
    @"Breathing",
    @"Swollen?",
    @"Body Parts?",
    @"Nausea?",
    @"Taking Meds?",
    @"Δ Water Pill?",
    @"Δ Heart Meds?",
    @"Satisfaction"
};
#elif HFB
static NSString * cols[] =
{
    @"Overall",
    @"Weight",
    @"Weight Change",
    @"Breathing",
    @"Low Salt Diet",
    @"Swollen?",
    @"Body Parts?",
    @"Nausea?",
    @"Trouble In Bed?",
    @"Filled Rx?",
    @"Understands Rx?",
    @"Taking Meds?",
	@"Nurse Visit?",
    @"Δ Water Pill?",
    @"Δ Heart Meds?",
    @"Need Help",
    @"Satisfaction"
};
#endif

@interface ReportViewController (PrivateMethods)
- (void)sendAcknowledgement;
@end

@implementation ReportViewController

@synthesize record, shouldShowReportsList, parentController,pMedications=_pMedications,iMedications=_iMedications;


-(void)dealloc
{
    self.pMedications=nil;
    self.iMedications=nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self)
	{
		self.shouldShowReportsList = NO;
		self.parentController = nil;
	}
	return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)doneClicked
{
    [self dismissModalViewControllerAnimated: YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    self.tableView.frame = CGRectMake(65, 50, 640, 832);

    [super viewDidLoad];
    [self loadBrandingViews];
}

-(void)updateReportView:(NSString *)strReportId
{
    
}

- (void)sendAcknowledgement
{
#if !COPD
    if (record.reportStatus != ReportStatusUserAcknowledged)
	{
	//	for (COPDObject * rec in [Content shared].rawRecords)
	//	{
		//	if ([rec.objectId isEqualToString: record.Id])
	//		{
           /* COPDObject *rec=[[[COPDObject alloc] init] autorelease];
				[rec setObject: [NSNumber numberWithInt: ReportStatusUserAcknowledged] forKey: @"ReportStatus_ID"];
				[rec setObject:[NSDate date] forKey:@"acknowledgedDate"];
                [rec setObject:self.record.reportId forKey:@"Report_ID"];
				[rec saveInBackground];*/
        NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt: ReportStatusUserAcknowledged],@"ReportStatus_ID",self.record.reportId,@"Report_ID" ,nil];
        
        [[COPDBackend sharedBackend] saveStatusInBackground:param WithBlock:^(NSError *errorOrNil) {
            if (errorOrNil==Nil) {
                
                COPDObject * newMessage =[[[COPDObject alloc] init] autorelease]; //[PFObject objectWithClassName: @"Message"];
                //2014-01-30 Vipul Push notification message use first name
                //[newMessage setObject: [NSString stringWithFormat: @"%@ acknowledged treatment", [Content shared].copdUser.username] forKey: @"Chat_Message"];
                [newMessage setObject: [NSString stringWithFormat: @"%@ acknowledged treatment", [Content shared].userFirstName] forKey: @"Chat_Message"];
                //2014-01-30 Vipul Push notification message use first name
                [newMessage setObject: [Content shared].copdUser.objectId forKey: @"CreatedBy"];
                [newMessage setObject: [Content shared].copdUser.objectId forKey: @"PatientID_FK"];
                [newMessage setObject: [[Content shared].copdUser objectForKey:@"PatientDisease_ID"] forKey: @"PatientDiseaseID_FK"];
                [newMessage setObject: [Content shared].diseaseID forKey: @"Disease_ID"];
                [newMessage setObject: [NSNumber numberWithInt:ReportStatusUserAcknowledged] forKey: @"ReportStatus_ID_FK"];
                [newMessage setObject: [NSNumber numberWithInt: YES] forKey: @"IsFromPatient"];
                [newMessage setObject: [NSNumber numberWithInt: NO] forKey: @"IsPatientAcknowledged"];
                [newMessage setObject:[NSString stringWithFormat:@"%@ %@", [Content shared].userFirstName, [Content shared].userLastName] forKey:@"SenderFullName"];
                
                [newMessage saveChatInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error)
                    {
                        NSMutableDictionary *data = [[[NSMutableDictionary alloc] init] autorelease];
                        //2014-01-30 Vipul Push notification message use first name
                        //[data setObject: [NSString stringWithFormat: @"%@ acknowledged treatment", [Content shared].copdUser.username] forKey:@"alert"];
                        [data setObject: [NSString stringWithFormat: @"%@ acknowledged treatment", [Content shared].userFirstName] forKey:@"alert"];
                        //2014-01-30 Vipul Push notification message use first name
                        [data setObject:[NSNumber numberWithInt:1] forKey:@"badge"];
                        [data setObject:@"1" forKey:@"acknowledged"];
                        [data setObject: [Content shared].copdUser.objectId forKey:@"userId"];
                        
                        //2014-03-04 Vipul Amazon SNS
//                        [[Content shared] initBackendForIpad];
//                        NSError * error = nil;
//                        BOOL isSucceed=[PFPush sendPushDataToChannel: @"" withData: data error: &error];
//                        
//                        NSMutableDictionary *notifyData=[[[NSMutableDictionary alloc] init] autorelease];
//                        [notifyData setObject:@"" forKey:@"ParseChannels"];
//                        [notifyData setObject:[data JSONRepresentation] forKey:@"Notification_Text"];
//                        [notifyData setObject:[Content shared].copdUser.objectId  forKey:@"CreatedBy"];
//                        [notifyData setObject:@"0" forKey:@"IsFromChat"];
//                        [notifyData setObject:[NSString stringWithFormat:@"%u",isSucceed] forKey:@"Status"];
//                        [notifyData setObject:(error)?error:@"" forKey:@"ParseMessage"];
//                        
//                        [[COPDBackend sharedBackend] saveNotificationInBackground:notifyData WithBlock:^(NSError *errorOrNil) {
//                            //
//                        }];
                        
                        [[Content shared] sendAmazonNotification:[NSString stringWithFormat: @"%@ acknowledged treatment", [Content shared].userFirstName] TopicARN:@"Clinician" EndpointARN:nil];
                        
                        NSMutableDictionary *notifyData=[[[NSMutableDictionary alloc] init] autorelease];
                        [notifyData setObject:@"" forKey:@"ParseChannels"];
                        [notifyData setObject:[data JSONRepresentation] forKey:@"Notification_Text"];
                        [notifyData setObject:[Content shared].copdUser.objectId  forKey:@"CreatedBy"];
                        [notifyData setObject:@"0" forKey:@"IsFromChat"];
                        [notifyData setObject:[NSString stringWithFormat:@"%u",true] forKey:@"Status"];
                        [notifyData setObject:@"" forKey:@"ParseMessage"];
                        
                        [[COPDBackend sharedBackend] saveNotificationInBackground:notifyData WithBlock:^(NSError *errorOrNil) {
                            //
                        }];
                        
                        //2014-03-04 Vipul Amazon SNS
                    }
                }];
                
               
            }
        }];
        
				
        
                
                // NSError *error = nil;
                // [PFPush sendPushDataToChannel: @"" withData: data error: &error];
                
                
                
               // break;
	//		}
	//	}
	}
	/*if (record.reportStatus != ReportStatusUserAcknowledged)
	{
		for (COPDObject * rec in [Content shared].rawRecords)
		{
			if ([rec.objectId isEqualToString: record.Id])
			{
				[rec setObject: [NSNumber numberWithInt: ReportStatusUserAcknowledged] forKey: @"ReportStatus_ID"];
				//[rec setObject:[NSDate date] forKey:@"acknowledgedDate"];
                [rec setObject:self.record.reportId forKey:@"Report_ID"];
				[rec saveInBackground];

				NSMutableDictionary *data = [[[NSMutableDictionary alloc] init] autorelease];
				[data setObject: [NSString stringWithFormat: @"%@ acknowledged treatment", [Content shared].copdUser.username] forKey:@"alert"];
				[data setObject:[NSNumber numberWithInt:1] forKey:@"badge"];
				[data setObject: [Content shared].copdUser.objectId forKey:@"userId"];
                
                [[Content shared] initBackendForIpad];
				NSError * error = nil;
				BOOL isSucceed=[PFPush sendPushDataToChannel: @"" withData: data error: &error];
                
                NSMutableDictionary *notifyData=[[[NSMutableDictionary alloc] init] autorelease];
                [notifyData setObject:@"" forKey:@"ParseChannels"];
                [notifyData setObject:[data JSONRepresentation] forKey:@"Notification_Text"];
                [notifyData setObject:[Content shared].copdUser.objectId  forKey:@"CreatedBy"];
                [notifyData setObject:@"0" forKey:@"IsFromChat"];
                [notifyData setObject:[NSString stringWithFormat:@"%u",isSucceed] forKey:@"Status"];
                [notifyData setObject:(error)?error:@"" forKey:@"ParseMessage"];
                
                [[COPDBackend sharedBackend] saveNotificationInBackground:notifyData WithBlock:^(NSError *errorOrNil) {
                    //
                }];

                
                // NSError *error = nil;
                // [PFPush sendPushDataToChannel: @"" withData: data error: &error];
               

                
                break;
			}
		}
	}*/
	record.reportStatus = ReportStatusUserAcknowledged;
	[self.tableView reloadData];
#endif
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tableView.frame = CGRectMake(65, 50, 640, 832);


    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.tableView.frame = CGRectMake(65, 50, 640, 832);

    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tableView.frame = CGRectMake(65, 50, 640, 832);

    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{

    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
#if HFBASE
		if (self.record.reportStatus != ReportStatusSentToPatient && self.record.reportStatus != ReportStatusUserAcknowledged)
		{
			return 1;
		}
#endif

		NSInteger acknowledgeCell = 0;
		if (record.reportStatus != ReportStatusUserAcknowledged)
		{
			acknowledgeCell = 1;
		}
        //if ([[record treatment] length] > 0 || [record level] == 0)
        //NSLog(@"%d",record.levelId);
       // NSLog(@"%d",[[record treatment] length]);
        
          if ([[record treatment] length] > 0 || [record levelId] == ReportNormalLevel)
        {
            return 2 + acknowledgeCell;
        }
        return 1 + acknowledgeCell;
    }
    else if (section == 1)
    {
        //return sizeof(cols)/sizeof(NSString *);
        //return [self.record.arrCheckIns count];
        return  1 + [self.iMedications count];
    }
    else if (section == 2)
    {
        //return sizeof(cols)/sizeof(NSString *);
        //return [self.record.arrCheckIns count];
        return  1 + [self.pMedications count];
    }
	else if (section == 3)
	{
		return 1;
	}

    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#if COPD
    return 2;
#else
	if (self.shouldShowReportsList)
	{
		return 4;//return 3;
	}
	return 3; //return 2;
#endif
}


// Jatin Chauhan 28-Nov-2013


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}


// -Jatin Chauhan 28-Nov-2013


- (NSString* )tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
#if COPD
        return nil;
#else
        //NSLog(@"%d",self.record.reportStatus);
		if (self.record.reportStatus != ReportStatusSentToPatient && self.record.reportStatus != ReportStatusUserAcknowledged)
		{
			return @"Report has not yet been reviewed";
		}
		return @"Instructions From Nurse";
#endif
    }
    else if (section == 1)
    {
//        return @"Intervention Medications"; //Check In Summary
        return @"Medication Changes";
    }
    else if (section == 2)
    {
        return @"Medication Plan"; //Check In Summary
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        CGSize sz =  [record.treatment sizeWithFont: [UIFont systemFontOfSize: 26] constrainedToSize: CGSizeMake(560, FLT_MAX)];
        return MAX(sz.height + 40, 75); // 30 height // ystemFontOfSize: 13 - Jatin Chauhan 28-Nov-2013
    }
    
    return 80;// 42
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{    
    UILabel* l = [[[UILabel alloc] initWithFrame:CGRectMake(21, 0, 600, 60)] autorelease];// (21,0,300,30)
    l.font = [UIFont boldSystemFontOfSize:34];//17 - Jatin Chauhan 28-Nov-2013
    l.backgroundColor = [UIColor clearColor];
    l.textColor = [UIColor whiteColor];
    l.shadowColor = [UIColor blackColor];
    l.shadowOffset = CGSizeMake(0, 1);
    l.text = [self tableView: tableView titleForHeaderInSection: section];
    
    UIView* v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 640, 70)] autorelease];// (0,0,320,35)- Jatin Chauhan 28-Nov-2013
    v.backgroundColor = [UIColor clearColor];
    [v addSubview: l];
    return v;
}

- (NSString *)markFromNumber:(NSNumber *)n
{
    if ([n intValue] == 1)
    {
        return @"YES";
    }
    return @"NO";
}

- (UIImage *)imageBgFromNumber:(NSNumber *)n
{
    if ([n intValue] == 2)
    {
        return [UIImage imageNamed: @"green-pill.png"];
    }
    else if([n intValue] == 1)
    {
        return [UIImage imageNamed: @"yellow-pill.png"];
    }
    else if([n intValue] == 0)
    {
        return [UIImage imageNamed: @"red-pill.png"];
    }
    return nil;
}

- (NSString *)smileFromNumber:(NSNumber *)n applyToCell:(UITableViewCell *)cell
{
    UIImageView * img = (UIImageView *)[cell viewWithTag: 111];
    img.image = [[self imageBgFromNumber: n] stretchableImageWithLeftCapWidth: 20 topCapHeight: 9];
    
    if ([n intValue] == 2)
    {
        return [@"😃" stringByAppendingString: @" 1"];
    }
    else if([n intValue] == 1)
    {
        return [@"😳" stringByAppendingString: @" 3"];
    }
    else if([n intValue] == 0)
    {
        return [@"😞" stringByAppendingString: @" 5"];
    }
    
    return @"";
}

- (NSString *)buildBodyStringFromSet:(NSSet *)set
{
    NSMutableArray * strings = [NSMutableArray array];
    
    for (NSNumber * i in set)
    {
        [strings addObject: painItems[[i intValue]]];
    }
    
    return [strings componentsJoinedByString: @", "];
}


- (NSString *)diffFromNumber:(NSInteger)number
{
    if (number == INT_MAX)
    {
        return @"—";
    }
    return [NSString stringWithFormat: @"%@%d",number >= 0 ? @"▲" : @"▼", abs(number)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
#if COPD
            RecordCell * cell = [[[RecordCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell updateWithRecordForReport: record];
            return cell;
#else
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"recCell"];
            if (!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: @"recCell"] autorelease];
                cell.textLabel.font = [UIFont boldSystemFontOfSize: 30]; // 15 - Jatin Chauhan 
                cell.detailTextLabel.font = [UIFont systemFontOfSize: 26]; // 13 - Jatin Chauhan 28-Nov-2013
            }
            
            if (record.reportStatus == ReportStatusUserAcknowledged)
            {
                cell.detailTextLabel.text = @"Response received";
            }
            else if (record.reportStatus == ReportStatusSentToPatient)
            {
                cell.detailTextLabel.text = @"NEW. Response received";
            }
            else
            {

                cell.detailTextLabel.text = @"Awaiting response from nurse";
            }
            
            
            //NSLog(@"RD: %@",record.reportDate);
            
            
            NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
            [formatter setDateStyle: NSDateFormatterLongStyle];
            [formatter setTimeStyle: NSDateFormatterShortStyle];
            cell.textLabel.text = [formatter stringFromDate: record.reportDate];
            //NSLog(@"RD: %@",cell.textLabel.text);
            return cell;

#endif
        }
        else if (indexPath.row == 1)
        {
            UITableViewCell * cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.font = [UIFont boldSystemFontOfSize: 30];//15 - Jatin Chauhan 28-Nov-2013
			cell.textLabel.textColor = [UIColor blackColor];
          
#if COPD
            #else
            //if ([record isGreen])
            if (record.levelId==ReportNormalLevel)
            {
                cell.textLabel.text = @"You're doing fine.";
            }
            else
            {
                if ([record.treatment length] == 0)
                {
                    cell.textLabel.text = @"No intervention";
                }
                else
                {
                    cell.textLabel.text = @"Patient Instructions";
					cell.textLabel.textColor = [UIColor redColor];
                    cell.detailTextLabel.text = record.treatment;
                }
            }
#endif
            cell.detailTextLabel.numberOfLines = 0;
            cell.detailTextLabel.font = [UIFont systemFontOfSize: 26];// 13 - Jatin Chauhan 28-Nov-2013
            return cell;
        }
#ifndef COPD
		else
		{
			FlashingCell * cell = [[[FlashingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			return cell;
		}
#endif
    }
    else if (indexPath.section == 1)
	{
		//return nil;
        if ([self.iMedications count]>0) {
            static NSString *medicationCellIdentifier = @"interventionmedication";
            static NSString *headerCellIdentifier = @"interventionheader";
            
            if (indexPath.row == 0)
            {
                MedicationHeaderCell *cell =  [tableView dequeueReusableCellWithIdentifier:headerCellIdentifier];
                if (cell == nil) {
                    cell = [[[MedicationHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerCellIdentifier hasDuration: NO] autorelease];
                    
                    cell.simpleHeader = !tableView.editing;
                }
                return cell;
            }
            else
            {
                MedicationCell *cell =  [tableView dequeueReusableCellWithIdentifier: medicationCellIdentifier];
                if (cell == nil) {
                    cell = [[[MedicationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:medicationCellIdentifier hasDuration:NO] autorelease];
                    
                    
                }
                //cell.delegate = self;
                
                NSString * medicationString = @"–";
                Medication * medication = [self.iMedications objectAtIndex: indexPath.row-1];
                
                if (medication.MedicationTitle.length>0)
                {
                    medicationString = medication.MedicationTitle;
                }
                
                NSString * dosageString = @"–";
                if (medication.MedicationDosageValue.length>0)
                {
                    dosageString = medication.MedicationDosageValue;
                }
                
                
                NSString * freqString = @"–";
                
                if (medication.FrequencyCode.length>0)
                {
                    freqString = medication.FrequencyCode;
                }
                
                
                [cell updateWithMedication: medicationString dosage: dosageString frequency: freqString duration: nil];
                return cell;
            }
            
        } else
        {
            UITableViewCell * cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.font = [UIFont boldSystemFontOfSize: 24];// 12 - Jatin Chauhan 28-Nov-2013
			cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.text = @"No change in medications";
            cell.detailTextLabel.numberOfLines = 0;
            cell.detailTextLabel.font = [UIFont systemFontOfSize: 24];//12
            return cell;
            
        }

    }
    else if (indexPath.section == 2) // Profile Medications
    {
       /* UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell)
        {
            cell = [[[DetailsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"] autorelease];
            UIImageView * imageView = [[[UIImageView alloc] initWithFrame: CGRectMake(248, 9, 47, 25)] autorelease];
            imageView.tag = 111;
            [cell.contentView addSubview: imageView];
        
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.backgroundColor = [UIColor clearColor];
        }
        
        UIImageView * img = (UIImageView *)[cell viewWithTag: 111];
        img.image = nil;
        
        NSString * detailsText = nil;
        PatientCheckIn *pci=(PatientCheckIn*)[self.record.arrCheckIns objectAtIndex:indexPath.row];
        switch (pci.qQType) {
            case SingleSelection:
                //
                detailsText = [self smileFromNumber: [NSNumber numberWithInt:[pci.qValue intValue]] applyToCell: cell];
                
                break;
            case MultipleSelection:
                //
                
                detailsText = [NSString stringWithFormat: @"%@",pci.qValue];
                break;
            case Input:
                //
                detailsText = [NSString stringWithFormat: @"%@",pci.qValue];
                break;
            case Range:
                //
                detailsText = [NSString stringWithFormat: @"%@",pci.qValue];
                break;
            case Option:
                //
                detailsText = [self markFromNumber: [NSNumber numberWithInt:[pci.qValue intValue]]];
                break;
                
            default:
                break;
        }
        
        
        
        cell.textLabel.text =pci.qLabel;
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.text = detailsText;
        cell.detailTextLabel.numberOfLines = 2;
        return cell;*/
        
        if ([self.pMedications count]>0) {
            static NSString *medicationCellIdentifier = @"medication";
            static NSString *headerCellIdentifier = @"header";
            
            if (indexPath.row == 0)
            {
                MedicationHeaderCell *cell =  [tableView dequeueReusableCellWithIdentifier:headerCellIdentifier];
                if (cell == nil) {
                    cell = [[[MedicationHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerCellIdentifier hasDuration: NO] autorelease];
                    
                    cell.simpleHeader = !tableView.editing;
                }
                return cell;
            }
            else
            {
                MedicationCell *cell =  [tableView dequeueReusableCellWithIdentifier: medicationCellIdentifier];
                if (cell == nil) {
                    cell = [[[MedicationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:medicationCellIdentifier hasDuration:NO] autorelease];
                    
                    
                }
                //cell.delegate = self;
                
                NSString * medicationString = @"–";
                Medication * medication = [self.pMedications objectAtIndex: indexPath.row-1];
                
                if (medication.MedicationTitle.length>0)
                {
                    medicationString = medication.MedicationTitle;
                }
                
                NSString * dosageString = @"–";
                if (medication.MedicationDosageValue.length>0)
                {
                    dosageString = medication.MedicationDosageValue;
                }
                
                
                NSString * freqString = @"–";
                
                if (medication.FrequencyCode.length>0)
                {
                    freqString = medication.FrequencyCode;
                }
                
                
                [cell updateWithMedication: medicationString dosage: dosageString frequency: freqString duration: nil];
                return cell;
            }
        
        } else
        {
            UITableViewCell * cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.font = [UIFont boldSystemFontOfSize: 24];// 12 - Jatin Chauhan 28-Nov-2013
			cell.textLabel.textColor = [UIColor blackColor];
             cell.textLabel.text = @"No Medications";
            cell.detailTextLabel.numberOfLines = 0;
            cell.detailTextLabel.font = [UIFont systemFontOfSize: 24];// 12
            return cell;

        }
    }
	else if (indexPath.section == 3)
	{
		UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
		cell.textLabel.text = @"View all check-ins & responses";
		cell.textLabel.font = [UIFont boldSystemFontOfSize:30];//15
        
		//if ([[Content shared].records count] == 0)
        if ([Content shared].allReportsCount == 0)
		{
			cell.detailTextLabel.text = @"You haven't checked in yet.";
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		else
		{
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			//cell.detailTextLabel.text = [NSString stringWithFormat:@"You have completed %d check-ins", [[Content shared].records count]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"You have completed %d check-ins", [Content shared].allReportsCount];
		}
        
		cell.detailTextLabel.font = [UIFont systemFontOfSize:26];//13 - Jatin Chauhan 28-Nov-2013
        
		cell.imageView.image = [UIImage imageNamed:@"calendar.png"];
		return cell;
	}
    
    return nil;
}

    /*
#if COPD
        NSInteger sputumColor = self.record.sputumColor;
        NSInteger sputumConsistency = self.record.sputumConsistency;
        
        if (self.record.sputumQuantity == 0) 
        {
            sputumColor = 0;
            sputumConsistency = 0;
        }
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize: 17];
        
        switch (indexPath.row)
        {
            case 0:
                detailsText = [NSString stringWithFormat: @"%.1f", self.record.breathlessness];
                break;
            case 1:
            {
                if (self.record.sputumQuantity == 0)
                {
                    detailsText = sputumQuantityItems[self.record.sputumQuantity];
                }
                else
                {
                    detailsText = [NSString stringWithFormat: @"%@ — %@ — %@",sputumQuantityItems[self.record.sputumQuantity], sputumColorItems[sputumColor],sputumConsistencyItems[sputumConsistency]];
                }
            }
                break;
            case 2:
                detailsText = [NSString stringWithFormat: @"%d", self.record.peakFlowMeasurement];
                break;
            case 3:
                detailsText = [NSString stringWithFormat: @"%@", self.record.tempOver100 ? @"Yes" : @"No"];
                break;
            case 4:
            {
                NSMutableArray * symptoms = [NSMutableArray array];
                if (self.record.cough)
                {
                    [symptoms addObject: @"Cough"];
                }
                
                if (self.record.wheeze)
                {
                    [symptoms addObject: @"Wheeze"];
                }
                
                if (self.record.soreThroat)
                {
                    [symptoms addObject: @"Sore Throat"];
                }
                
                if (self.record.nasalCongestion)
                {
                    [symptoms addObject: @"Nasal Congestion"];
                }
                
                if ([symptoms count] == 2)
                {
                    cell.detailTextLabel.font = [UIFont systemFontOfSize: 16];
                }
                
                if ([symptoms count] > 2)
                {
                    cell.detailTextLabel.font = [UIFont systemFontOfSize: 15];
                }
                
                if ([symptoms count] == 0)
                {
                    detailsText = @"None";
                }
                else
                {
                    detailsText = [symptoms componentsJoinedByString: @", "];
                }
            }
                
                break;
            default:
                break;
        }
#elif HFBASE
        switch (indexPath.row)
        {
            case 0:
                detailsText = [self smileFromNumber: record.CHF_feelToday applyToCell: cell];
                break;
            case 1:
                detailsText = [NSString stringWithFormat: @"%@",record.CHF_weightToday];
                break;
            case 2:
                detailsText = [self markFromNumber: record.CHF_weightChanged];
                break;
            case 3:
                detailsText = [self smileFromNumber: record.CHF_breathingTodayAtRest applyToCell: cell];
                break;
            case 4:
                detailsText = [self markFromNumber: record.CHF_isSwallen];
                break;
            case 5:
                detailsText = [self buildBodyStringFromSet: record.CHF_bodyPartsWithPain];
                break;
            case 6:
                detailsText = [self markFromNumber: record.CHF_haveNausea];
                break;
            case 7:
                detailsText = [self markFromNumber: record.CHF_beenTakingMedications];
                break;
            case 8:
                detailsText = [self markFromNumber: record.CHF_somebodyChangedWaterPills];
                break;
            case 9:
                detailsText = [self markFromNumber: record.CHF_somebodyChangedHeartMeds];
                break;
            case 10:
                detailsText = [self smileFromNumber: record.CHF_experienceRate applyToCell: cell];
                break;
            default:
                break;
        }
#elif HFB
        
        switch (indexPath.row)
        {
            case 0:
                detailsText = [self smileFromNumber: record.CHF_feelToday applyToCell: cell];
                break;
            case 1:
                detailsText = [NSString stringWithFormat: @"%@",record.CHF_weightToday];
                break;
            case 2:
                detailsText = [self markFromNumber: record.CHF_weightChanged];
                break;
            case 3:
                detailsText = [self smileFromNumber: record.CHF_breathingTodayAtRest applyToCell: cell];
                break;
            case 4:
                detailsText = [self markFromNumber: record.CHF_lowSaltDiet];
                break;
            case 5:
                detailsText = [self markFromNumber: record.CHF_isSwallen];
                break;
            case 6:
                detailsText = [self buildBodyStringFromSet: record.CHF_bodyPartsWithPain];
                break;
            case 7:
                detailsText = [self markFromNumber: record.CHF_haveNausea];
                break;
            case 8:
                detailsText = [self markFromNumber: record.CHF_haveTroubleInBed];
                break;
            case 9:
                detailsText = [self markFromNumber: record.CHF_filledPrescriptions];
                 break;
            case 10:
                detailsText = [self markFromNumber: record.CHF_understandShedule];
                 break;
            case 11:
                detailsText = [self markFromNumber: record.CHF_beenTakingMedications];
                break;
			case 12:
                detailsText = [self markFromNumber: record.CHF_nurseVisit];
                break;
            case 13:
                detailsText = [self markFromNumber: record.CHF_somebodyChangedWaterPills];
                break;
            case 14:
                detailsText = [self markFromNumber: record.CHF_somebodyChangedHeartMeds];
                break;
            case 15:
                detailsText = [self markFromNumber: record.CHF_needHelp];
                break;
            case 16:
                detailsText = [self smileFromNumber: record.CHF_experienceRate applyToCell: cell];
                break;
            default:
                break;
        }
#endif
        */

        //cell.textLabel.text = cols[indexPath.row];
       


#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0 && indexPath.row == 2)
	{
		return indexPath;
	}
	else if (indexPath.section == 3)
	{
		return indexPath;
	}
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section == 0 && indexPath.row == 2)
	{
		[self sendAcknowledgement];
	}
	else if (indexPath.section == 3)
	{
#if HFBASE
		if (!self.parentController)
		{
			return;
		}
        
        ReportsViewController *vc  = [[[ReportsViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
        [self.parentController pushViewController:vc animated:YES];
#endif
	}
}

@end
