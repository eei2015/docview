//
//  BodyViewController.m
//  COPD
//
//  Created by Pavel Sharanda on 19.06.12.
//

//
//  BodyViewController.m
//  COPD
//
//  Created by Pavel Sharanda on 19.06.12.
//

#import "BodyQuestionController.h"

NSString * const kBodyQuestionController_KeyPath_Key = @"kBodyQuestionController_KeyPath_Key";
NSString * const kBodyQuestionController_Title_Key = @"kBodyQuestionController_Title_Key";
NSString * const kBodyQuestionController_HelpUrl_Key = @"kBodyQuestionController_HelpUrl_Key";
NSString * const kBodyQuestionController_Error_Key = @"kBodyQuestionController_Error_Key";


@interface BodyQuestionController ()

@end

@implementation BodyQuestionController

- (void)dealloc
{
    [btns release];
    [parts release];
    [super dealloc];
}

#pragma mark - overrides

- (NSString*)titleForHeaderAtSection:(NSInteger)section
{
    return self.question.questionTitle;
    //return [self.config objectForKey: kBodyQuestionController_Title_Key];
}

- (NSString *)helpUrl
{
    return @"http://help.docviewsolutions.com/chf-app/help.html";
    //return [self.config objectForKey: kBodyQuestionController_HelpUrl_Key];
}

- (BOOL)canGoNext
{
    
    return [[self painItems] count] > 0;
}

- (NSString *)errorText
{
    return @"Please tap on the body parts where you feel swollen.";//[self.config objectForKey: kBodyQuestionController_Error_Key];
}

#pragma mark - View lifecycle

- (UIButton *)createCheckBoxWithTitle:(NSString *)title
{
    UIButton * btn = [UIButton buttonWithType: UIButtonTypeCustom];
    
    //2015-01-19 Vipul ios8 upgradation
    NSString * strVersion = [[UIDevice currentDevice] systemVersion];
    int intVersion = [strVersion integerValue];
    
    if(intVersion > 7)
    {
        [btn setImage: [UIImage imageNamed: @"check-box@2x_ios8.png"] forState: UIControlStateNormal];
        [btn setImage: [UIImage imageNamed: @"checked@2x_ios8.png"] forState: UIControlStateSelected];
    }
    else{
        [btn setImage: [UIImage imageNamed: @"check-box@2x.png"] forState: UIControlStateNormal];
        [btn setImage: [UIImage imageNamed: @"checked@2x.png"] forState: UIControlStateSelected];
    }
    
    //2015-01-19 Vipul ios8 upgradation
        
    [btn setTitle: title forState: UIControlStateNormal];
    [btn setContentHorizontalAlignment: UIControlContentHorizontalAlignmentLeft];
    [btn setTitleShadowColor: [UIColor colorWithWhite: 0.5 alpha: 0.5] forState: UIControlStateNormal];
    
    [btn setTitleColor: [UIColor whiteColor] forState: UIControlStateSelected];
    [btn setTitleColor: [UIColor colorWithWhite: 0.4 alpha: 1] forState: UIControlStateHighlighted];
    [btn setTitleColor: [UIColor colorWithRed:(0xA8 / 255.0) green:(0xA8 / 255.0) blue:(0xA9 / 255.0) alpha:1.0] forState: UIControlStateNormal];
    
    btn.titleLabel.shadowOffset = CGSizeMake(0, 1);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    btn.titleLabel.font = [UIFont boldSystemFontOfSize: 30];
    
    [btn addTarget: self action: @selector(checkBoxClicked:) forControlEvents: UIControlEventTouchUpInside];
    return btn;
}

