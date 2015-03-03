//
//  ForgetViewController.m
//  COPD
//
//  Created by Akhil on 11/12/13.
//  Copyright (c) 2013 TKInteractive. All rights reserved.
//

#import "ForgetViewController.h"
#import "UIViewController+Branding.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "Crittercism.h"
#import "Content.h"
#import "MainViewController.h"
#import "QuestionsViewController.h"

#if COPD
#import "InAppBrowserController.h"
#else
#import "HelpViewController.h"
#endif

#import "ConfirmPassViewController.h"

//akhil 23-12-13
#define CHECK_EXIT_PATIENT			@"CheckExistingPatient"///%@
#import "SBJson.h"

#define USERNAME_SETTING_KEY @"USERNAME_SETTING_KEY"
#define PASSWORD_SETTING_KEY @"PASSWORD_SETTING_KEY"

//akhil 23-1-15

//  System Versioning Preprocessor Macros
 

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
//akhil 23-1-15



@interface ForgetViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, TSAlertViewDelegate>

@property (nonatomic, retain) UITableView* fieldsTable;
@property (nonatomic, retain) UITableViewCell* loginCell;
@property (nonatomic, retain) UITableViewCell* passwdCell;
@property (nonatomic, retain) UITableViewCell* nameFirstCell;
@property (nonatomic, retain) UITableViewCell* nameLastCell;
@property (nonatomic, retain) UITableViewCell* maleCell;
@property (nonatomic, retain) UITableViewCell* femaleCell;
@property (nonatomic, retain) UITableViewCell* birthDayCell;
@property (nonatomic, retain) UITextField* loginField;
@property (nonatomic, retain) UITextField* passwdField;
@property (nonatomic, retain) UITextField* nameFirstField;
@property (nonatomic, retain) UITextField* nameLastField;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) UIDatePicker *pickerView;
@property (nonatomic, retain) UIBarButtonItem *doneButton;


@end

@implementation ForgetViewController

@synthesize fieldsTable;

