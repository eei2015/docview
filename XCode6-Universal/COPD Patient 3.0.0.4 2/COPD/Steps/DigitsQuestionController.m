#import "DigitsQuestionController.h"
#import "DigitsView.h"
#import "QuestionsViewController.h"

NSString * const kDigitsQuestionController_Title_Key = @"kDigitsQuestionController_Title_Key";
NSString * const kDigitsQuestionController_HelpUrl_Key = @"kDigitsQuestionController_HelpUrl_Key";
NSString * const kDigitsQuestionController_Divider_Key = @"kDigitsQuestionController_Divider_Key";
NSString * const kDigitsQuestionController_SelectedFieldKeyPath_Key = @"kDigitsQuestionController_SelectedFieldKeyPath_Key";
NSString * const kDigitsQuestionController_Fields_Key = @"kDigitsQuestionController_Fields_Key";

NSString * const kDigitsQuestionController_Field_KeyPath_Key = @"kDigitsQuestionController_Field_KeyPath_Key";
NSString * const kDigitsQuestionController_Field_RangeBegin_Key = @"kDigitsQuestionController_Field_RangeBegin_Key";
NSString * const kDigitsQuestionController_Field_RangeEnd_Key = @"kDigitsQuestionController_Field_RangeEnd_Key";
NSString * const kDigitsQuestionController_Field_Prompt_Key = @"kDigitsQuestionController_Field_Prompt_Key";
NSString * const kDigitsQuestionController_Field_Error_Key = @"kDigitsQuestionController_Field_Error_Key";




@interface DigitsQuestionController () <DigitsViewDelegate>

@end

@implementation DigitsQuestionController

#pragma mark - helpers

- (NSInteger)fieldsCount
{
    return self.question.questionOptions.count;
    //return [[self.config objectForKey: kDigitsQuestionController_Fields_Key] count];
}

- (NSInteger)valueAtIndex:(NSInteger)index
{
    
    //return [[self.record valueForKey: [[self fieldAtIndex: index] objectForKey: kDigitsQuestionController_Field_KeyPath_Key]] intValue];
    return  [self.pRecord.checkInValue intValue];//[self.pRecord.multipleSet]
}

- (NSDictionary *)fieldAtIndex:(NSInteger)index
{
    // return <#expression#>
    return [[self.config objectForKey: kDigitsQuestionController_Fields_Key] objectAtIndex: index];
}

- (NSInteger)rangeBeginForIndex:(NSInteger)index
{
    QuestionOptions *qo=(QuestionOptions*)self.question.questionOptions[index];
    // NSLog(@"Val 1 : %@",qo.qOptionValue);
    return [[[qo.qOptionValue componentsSeparatedByString:@"-"] objectAtIndex:0] intValue];
    
    //return [[[self fieldAtIndex: index] objectForKey: kDigitsQuestionController_Field_RangeBegin_Key] intValue];
}

- (NSInteger)rangeEndForIndex:(NSInteger)index
{
    QuestionOptions *qo=(QuestionOptions*)self.question.questionOptions[index];
    // NSLog(@"Val 2 : %@",qo.qOptionValue);
    return [[[qo.qOptionValue componentsSeparatedByString:@"-"] objectAtIndex:1] intValue];
    // return [[[self fieldAtIndex: index] objectForKey: kDigitsQuestionController_Field_RangeEnd_Key] intValue];
}

#pragma mark - overrides

- (NSString*)titleForHeaderAtSection:(NSInteger)section
{
    return  self.question.questionTitle;
    //return [self.config objectForKey: kDigitsQuestionController_Title_Key];
}

- (NSString *)helpUrl
{
    return @"http://help.docviewsolutions.com/chf-app/help.html";
    //return [self.config objectForKey: kDigitsQuestionController_HelpUrl_Key];
}


- (NSString *)errorText
{
    for (int i = 0; i < [self fieldsCount]; i++)
    {
        NSInteger val = [self valueAtIndex: i];
        NSInteger start = [self rangeBeginForIndex: i];
        NSInteger end = [self rangeEndForIndex: i];
        if (val < start || val > end)
        {
            return @"Enter a value between 60 and 600.";
            //return [[self fieldAtIndex: i] objectForKey: kDigitsQuestionController_Field_Error_Key];
        }
        
    }
    return @"";
}

- (BOOL)canGoNext
{
    // return YES;
    /////
    
    BOOL ok = YES;
    for (int i = 0; i < [self fieldsCount]; i++)
    {
        NSInteger val = [self valueAtIndex: i];
        NSInteger start = [self rangeBeginForIndex: i];
        NSInteger end = [self rangeEndForIndex: i];
        if (!(val >= start && val <= end))
        {
            ok = NO;
            break;
        }
        QuestionOptions *qo=(QuestionOptions*)self.question.questionOptions[i];
        self.pRecord.qOptionID=qo.qOptionID;
        self.pRecord.checkInValue=[NSString stringWithFormat:@"%d",val];
        
    }
    
    if (!ok)
    {
        [digitsView showFirstLimitError];
    }
    
    
    
    return ok;
}

#pragma mark - View lifecycle

