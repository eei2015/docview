#import "SputumConsistencyQuestionController.h"


static NSString* sputumConsistencyImages[5] = 
{
    @"water.png",
    @"milk.png",
    @"ice-cream.png"
};

@implementation SputumConsistencyQuestionController

#pragma mark - overrides

- (NSString*)titleForHeaderAtSection:(NSInteger)section
{
    return @"Sputum Consistency";
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
    return @"Please tap one of the buttons above to indicate your sputum consistency.";
}

- (BOOL)canGoNext
{
    return (self.record.sputumConsistency != -1);
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
    }
    
    cell.textLabel.text = sputumConsistencyItems[indexPath.row + 1];
    cell.accessoryType = self.record.sputumConsistency == indexPath.row + 1 ?  UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    cell.imageView.image = [UIImage imageNamed: sputumConsistencyImages[indexPath.row]];    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath * oldPath = nil;
    
    if (self.record.sputumConsistency != -1)
    {
        oldPath =[NSIndexPath indexPathForRow: self.record.sputumConsistency - 1 inSection:0];
    }
    
    self.record.sputumConsistency = indexPath.row + 1;
    
    if (oldPath)
    {
        [tableView reloadRowsAtIndexPaths: [NSArray arrayWithObject: oldPath]  withRowAnimation: UITableViewRowAnimationNone];
    }
    
    [tableView reloadRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationFade];
    [self.questionsViewController errorWasFixed];
}

@end