@synthesize loginCell, passwdCell, nameFirstCell, nameLastCell, maleCell, femaleCell;
@synthesize loginField, passwdField, nameFirstField, nameLastField,birthDayCell,dateFormatter;
@synthesize pickerView,doneButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        //akhil 8-1-14
    self.navigationItem.hidesBackButton = YES;
    
    [[NSUserDefaults standardUserDefaults] setValue: @"" forKey: ALFTA_NUMERIC_EXP];
    [[NSUserDefaults standardUserDefaults] setValue: @"" forKey: ALFTA_NUMERIC_EXP_MSG];
    [[NSUserDefaults standardUserDefaults] setValue: @"" forKey: COMPLEX_EXP];
    [[NSUserDefaults standardUserDefaults] setValue: @"" forKey: COMPLEX_EXP_MSG];
    [[NSUserDefaults standardUserDefaults] setValue: @"" forKey: PASS_LENGTH_EXP];
    [[NSUserDefaults standardUserDefaults] setValue: @"" forKey: PASS_LENGTH_EXP_MSG];

    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [self loadBrandingViews];
    
    self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
   // UILongPressGestureRecognizer * lp = [[[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(handleLogoLongPress:)] autorelease];
    //[self.navigationItem.titleView addGestureRecognizer: lp];
  //  UITapGestureRecognizer * tg = [[[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleLogoTap:)] autorelease];
   // [self.navigationItem.titleView addGestureRecognizer: tg];
    
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle: @"Help" style: UIBarButtonItemStyleBordered target: self action: @selector(helpClicked)] autorelease];
    
    //self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle: @"TEST" style: UIBarButtonItemStyleBordered target: self action: @selector(testClicked)] autorelease];

    
    
    headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    
    //akhil 16-2-15
    //ios update remwove above space on table view
    
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //akhil 16-2-15
    //ios update remwove above space on table view

    //UILabel* l = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 60)] autorelease];
   // UILabel* l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 0, 580, 60)] autorelease];
    UILabel* l = [[[UILabel alloc] init] autorelease];

    //akhil 27-1-15
    //IOS Upgradation
    if(IS_IPHONE_4_OR_LESS)
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 30)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:12];
        //l.layer.borderWidth=1;
         //  [l setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        
    }
    else if (IS_IPHONE_5)
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 35)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:14];
         l.layer.borderWidth=1;
          // [headerView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        
    }
    
    else
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 580, 60)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:25];
        l.layer.borderWidth = 1;
    }
    //}
    //akhil 27-1-15
    //IOS Upgradation

    
    //40, 80, 690, 700
    //l.layer.borderWidth = 1;
    l.layer.borderColor = [[UIColor redColor]CGColor];
    //l.font = [UIFont boldSystemFontOfSize:25];
    l.backgroundColor = [UIColor clearColor];
    l.textColor = [UIColor whiteColor];
    l.shadowColor = [UIColor blackColor];
    l.shadowOffset = CGSizeMake(0, 1);
    l.numberOfLines = 2;
    
    l.text = @"Welcome to DocView \nPassword Reset";
    //l.layer.borderWidth = 2;
    l.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:l];
    
    //self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
     //self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(240, 11, 370, 42)] autorelease];
    //akhil 2-2-15
    //IOS Upgradation
    /*if(IS_IPHONE_4_OR_LESS)
    {
        self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
        loginField.font = [UIFont systemFontOfSize:14];
        
    }
    else if (IS_IPHONE_5)
    {
        self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
        loginField.font = [UIFont systemFontOfSize:14];
    }*/
    //akhil 13-2-15
    if (IS_IPHONE_4_OR_LESS||IS_IPHONE_5)
    {
        self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, self.view.frame.size.width-180, 24)] autorelease];
        loginField.font = [UIFont systemFontOfSize:14];
         [self.loginField setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    }
    //akhil 13-2-15

    else
    {
        self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(240, 11, 370, 42)] autorelease];
        loginField.font = [UIFont systemFontOfSize:34];
    }
    //}
    //akhil 2-2-15
    //IOS Upgradation

    self.loginField.layer.borderWidth = 1;
    loginField.delegate = self;
    loginField.placeholder = @"Enter your Firstname";
    //loginField.font = [UIFont systemFontOfSize:34];
    loginField.borderStyle = UITextBorderStyleNone;
    loginField.spellCheckingType = UITextSpellCheckingTypeNo;
    loginField.autocorrectionType = UITextAutocorrectionTypeNo;
    loginField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //loginField.text = [[NSUserDefaults standardUserDefaults] valueForKey: USERNAME_SETTING_KEY];
    [loginField addTarget: self action: @selector(loginFieldEditingChanged) forControlEvents: UIControlEventEditingChanged];
    
    //self.passwdField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
   // self.passwdField = [[[UITextField alloc] initWithFrame:CGRectMake(240, 11, 370, 42)] autorelease];
    //akhil 2-2-15
    //IOS Upgradation
   /* if(IS_IPHONE_4_OR_LESS)
    {
        self.passwdField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
        passwdField.font = [UIFont systemFontOfSize:14];
        
    }
    else if (IS_IPHONE_5)
    {
        self.passwdField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
        passwdField.font = [UIFont systemFontOfSize:14];
        
    }*/
    //akhil 12-2-15
    if(IS_IPHONE_4_OR_LESS || IS_IPHONE_5)
    {
        self.passwdField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, self.view.frame.size.width-180, 24)] autorelease];
        passwdField.font = [UIFont systemFontOfSize:14];
         [self.passwdField setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    }
    //akhil 12-2-15

    else
    {
        self.passwdField = [[[UITextField alloc] initWithFrame:CGRectMake(240, 11, 370, 42)] autorelease];
        passwdField.font = [UIFont systemFontOfSize:34];
    }
    //akhil 2-2-15
    //IOS Upgradation
    passwdField.layer.borderWidth=1;
   // passwdField.font = [UIFont systemFontOfSize:34];
    passwdField.placeholder = @"Enter your Lastname";
    passwdField.delegate = self;
    passwdField.spellCheckingType = UITextSpellCheckingTypeNo;
    passwdField.autocorrectionType = UITextAutocorrectionTypeNo;
    passwdField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //passwdField.secureTextEntry = YES;
    passwdField.borderStyle = UITextBorderStyleNone;
    
    //akhil 11-12-13
    //self.nameFirstField = [[[UITextField alloc] initWithFrame:CGRectMake(151, 11, 155, 24)] autorelease];//115, 11, 185, 24
    self.nameFirstField = [[[UITextField alloc] initWithFrame:CGRectMake(320, 11, 290, 42)] autorelease];
    
    //akhil 2-2-15
    //IOS Upgradation
    /*if(IS_IPHONE_4_OR_LESS)
    {
        self.nameFirstField = [[[UITextField alloc] initWithFrame:CGRectMake(130, 11, 185, 24)] autorelease];
        nameFirstField.font = [UIFont systemFontOfSize:14];
    }
    else if (IS_IPHONE_5)
    {
        self.nameFirstField = [[[UITextField alloc] initWithFrame:CGRectMake(130, 11, 185, 24)] autorelease];
        nameFirstField.font = [UIFont systemFontOfSize:14];
    }*/
    //akhil 13-2-15
    if(IS_IPHONE_4_OR_LESS || IS_IPHONE_5)
    {
        self.nameFirstField = [[[UITextField alloc] initWithFrame:CGRectMake(135, 11, self.view.frame.size.width-200, 24)] autorelease];
        nameFirstField.font = [UIFont systemFontOfSize:14];
        [self.nameFirstField setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];

    }
    //akhil 13-2-15

    else
    {
        self.nameFirstField = [[[UITextField alloc] initWithFrame:CGRectMake(310, 11, 310, 42)] autorelease];
        nameFirstField.font = [UIFont systemFontOfSize:32];
    }
    //akhil 2-2-15
    //IOS Upgradation

    nameFirstField.layer.borderWidth=1;
    nameFirstField.placeholder = @"Enter Home Zip Code";
    // nameFirstField.font = [UIFont systemFontOfSize:29];
    //self.nameFirstField.layer.borderWidth=1;
    nameFirstField.delegate = self;
    nameFirstField.borderStyle = UITextBorderStyleNone;
    
    self.nameLastField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
    //akhil 2-2-15
    //IOS Upgradation
   /* if(IS_IPHONE_4_OR_LESS)
    {
        self.nameLastField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
        nameLastField.font = [UIFont systemFontOfSize:14];
    }
    else if (IS_IPHONE_5)
    {
        self.nameLastField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
        nameLastField.font = [UIFont systemFontOfSize:14];
    }*/
    //akhil 13-2-15
    if(IS_IPHONE_4_OR_LESS || IS_IPHONE_5)
    {
        self.self.nameLastField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, self.view.frame.size.width-180, 24)] autorelease];
        self.nameLastField.font = [UIFont systemFontOfSize:14];
        [self.nameLastField setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];

    }
    //akhil 13-2-15

    else
    {
        self.nameLastField = [[[UITextField alloc] initWithFrame:CGRectMake(240, 11, 370, 42)] autorelease];
        nameLastField.font = [UIFont systemFontOfSize:34];
    }
    //akhil 2-2-15
    //IOS Upgradation
    nameLastField.layer.borderWidth=1;
    nameLastField.delegate = self;
    nameLastField.borderStyle = UITextBorderStyleNone;
    
    
    
    self.loginCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"login"] autorelease];
    loginCell.selectionStyle = UITableViewCellSelectionStyleNone;
  //  l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 90, 42)] autorelease];
    l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 1, 180, 57)] autorelease];
    
    //akhil 2-2-15
    //IOS Upgradation
    if(IS_IPHONE_4_OR_LESS)
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 90, 42)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:14];
    }
    else if (IS_IPHONE_5)
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 90, 42)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:14];
    }
    else
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 1, 180, 57)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:34];
    }
    //akhil 2-2-15
    //IOS Upgradation

    l.text = @"First";
    //l.font = [UIFont boldSystemFontOfSize:34];
    [loginCell addSubview:l];
    [loginCell addSubview:loginField];
    
    self.passwdCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"passwd"] autorelease];
    passwdCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 90, 42)] autorelease];
     l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 1, 180, 57)] autorelease];
    
    //akhil 2-2-15
    //IOS Upgradation
    if(IS_IPHONE_4_OR_LESS)
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 90, 42)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:14];
         [l setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    }
    else if (IS_IPHONE_5)
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 90, 42)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:14];
          [l setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        
    }
    else
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 1, 180, 57)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:34];
    }
    //akhil 2-2-15
    //IOS Upgradation

    l.text = @"Last";
    //l.font = [UIFont boldSystemFontOfSize:34];
    [passwdCell addSubview:l];
    [passwdCell addSubview:passwdField];
    
    self.nameFirstCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nameFirst"] autorelease];
    nameFirstCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 130, 42)] autorelease];
     l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 1, 260, 57)] autorelease];
    
    //akhil 2-2-15
    //IOS Upgradation
    if(IS_IPHONE_4_OR_LESS)
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 130, 42)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:14];
    }
    else if (IS_IPHONE_5)
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 130, 42)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:14];
        
    }
    else
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 1, 260, 57)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:34];
    }
    //akhil 2-2-15
    //IOS Upgradation

    l.text = @"Home Zip Code";
   // l.font = [UIFont boldSystemFontOfSize:34];
    [nameFirstCell addSubview:l];
    [nameFirstCell addSubview:nameFirstField];
    
   /* self.nameLastCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nameLast"] autorelease];
    nameLastCell.selectionStyle = UITableViewCellSelectionStyleNone;
    l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 90, 42)] autorelease];
    l.text = @"Last Name";
    l.font = [UIFont boldSystemFontOfSize:17];
    [nameLastCell addSubview:l];
    [nameLastCell addSubview:nameLastField];*/
    
      
    self.birthDayCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: nil] autorelease];
	self.birthDayCell.textLabel.text = @"Birthday";
    
    //akhil 2-2-15
    //IOS Upgradation
    if(IS_IPHONE_4_OR_LESS)
    {
        self.birthDayCell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        self.birthDayCell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
    }
    else if (IS_IPHONE_5)
    {
        self.birthDayCell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        self.birthDayCell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
    }
    else
    {
        self.birthDayCell.textLabel.font = [UIFont boldSystemFontOfSize:34];
        self.birthDayCell.detailTextLabel.font = [UIFont boldSystemFontOfSize:30];
    }
    //akhil 2-2-15
    //IOS Upgradation
   // self.birthDayCell.textLabel.font = [UIFont boldSystemFontOfSize:34];
   // self.birthDayCell.detailTextLabel.font = [UIFont boldSystemFontOfSize:30];
	self.birthDayCell.detailTextLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
    
    
    self.pickerView = [[[UIDatePicker alloc] initWithFrame: CGRectZero] autorelease];
    self.pickerView.datePickerMode = UIDatePickerModeDate;
    [self.pickerView addTarget: self action: @selector(dateAction:) forControlEvents: UIControlEventValueChanged];
    [self.pickerView sizeToFit];
    //2014-01-20 Vipul ITAD 2.6
    self.pickerView.maximumDate = [NSDate date];
    //2014-01-20 Vipul ITAD 2.6
    
    self.doneButton = [[[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleDone target: self action: @selector(doneAction:)] autorelease];
    
    //self.fieldsTable = [[[UITableView alloc] initWithFrame: self.view.bounds style:UITableViewStyleGrouped] autorelease];
    
    
    
    
    /*//akhil 23-1-15
    //ios - 8
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        self.fieldsTable = [[[UITableView alloc]initWithFrame:CGRectMake(70, 80, 630, 700) style:UITableViewStyleGrouped]autorelease];
    }
    else
    {
        self.fieldsTable = [[[UITableView alloc]initWithFrame:CGRectMake(40, 80, 690, 700) style:UITableViewStyleGrouped]autorelease];
    }
    //akhil 23-1-15
    //ios - 8*/
    
    //akhil 2-2-15
    //IOS Upgradation
   /* if(IS_IPHONE_4_OR_LESS)
    {
        self.fieldsTable = [[[UITableView alloc]initWithFrame:CGRectMake(0, 60, 320, 460) style:UITableViewStyleGrouped]autorelease];
    }
    else if (IS_IPHONE_5)
    {
        self.fieldsTable = [[[UITableView alloc]initWithFrame:CGRectMake(0, 65, 320, 500) style:UITableViewStyleGrouped]autorelease];
        
    }
    else
    {
        self.fieldsTable = [[[UITableView alloc]initWithFrame:CGRectMake(70, 80, 630, 700) style:UITableViewStyleGrouped]autorelease];
        
    }*/

       //akhil 2-2-15
    //IOS Upgradation


    fieldsTable.backgroundColor = nil;
    fieldsTable.backgroundView = nil;
    //fieldsTable.scrollEnabled = NO;
    fieldsTable.delegate = self;
    fieldsTable.dataSource = self;
    
    //akhil
    fieldsTable.layer.borderWidth = 3;
    fieldsTable.layer.borderColor = [[UIColor redColor]CGColor];
    
    //fieldsTable.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:fieldsTable];
    
    //akhil 2-2-15
    //iphone ipad
    if ([UIDevice currentDevice ].userInterfaceIdiom==UIUserInterfaceIdiomPad )
    {
        fieldsTable.rowHeight = 59;
    }
    else
    {
        //iphone 4
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        if(iOSDeviceScreenSize.height == 480)
        {
            fieldsTable.rowHeight = 40;
        }
        if(iOSDeviceScreenSize.height == 568)
        {
            fieldsTable.rowHeight = 40;

        }
        // fieldsTable.rowHeight = 35;
        
    }
    //akhil 2-2-15
    //iphone ipad

     //fieldsTable.rowHeight = 59;
    //fieldsTable.rowHeight = 118;
    footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    
    loginButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login-active"] forState:UIControlStateSelected];
    [loginButton setTitle:@"Submit" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor colorWithWhite: 0.2 alpha: 1] forState:UIControlStateNormal];
    [loginButton setTitleShadowColor:[UIColor colorWithWhite: 0.92 alpha: 1] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor colorWithWhite: 0.1 alpha: 1] forState:UIControlStateHighlighted];
    [loginButton setTitleShadowColor:[UIColor colorWithWhite: 0.15 alpha: 0.2] forState:UIControlStateHighlighted];
    loginButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [loginButton addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton sizeToFit];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize: 36];
   // loginButton.center = CGPointMake(self.view.frame.size.width/2, 40);
   // loginButton.frame = CGRectMake(70, 90, 610, 60);
   // loginButton.center = CGPointMake((self.view.frame.size.width/2)-40, 40);
    
   /* //akhil 23-1-15
    //ios 8
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        loginButton.frame = CGRectMake(40, 90, 610, 60);
        loginButton.center = CGPointMake((self.view.frame.size.width/2)-70, 40);
    }
    
    else
    {
        loginButton.frame = CGRectMake(70, 90, 610, 60);
        loginButton.center = CGPointMake((self.view.frame.size.width/2)-40, 40);
    }
    
    //akhil 23-1-15
    //ios 8*/
    //akhil 2-2-15
    //IOS Upgradation
    
    if(IS_IPHONE_4_OR_LESS)
    {
        //loginButton.center = CGPointMake(self.view.frame.size.width/2, 40);
        //loginButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
        
        loginButton.center = CGPointMake(0, 40);
        loginButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
        [loginButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    }
    else if (IS_IPHONE_5)
    {
       // loginButton.center = CGPointMake(self.view.frame.size.width/2, 40);
      //  loginButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
        loginButton.center = CGPointMake(0, 40);
        loginButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
        [loginButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    }
    else
    {
        loginButton.frame = CGRectMake(60, 90, 610, 60);
        loginButton.center = CGPointMake((self.view.frame.size.width/2)-70, 40);
        loginButton.titleLabel.font = [UIFont boldSystemFontOfSize: 36];
    }
    //}
    //akhil 2-2-15
    //IOS Upgradation


    
    //2014-01-20 Vipul ITAD 2.6
    CancelButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [CancelButton setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [CancelButton setBackgroundImage:[UIImage imageNamed:@"login-active"] forState:UIControlStateSelected];
    [CancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [CancelButton setTitleColor:[UIColor colorWithWhite: 0.2 alpha: 1] forState:UIControlStateNormal];
    [CancelButton setTitleShadowColor:[UIColor colorWithWhite: 0.92 alpha: 1] forState:UIControlStateNormal];
    [CancelButton setTitleColor:[UIColor colorWithWhite: 0.1 alpha: 1] forState:UIControlStateHighlighted];
    [CancelButton setTitleShadowColor:[UIColor colorWithWhite: 0.15 alpha: 0.2] forState:UIControlStateHighlighted];
    CancelButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [CancelButton addTarget:self action:@selector(CancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [CancelButton sizeToFit];
    CancelButton.titleLabel.font = [UIFont boldSystemFontOfSize: 36];
    // loginButton.center = CGPointMake(self.view.frame.size.width/2, 40);
   // CancelButton.frame = CGRectMake(70, 160, 610, 60);
   // CancelButton.center = CGPointMake((self.view.frame.size.width/2)-40, 110);
    
    //akhil 23-1-15
    //ios 8
   /*
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        CancelButton.frame = CGRectMake(70, 160, 610, 60);
        CancelButton.center = CGPointMake((self.view.frame.size.width/2)-70, 110);
    }
    else
    {
        CancelButton.frame = CGRectMake(70, 160, 610, 60);
        CancelButton.center = CGPointMake((self.view.frame.size.width/2)-40, 110);
    }
    //2014-01-20 Vipul ITAD 2.6*/
    
    //akhil 2-2-15
    //IOS Upgradation
    if(IS_IPHONE_4_OR_LESS)
    {
       // CancelButton.center = CGPointMake(self.view.frame.size.width/2, 40);
        //CancelButton.frame = CGRectMake(CancelButton.frame.origin.x, CancelButton.frame.origin.y+50, CancelButton.frame.size.width, CancelButton.frame.size.height);
       // CancelButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
        CancelButton.center = CGPointMake(0, 90);
        CancelButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
        [CancelButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    }
    else if (IS_IPHONE_5)
    {
       // CancelButton.center = CGPointMake(self.view.frame.size.width/2, 40);
      //  CancelButton.frame = CGRectMake(CancelButton.frame.origin.x, CancelButton.frame.origin.y+50, CancelButton.frame.size.width, CancelButton.frame.size.height);
       // CancelButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
        
        CancelButton.center = CGPointMake(0, 90);
        CancelButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
        [CancelButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    }
    else
    {
        CancelButton.frame = CGRectMake(70, 90, 610, 60);
        CancelButton.center = CGPointMake((self.view.frame.size.width/2)-70, 120);
        CancelButton.titleLabel.font = [UIFont boldSystemFontOfSize: 36];
    }
    //akhil 2-2-15
    //IOS Upgradation
    
    activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray] autorelease];
    activityIndicatorView.center = CGPointMake(loginButton.frame.size.width - 20, loginButton.frame.size.height/2+1);
    [loginButton addSubview: activityIndicatorView];
    
    UIImageView * logos = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"login-logos.png"]] autorelease];
    
    logos.frame = CGRectMake(0, 197, logos.frame.size.width, logos.frame.size.height);
    [footerView addSubview: logos];
    [footerView addSubview:loginButton];
    
    //2014-01-20 Vipul ITAD 2.6
    [footerView addSubview:CancelButton];
    //2014-01-20 Vipul ITAD 2.6
    
    tempIndex = 0;
    signupMode = NO;
    male = YES;
  //  [self updateUIMode];
    
    
    
    
    NSURL *url = [NSURL URLWithString:@"http://api.pusherapp.com/"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"chatX" , @"channel_name",
                            @"new-message", @"channel_name",
                            [NSString stringWithFormat:@"%f",[[NSDate date]timeIntervalSince1970] ]  , @"auth_timestamp",
                            nil];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [client postPath:@"apps/27056/channels/chatX/events" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *text = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"Response: %@", text);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    UILabel * footerLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 0, 28)];
    footerLabel.backgroundColor = [UIColor clearColor];
    footerLabel.textColor = [UIColor whiteColor];
    
    //3-2-15
    //ios upgration
    if ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
    {
        footerLabel.font = [UIFont boldSystemFontOfSize: 22];
    }
    else
    {
        footerLabel.font = [UIFont boldSystemFontOfSize: 11];
    }
    //26-1-15
    //ios upgration

    //footerLabel.font = [UIFont boldSystemFontOfSize: 22];
    
    footerLabel.text = [[Content shared] versionString];
    footerLabel.textAlignment = UITextAlignmentCenter;
    fieldsTable.tableFooterView = footerLabel;

	// Do any additional setup after loading the view.
}

