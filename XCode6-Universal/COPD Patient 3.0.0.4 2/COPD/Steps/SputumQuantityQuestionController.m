#import "SputumQuantityQuestionController.h"


static NSString* sputumQuantityImages[4] = 
{
    @"less",
    @"less",
    @"more",
    @"cup"
};

@implementation SputumQuantityQuestionController

#pragma mark - overrides


- (NSString*)titleForHeaderAtSection:(NSInteger)section
{
    return @"Sputum Quantity";
}

- (BOOL)tableViewBased
{
    return YES;
}

- (NSString *)helpUrl
{
    return @"http://help.docviewsolutions.com/copd-app/help.html#sputum";
}

- (NSString *)errorText
{
    return @"Please tap one of the buttons above to indicate your sputum quantity.";
}

- (BOOL)canGoNext
{
    return (self.record.sputumQuantity != -1);
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
    }
    
    cell.textLabel.text =  sputumQuantityItems[indexPath.row];
    cell.accessoryType = [self.record sputumQuantity] == indexPath.row ?  UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    cell.imageView.image = [UIImage imageNamed: sputumQuantityImages[indexPath.row]];    
    cell.imageView.hidden = (indexPath.row == 0);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSIndexPath * oldPath = nil;
    
    if (self.record.sputumQuantity != -1)
    {
        oldPath =[NSIndexPath indexPathForRow:self.record.sputumQuantity inSection:0];
    }
     
    
    self.record.sputumQuantity = indexPath.row;
    
    if (oldPath)
    {
        [tableView reloadRowsAtIndexPaths: [NSArray arrayWithObject: oldPath]  withRowAnimation: UITableViewRowAnimationNone];
    }
    
    [tableView reloadRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationFade];
    [self.questionsViewController errorWasFixed];
}


@end
