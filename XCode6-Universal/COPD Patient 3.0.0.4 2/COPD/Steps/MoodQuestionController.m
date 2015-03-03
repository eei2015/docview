

/*#import "MoodQuestionController.h"
#import "MoodView.h"
#import <QuartzCore/QuartzCore.h>
NSString * const kMoodQuestionController_KeyPath_Key = @"kMoodQuestionController_KeyPath_Key";
NSString * const kMoodQuestionController_Title_Key = @"kMoodQuestionController_Title_Key";
NSString * const kMoodQuestionController_HelpUrl_Key = @"kMoodQuestionController_HelpUrl_Key";
NSString * const kMoodQuestionController_Error_Key = @"kMoodQuestionController_Error_Key";
NSString * const kMoodQuestionController_Field_Emergency_Key = @"kMoodQuestionController_Field_Emergency_Key";


@interface MoodQuestionController () <MoodViewDelegate>
-(void)addAlert;
@end


@implementation MoodQuestionController


#pragma mark - overrides

- (NSString*)titleForHeaderAtSection:(NSInteger)section
{
    return [self.config objectForKey: kMoodQuestionController_Title_Key];
}

- (NSString *)helpUrl
{
    return [self.config objectForKey: kMoodQuestionController_HelpUrl_Key];
}

- (BOOL)canGoNext
{
    return ([[self.record valueForKey: [self.config objectForKey: kMoodQuestionController_KeyPath_Key]] intValue] != -1);
}

- (NSString *)errorText
{
    return [self.config objectForKey: kMoodQuestionController_Error_Key];
}
-(BOOL)isNeedShowEmergency
{
    return  [[self.config objectForKey: kMoodQuestionController_Field_Emergency_Key]boolValue];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MoodView * smileView = [[[MoodView alloc] initWithFrame: CGRectMake(20, [self tableView: nil heightForHeaderInSection: 0] + 12, 280, 58)] autorelease];
    smileView.selectedSmileIndex = [[self.record valueForKey: [self.config objectForKey: kMoodQuestionController_KeyPath_Key]] intValue];
    smileView.delegate = self;
    [self.view addSubview: smileView];
    if ([self isNeedShowEmergency])
        [self addAlert];
}

-(void)addAlert
{
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(10.0, 230.0, 300.0, 90.0)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.layer.cornerRadius = 20.0f;
    backgroundView.layer.borderWidth = 3.0f;
    backgroundView.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:backgroundView];

   
    UILabel  * emergencyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0, 5, 290.0, 80.0)];
    emergencyLabel.numberOfLines = 0;
    emergencyLabel.backgroundColor = [UIColor clearColor];
    emergencyLabel.textColor = [UIColor blackColor];
    emergencyLabel.font = [UIFont boldSystemFontOfSize:19];
    emergencyLabel.text = @"If you are having a medical emergency, please call 911 immediately.";
    [backgroundView addSubview:emergencyLabel];
   
    [emergencyLabel release];
    
    [backgroundView release];
}

- (void)moodViewDidChanged:(MoodView *)moodView
{
    //need a reverse index
    
    [self.record setValue: [NSNumber numberWithInt: moodView.selectedSmileIndex] forKey: [self.config objectForKey: kMoodQuestionController_KeyPath_Key]];
    
    [self.questionsViewController errorWasFixed];
}

@end*/
#import "MoodQuestionController.h"
#import "MoodView.h"
#import "QuestionsViewController.h"

#import <QuartzCore/QuartzCore.h>
NSString * const kMoodQuestionController_KeyPath_Key = @"kMoodQuestionController_KeyPath_Key";
NSString * const kMoodQuestionController_Title_Key = @"kMoodQuestionController_Title_Key";
NSString * const kMoodQuestionController_HelpUrl_Key = @"kMoodQuestionController_HelpUrl_Key";
NSString * const kMoodQuestionController_Error_Key = @"kMoodQuestionController_Error_Key";
NSString * const kMoodQuestionController_Field_Emergency_Key = @"kMoodQuestionController_Field_Emergency_Key";
@interface MoodQuestionController () <MoodViewDelegate>

@end

@implementation MoodQuestionController


#pragma mark - overrides

- (NSString*)titleForHeaderAtSection:(NSInteger)section
{
    // return [self.config objectForKey: kMoodQuestionController_Title_Key];
    return self.question.questionTitle;
}
- (QuestionOptions *)questionKeyPathAtIndex:(NSInteger)index
{
    return [self.question.questionOptions objectAtIndex: index];
    //return [[[self questions] objectAtIndex: index] objectForKey: kSimpleQuestionController_KeyPath_Key];
}
- (NSString *)helpUrl
{
    return @"http://help.docviewsolutions.com/chf-app/help.html";
    //return [self.config objectForKey: kMoodQuestionController_HelpUrl_Key];
}