/*- (void)testClicked
{
    
#if COPD
    [InAppBrowserController showFromViewController: self withUrl: @"http://help.docviewsolutions.com/copd-app/help.html"];
#elif HFBASE
	ConfirmPassViewController *help = [[[ConfirmPassViewController alloc] init] autorelease];
	//help.url = @"http://help.docviewsolutions.com/chf-app/help.html";
	[self.navigationController pushViewController:help animated:YES];
#elif HFB
	HelpViewController *help = [[[HelpViewController alloc] init] autorelease];
	help.url = @"http://www.barnabashealth.org/services/cardiac/education/chf_diagnosing.html";
	[self.navigationController pushViewController:help animated:YES];
#endif
}*/

-(void)keyboardWillShow
{
    NSLog(@"come here ");
}
- (void)helpClicked
{
    
#if COPD
    [InAppBrowserController showFromViewController: self withUrl: @"http://help.docviewsolutions.com/copd-app/help.html"];
#elif HFBASE
	HelpViewController *help = [[[HelpViewController alloc] init] autorelease];
	help.url = @"http://help.docviewsolutions.com/chf-app/help.html";
	[self.navigationController pushViewController:help animated:YES];
#elif HFB
	HelpViewController *help = [[[HelpViewController alloc] init] autorelease];
	help.url = @"http://www.barnabashealth.org/services/cardiac/education/chf_diagnosing.html";
	[self.navigationController pushViewController:help animated:YES];
#endif
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}
- (void)loginFieldEditingChanged
{
    //[[NSUserDefaults standardUserDefaults] setValue: [loginField.text length] > 0 ? loginField.text : @"" forKey: USERNAME_SETTING_KEY];
    //[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showLoading:(BOOL)show
{
    if (show)
    {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [activityIndicatorView startAnimating];
    }
    else
    {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [activityIndicatorView stopAnimating];
    }
}

- (void)login
{
    
    if ([[Content shared] handleInternetConnectivity]) {
        [self loginFieldEditingChanged];
        
        [loginField resignFirstResponder];
        [passwdField resignFirstResponder];
        [nameFirstField resignFirstResponder];
        [nameLastField resignFirstResponder];
        if (!signupMode)
        {
            // Login
            if (![loginField.text length])
                [self showError:@"Please Enter First Name"];
            else if (![passwdField.text length])
                [self showError:@"Please Enter Last Name"];
            else if (![nameFirstField.text length])
                [self showError:@"Please Enter Home Zip Code"];
            else if (![self.birthDayCell.detailTextLabel.text length])
                [self showError:@"Please Enter Your Birth Date"];
            else
            {
                [self showLoading: YES];
                
                NSString *strBaseURL=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"BaseUrl"];
               //   NSString *strBaseURL=@"http://203.88.128.134/Demob/hf/docviewservice/IpadServiceData.svc/";
                
            AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:strBaseURL]] autorelease];
                
                NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:loginField.text,@"FirstName",passwdField.text,@"LastName",nameFirstField.text,@"ZipCode",self.birthDayCell.detailTextLabel.text,@"DOB", nil];
                
                
                [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
                [client setDefaultHeader:@"Accept" value:@"application/json"];
                client.parameterEncoding = AFJSONParameterEncoding;
                
                NSLog(@"%@",param);
                //NSString *strError;
                [client postPath:CHECK_EXIT_PATIENT parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
                 
                 //[client getPath:[NSString stringWithFormat:CHECK_EXIT_PATIENT, param] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
                 {
                     NSLog(@"RES: %@",responseObject);
                     
                     
                     //  NSLog(@"RES: %@",[responseObject objectForKey:@"CheckExistingPatientResult"]);
                     
                     // NSDictionary *response=[responseObject objectForKey:@"CheckForSurveyResult"];
                     NSDictionary *response=[[[responseObject objectForKey:@"CheckExistingPatientResult"] objectForKey:@"Data"] JSONValue];
                     NSLog(@"responce dict = %@",response);
                     
                     //NSLog(@"error = %@",[[responseObject objectForKey:@"CheckExistingPatientResult"]objectForKey:@"Error"]);
                     
                     if ([[[responseObject objectForKey:@"CheckExistingPatientResult"]objectForKey:@"Error"]isEqualToString:@"1"])
                     {
                         
                         [self showError:[[responseObject objectForKey:@"CheckExistingPatientResult"]objectForKey:@"ErrorMessage"]];
                     }
                     else
                     {
                         [[NSUserDefaults standardUserDefaults] setValue: [[responseObject objectForKey:@"CheckExistingPatientResult"]objectForKey:@"Username"] forKey: USERNAME_SETTING_KEY];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         
                         [[NSUserDefaults standardUserDefaults] setValue: [[responseObject objectForKey:@"CheckExistingPatientResult"]objectForKey:@"Password"] forKey: PASSWORD_SETTING_KEY];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         
                         // store exp
                         //alpha numeric
                         NSLog(@"lenght = %d",[[[responseObject objectForKey:@"CheckExistingPatientResult"]objectForKey:@"AlphaNumericRegEx"] length]);
                         if ([[[responseObject objectForKey:@"CheckExistingPatientResult"]objectForKey:@"AlphaNumericRegEx"]length]>0)
                         {
                             [[NSUserDefaults standardUserDefaults] setValue: [[responseObject objectForKey:@"CheckExistingPatientResult"]objectForKey:@"AlphaNumericRegEx"] forKey: ALFTA_NUMERIC_EXP];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             [[NSUserDefaults standardUserDefaults] setValue: [[responseObject objectForKey:@"CheckExistingPatientResult"]objectForKey:@"AlphaNumericMsg"] forKey: ALFTA_NUMERIC_EXP_MSG];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                         }
                         //compex charcter
                         if ([[[responseObject objectForKey:@"CheckExistingPatientResult"]objectForKey:@"ComplexCharRegEx"]length]>0)
                         {
                             [[NSUserDefaults standardUserDefaults] setValue: [[responseObject objectForKey:@"CheckExistingPatientResult"]objectForKey:@"ComplexCharRegEx"] forKey: COMPLEX_EXP];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             [[NSUserDefaults standardUserDefaults] setValue: [[responseObject objectForKey:@"CheckExistingPatientResult"]objectForKey:@"ComplexCharMsg"] forKey: COMPLEX_EXP_MSG];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                         }
                         //password length
                         if ([[[responseObject objectForKey:@"CheckExistingPatientResult"]objectForKey:@"PasscodeLengthRegEx"]length]>0)
                         {
                             [[NSUserDefaults standardUserDefaults] setValue: [[responseObject objectForKey:@"CheckExistingPatientResult"]objectForKey:@"PasscodeLengthRegEx"] forKey: PASS_LENGTH_EXP];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             [[NSUserDefaults standardUserDefaults] setValue: [[responseObject objectForKey:@"CheckExistingPatientResult"]objectForKey:@"PasscodeLengthMsg"] forKey: PASS_LENGTH_EXP_MSG];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                         }
                         
                         
                         ConfirmPassViewController * cofirm = [[ConfirmPassViewController alloc]init];
                         [self.navigationController pushViewController:cofirm animated:YES];
                        //[Settings shared].account = account.text;
                         // NSLog(@"user name get resp = %@",[[responseObject objectForKey:@"CheckExistingPatientResult"]objectForKey:@"Username"]);
                         //[Settings shared].username = [[responseObject objectForKey:@"CheckExistingPatientResult"]objectForKey:@"Username"];
                        // [Settings shared].password = [[responseObject objectForKey:@"CheckExistingPatientResult"]objectForKey:@"Password"];
                        // NSLog(@"now new user name = %@",[Settings shared].username);
                        // NSLog(@"now new passworde = %@",[Settings shared].password);
                         
                         
                        // [self confirm_password];
                     }
                     [self showLoading:NO];
                     
                 }
                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
                 {
                     NSLog(@"ERR: %@",error.description);
                     [self showLoading:NO];
                     //  block(error);
                 }];
            }//akhil 19-12-13*/
        }
        else
        {
            // SignUp
            
            if (![loginField.text length])
                [self showError:@"Please enter username"];
            else if (![loginField.text length])
                [self showError:@"Please enter password"];
            else if (![nameFirstField.text length])
                [self showError:@"Please enter first name"];
            else if (![nameLastField.text length])
                [self showError:@"Please enter last name"];
            else
            {
                COPDUser *user = [COPDUser user];
                user.username = loginField.text;
                user.password = passwdField.text;
                [user setObject:nameFirstField.text forKey:@"FirstName"];
                [user setObject:nameLastField.text forKey:@"LastName"];
                //if ([self.maleCell isSelected])
                if (male==TRUE)
                {
                    [user setObject:@"M" forKey:@"Gender"];
                }
                else
                {
                    [user setObject:@"F" forKey:@"Gender"];
                }
                
                NSDate * date = [self.dateFormatter dateFromString: self.birthDayCell.detailTextLabel.text];
                
                
                
                NSDateFormatter * df = [[[NSDateFormatter alloc] init] autorelease];
                [df setDateFormat: @"yyyy-MM-dd"];
                NSString * birthDate = [df stringFromDate: date];
                
                [user setObject: birthDate forKey:@"DOB"];
                
                [self showLoading: YES];
                [user signUpInBackgroundWithTarget:self selector:@selector(signupFinished:error:)];
                
            }
        }
    }
    
    
    
    /*if (!signupMode)
     {
     // Login
     if (![loginField.text length])
     [self showError:@"Please enter username"];
     else if (![passwdField.text length])
     [self showError:@"Please enter password"];
     else
     {
     [self showLoading: YES];
     [PFUser logInWithUsernameInBackground:loginField.text password:passwdField.text target:self selector:@selector(loginFinished:error:)];
     }
     }
     else
     {
     // SignUp
     
     if (![loginField.text length])
     [self showError:@"Please enter username"];
     else if (![loginField.text length])
     [self showError:@"Please enter password"];
     else if (![nameFirstField.text length])
     [self showError:@"Please enter first name"];
     else if (![nameLastField.text length])
     [self showError:@"Please enter last name"];
     else
     {
     [Content shared].user = [PFUser user];
     [Content shared].user.username = loginField.text;
     [Content shared].user.password = passwdField.text;
     [[Content shared].user setObject:nameFirstField.text forKey:@"firstName"];
     [[Content shared].user setObject:nameLastField.text forKey:@"lastName"];
     [[Content shared].user setObject:@"patient" forKey:@"role"];
     
     NSDate * date = [self.dateFormatter dateFromString: self.birthDayCell.detailTextLabel.text];
     
     
     
     NSDateFormatter * df = [[[NSDateFormatter alloc] init] autorelease];
     [df setDateFormat: @"yyyy-MM-dd"];
     NSString * birthDate = [df stringFromDate: date];
     
     
     
     [[Content shared].user setObject: birthDate forKey:@"birthDate"];
     [self showLoading: YES];
     [[Content shared].user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
     [self showLoading: NO];
     
     [loginField resignFirstResponder];
     [passwdField resignFirstResponder];
     [nameFirstField resignFirstResponder];
     [nameLastField resignFirstResponder];
     [self doneAction: nil];
     
     signupMode = !signupMode;
     
     [self updateUIMode];
     
     if (!succeeded)
     {
     [self showError:@"Unable to signup"];
     }
     else
     {
     PFObject * info = [PFObject objectWithClassName: @"PatientInfo"];
     [info setObject: birthDate forKey: @"birthDate"];
     [info setObject: nameFirstField.text forKey:@"firstName"];
     [info setObject: nameLastField.text forKey:@"lastName"];
     [info setObject: [Content shared].user.objectId forKey: @"userId"];
     [info saveInBackground];
     }
     }];
     }
     }*/
    
}