- (void)addBodyButtonWithFrame:(CGRect)frame index:(NSInteger)index
{
    UIButton * btn = [UIButton buttonWithType: UIButtonTypeCustom];
    btn.frame = frame;
    btn.tag = index;
    [btn addTarget: self action: @selector(bodyClicked:) forControlEvents: UIControlEventTouchUpInside];
    [bodyButtonsRootView addSubview: btn];
    [bodyBtns addObject: btn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [btns release];
    btns = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 8; i++)
    {
        UIButton * btn = [self createCheckBoxWithTitle: painItems[i]];
        
        // Jatin Chauhan 27-Nov-2013

        
//        btn.frame = CGRectMake(10, 35 + i*36, 120, 36);
        
        btn.frame = CGRectMake(10, 115 + i*63, 200, 36);

        
                // Jatin Chauhan 27-Nov-2013
        
        
        
        [self.view addSubview: btn];
        [btns addObject: btn];
    }
    
    //2015-01-19 Vipul ios8 upgradation
    NSString * strVersion = [[UIDevice currentDevice] systemVersion];
    int intVersion = [strVersion integerValue];
    //2015-01-19 Vipul ios8 upgradation
    
    CGFloat x = 155;
    CGFloat y = 70;// CGFloat y= 25;        - Jatin Chauhan 26-Nov-2013
    
    //2015-01-19 Vipul ios8 upgradation
    UIImageView * full  = [[UIImageView alloc] init];
    if(intVersion > 7)
    {
       full = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"Body@2x_ios8.png"]] autorelease];
    }
    else
    {
        full = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"Body@2x.png"]] autorelease];
    }
    //2015-01-19 Vipul ios8 upgradation
    
    // Jatin Chauhan 26-Nov-2013
    
    
    //  full.frame = CGRectMake(x, y, full.image.size.width, full.image.size.height);

    
    full.frame = CGRectMake(x+160, y, full.image.size.width, full.image.size.height);
    
    
    // -Jatin Chauhan 26-Nov-2013
        
    
    [self.view addSubview: full];
    
    //2015-01-19 Vipul ios8 upgradation
    NSArray * images = [[NSArray alloc] init];
    if(intVersion > 7)
    {
        images = [NSArray arrayWithObjects:
                        @"arms@2x_ios8.png",
                        @"wrists@2x_ios8.png",
                        @"hands@2x_ios8.png",
                        @"abdomen@2x_ios8.png",
                        @"thighs@2x_ios8.png",
                        @"calves@2x_ios8.png",
                        @"ankles@2x_ios8.png",
                        @"feet@2x_ios8.png",
                        nil];
    }
    else
    {
        images = [NSArray arrayWithObjects:
                            @"arms@2x.png",
                            @"wrists@2x.png",
                            @"hands@2x.png",
                            @"abdomen@2x.png",
                            @"thighs@2x.png",
                            @"calves@2x.png",
                            @"ankles@2x.png",
                            @"feet@2x.png",
                            nil];
    }
    //2015-01-19 Vipul ios8 upgradation
    
    [parts release];
    parts = [[NSMutableArray alloc] init];
    
    
    for (NSString * s in images)
    {
        UIImageView * imgView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: s]] autorelease];
        
        
        
        
         // Jatin Chauhan 26-Nov-2013
      //  imgView.frame = CGRectMake(x, y, imgView.image.size.width, imgView.image.size.height);
        
        
        imgView.frame = CGRectMake(x+160, y, imgView.image.size.width, imgView.image.size.height);

        
         // -Jatin Chauhan 26-Nov-2013
        
        imgView.alpha = 0;
        [self.view addSubview: imgView];
        [parts addObject: imgView];
    }
    
    //  for (NSNumber * i in [self painItems])
    // {
    //   [self setBodyPartWithIndex: [i intValue] hasPain: YES animated: NO];
    //  [self setBodyPartWithIndex: i hasPain: YES animated: NO];
    //}
    // NSLog(@"%@",[self painItems]);
    for (QuestionOptions * item in [self painItems])
    {
       // NSLog(@"Options: %d", item.optionIndex);
        [self setBodyPartWithIndex: item.optionIndex hasPain: YES animated: NO];
        
    }
    [bodyBtns release];
    bodyBtns = [[NSMutableArray alloc] init];
    
    bodyButtonsRootView = [[[UIView alloc] initWithFrame: full.frame] autorelease];
    [self.view addSubview: bodyButtonsRootView];
    
    [self addBodyButtonWithFrame: CGRectMake(20, 80, 35, 53) index: 0];
    [self addBodyButtonWithFrame: CGRectMake(93, 80, 35, 53) index: 0];
    
    [self addBodyButtonWithFrame: CGRectMake(23, 137, 17, 13) index: 1];
    [self addBodyButtonWithFrame: CGRectMake(111, 137, 17, 13) index: 1];
    
    [self addBodyButtonWithFrame: CGRectMake(8, 151, 33, 36) index: 2];
    [self addBodyButtonWithFrame: CGRectMake(111, 151, 33, 36) index: 2];
    
    [self addBodyButtonWithFrame: CGRectMake(57, 85, 34, 60) index: 3];
    
    [self addBodyButtonWithFrame: CGRectMake(46, 147, 57, 65) index: 4];
    
    [self addBodyButtonWithFrame: CGRectMake(63, 220, 26, 45) index: 5];
    
    [self addBodyButtonWithFrame: CGRectMake(56, 272, 37, 13) index: 6];
    
    [self addBodyButtonWithFrame: CGRectMake(45, 285, 60, 15) index: 7];
}

- (NSMutableSet *)painItems
{
    

    
    return self.pRecord.multipleSet;
    
    //return [self.record valueForKey: [self.config objectForKey: kBodyQuestionController_KeyPath_Key]];
}

