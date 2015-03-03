#import "OthersQuestionController.h"
#import "YesNoSwitch.h"

@interface OthersQuestionController () <YesNoSwitchDelegate>

@property (nonatomic, retain) UITableViewCell* coughCell;
@property (nonatomic, retain) UITableViewCell* wheezeCell;
@property (nonatomic, retain) UITableViewCell* soreCell;
@property (nonatomic, retain) UITableViewCell* nasalCell;

- (UITableViewCell*)cellWithText:(NSString*)text;
- (YesNoSwitch*)switchForCell:(UITableViewCell*)cell;

@end

@implementation OthersQuestionController

@synthesize coughCell, wheezeCell, soreCell, nasalCell;

- (void)dealloc
{
    [coughCell release];
    [wheezeCell release];
    [soreCell release];
    [nasalCell release];
    
    [super dealloc];
}


#pragma mark - overrides

- (NSString*)titleForHeaderAtSection:(NSInteger)section
{
    return @"Do you have any of these symptoms?";
}

- (BOOL)tableViewBased
{
    return YES;
}

- (NSString *)helpUrl
{
    return @"http://help.docviewsolutions.com/copd-app/help.html#other";
}

#pragma mark - View lifecycle


- (UITableViewCell*)cellWithText:(NSString*)text
{
    YesNoSwitch * yns = [[[YesNoSwitch alloc] initWithStyle: YesNoSwitchStyleLarge] autorelease];
    yns.tag = 100;
    yns.frame = CGRectMake(187, 8, yns.frame.size.width, yns.frame.size.height);
    yns.delegate = self;
    
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:text] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel* ll = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 160, 42)] autorelease];
    ll.text = text;
    ll.font = [UIFont boldSystemFontOfSize:17];
    [cell addSubview:ll];
    [cell addSubview:yns];
    
    return cell;
}

- (YesNoSwitch*)switchForCell:(UITableViewCell*)cell
{
    return (YesNoSwitch*)[cell viewWithTag:100];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.coughCell = [self cellWithText:@"Cough?"];
    self.wheezeCell = [self cellWithText:@"Wheeze?"];
    self.soreCell = [self cellWithText:@"Sore Throat?"];
    self.nasalCell = [self cellWithText:@"Nasal Congestion?"];
    
    [self switchForCell:coughCell].yes= self.record.cough;
    [self switchForCell:wheezeCell].yes = self.record.wheeze;
    [self switchForCell:soreCell].yes= self.record.soreThroat;
    [self switchForCell:nasalCell].yes = self.record.nasalCongestion;
}

#pragma mark - Custom Switch

- (void)yesNoSwitchWasToggled:(YesNoSwitch *)yesNoSwitch
{
    if (yesNoSwitch == [self switchForCell:coughCell])
        self.record.cough = yesNoSwitch.yes;
    else if (yesNoSwitch == [self switchForCell:wheezeCell])
        self.record.wheeze = yesNoSwitch.yes;
    else if (yesNoSwitch == [self switchForCell:soreCell])
        self.record.soreThroat = yesNoSwitch.yes;
    else if (yesNoSwitch == [self switchForCell:nasalCell])
        self.record.nasalCongestion = yesNoSwitch.yes;
}



#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return coughCell;
        case 1:
            return wheezeCell;
        case 2:
            return soreCell;
        case 3:
            return nasalCell;
    }

    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 305, 50)] autorelease];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.text = @"Please tap YES or NO for each of the symptoms above.";
    label.numberOfLines = 0;
    
    UIView* v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] autorelease];
    [v addSubview:  label];
    return v;
    
   
}

@end