- (void)signupFinished:(COPDUser*)user error:(NSError**)error
{
    [self showLoading: NO];
    if (user)
    {
		[self showError:@"Sign up was successfull. Please login"];
		
		[loginField resignFirstResponder];
        [passwdField resignFirstResponder];
        [nameFirstField resignFirstResponder];
        [nameLastField resignFirstResponder];
        [self doneAction: nil];
        
        signupMode = !signupMode;
        //[self updateUIMode];
		loginField.text = user.username;
		passwdField.text = user.password;
    }
    else
    {
        [self showError:@"Unable to signup"];
    }
}

- (void)loginClicked:(UIButton*)sender
{
    [self login];
}

//2014-01-20 Vipul ITAD 2.6
- (void)CancelClicked:(UIButton*)sender
{
    //LoginViewController *LoginView = [[[LoginViewController alloc] init] autorelease];
    //akhil 16-2-15
    //ios update
    LoginViewController *vc;
    
    if ([UIDevice currentDevice].userInterfaceIdiom ==UIUserInterfaceIdiomPhone )
    {
        vc = [[[LoginViewController alloc] initWithNibName:@"View" bundle:nil] autorelease];
    }
    else
    {
        //vc = [[[LoginViewController alloc] init] autorelease];
        vc = [[[LoginViewController alloc] initWithNibName:@"Login" bundle:nil] autorelease];
        
    }
    //akhil 16-2-15
    //ios update
	[self.navigationController pushViewController:vc animated:YES];
}
//2014-01-20 Vipul ITAD 2.6

