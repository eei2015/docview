#import "CHFBreathQuestionController.h"
#import "MoodCell.h"
#import "MoodView.h"
#import "SimpleAnswerCell.h"

@interface CHFBreathQuestionController () <MoodViewDelegate>

@property (nonatomic, retain) NSArray * questions;

@end

@implementation CHFBreathQuestionController
@synthesize questions = _questions;

- (void)dealloc
{
    [_questions release];
    [super dealloc];
}

#pragma mark - logic

- (NSDictionary *)buildQuestionWithTitle:(NSString *)title key:(NSString *)key
{
    return [NSDictionary dictionaryWithObjectsAndKeys: title, @"title", key, @"key", nil];
}

- (NSArray *)buildQuestions
{
    NSMutableArray * a = [NSMutableArray array];
    
//    if ([self.record.CHF_breathMood intValue] > 0)
//    {
//        [a addObject: [self buildQuestionWithTitle: @"Is your breathing worse than usual at rest?" key: @"CHF_breathWorseThanUsualAtRest"]];
//        
//        if ([self.record.CHF_breathWorseThanUsualAtRest intValue] == 1)
//        {
//            [a addObject: [self buildQuestionWithTitle: @"Is it worse with activity?" key: @"CHF_breathWorseWithActivity"]];
//        }
//        else if ([self.record.CHF_breathWorseThanUsualAtRest intValue] == 0)
//        {
//            [a addObject: [self buildQuestionWithTitle: @"Do you sleep well lying flat?" key: @"CHF_breathSleepWellFlyingFlat"]];
//            
//            if ([self.record.CHF_breathSleepWellFlyingFlat intValue] == 0)
//            {
//                [a addObject: [self buildQuestionWithTitle: @"Do you sleep well with additional pillows?" key: @"CHF_breathSleepWellWithAdditionalPillows"]];
//                
//                if ([self.record.CHF_breathSleepWellWithAdditionalPillows intValue] == 0)
//                {
//                    [a addObject: [self buildQuestionWithTitle: @"Do you sleep sitting up in a chair?" key: @"CHF_breathSleepInChair"]];
//                }
//            }
//        }
//    }
    
    return a;
}

#pragma mark - overrides

- (BOOL)tableViewBased
{
    return YES;
}

- (NSString*)titleForHeaderAtSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"How are you breathing today?";
    }
    else
    {
        return [[self.questions objectAtIndex: section - 1] objectForKey: @"title"];
    }
}

- (NSString *)helpUrl
{
    return @"";
}

- (BOOL)canGoNext
{
//    if ([self.record.CHF_breathMood intValue] == 0)
//    {
//        return YES;
//    }
    
    if ([self.questions count] > 0)
    {
        NSString * key = [[self.questions lastObject] objectForKey: @"key"];
        if ([[self.record valueForKey: key] intValue] != -1)
        {
            return YES;
        }
    }
    return NO;
}

- (NSString *)errorText
{
    return @"Error";
}

- (BOOL)scrollEnabled
{
    return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.questions = [self buildQuestions];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + [self.questions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        MoodCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        if (!cell)
        {
            cell = [[[MoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"] autorelease];
        }
        //        cell.moodView.selectedSmileIndex = [self.record.CHF_breathMood intValue];
        cell.moodView.delegate = self;
        return cell;
    }
    else
    {
        SimpleAnswerCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        
        if (!cell)
        {
            cell = [[[SimpleAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"] autorelease];
            [cell.segmentedControl addTarget: self action: @selector(segmentedControlValueChanged:) forControlEvents: UIControlEventValueChanged];
        }
        
        NSString * key = [[self.questions objectAtIndex: indexPath.section - 1] objectForKey: @"key"];
        int val =  [[self.record valueForKey: key] intValue];
        cell.segmentedControl.selectedSegmentIndex = val == - 1 ? - 1 : !val;
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 96;
    }
    else
    {
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[self titleForHeaderAtSection: section] sizeWithFont: [UIFont boldSystemFontOfSize: 17]].width > 305) {
        return 40;
    }
    return 35;
}

- (void)updateQuestions
{
    NSArray * newArray = [self buildQuestions];
    
    int new = [newArray count];
    int old = [self.questions count];
    int diff = new - old;
    
    self.questions = newArray;
    if (diff != 0)
    {
        if (diff > 0)
        {
            [self.tableView insertSections: [NSIndexSet indexSetWithIndexesInRange: NSMakeRange(old + 1, diff)] withRowAnimation: UITableViewRowAnimationAutomatic];
            
            [self.tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection: [self.questions count]] atScrollPosition:UITableViewScrollPositionBottom animated: YES];
        }
        else
        {
            [self.tableView deleteSections: [NSIndexSet indexSetWithIndexesInRange: NSMakeRange(new + 1, -diff)] withRowAnimation: UITableViewRowAnimationAutomatic];
        }
    }
    else 
    {
        if (new > 0)
        {
            [self.tableView reloadSections: [NSIndexSet indexSetWithIndexesInRange: NSMakeRange(new, 1)] withRowAnimation: UITableViewRowAnimationNone];
        }
        
    }
}

- (void)clearValuesUntil:(NSString *)k
{
    for (NSDictionary * d in [self.questions reverseObjectEnumerator])
    {
        NSString * key = [d objectForKey: @"key"];
        if ([key isEqualToString: k])
        {
            return;
        }
        [self.record setValue: [NSNumber numberWithInt: -1] forKey: key];
    }
}

- (void)moodViewDidChanged:(MoodView *)moodView
{
    //    self.record.CHF_breathMood = [NSNumber numberWithInt: moodView.selectedSmileIndex];
    [self clearValuesUntil: nil];
    [self updateQuestions];
    
    [self.questionsViewController errorWasFixed];
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)c
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell: (UITableViewCell *)c.superview.superview];
    if (indexPath)
    {
        NSString * key = [[self.questions objectAtIndex: indexPath.section - 1] objectForKey: @"key"];
        [self.record setValue: [NSNumber numberWithInt: !c.selectedSegmentIndex] forKey: key];
        [self clearValuesUntil: key];
    }
    
    
    [self updateQuestions];
    
    [self.questionsViewController errorWasFixed];
}

@end