- (BOOL)hasPainForBodyPartWithIndex:(NSInteger)index
{
    QuestionOptions *qo=[self.question.questionOptions objectAtIndex:index];
    for (QuestionOptions *item in [self painItems]) {
        if ([qo.qOptionID isEqualToString:item.qOptionID]) {
            return TRUE;
        }
    }
    return FALSE;
    //return [[self painItems] containsObject: qo];
    //return  [[self painItems] containsObject: [NSNumber numberWithInt: index]];
}

- (void)setBodyPartWithIndex:(NSInteger)index hasPain:(BOOL)hasPain animated:(BOOL)animated
{
    //  NSNumber * n = [NSNumber numberWithInt: index];
  //  NSLog(@"Index: %d",index);
    QuestionOptions *qo=[self.question.questionOptions objectAtIndex:index];
    qo.optionIndex=index;
    NSMutableSet * set = [self painItems];
    if (hasPain)
    {
        if (![set containsObject: qo])
        {
            
            [[self painItems] addObject: qo];
        }
    }
    else
    {
        //id obj = [set member: qo];
        //if (obj)
        //{
        [[self painItems] removeObject: qo];
        //}
    }
    
    UIButton * btn = [btns objectAtIndex: index];
    btn.selected = hasPain;
    
    UIImageView * imgView = [parts objectAtIndex: index];
    [UIView animateWithDuration: animated ? 0.15 : 0 animations:^{
        imgView.alpha = hasPain ? 1 : 0;
    }];
    
    [self.questionsViewController errorWasFixed];
}

- (void)checkBoxClicked:(UIButton *)sender
{
    //   UIButton *btn=(UIButton*)sender;
    NSInteger index = [btns indexOfObject: sender];
    [self setBodyPartWithIndex: index hasPain: ![self hasPainForBodyPartWithIndex: index] animated: YES];
    //[self setBodyPartWithIndex: index hasPain: !btn.selected animated: YES];
}

- (void)bodyClicked:(UIButton *)sender
{
    NSInteger index = sender.tag;
    [self setBodyPartWithIndex: index hasPain: ![self hasPainForBodyPartWithIndex: index] animated: YES];
}

@end