/*- (void)handleLogoLongPress:(UILongPressGestureRecognizer *)g
{
    if (g.state == UIGestureRecognizerStateBegan)
    {
        loginField.text = @"";
        passwdField.text = @"";
        [loginField resignFirstResponder];
        [passwdField resignFirstResponder];
        [nameFirstField resignFirstResponder];
        [nameLastField resignFirstResponder];
        [self doneAction: nil];
        signupMode = !signupMode;
 
        [self updateUIMode];
        
    }
}*/

/*- (void)handleLogoTap:(UITapGestureRecognizer *) g
{
    loginField.text = @"";
    passwdField.text = @"";
}*/
- (void)presentMainScreen
{
    [[Content shared] handleLogin];
    
    
    MainViewController * vc  = [[[MainViewController alloc] init] autorelease];
    
    UINavigationController * nc = [[[UINavigationController alloc] initWithRootViewController: vc] autorelease];
    nc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController: nc animated: YES];
}

//- (void)loginFinished:(PFUser*)u error:(NSError**)error
- (void)loginFinished:(COPDUser*)u error:(NSError**)error
{
	/*[self showLoading: NO];
     if (u)
     {
     if (![u objectForKey:@"role"] || ![[NSString stringWithString:@"patient"] isEqualToString:[u objectForKey:@"role"]])
     {
     [self showError:@"User Type Error: You must be a patient to log in to this app"];
     return;
     }
     [Content shared].user = u;
     [self presentMainScreen];
     }
     else
     {
     if ([self isInternetConnection])
     {
     [self showError:@"Incorrect username or password"];
     }
     else
     {
     [self showError:@"No Internet Connection. Please make sure you are connected to the Internet via WiFi or 3G."];
     }
     }*/
    [self showLoading: NO];
    if (u)
    {
        //[Content shared].user = u;
        [Content shared].copdUser = u;
        [self presentMainScreen];
    }
    else
    {
        [self showError:@"Incorrect username or password"];
    }
}

