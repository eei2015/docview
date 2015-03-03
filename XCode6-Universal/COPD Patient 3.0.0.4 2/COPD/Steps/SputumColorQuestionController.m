#import "SputumColorQuestionController.h"

static NSString* sputumColorImages[5] = 
{
    @"",
    @"sputum-white",
    @"sputum-yellow",
    @"sputum-green",
    @"sputum-brown"
};


@implementation SputumColorQuestionController

#pragma mark - overrides

- (NSString*)titleForHeaderAtSection:(NSInteger)section
{
    return @"Sputum Color";
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
    return @"Please tap one of the buttons above to indicate your sputum color.";
}

- (BOOL)canGoNext
{
    return (self.record.sputumColor != -1);
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
    
    cell.textLabel.text = sputumColorItems[indexPath.row + 1];
    cell.accessoryType = self.record.sputumColor == indexPath.row + 1 ?  UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    UIImageView * imageView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: sputumColorImages[indexPath.row + 1]]] autorelease];
    imageView.center = CGPointMake(100, 22);
    [cell.contentView addSubview: imageView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSIndexPath * oldPath = nil;
    
    if (self.record.sputumColor != -1)
    {
        oldPath =[NSIndexPath indexPathForRow:self.record.sputumColor - 1 inSection:0];
    }
    
    self.record.sputumColor = indexPath.row + 1;
    
    if (oldPath)
    {
        [tableView reloadRowsAtIndexPaths: [NSArray arrayWithObject: oldPath]  withRowAnimation: UITableViewRowAnimationNone];
    }
    
    [tableView reloadRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationFade];
    [self.questionsViewController errorWasFixed];
}

@end