/*
#import "BodyQuestionController.h"

NSString * const kBodyQuestionController_KeyPath_Key = @"kBodyQuestionController_KeyPath_Key";
NSString * const kBodyQuestionController_Title_Key = @"kBodyQuestionController_Title_Key";
NSString * const kBodyQuestionController_HelpUrl_Key = @"kBodyQuestionController_HelpUrl_Key";
NSString * const kBodyQuestionController_Error_Key = @"kBodyQuestionController_Error_Key";


@interface BodyQuestionController ()
- (NSMutableSet *)painItems;
- (void)setBodyPartWithIndex:(NSInteger)index hasPain:(BOOL)hasPain animated:(BOOL)animated;
@end

@implementation BodyQuestionController

- (void)dealloc
{
    [btns release];
    [parts release];
    [super dealloc];
}

#pragma mark - overrides

- (NSString*)titleForHeaderAtSection:(NSInteger)section
{
    return [self.config objectForKey: kBodyQuestionController_Title_Key];
}

- (NSString *)helpUrl
{
    return [self.config objectForKey: kBodyQuestionController_HelpUrl_Key];
}

- (BOOL)canGoNext
{
    return [[self painItems] count] > 0;
}

- (NSString *)errorText
{
    return [self.config objectForKey: kBodyQuestionController_Error_Key];
}

#pragma mark - View lifecycle

- (UIButton *)createCheckBoxWithTitle:(NSString *)title
{
    UIButton * btn = [UIButton buttonWithType: UIButtonTypeCustom];
    [btn setImage: [UIImage imageNamed: @"check-box.png"] forState: UIControlStateNormal];
    [btn setImage: [UIImage imageNamed: @"checked.png"] forState: UIControlStateSelected];
    [btn setTitle: title forState: UIControlStateNormal];
    [btn setContentHorizontalAlignment: UIControlContentHorizontalAlignmentLeft];
    [btn setTitleShadowColor: [UIColor colorWithWhite: 0.5 alpha: 0.5] forState: UIControlStateNormal];
    
    [btn setTitleColor: [UIColor whiteColor] forState: UIControlStateSelected];
    [btn setTitleColor: [UIColor colorWithWhite: 0.4 alpha: 1] forState: UIControlStateHighlighted];
    [btn setTitleColor: [UIColor colorWithRed:(0xA8 / 255.0) green:(0xA8 / 255.0) blue:(0xA9 / 255.0) alpha:1.0] forState: UIControlStateNormal];
    
    btn.titleLabel.shadowOffset = CGSizeMake(0, 1);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    btn.titleLabel.font = [UIFont boldSystemFontOfSize: 15];
    
    [btn addTarget: self action: @selector(checkBoxClicked:) forControlEvents: UIControlEventTouchUpInside];
    return btn;
}

- (void)addBodyButtonWithFrame:(CGRect)frame index:(NSInteger)index
{
    UIButton * btn = [UIButton buttonWithType: UIButtonTypeCustom];
    btn.frame = frame;
    btn.tag = index;
    [btn addTarget: self action: @selector(bodyClicked:) forControlEvents: UIControlEventTouchUpInside];
    [bodyButtonsRootView addSubview: btn];
    [bodyBtns addObject: btn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [btns release];
    btns = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 8; i++)
    {
        UIButton * btn = [self createCheckBoxWithTitle: painItems[i]];
        btn.frame = CGRectMake(10, 35 + i*36, 120, 36);
        [self.view addSubview: btn];
        [btns addObject: btn];
    }
    
    CGFloat x = 155;
    CGFloat y = 25;
    
    UIImageView * full = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"Body.png"]] autorelease];
    full.frame = CGRectMake(x, y, full.image.size.width, full.image.size.height);
    [self.view addSubview: full];
    
    NSArray * images = [NSArray arrayWithObjects: 
                        @"arms.png",
                        @"wrists.png",
                        @"hands.png",
                        @"abdomen.png",
                        @"thighs.png",
                        @"calves.png",
                        @"ankles.png",
                        @"feet.png",
                         nil];
    
    [parts release];
    parts = [[NSMutableArray alloc] init];
    
    
    for (NSString * s in images)
    {
        UIImageView * imgView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: s]] autorelease];
        imgView.frame = CGRectMake(x, y, imgView.image.size.width, imgView.image.size.height);
        imgView.alpha = 0;
        [self.view addSubview: imgView];
        [parts addObject: imgView];
    }
    
    for (NSNumber * i in [self painItems])
    {
        [self setBodyPartWithIndex: [i intValue] hasPain: YES animated: NO];
    }
    
    [bodyBtns release];
    bodyBtns = [[NSMutableArray alloc] init];
    
    bodyButtonsRootView = [[[UIView alloc] initWithFrame: full.frame] autorelease];
    [self.view addSubview: bodyButtonsRootView];
    
    [self addBodyButtonWithFrame: CGRectMake(20, 80, 35, 53) index: 0];
    [self addBodyButtonWithFrame: CGRectMake(93, 80, 35, 53) index: 0];
    
    [self addBodyButtonWithFrame: CGRectMake(23, 137, 17, 13) index: 1];
    [self addBodyButtonWithFrame: CGRectMake(111, 137, 17, 13) index: 1];
    
    [self addBodyButtonWithFrame: CGRectMake(8, 151, 33, 36) index: 2];
    [self addBodyButtonWithFrame: CGRectMake(111, 151, 33, 36) index: 2];
    
    [self addBodyButtonWithFrame: CGRectMake(57, 85, 34, 60) index: 3];
    
    [self addBodyButtonWithFrame: CGRectMake(46, 147, 57, 65) index: 4];
    
    [self addBodyButtonWithFrame: CGRectMake(63, 220, 26, 45) index: 5];
    
    [self addBodyButtonWithFrame: CGRectMake(56, 272, 37, 13) index: 6];
    
    [self addBodyButtonWithFrame: CGRectMake(45, 285, 60, 15) index: 7];
}

- (NSMutableSet *)painItems
{
    return [self.record valueForKey: [self.config objectForKey: kBodyQuestionController_KeyPath_Key]];
}

- (BOOL)hasPainForBodyPartWithIndex:(NSInteger)index
{
    return  [[self painItems] containsObject: [NSNumber numberWithInt: index]];
}

- (void)setBodyPartWithIndex:(NSInteger)index hasPain:(BOOL)hasPain animated:(BOOL)animated
{
    NSNumber * n = [NSNumber numberWithInt: index];
    NSMutableSet * set = [self painItems];
    if (hasPain)
    {
        if (![set containsObject: n])
        {
            [[self painItems] addObject: n];
        }
    }
    else
    {
        id obj = [set member: n];
        if (obj)
        {
             [[self painItems] removeObject: obj];
        }
    }
    
    UIButton * btn = [btns objectAtIndex: index];
    btn.selected = hasPain;
    
    UIImageView * imgView = [parts objectAtIndex: index];
    [UIView animateWithDuration: animated ? 0.15 : 0 animations:^{
        imgView.alpha = hasPain ? 1 : 0; 
    }];
    
    [self.questionsViewController errorWasFixed];
}

- (void)checkBoxClicked:(UIButton *)sender
{
    NSInteger index = [btns indexOfObject: sender];
    [self setBodyPartWithIndex: index hasPain: ![self hasPainForBodyPartWithIndex: index] animated: YES];
}

- (void)bodyClicked:(UIButton *)sender
{
    NSInteger index = sender.tag;
    [self setBodyPartWithIndex: index hasPain: ![self hasPainForBodyPartWithIndex: index] animated: YES];
}

@end*/