-(BOOL)isInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}


- (void)showError:(NSString*)error
{
    TSAlertView* alert =
    [[[TSAlertView alloc] initWithTitle:@"DocView iT3"
                                message:error
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] autorelease];
    
    [alert show];
}



- (NSString*)getLogin
{
    return loginField.text;
}

- (NSString*)getPassword
{
    return passwdField.text;
}

- (int)getTempIndex
{
    return tempIndex;
}
#pragma mark - UITectFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   /* if (textField == loginField)
        [passwdField becomeFirstResponder];
    else if (textField == passwdField)
        [self login];*/
    
    //akhil 11-12-13
    if (textField == loginField)
        [passwdField becomeFirstResponder];
    else if (textField == passwdField)
        [nameFirstField becomeFirstResponder];
    else if (textField == nameFirstField)
        [nameFirstField resignFirstResponder];
    
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self doneAction: nil];
    return YES;
}



#pragma amrk - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*if (section == 0)
        return 2;
    if (section == 1)
        return 2;
    if (section == 2)
        return 2;
    if (section == 3)
        return 1;
    
    return 0;*/
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? (IS_IPHONE)?55:70 : 0;
    // return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == (signupMode ? 3 : 0))
        //2014-01-20 Vipul ITAD 2.6
        //return 80;
        return 150;
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? headerView : nil;
} 

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == (signupMode ? 3 : 0))
        return footerView;
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        //return (indexPath.row == 0) ? loginCell : passwdCell;
        //akhil 11-12-13
       /* return self.loginCell;
        return self.passwdCell;
        return self.nameFirstCell;*/
        if (indexPath.row==0)
        {
           // self.loginCell.contentView.layer.cornerRadius=50;
           // cell.contentView.layer.cornerRadius = 10.0f;
            return self.loginCell;
        }
        else if(indexPath.row==1)
        {
            return self.passwdCell;

        }
        else if(indexPath.row==2)
        {
            return self.nameFirstCell;
            
        }else if(indexPath.row==3)
        {
            return self.birthDayCell;
            
        }
    }
    else if (indexPath.section == 1)
        return (indexPath.row == 0) ? nameFirstCell : nameLastCell;
    else if (indexPath.section == 2)
    {
        maleCell.accessoryType = male ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        femaleCell.accessoryType = !male ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        
        return (indexPath.row == 0) ? maleCell : femaleCell;
    }
    else if (indexPath.section == 3)
    {
        return self.birthDayCell;
    }
    
    return nil;
}

