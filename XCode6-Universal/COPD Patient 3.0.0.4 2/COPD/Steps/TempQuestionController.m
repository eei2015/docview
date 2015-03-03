#import "TempQuestionController.h"
#import "YesNoSwitch.h"


@interface TempQuestionController () <YesNoSwitchDelegate>
@end

@implementation TempQuestionController

#pragma mark - overrides

- (NSString*)titleForHeaderAtSection:(NSInteger)section
{
    return @"Temperature Over 100˚?";
}

- (NSString *)helpUrl
{
    return @"http://help.docviewsolutions.com/copd-app/help.html#temp";
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    YesNoSwitch * ynSwitch = [[[YesNoSwitch alloc] initWithStyle: YesNoSwitchStyleLarge] autorelease];
    ynSwitch.yes = self.record.tempOver100;
    ynSwitch.delegate = self;
    ynSwitch.frame = CGRectMake(9, 36, ynSwitch.frame.size.width, ynSwitch.frame.size.height);
    [self.view addSubview: ynSwitch];
}

- (void)yesNoSwitchWasToggled:(YesNoSwitch *)yesNoSwitch
{
    self.record.tempOver100 = yesNoSwitch.yes;
}

@end