- (NSString *)formatValue:(NSInteger)value
{
    if (value < 0)
    {
        return @"—";
    }
    return [NSString stringWithFormat: @"%d", value];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Jatin chauhan 25-ov-2013
    
    //    digitsView = [[[DigitsView alloc] initWithFrame: CGRectMake(0, 36, 320, 310) delegate: self] autorelease];
    
    
    
        digitsView = [[[DigitsView alloc] initWithFrame: CGRectMake(10, 150, 625, 780) delegate: self] autorelease];

    

    // Jatin chauhan 25-ov-2013
    
    
    
    
    
    

    
    /* NSString * k = [self.config objectForKey: kDigitsQuestionController_SelectedFieldKeyPath_Key];
     
     if (k)
     {
     digitsView.selectedField = [[self.record valueForKey: k] intValue];
     }*/
    
    NSString * k=self.pRecord.checkInValue;
    if(k!=@""){
        for (int i = 0; i < [self fieldsCount]; i++)
        {
            [digitsView setValue: [self formatValue: [self valueAtIndex: i]] forFieldAtIndex: i];
        }
        
    }
    
    
    [self.view addSubview: digitsView];
    
    
}


#pragma mark - Peak Flow delegate

- (void)digitsView:(DigitsView *)pfv fieldValueChangedAtIndex:(NSInteger)index
{
    self.pRecord.checkInValue=[digitsView valueForFieldAtIndex: index];
    
    
    // NSLog(@"Value : %@",[digitsView valueForFieldAtIndex: index]);
    //[self.record setValue: [NSNumber numberWithInt: [[digitsView valueForFieldAtIndex: index] intValue]]  forKey: [[self fieldAtIndex: index] objectForKey: kDigitsQuestionController_Field_KeyPath_Key]];
    [self.questionsViewController errorWasFixed];
}

- (void)digitsViewFieldChanged:(DigitsView *)pfv
{
    //  [self.record setValue: [NSNumber numberWithInt: digitsView.selectedField] forKey: [self.config objectForKey: kDigitsQuestionController_SelectedFieldKeyPath_Key]];
    
}

- (void)digitsViewTryToGoNext:(DigitsView *)digitsView
{
    [self.questionsViewController nextClicked];
}

- (NSInteger)numberOfFieldsInDigitView
{
    return [self fieldsCount];
}

- (NSString *)digitsView:(DigitsView *)digitsView promptForFieldAtIndex:(NSInteger )index
{
    return [[self fieldAtIndex: index] objectForKey: kDigitsQuestionController_Field_Prompt_Key];
}

- (UIView *)fieldsDividerViewForDigitsView:(DigitsView *)digitsView
{
    UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 0)] autorelease];
    label.font = [UIFont boldSystemFontOfSize: 40];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.text = [self.config objectForKey: kDigitsQuestionController_Divider_Key];
  
    label.textAlignment = UITextAlignmentCenter;
    return label;
}

- (BOOL)digitsViewShouldHaveDivider:(DigitsView *)digitsView
{
    return [self.config objectForKey: kDigitsQuestionController_Divider_Key] != nil;
}

- (BOOL)digitsView:(DigitsView *)digitsView valueIsValidAtIndex:(NSInteger)i
{
    NSInteger val = [self valueAtIndex: i];
    NSInteger start = [self rangeBeginForIndex: i];
    NSInteger end = [self rangeEndForIndex: i];
    if (val < start || val > end)
    {
        return NO;
    }
    return YES;
}


@end


