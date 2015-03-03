#import "SummaryViewController.h"
#import "DetailsCell.h"

@implementation SummaryViewController

#pragma mark - overrides

- (NSString*)titleForHeaderAtSection:(NSInteger)section
{
    return @"Summary";
}

- (BOOL)tableViewBased
{
    return YES;
}

- (NSString *)helpUrl
{
    return @"http://help.docviewsolutions.com/copd-app/help.html#summary";
}

- (BOOL)scrollEnabled
{
    return YES;
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

static NSString* cols[] =
{
    @"Breathlessness",
    @"Sputum",
    @"Peak Flow",
    @"Temperature Over 100˚?",
    @"Symptoms"
};



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[[DetailsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"] autorelease];
    }
    
    cell.textLabel.text = cols[indexPath.row];
    
    NSString * detailsText = nil;
    
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
    
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.text = detailsText;
    
    cell.detailTextLabel.numberOfLines = 2;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * vcs = self.navigationController.viewControllers;
    NSInteger index = indexPath.row;
    
    if (indexPath.row > 1)
    {
        if (self.record.sputumQuantity != 0)
        {
            index += 2;
        }
    }

    [self.navigationController popToViewController: [vcs objectAtIndex: index] animated: YES];
}

@end