- (BOOL)canGoNext
{
    return (self.pRecord.checkInValue)?TRUE:FALSE;
    //return ([[self.record valueForKey: [self.config objectForKey: kMoodQuestionController_KeyPath_Key]] intValue] != -1);
}

- (NSString *)errorText
{
    return @"Please tap on one of the faces.";
    //return [self.config objectForKey: kMoodQuestionController_Error_Key];
}
-(BOOL)isNeedShowEmergency
{
    return  [[self.config objectForKey: kMoodQuestionController_Field_Emergency_Key]boolValue];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // MoodView * smileView = [[[MoodView alloc] initWithFrame: CGRectMake(20, [self tableView: nil heightForHeaderInSection: 0] + 12, 280, 58)] autorelease];
    // smileView.selectedSmileIndex = [[self.record valueForKey: [self.config objectForKey: kMoodQuestionController_KeyPath_Key]] intValue];
  
    
  // Jatin Chauhan 25-Nov-2013
    
    
    
    
     MoodView *smileView=[[[MoodView alloc] initWithFrameWithOptions:CGRectMake(20, [self tableView: nil heightForHeaderInSection: 0], 600, 150) Options:self.question.questionOptions] autorelease];
    
                                                 // 150              // 600 , 58
    
   // MoodView *smileView=[[[MoodView alloc] initWithFrameWithOptions:CGRectMake(20,100,600,60) Options:self.question.questionOptions] autorelease];
    
    
    
   // MoodView *smileView=[[[MoodView alloc] initWithFrameWithOptions:CGRectMake(20, [self tableView: nil heightForHeaderInSection: 0] + 12, 280, 58) Options:self.question.questionOptions] autorelease];
    
    // -Jatin Chauhan 25-Nov-2013

    
    
    
    
    //2013-12-10 Vipul
    //smileView.selectedSmileIndex=self.pRecord.selectedIndex;//(self.pRecord.checkInValue)?[self.pRecord.checkInValue intValue]:-1;
    if([self.pRecord.checkInValue isEqualToString:@"0"])
        smileView.selectedSmileIndex = 2;
    else if([self.pRecord.checkInValue isEqualToString:@"1"])
        smileView.selectedSmileIndex = 1;
    else if ([self.pRecord.checkInValue isEqualToString:@"2"])
        smileView.selectedSmileIndex = 0;
    else
        smileView.selectedSmileIndex=self.pRecord.selectedIndex;//(self.pRecord.checkInValue)?[self.pRecord.checkInValue intValue]:-1;
    //
    smileView.delegate = self;
    [self.view addSubview: smileView];
   // if ([self isNeedShowEmergency])
    if (self.question.questionAlert.length>0)
        [self addAlert];
}
-(void)addAlert
{
    
    // Jatin Chauhan 25-Nov-2013
//    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(10.0, 230.0, 300.0, 90.0)];
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(20, 575.0, 600.0, 180.0)];

  // -Jatin Chauhan 25-Nov-2013
    
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.layer.cornerRadius = 20.0f;
    backgroundView.layer.borderWidth = 3.0f;
    backgroundView.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:backgroundView];
    
    
    
    UILabel  * emergencyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 580.0, 180.0)];
    emergencyLabel.numberOfLines = 0;
    emergencyLabel.backgroundColor = [UIColor clearColor];
    emergencyLabel.textColor = [UIColor blackColor];
    emergencyLabel.font = [UIFont boldSystemFontOfSize:38];
    emergencyLabel.text =self.question.questionAlert; //@"If you are having a medical emergency, please call 911 immediately.";
    [backgroundView addSubview:emergencyLabel];
    
    [emergencyLabel release];
    
    [backgroundView release];
}

- (void)moodViewDidChanged:(MoodView *)moodView
{
    //need a reverse index
    
    //[self.record setValue: [NSNumber numberWithInt: moodView.selectedSmileIndex] forKey: [self.config objectForKey: kMoodQuestionController_KeyPath_Key]];
    QuestionOptions *qo=[self questionKeyPathAtIndex:moodView.selectedSmileIndex];
    self.pRecord.qOptionID=qo.qOptionID;
    self.pRecord.selectedIndex=moodView.selectedSmileIndex;
   self.pRecord.score=qo.qOptionScore;
    /*if (![qo.qOptionTitle isEqualToString:@"Good"]) {
        self.pRecord.normal=FALSE;
    }*/
    self.pRecord.checkInValue=qo.qOptionValue;//[NSString stringWithFormat:@"%d",moodView.selectedSmileIndex];
   // NSLog(@"%@",self.pRecord);
    [self.questionsViewController errorWasFixed];
}

@end