/*#import "DigitsQuestionController.h"
#import "DigitsView.h"
#import "QuestionsViewController.h"

NSString * const kDigitsQuestionController_Title_Key = @"kDigitsQuestionController_Title_Key";
NSString * const kDigitsQuestionController_HelpUrl_Key = @"kDigitsQuestionController_HelpUrl_Key";
NSString * const kDigitsQuestionController_Divider_Key = @"kDigitsQuestionController_Divider_Key";
NSString * const kDigitsQuestionController_SelectedFieldKeyPath_Key = @"kDigitsQuestionController_SelectedFieldKeyPath_Key";
NSString * const kDigitsQuestionController_Fields_Key = @"kDigitsQuestionController_Fields_Key";

NSString * const kDigitsQuestionController_Field_KeyPath_Key = @"kDigitsQuestionController_Field_KeyPath_Key";
NSString * const kDigitsQuestionController_Field_RangeBegin_Key = @"kDigitsQuestionController_Field_RangeBegin_Key";
NSString * const kDigitsQuestionController_Field_RangeEnd_Key = @"kDigitsQuestionController_Field_RangeEnd_Key";
NSString * const kDigitsQuestionController_Field_Prompt_Key = @"kDigitsQuestionController_Field_Prompt_Key";
NSString * const kDigitsQuestionController_Field_Error_Key = @"kDigitsQuestionController_Field_Error_Key";




@interface DigitsQuestionController () <DigitsViewDelegate>
- (NSDictionary*)fieldAtIndex:(NSInteger)index;
@end


@implementation DigitsQuestionController

#pragma mark - helpers

- (NSInteger)fieldsCount
{
    return [[self.config objectForKey: kDigitsQuestionController_Fields_Key] count];
}

- (NSInteger)valueAtIndex:(NSInteger)index
{
    return [[self.record valueForKey: [[self fieldAtIndex: index] objectForKey: kDigitsQuestionController_Field_KeyPath_Key]] intValue];
}

- (NSDictionary *)fieldAtIndex:(NSInteger)index
{
    return [[self.config objectForKey: kDigitsQuestionController_Fields_Key] objectAtIndex: index];
}

- (NSInteger)rangeBeginForIndex:(NSInteger)index
{
    return [[[self fieldAtIndex: index] objectForKey: kDigitsQuestionController_Field_RangeBegin_Key] intValue];
}

- (NSInteger)rangeEndForIndex:(NSInteger)index
{
    return [[[self fieldAtIndex: index] objectForKey: kDigitsQuestionController_Field_RangeEnd_Key] intValue];
}

#pragma mark - overrides

- (NSString*)titleForHeaderAtSection:(NSInteger)section
{
    return [self.config objectForKey: kDigitsQuestionController_Title_Key];
}

- (NSString *)helpUrl
{
    return [self.config objectForKey: kDigitsQuestionController_HelpUrl_Key];
}


- (NSString *)errorText
{
    for (int i = 0; i < [self fieldsCount]; i++)
    {
        NSInteger val = [self valueAtIndex: i];
        NSInteger start = [self rangeBeginForIndex: i];
        NSInteger end = [self rangeEndForIndex: i];
        if (val < start || val > end)
        {
            return [[self fieldAtIndex: i] objectForKey: kDigitsQuestionController_Field_Error_Key];
        }
    }
    return @"";
}

- (BOOL)canGoNext
{
    BOOL ok = YES;
    for (int i = 0; i < [self fieldsCount]; i++)
    {
        NSInteger val = [self valueAtIndex: i];
        NSInteger start = [self rangeBeginForIndex: i];
        NSInteger end = [self rangeEndForIndex: i];
        if (!(val >= start && val <= end))
        {
            ok = NO;
            break;
        }
    }
    
    if (!ok) 
    {
        [digitsView showFirstLimitError];
    }
    
    return ok;
}

#pragma mark - View lifecycle

- (NSString *)formatValue:(NSInteger)value
{
    if (value < 0)
    {
        return @"—";
    }
    return [NSString stringWithFormat: @"%d", value];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    digitsView = [[[DigitsView alloc] initWithFrame: CGRectMake(0, 36, 320, 310) delegate: self] autorelease];
    
    NSString * k = [self.config objectForKey: kDigitsQuestionController_SelectedFieldKeyPath_Key];
    
    if (k)
    {
        digitsView.selectedField = [[self.record valueForKey: k] intValue];
    }
    
    
    for (int i = 0; i < [self fieldsCount]; i++)
    {
        [digitsView setValue: [self formatValue: [self valueAtIndex: i]] forFieldAtIndex: i];
    }
    
    [self.view addSubview: digitsView];
}

#pragma mark - Peak Flow delegate

- (void)digitsView:(DigitsView *)pfv fieldValueChangedAtIndex:(NSInteger)index
{
    [self.record setValue: [NSNumber numberWithInt: [[digitsView valueForFieldAtIndex: index] intValue]]  forKey: [[self fieldAtIndex: index] objectForKey: kDigitsQuestionController_Field_KeyPath_Key]];
    
    [self.questionsViewController errorWasFixed];
}

- (void)digitsViewFieldChanged:(DigitsView *)pfv
{
    [self.record setValue: [NSNumber numberWithInt: digitsView.selectedField] forKey: [self.config objectForKey: kDigitsQuestionController_SelectedFieldKeyPath_Key]];
}

- (void)digitsViewTryToGoNext:(DigitsView *)digitsView
{
    [self.questionsViewController nextClicked];
}

- (NSInteger)numberOfFieldsInDigitView
{
    return [self fieldsCount];
}

- (NSString *)digitsView:(DigitsView *)digitsView promptForFieldAtIndex:(NSInteger )index
{
    return [[self fieldAtIndex: index] objectForKey: kDigitsQuestionController_Field_Prompt_Key];
}

- (UIView *)fieldsDividerViewForDigitsView:(DigitsView *)digitsView
{
    UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 0)] autorelease];
    label.font = [UIFont boldSystemFontOfSize: 40];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.text = [self.config objectForKey: kDigitsQuestionController_Divider_Key];
    label.textAlignment = UITextAlignmentCenter;
    return label;
}

- (BOOL)digitsViewShouldHaveDivider:(DigitsView *)digitsView
{
    return [self.config objectForKey: kDigitsQuestionController_Divider_Key] != nil;
}

- (BOOL)digitsView:(DigitsView *)digitsView valueIsValidAtIndex:(NSInteger)i
{
    NSInteger val = [self valueAtIndex: i];
    NSInteger start = [self rangeBeginForIndex: i];
    NSInteger end = [self rangeEndForIndex: i];
    if (val < start || val > end)
    {
        return NO;
    }
    return YES;
}


@end*/
