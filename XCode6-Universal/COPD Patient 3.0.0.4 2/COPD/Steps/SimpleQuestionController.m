#import "SimpleQuestionController.h"
#import "SimpleAnswerCell.h"

NSString * const kSimpleQuestionController_KeyPath_Key = @"kSimpleQuestionController_KeyPath_Key";
NSString * const kSimpleQuestionController_Title_Key = @"kSimpleQuestionController_Title_Key";

NSString * const kSimpleQuestionController_Questions_Key = @"kSimpleQuestionController_Questions_Key";
NSString * const kSimpleQuestionController_HelpUrl_Key = @"kSimpleQuestionController_HelpUrl_Key";
NSString * const kSimpleQuestionController_Error_Key = @"kSimpleQuestionController_Error_Key";

@interface SimpleQuestionController ()

@end

@implementation SimpleQuestionController


- (NSArray *)questions
{
    return [self.config objectForKey: kSimpleQuestionController_Questions_Key];
}

- (QuestionOptions *)questionKeyPathAtIndex:(NSInteger)index
{
    return [self.question.questionOptions objectAtIndex: index];
    //return [[[self questions] objectAtIndex: index] objectForKey: kSimpleQuestionController_KeyPath_Key];
}

- (NSString *)questionTitleAtIndex:(NSInteger)index
{
    // return [[[self questions] objectAtIndex: index] objectForKey: kSimpleQuestionController_Title_Key];
    return self.question.questionTitle;
}

#pragma mark - overrides

- (BOOL)tableViewBased
{
    return YES;
}

- (BOOL)scrollEnabled
{
    return NO;
}

- (NSString*)titleForHeaderAtSection:(NSInteger)section
{
    return [self questionTitleAtIndex: section];
    //return self.question.questionTitle;
}

- (NSString *)helpUrl
{
    return @"http://help.docviewsolutions.com/chf-app/help.html";
    // return [self.config objectForKey: kSimpleQuestionController_HelpUrl_Key];
}

- (BOOL)canGoNext
{
    if (!self.pRecord.checkInValue) {
        return NO;
    }
    /* for (NSDictionary * q in [self questions])
     {
     if ([[self.record valueForKey: [q objectForKey: kSimpleQuestionController_KeyPath_Key]] intValue] == -1)
     {
     return NO;
     }
     }*/
    return YES;
}

- (NSString *)errorText
{
    return @"Please tap YES or NO.";
    //return [self.config objectForKey: kSimpleQuestionController_Error_Key];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//[[self questions] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SimpleAnswerCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[[SimpleAnswerCell alloc] initWithStyleWithOptions:UITableViewCellStyleDefault reuseIdentifier:@"cell" Options:self.question.questionOptions] autorelease];
        [cell.segmentedControl addTarget: self action: @selector(segmentedControlValueChanged:) forControlEvents: UIControlEventValueChanged];
    }
    
    
    //int val =  [self.pRecord.checkInValue intValue];
    
    /// NSLog(@"INT %@",self.pRecord.checkInValue);
    /* if (self.pRecord.checkInValue) {
     int val =  [self.pRecord.checkInValue intValue];
     cell.segmentedControl.selectedSegmentIndex=val;
     }*/
    
    //2013-12-10 Vipul
    //cell.segmentedControl.selectedSegmentIndex=self.pRecord.selectedIndex;
    if([self.pRecord.checkInValue isEqualToString:@"0"])
        cell.segmentedControl.selectedSegmentIndex = 1;
    else if ([self.pRecord.checkInValue isEqualToString:@"1"])
        cell.segmentedControl.selectedSegmentIndex = 0;
    else
        cell.segmentedControl.selectedSegmentIndex=self.pRecord.selectedIndex;
    //
    //cell.segmentedControl.selectedSegmentIndex = [self.pRecord.checkInValue isEqual: [NSNull null]] ? - 1 : val;
    
    //QuestionOptions *qo = [self questionKeyPathAtIndex: indexPath.section];
    
    //if (qo.qOptionID==self.pRecord.qOptionID) {
    //   cell.segmentedControl.selectedSegmentIndex = [self.pRecord.checkInValue intValue];
    //}
    
    //int val =  [[self.record valueForKey: key] intValue];
    //cell.segmentedControl.selectedSegmentIndex = val == - 1 ? - 1 : !val;
    
    
    // NSString * key = [self questionKeyPathAtIndex: indexPath.section];
    //int val =  [[self.record valueForKey: key] intValue];
    //cell.segmentedControl.selectedSegmentIndex = val == - 1 ? - 1 : !val;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)c
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell: (UITableViewCell *)c.superview.superview];
    if (indexPath)
    {
        
        QuestionOptions *qo=[self questionKeyPathAtIndex:c.selectedSegmentIndex];
        
        self.pRecord.qOptionID=qo.qOptionID;
        self.pRecord.selectedIndex=c.selectedSegmentIndex;
        self.pRecord.checkInValue=qo.qOptionValue;//[NSString stringWithFormat:@"%d",c.selectedSegmentIndex];
        self.pRecord.score=qo.qOptionScore;
        
        /*if ([qo.qOptionScore intValue]>0) {
            self.pRecord.normal=FALSE;
        }*/
        // NSLog(@"%@",qo.qOptionTitle);
        //NSLog(@"%@",self.pRecord.checkInValue);
        // NSString * key = [self questionKeyPathAtIndex: indexPath.section];
        //[self.record setValue: [NSNumber numberWithInt: !c.selectedSegmentIndex] forKey: key];
        
    }
    
    [self.questionsViewController errorWasFixed];
}