- (void)slideDownDidStop
{
	// the date picker has finished sliding downwards, so remove it
	[self.pickerView removeFromSuperview];
}

- (void)dateAction:(id)sender
{
	birthDayCell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.pickerView.date];
}

- (void)doneAction:(id)sender
{
    if (self.pickerView.superview == nil)
    {
        return;
    }
    
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect endFrame = self.pickerView.frame;
	endFrame.origin.y = screenRect.origin.y + screenRect.size.height;
	
	// start the slide down animation
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
	
    // we need to perform some post operations after the animation is complete
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
	
    self.pickerView.frame = endFrame;
	[UIView commitAnimations];
	
	// grow the table back again in vertical size to make room for the date picker
	CGRect newFrame = fieldsTable.frame;
	newFrame.size.height += self.pickerView.frame.size.height;
	fieldsTable.frame = newFrame;
	
	// remove the "Done" button in the nav bar
	self.navigationItem.rightBarButtonItem = nil;
	
	// deselect the current table row
	NSIndexPath *indexPath = [fieldsTable indexPathForSelectedRow];
	[fieldsTable deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showPicker
{
    [loginField resignFirstResponder];
    [passwdField resignFirstResponder];
    [nameFirstField resignFirstResponder];
    [nameLastField resignFirstResponder];
    
	self.pickerView.date = [self.dateFormatter dateFromString: self.birthDayCell.detailTextLabel.text];
	
	// check if our date picker is already on screen
	if (self.pickerView.superview == nil)
	{
		/*[self.view.window addSubview: self.pickerView];
		
		// size up the picker view to our screen and compute the start/end frame origin for our slide up animation
		//
		// compute the start frame
		CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
		CGSize pickerSize = [self.pickerView sizeThatFits:CGSizeZero];
		CGRect startRect = CGRectMake(0.0,
									  screenRect.origin.y + screenRect.size.height,
									  pickerSize.width, pickerSize.height);
		self.pickerView.frame = startRect;
		
		// compute the end frame
		CGRect pickerRect = CGRectMake(0.0,
									   screenRect.origin.y + screenRect.size.height - pickerSize.height,
									   pickerSize.width,
									   pickerSize.height);
		// start the slide up animation
		[UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
		
        // we need to perform some post operations after the animation is complete
        [UIView setAnimationDelegate:self];
		
        self.pickerView.frame = pickerRect;
		
        // shrink the table vertical size to make room for the date picker
        CGRect newFrame = fieldsTable.frame;
        newFrame.size.height -= self.pickerView.frame.size.height;
        fieldsTable.frame = newFrame;
		[UIView commitAnimations];
		
		// add the "Done" button to the nav bar
		self.navigationItem.rightBarButtonItem = self.doneButton;*/
        
        //akhil 26-12-13
        
        UIViewController* popoverContent = [[UIViewController alloc] init];
        
        UIView *popoverView = [[UIView alloc] init];
       // popoverView.backgroundColor = [UIColor whiteColor];
        //akhil 27-1-15
        //IOS Upgradation
      /*  if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1){
            if(IS_IPHONE_4_OR_LESS)
            {
                popoverView.backgroundColor = [UIColor clearColor];
            }
            else
            {
                popoverView.backgroundColor = [UIColor clearColor];
            }
            
        }
        else
        {
            if(IS_IPHONE_4_OR_LESS)
            {
                popoverView.backgroundColor = [UIColor blackColor];
            }
            else
            {
                popoverView.backgroundColor = [UIColor blackColor];
            }
        }*/
         popoverView.backgroundColor = [UIColor blackColor];
        //akhil 27-1-15
        //IOS Upgradation

        
        //UIDatePicker *datePicker=[[UIDatePicker alloc]init];
        pickerView.frame=CGRectMake(0,0,320, 216);
        [popoverView addSubview:pickerView];
        
        popoverContent.view = popoverView;
        popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        popoverController.delegate=self;
        [popoverContent release];
        
        [popoverController setPopoverContentSize:CGSizeMake(320, 216) animated:NO];
        
        //akhil 27-1-15
        //IOS Upgradation
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
        {
            [popoverController presentPopoverFromRect:CGRectMake(225, 420, 320, 216) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
        else
        {
            [popoverController presentPopoverFromRect:CGRectMake(225, 370, 320, 216) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
        //akhil 27-1-15
        //IOS Upgradation

       // [popoverController setPopoverContentSize:CGSizeMake(320, 216) animated:NO];
       // [popoverController presentPopoverFromRect:CGRectMake(225, 175, 320, 216) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        //akhil 26-12-13

	}
}
 //akhil 26-12-13
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController1
{
    NSLog(@"call success");
    [popoverController autorelease];
    popoverController = nil;
    [pickerView removeFromSuperview];
    [self birthdaycell_disselect];
}
-(void)birthdaycell_disselect
{
    NSIndexPath *indexPath = [fieldsTable indexPathForSelectedRow];
	[fieldsTable deselectRowAtIndexPath:indexPath animated:YES];
}
 //akhil 26-12-13


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            /*if (indexPath.row == 0)
                [loginField becomeFirstResponder];
            else
                [passwdField becomeFirstResponder];
            
            [self doneAction: nil];*/
            //akhil 11-12-13
            if (indexPath.row == 0)
            {
                [nameFirstField becomeFirstResponder];
            }
            else if(indexPath.row==1)
            {
               [nameLastField becomeFirstResponder];
            }
            else if(indexPath.row==2)
            {
                [nameLastField becomeFirstResponder];
            }
            else if(indexPath.row==3)
            {
                [self showPicker];
            }
            break;
            
        case 1:
            if (indexPath.row == 0)
                [nameFirstField becomeFirstResponder];
            else
                [nameLastField becomeFirstResponder];
            [self doneAction: nil];
            break;
            
        case 2:
            male = (indexPath.row == 0);
            
            maleCell.accessoryType = male ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            femaleCell.accessoryType = !male ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            break;
            
        case 3:
        {
            [self showPicker];
        }
            break;
    }
}

- (void)keyboardWillShow:(NSNotification *)n
{
    CGFloat keyboardHeight = [[[n userInfo] valueForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    
    [UIView beginAnimations: nil context:nil];
    [UIView setAnimationCurve:[[[n userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationDuration:[[[n userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    
    //fieldsTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - keyboardHeight);
   //  fieldsTable.frame = CGRectMake(40, 80, 690, self.view.frame.size.height - keyboardHeight);
    
    if(IS_IPHONE_4_OR_LESS)
    {
        // fieldsTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height- keyboardHeight);
       // fieldsTable.frame = CGRectMake(0, 60, 320, self.view.frame.size.height - keyboardHeight);
        
    }
    else if (IS_IPHONE_5)
    {
        //fieldsTable.frame = CGRectMake(0, 65, 320, 500 - keyboardHeight);
        
    }
    
    else
    {
          fieldsTable.frame = CGRectMake(70, 80, 630, self.view.frame.size.height - keyboardHeight);
       // fieldsTable.frame = CGRectMake(70, 80, 630, self.view.frame.size.height - keyboardHeight);
        //  fieldsTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - keyboardHeight);
    }

    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *) n
{
    CGFloat keyboardHeight = 0;
    
    [UIView beginAnimations: nil context:nil];
    [UIView setAnimationCurve:[[[n userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationDuration:[[[n userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    
    //fieldsTable.frame = CGRectMake(0, 0, 320,  self.view.frame.size.height - keyboardHeight);
     //fieldsTable.frame = CGRectMake(40, 80, 690, self.view.frame.size.height - keyboardHeight);
    
    if(IS_IPHONE_4_OR_LESS)
    {
       // fieldsTable.frame = CGRectMake(0, 60, 320, self.view.frame.size.height - keyboardHeight);
        
    }
    else if (IS_IPHONE_5)
    {
        //fieldsTable.frame = CGRectMake(0, 60, 320, self.view.frame.size.height - keyboardHeight);
        
    }
    else
    {
        fieldsTable.frame = CGRectMake(70, 80, 630, self.view.frame.size.height - keyboardHeight);
       // fieldsTable.frame = CGRectMake(70, 80, 630, self.view.frame.size.height - keyboardHeight);
    }

    
    [UIView commitAnimations];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
