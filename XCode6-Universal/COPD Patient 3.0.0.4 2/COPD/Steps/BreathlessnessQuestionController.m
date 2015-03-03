#import "BreathlessnessQuestionController.h"
#import "BreathlessnessView.h"

@interface BreathlessnessQuestionController () <BreathlessnessViewDelegate>

@end

@implementation BreathlessnessQuestionController

#pragma mark - overrides


- (NSString *)helpUrl
{
    return @"http://help.docviewsolutions.com/copd-app/help.html#breathlessness";
}

- (NSString*)titleForHeaderAtSection:(NSInteger)section
{
    return @"Breathlessness";
}

- (NSString *)errorText
{
    return @"Please tap one of the buttons above to indicate your level of breathlessness.";
}

- (BOOL)canGoNext
{
    return (self.record.breathlessness >= 0);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat cellWidth = 308;
    CGFloat cellHeight = 51;
   // BreathlessnessView * brView = [[[BreathlessnessView alloc] initWithFrame: CGRectMake((self.view.frame.size.width - cellWidth)/2, 36, cellWidth, cellHeight*5)] autorelease];
    
    
    BreathlessnessView * brView = [[[BreathlessnessView alloc] initWithFrame: CGRectMake((self.view.frame.size.width - cellWidth)/2, 36, cellWidth, cellHeight*5)] autorelease];
  
// Jatin Chauhan 25-Nov-2013
    
    
    
    NSLog(@"view x = %0.2f",self.view.frame.origin.x);
    NSLog(@"view y = %0.2f",self.view.frame.origin.y);
    NSLog(@"view widht = %0.2f",self.view.frame.size.width);
    NSLog(@"view height = %0.2f",self.view.frame.size.height);

    
    // Jatin Chauhan 25-Nov-2013
    
    brView.delegate = self;
    [self.view addSubview: brView];
    
    if (self.record.breathlessness < 0)
    {
        brView.value = -1;
    }
    else if (fabs(self.record.breathlessness) < 0.01)
    {
        brView.value = 0;
    }
    else if (fabs(self.record.breathlessness - 0.5) < 0.01)
    {
        brView.value = 1;
    }
    else
    {
        brView.value = self.record.breathlessness + 1;
    }
}

#pragma mark - BreathlessnessView delegate

- (void)breathlessnessViewValueChanged:(BreathlessnessView *)breathlessnessView
{    
    if (breathlessnessView.value == -1)
    {
        self.record.breathlessness = -1;
    }
    else if (breathlessnessView.value == 0)
    {
        self.record.breathlessness = 0;
    }
    else if (breathlessnessView.value == 1)
    {
        self.record.breathlessness = 0.5;
    }
    else
    {
        self.record.breathlessness = breathlessnessView.value - 1;
    }
    
    [self.questionsViewController errorWasFixed];
}

@end