@end


/*#import "SimpleQuestionController.h"
#import "SimpleAnswerCell.h"

NSString * const kSimpleQuestionController_KeyPath_Key = @"kSimpleQuestionController_KeyPath_Key";
NSString * const kSimpleQuestionController_Title_Key = @"kSimpleQuestionController_Title_Key";

NSString * const kSimpleQuestionController_Questions_Key = @"kSimpleQuestionController_Questions_Key";
NSString * const kSimpleQuestionController_HelpUrl_Key = @"kSimpleQuestionController_HelpUrl_Key";
NSString * const kSimpleQuestionController_Error_Key = @"kSimpleQuestionController_Error_Key";

@interface SimpleQuestionController () 

@end

@implementation SimpleQuestionController


- (NSArray *)questions
{
    return [self.config objectForKey: kSimpleQuestionController_Questions_Key];
}

- (NSString *)questionKeyPathAtIndex:(NSInteger)index
{
    return [[[self questions] objectAtIndex: index] objectForKey: kSimpleQuestionController_KeyPath_Key];
}

- (NSString *)questionTitleAtIndex:(NSInteger)index
{
    return [[[self questions] objectAtIndex: index] objectForKey: kSimpleQuestionController_Title_Key];
}

#pragma mark - overrides

- (BOOL)tableViewBased
{
    return YES;
}

- (BOOL)scrollEnabled
{
    return NO;
}

- (NSString*)titleForHeaderAtSection:(NSInteger)section
{
    return [self questionTitleAtIndex: section];
}

- (NSString *)helpUrl
{
    return [self.config objectForKey: kSimpleQuestionController_HelpUrl_Key];
}

- (BOOL)canGoNext
{
    for (NSDictionary * q in [self questions])
    {
        if ([[self.record valueForKey: [q objectForKey: kSimpleQuestionController_KeyPath_Key]] intValue] == -1) 
        {
            return NO;
        }
    }
    return YES;
}

- (NSString *)errorText
{
    return [self.config objectForKey: kSimpleQuestionController_Error_Key];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self questions] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SimpleAnswerCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell)
    {
        cell = [[[SimpleAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
        [cell.segmentedControl addTarget: self action: @selector(segmentedControlValueChanged:) forControlEvents: UIControlEventValueChanged];
    }
    
    NSString * key = [self questionKeyPathAtIndex: indexPath.section];
    int val =  [[self.record valueForKey: key] intValue];
    cell.segmentedControl.selectedSegmentIndex = val == - 1 ? - 1 : !val;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)c
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell: (UITableViewCell *)c.superview.superview];
    if (indexPath)
    {
         NSString * key = [self questionKeyPathAtIndex: indexPath.section];
        [self.record setValue: [NSNumber numberWithInt: !c.selectedSegmentIndex] forKey: key];
    }
    
    [self.questionsViewController errorWasFixed];
}

@end*/
