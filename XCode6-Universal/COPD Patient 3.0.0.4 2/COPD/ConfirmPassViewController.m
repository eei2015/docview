//
//  ConfirmPassViewController.m
//  COPD
//
//  Created by Akhil on 12/12/13.
//  Copyright (c) 2013 TKInteractive. All rights reserved.
//

#import "ConfirmPassViewController.h"

#import "Content.h"
#import "UIViewController+Branding.h"
#import "MainViewController.h"
#import "QuestionsViewController.h"
#import <Bully/Bully.h>
#import "AFNetworking.h"
#import "Reachability.h"
#import "Crittercism.h"


#if COPD
#import "InAppBrowserController.h"
#else
#import "HelpViewController.h"
#endif

#define CHECK_NEW_PASSWORD			@"ResetPatientPassword"///%@
#import "SBJson.h"

@interface ConfirmPassViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, TSAlertViewDelegate>
@property (nonatomic, retain) UITableView* fieldsTable;
@property (nonatomic, retain) UITableViewCell* loginCell;
@property (nonatomic, retain) UITableViewCell* passwdCell;
@property (nonatomic, retain) UITextField* loginField;
@property (nonatomic, retain) UITextField* passwdField;

- (void)login;
- (void)loginFinished:(COPDUser*)user error:(NSError**)error;
//- (void)signupFinished:(COPDUser*)user error:(NSError**)error;
- (void)showError:(NSString*)error;
//- (void)updateUIMode;
//- (void)doneAction:(id)sender;
-(BOOL)isInternetConnection;
@end

@implementation ConfirmPassViewController

@synthesize fieldsTable,loginField,passwdField,passwdCell,loginCell;
- (void)dealloc
{
    [fieldsTable release];
    [loginCell release];
    [passwdCell release];
    //[nameFirstCell release];
    //[nameLastCell release];
   // [maleCell release];
    //[femaleCell release];
  //  [birthDayCell release];
    
    [loginField release];
    [passwdField release];
   // [nameFirstField release];
   // [nameLastField release];
    
    [footerView release];
   // [dateFormatter release];
    [super dealloc];
}

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
    [self loadBrandingViews];
    
    //akhil 8-1-14
    self.navigationItem.hidesBackButton = YES;
   /* self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];*/
    
  /*  UILongPressGestureRecognizer * lp = [[[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(handleLogoLongPress:)] autorelease];
    [self.navigationItem.titleView addGestureRecognizer: lp];
    UITapGestureRecognizer * tg = [[[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleLogoTap:)] autorelease];
    [self.navigationItem.titleView addGestureRecognizer: tg];
    */
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle: @"Help" style: UIBarButtonItemStyleBordered target: self action: @selector(helpClicked)] autorelease];
    
    //akhil 11-12-13
    
    //self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle: @"TEST" style: UIBarButtonItemStyleBordered target: self action: @selector(testClicked)] autorelease];
    
    //akhil 23-2-15
    //ios update remwove above space on table view
    
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //akhil 23-2-15
    //ios update remwove above space on table view

    
    headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    //UILabel* l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 300, 30)] autorelease];
    //UILabel* l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 0, 580, 30)] autorelease];
    

    
    //akhil 4-2-15
    //IOS Upgradation
    UILabel* l = [[[UILabel alloc] init] autorelease];

    /*if(IS_IPHONE_4_OR_LESS)
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:12];
        //l.layer.borderWidth=1;
        
    }
    else if (IS_IPHONE_5)
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:12];
        //l.layer.borderWidth=1;
        
    }
    
    else
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 580, 60)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:25];
        //l.layer.borderWidth = 1;
    }*/
    if(IS_IPHONE_4_OR_LESS)
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:17];
        //l.layer.borderWidth=1;
        
        
    }
    else if (IS_IPHONE_5)
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:17];
        // l.layer.borderWidth=1;
        
    }
    
    else
    {
        //l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 0, 450, 30)] autorelease];
        l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 0, 450, 30)] autorelease];
        
        l.font = [UIFont boldSystemFontOfSize:34];
    }

    //}
    //akhil 4-2-15
    //IOS Upgradation

   // l.font = [UIFont boldSystemFontOfSize:34];
    //l.layer.borderWidth=1;
    l.backgroundColor = [UIColor clearColor];
    l.textColor = [UIColor whiteColor];
    l.shadowColor = [UIColor blackColor];
    l.shadowOffset = CGSizeMake(0, 1);
    
    l.text = @"Welcome to DocView iT3";
    
    [headerView addSubview:l];
    
  //  self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(150, 11, 150, 24)] autorelease];
    //self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(290, 11, 320, 42)] autorelease];

   /* loginField.delegate = self;
    loginField.layer.borderWidth = 1;
    loginField.placeholder = @"Enter New Password";
    [loginField setFont:[UIFont systemFontOfSize:14]];

    loginField.borderStyle = UITextBorderStyleNone;
    loginField.spellCheckingType = UITextSpellCheckingTypeNo;
    loginField.autocorrectionType = UITextAutocorrectionTypeNo;
    loginField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    loginField.text = [[NSUserDefaults standardUserDefaults] valueForKey: USERNAME_SETTING_KEY];
    [loginField addTarget: self action: @selector(loginFieldEditingChanged) forControlEvents: UIControlEventEditingChanged];*/
    loginField.delegate = self;
   // loginField.layer.borderWidth=1;
    
    //akhil 4-2-15
    //IOS Upgradation
    /*if(IS_IPHONE_4_OR_LESS)
    {
        self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
        loginField.font = [UIFont systemFontOfSize:12];
        
    }
    else if (IS_IPHONE_5)
    {
        self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
        loginField.font = [UIFont systemFontOfSize:12];
    }
    else
    {
        self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(240, 11, 370, 42)] autorelease];
        loginField.font = [UIFont systemFontOfSize:28];
    }*/
    //akhil 12-2-15
    if (IS_IPHONE_4_OR_LESS||IS_IPHONE_5)
    {
        self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, self.view.frame.size.width-180, 24)] autorelease];
        loginField.font = [UIFont systemFontOfSize:14];
        
        [self.loginField setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    }
    //akhil 12-2-15
    else
    {
        self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(240, 11, 370, 42)] autorelease];
        loginField.font = [UIFont systemFontOfSize:34];
    }
    
    self.loginField.layer.borderWidth = 1;
    //}
    //akhil 4-2-15
    //IOS Upgradation

    loginField.secureTextEntry = YES;
    [loginField setPlaceholder:@"Enter New Password"];
    //[loginField setFont:[UIFont systemFontOfSize:28]];
    
    loginField.borderStyle = UITextBorderStyleNone;

    
   // self.passwdField = [[[UITextField alloc] initWithFrame:CGRectMake(150, 11, 150, 24)] autorelease];
   //self.passwdField = [[[UITextField alloc] initWithFrame:CGRectMake(290, 11, 320, 42)] autorelease];
    passwdField.delegate = self;
   // passwdField.layer.borderWidth=1;
    
    //akhil 4-2-15
    //IOS Upgradation
    /*if(IS_IPHONE_4_OR_LESS)
    {
        self.passwdField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
        passwdField.font = [UIFont systemFontOfSize:12];
        
    }
    else if (IS_IPHONE_5)
    {
        self.passwdField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
        passwdField.font = [UIFont systemFontOfSize:12];
        
    }
    else
    {
        self.passwdField = [[[UITextField alloc] initWithFrame:CGRectMake(290, 11, 320, 42)] autorelease];
        passwdField.font = [UIFont systemFontOfSize:28];
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
    self.passwdField.layer.borderWidth=1;

    //akhil 4-2-15
    //IOS Upgradation

    passwdField.secureTextEntry = YES;
   // [passwdField setFont:[UIFont systemFontOfSize:28]];
    passwdField.borderStyle = UITextBorderStyleNone;
    
    /*self.nameFirstField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
    nameFirstField.delegate = self;
    nameFirstField.borderStyle = UITextBorderStyleNone;
    
    self.nameLastField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
    nameLastField.delegate = self;
    nameLastField.borderStyle = UITextBorderStyleNone;
    */
    
    
    self.loginCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"login"] autorelease];
    
    loginCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 125, 42)] autorelease];
   // l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 1, 230, 57)] autorelease];
    
    //akhil 4-2-15
    //IOS Upgradation
    if(IS_IPHONE_4_OR_LESS)
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 90, 42)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:11];
    }
    else if (IS_IPHONE_5)
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 90, 42)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:11];
    }
    else
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 1, 180, 57)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:25];
    }
  
    //akhil 4-2-15
    //IOS Upgradation

    l.text = @"New Password";
  //  l.font = [UIFont boldSystemFontOfSize:25];
    [loginCell addSubview:l];
    [loginCell addSubview:loginField];
    
    //self.loginCell.layer.borderWidth = 2;
    
    self.passwdCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"passwd"] autorelease];
    passwdCell.selectionStyle = UITableViewCellSelectionStyleNone;
   // l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 125, 42)] autorelease];
   //  l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 1, 230, 57)] autorelease];
    
    //akhil 2-2-15
    //IOS Upgradation
    if(IS_IPHONE_4_OR_LESS)
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 90, 42)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:12];
    }
    else if (IS_IPHONE_5)
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 90, 42)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:12];
        
    }
    else
    {
        l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 1, 180, 57)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:25];
    }
    //akhil 2-2-15
    //IOS Upgradation

    l.text = @"Confirm Password";
   // l.font = [UIFont boldSystemFontOfSize:25];
    [passwdCell addSubview:l];
    [passwdCell addSubview:passwdField];
    
    //self.passwdCell.layer.borderWidth = 2;

    
   /* self.nameFirstCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nameFirst"] autorelease];
    nameFirstCell.selectionStyle = UITableViewCellSelectionStyleNone;
    l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 90, 42)] autorelease];
    l.text = @"First Name";
    l.font = [UIFont boldSystemFontOfSize:17];
    [nameFirstCell addSubview:l];
    [nameFirstCell addSubview:nameFirstField];*/
    
   /* self.nameLastCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nameLast"] autorelease];
    nameLastCell.selectionStyle = UITableViewCellSelectionStyleNone;
    l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 90, 42)] autorelease];
    l.text = @"Last Name";
    l.font = [UIFont boldSystemFontOfSize:17];
    [nameLastCell addSubview:l];
    [nameLastCell addSubview:nameLastField];
    
    self.maleCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"male"] autorelease];
    maleCell.textLabel.text = @"Male";
    
    self.femaleCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"female"] autorelease];
    femaleCell.textLabel.text = @"Female";
    
    
    self.birthDayCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: nil] autorelease];
	self.birthDayCell.textLabel.text = @"Birthday";
	self.birthDayCell.detailTextLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
    
    
    self.pickerView = [[[UIDatePicker alloc] initWithFrame: CGRectZero] autorelease];
    self.pickerView.datePickerMode = UIDatePickerModeDate;
    [self.pickerView addTarget: self action: @selector(dateAction:) forControlEvents: UIControlEventValueChanged];
    [self.pickerView sizeToFit];
    
    self.doneButton = [[[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleDone target: self action: @selector(doneAction:)] autorelease];
    */
    self.fieldsTable = [[[UITableView alloc] initWithFrame: self.view.bounds style:UITableViewStyleGrouped] autorelease];
   // self.fieldsTable = [[[UITableView alloc]initWithFrame:CGRectMake(40, 80, 690, 700) style:UITableViewStyleGrouped]autorelease];
    
    //akhil 4-2-15
    //IOS Upgradation
    if(IS_IPHONE_4_OR_LESS)
    {
        //self.fieldsTable = [[[UITableView alloc]initWithFrame:CGRectMake(0, 60, 320, 460) style:UITableViewStyleGrouped]autorelease];
    }
    else if (IS_IPHONE_5)
    {
        //self.fieldsTable = [[[UITableView alloc]initWithFrame:CGRectMake(0, 65, 320, 500) style:UITableViewStyleGrouped]autorelease];
        
    }
    else
    {
       // self.fieldsTable = [[[UITableView alloc]initWithFrame:CGRectMake(70, 80, 630, 700) style:UITableViewStyleGrouped]autorelease];
        
    }
    //akhil 4-2-15
    //IOS Upgradation

    fieldsTable.backgroundColor = nil;
    fieldsTable.backgroundView = nil;
    fieldsTable.scrollEnabled = NO;
    fieldsTable.delegate = self;
    fieldsTable.dataSource = self;
    // fieldsTable.rowHeight = 59;
    
    //akhil 4-2-15
     //IOS Upgradation
    if ([UIDevice currentDevice ].userInterfaceIdiom==UIUserInterfaceIdiomPad )
    {
        fieldsTable.rowHeight = 59;
    }
    else
    {
        fieldsTable.rowHeight = 40;
        
    }
    //akhil 4-2-15
     //IOS Upgradation

    
    //akhil
    //fieldsTable.layer.borderWidth = 3;
    
   // fieldsTable.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:fieldsTable];
    
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
    //loginButton.titleLabel.font = [UIFont boldSystemFontOfSize: 36];
    //loginButton.center = CGPointMake(self.view.frame.size.width/2, 40);
    //loginButton.frame = CGRectMake(70, 90, 610, 60);
     //loginButton.center = CGPointMake((self.view.frame.size.width/2)-40, 40);
    //akhil 2-2-15
    //IOS Upgradation
    
   /* if(IS_IPHONE_4_OR_LESS)
    {
        loginButton.center = CGPointMake(self.view.frame.size.width/2, 40);
        loginButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
    }
    else if (IS_IPHONE_5)
    {
        loginButton.center = CGPointMake(self.view.frame.size.width/2, 40);
        loginButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
    }
    else
    {
        loginButton.frame = CGRectMake(60, 90, 610, 60);
        loginButton.center = CGPointMake((self.view.frame.size.width/2)-70, 40);
        loginButton.titleLabel.font = [UIFont boldSystemFontOfSize: 36];
    }*/
    if(IS_IPHONE_4_OR_LESS)
    {
        // loginButton.center = CGPointMake(self.view.frame.size.width/2, 40);
        loginButton.center = CGPointMake(0, 40);
        loginButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
        [loginButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        
    }
    else if (IS_IPHONE_5)
    {
        // loginButton.center = CGPointMake(self.view.frame.size.width/2, 40);
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
    loginButton.layer.borderWidth=1;

    //}
    //akhil 2-2-15
    //IOS Upgradation

   

    
    activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray] autorelease];
    activityIndicatorView.center = CGPointMake(loginButton.frame.size.width - 20, loginButton.frame.size.height/2+1);
    [loginButton addSubview: activityIndicatorView];
    
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
    //CancelButton.titleLabel.font = [UIFont boldSystemFontOfSize: 36];
    // loginButton.center = CGPointMake(self.view.frame.size.width/2, 40);
    //CancelButton.frame = CGRectMake(70, 160, 610, 60);
   // CancelButton.center = CGPointMake((self.view.frame.size.width/2)-40, 110);
    //2014-01-20 Vipul ITAD 2.6
    
    //akhil 4-2-15
    //IOS Upgradation
   /* if(IS_IPHONE_4_OR_LESS)
    {
        CancelButton.center = CGPointMake(self.view.frame.size.width/2, 40);
        CancelButton.frame = CGRectMake(CancelButton.frame.origin.x, CancelButton.frame.origin.y+50, CancelButton.frame.size.width, CancelButton.frame.size.height);
        CancelButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
    }
    else if (IS_IPHONE_5)
    {
        CancelButton.center = CGPointMake(self.view.frame.size.width/2, 40);
        CancelButton.frame = CGRectMake(CancelButton.frame.origin.x, CancelButton.frame.origin.y+50, CancelButton.frame.size.width, CancelButton.frame.size.height);
        CancelButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
    }
    else
    {
        CancelButton.frame = CGRectMake(70, 90, 610, 60);
        CancelButton.center = CGPointMake((self.view.frame.size.width/2)-70, 120);
        CancelButton.titleLabel.font = [UIFont boldSystemFontOfSize: 36];
    }*/
    
    if(IS_IPHONE_4_OR_LESS)
    {
        // forget_password.center = CGPointMake(self.view.frame.size.width/2, 40);
        //  forget_password.frame = CGRectMake(forget_password.frame.origin.x, forget_password.frame.origin.y+50, forget_password.frame.size.width, forget_password.frame.size.height);
        CancelButton.center = CGPointMake(0, 90);
        CancelButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
        [CancelButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        
    }
    else if (IS_IPHONE_5)
    {
        // forget_password.center = CGPointMake(self.view.frame.size.width/2, 40);
        //forget_password.frame = CGRectMake(forget_password.frame.origin.x, forget_password.frame.origin.y+70, forget_password.frame.size.width, forget_password.frame.size.height);
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
    CancelButton.layer.borderWidth = 1;
    //akhil 4-2-15
    //IOS Upgradation

    
    UIImageView * logos = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"login-logos.png"]] autorelease];
    
    logos.frame = CGRectMake(0, 77, logos.frame.size.width, logos.frame.size.height);
    [footerView addSubview: logos];
    [footerView addSubview:loginButton];
    
    //2014-01-20 Vipul ITAD 2.6
    [footerView addSubview:CancelButton];
    //2014-01-20 Vipul ITAD 2.6
    
    tempIndex = 0;
    signupMode = NO;
   // male = YES;
    [self updateUIMode];
    
    
    
    
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

    footerLabel.backgroundColor = [UIColor clearColor];
    footerLabel.textColor = [UIColor whiteColor];
   // footerLabel.font = [UIFont boldSystemFontOfSize: 22];
    
    footerLabel.text = [[Content shared] versionString];
    footerLabel.textAlignment = UITextAlignmentCenter;
    fieldsTable.tableFooterView = footerLabel;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
- (void)loginFieldEditingChanged
{
    //[[NSUserDefaults standardUserDefaults] setValue: [loginField.text length] > 0 ? loginField.text : @"" forKey: USERNAME_SETTING_KEY];
    //[[NSUserDefaults standardUserDefaults] synchronize];
}
/*-(void)textFieldDidEndEditing:(UITextField *)textField{
   // int numberofCharacters = 0;
    BOOL alphanumeric,digit,specialCharacter = 0;
    
    
    if([textField.text length] >= 10)
    {
        for (int i = 0; i < [passwdField.text length]; i++)
        {
            unichar c = [passwdField.text characterAtIndex:i];
           
            if(!alphanumeric)
            {
                alphanumeric = [[NSCharacterSet alphanumericCharacterSet] characterIsMember:c];
            }
            if(!digit)
            {
                digit = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
            }
            if(!specialCharacter)
            {
                specialCharacter = [[NSCharacterSet symbolCharacterSet] characterIsMember:c];
            }
        }
        
        if(specialCharacter && digit && alphanumeric)
        {
            //do what u want
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please Ensure that you have at least one lower case letter, one upper case letter, one digit and one special character"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please Enter at least 10 password"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}*/

-(void)validation_for_expression
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey: PASS_LENGTH_EXP]length]>0)
    {
        NSString *emailRegex = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey: PASS_LENGTH_EXP]];
        //[[NSUserDefaults standardUserDefaults] valueForKey: USERNAME_SETTING_KEY]
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if ([emailTest evaluateWithObject: passwdField.text])
        {
            //Matches
            NSLog(@"pass");
            flag_validate=1;
        }
        else
        {
            NSLog(@"fail");
            flag_validate=0;
            str_invalide_msg = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey: PASS_LENGTH_EXP_MSG]];
            NSLog(@"pass lenght = %@",str_invalide_msg);

        }
        
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey: ALFTA_NUMERIC_EXP]length]>0)
        {
            
            if (flag_validate==1)
            {
                NSError *error = NULL;
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[[NSUserDefaults standardUserDefaults] valueForKey: ALFTA_NUMERIC_EXP]
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:&error];
                NSArray *matches = [regex matchesInString:passwdField.text
                                                  options:0
                                                    range:NSMakeRange(0, [passwdField.text length])];
                
                if([matches count] > 0)
                {
                    NSLog(@"pass");
                    flag_validate=1;
                }
                else
                {
                    NSLog(@"fail");
                    flag_validate=0;
                    str_invalide_msg = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey: ALFTA_NUMERIC_EXP_MSG]];
                    NSLog(@"alpha numeric lenght = %@",str_invalide_msg);
                    
                }

               /* NSString *emailRegex = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey: ALFTA_NUMERIC_EXP]];
                //[[NSUserDefaults standardUserDefaults] valueForKey: USERNAME_SETTING_KEY]
                NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
                if ([emailTest evaluateWithObject: passwdField.text])
                {
                    //Matches
                    NSLog(@"pass");
                    flag_validate=1;
                }
                else
                {
                    NSLog(@"fail");
                    flag_validate=0;
                    str_invalide_msg = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey: ALFTA_NUMERIC_EXP_MSG]];
                    NSLog(@"alpha numeric lenght = %@",str_invalide_msg);

                    
                }*/

            }
        }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey: COMPLEX_EXP]length]>0)
    {
        if (flag_validate==1)
        {
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[[NSUserDefaults standardUserDefaults] valueForKey: COMPLEX_EXP]
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:&error];
            NSArray *matches = [regex matchesInString:passwdField.text
                                              options:0
                                                range:NSMakeRange(0, [passwdField.text length])];
            if([matches count] > 0)
            {
                NSLog(@"pass");
                flag_validate=1;
            }
            else
            {
                NSLog(@"fail");
                flag_validate=0;
                str_invalide_msg = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey: COMPLEX_EXP_MSG]];
                NSLog(@"complex error = %@",str_invalide_msg);
                
            }


            /*NSString *emailRegex = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey: COMPLEX_EXP]];
            //[[NSUserDefaults standardUserDefaults] valueForKey: USERNAME_SETTING_KEY]
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
            if ([emailTest evaluateWithObject: passwdField.text])
            {
                //Matches
                NSLog(@"pass");
                flag_validate=1;
            }
            else
            {
                NSLog(@"fail");
                flag_validate=0;
                str_invalide_msg = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey: COMPLEX_EXP_MSG]];
                NSLog(@"complex error = %@",str_invalide_msg);

                
            }*/
            
        }
    }
    
    //NSLog(@"flag of validation we get = %d",flag_validate);
//NSLog(@"msg for error we get = %@",str_invalide_msg);

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
       // [nameFirstField resignFirstResponder];
       // [nameLastField resignFirstResponder];
        if (!signupMode)
        {
            // Login
            if (![loginField.text length])
                [self showError:@"Please enter New Password"];
            else if (![passwdField.text length])
                [self showError:@"Please enter Confirm Password"];
            else if (![loginField.text isEqualToString:passwdField.text])
                [self showError:@"Please enter Both password same"];
           /* else if ([[[NSUserDefaults standardUserDefaults] valueForKey: PASS_LENGTH_EXP] length]>0)
            {
                [[NSUserDefaults standardUserDefaults] setValue: [loginField.text length] > 0 ? loginField.text : @"" forKey: USERNAME_SETTING_KEY];
                
            }*/
            else
            {
                
                [self validation_for_expression];
                if (flag_validate==1)
                {
                    [self showLoading: YES];
                    
                    NSLog(@"txt new pass = %@",loginField.text);
                    NSLog(@"txt con pass = %@",passwdField.text);
                    NSLog(@"default pass = %@",[[NSUserDefaults standardUserDefaults] valueForKey:PASSWORD_SETTING_KEY ]);
                    NSString *strBaseURL=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"BaseUrl"];
                    //NSString *strBaseURL=@"http://203.88.128.134/Demob/hf/docviewservice/IpadServiceData.svc/";
                    // NSString *strBaseURL=@"http://203.88.128.134/Demob/hf/docviewservice/IpadServiceData.svc/";
                    
                    AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:strBaseURL]] autorelease];
                    
                    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey: USERNAME_SETTING_KEY],@"UserName",[[NSUserDefaults standardUserDefaults] valueForKey:PASSWORD_SETTING_KEY ],@"OldPassword",passwdField.text,@"NewPassword",@"Heart Failure",@"DiseaseName", nil];
                    
                    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
                    [client setDefaultHeader:@"Accept" value:@"application/json"];
                    client.parameterEncoding = AFJSONParameterEncoding;
                    
                    NSLog(@"%@",param);
                    //NSString *strError;
                    [client postPath:CHECK_NEW_PASSWORD parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
                     
                     //[client getPath:[NSString stringWithFormat:CHECK_EXIT_PATIENT, param] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
                     {
                         NSLog(@"RES: %@",responseObject);
                         
                         //  NSLog(@"RES: %@",[responseObject objectForKey:@"CheckExistingPatientResult"]);
                         
                         NSLog(@"erroe msg = %@",[[responseObject objectForKey:@"ResetPatientPasswordResult"] objectForKey:@"ErrorMessage"]);
                         NSLog(@"erroe msg = %@",[[responseObject objectForKey:@"ResetPatientPasswordResult"] objectForKey:@"Error"]);
                         //NSLog(@"error = %@",[[responseObject objectForKey:@"CheckExistingPatientResult"]objectForKey:@"Error"]);
                         
                         if ([[[responseObject objectForKey:@"ResetPatientPasswordResult"] objectForKey:@"Error"]isEqualToString:@"1"])
                         {
                             [self showLoading:NO];
                             [self showError:[[responseObject objectForKey:@"ResetPatientPasswordResult"] objectForKey:@"ErrorMessage"]];
                         }
                         else
                         {
                             
                             [[NSUserDefaults standardUserDefaults] setValue: [[responseObject objectForKey:@"ResetPatientPasswordResult"]objectForKey:@"Username"] forKey: USERNAME_SETTING_KEY];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             
                             
                           /*  [COPDUser validatePatient:[[NSUserDefaults standardUserDefaults] valueForKey: USERNAME_SETTING_KEY] password:passwdField.text block:^(NSError *errorOrNil) {
                                 // NSLog(@"NIL %@",errorOrNil);
                                 if (errorOrNil==nil) {
                                     [COPDUser logInWithUsernameInBackground:loginField.text password:passwdField.text target:self selector:@selector(loginFinished:error:)];
                                 } else {
                                     if (errorOrNil.code==-1001) {
                                         [self showError:@"No Internet Connection. Please make sure you are connected to the Internet via WiFi or 3G."];
                                     } else {
                                         if ([[Content shared] isInternetConnection]) {
                                             [self showError:@"Invalid username/password"];
                                         }
                                         else {
                                             [self showError:@"No Internet Connection. Please make sure you are connected to the Internet via WiFi or 3G."];
                                         }
                                         
                                     }
                                     
                                     // [self showError:@"Invalid username/password"];
                                     [self showLoading: NO];
                                 }
                                 
                             }];*/
                            
                             //akhil 8-1-14
                              [self showLoading:NO];
                           //  UIAlertView * alt = [[UIAlertView alloc]initWithTitle:Nil message:[[responseObject objectForKey:@"ResetPatientPasswordResult"]objectForKey:@"ErrorMessage"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
                           //  [alt show];
                             [self navigation_to_login];
                             //ForgetViewController * log_view = [[ForgetViewController alloc]init];
                            // [self.navigationController pushViewController:log_view animated:NO];
                           //  COPDAppDelegate * appDelegate = (COPDAppDelegate *)[UIApplication sharedApplication].delegate;
                            // [appDelegate showLogin];
                             
                            // LoginViewController * vc  = [[[LoginViewController alloc] init] autorelease];
                             
                           //  UINavigationController * nc = [[[UINavigationController alloc] initWithRootViewController: vc] autorelease];
                            // nc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                            //[self presentModalViewController: nc animated: NO];
                         }//else no 6
                         
                     }
                             failure:^(AFHTTPRequestOperation *operation, NSError *error)
                     {
                         NSLog(@"ERR: %@",error.description);
                         //  block(error);
                     }];
                    
                    
                    /// end here

                }
                // not validate some thing
                else
                {
                     [self showError:str_invalide_msg];
                }
                
                                             
            }
        }
        else
        {/*
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
        */}
    }
    
    
    
       
}
-(void)navigation_to_login
{
    LoginViewController * log_view = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:log_view animated:NO];
}
/*- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [self navigation_to_login];
    }
}*/


- (void)signupFinished:(COPDUser*)user error:(NSError**)error
{
    [self showLoading: NO];
    if (user)
    {
		[self showError:@"Sign up was successfull. Please login"];
		
		[loginField resignFirstResponder];
        [passwdField resignFirstResponder];
       // [nameFirstField resignFirstResponder];
      //  [nameLastField resignFirstResponder];
       // [self doneAction: nil];
        
        signupMode = !signupMode;
        [self updateUIMode];
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
	//[self.navigationController pushViewController:LoginView animated:YES];
    
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

}
//2014-01-20 Vipul ITAD 2.6
- (void)updateUIMode
{
    fieldsTable.scrollEnabled = signupMode;
   // [modeButton setTitle:(signupMode ? @"Back" : @"Sign Up") forState:UIControlStateNormal];
    [loginButton setTitle:(signupMode ? @"Sign Up" : @"Submit") forState:UIControlStateNormal];
    
    [passwdField setPlaceholder:(signupMode?@"Min. 6 characters":@"Enter Confirm Password")];
    
    [fieldsTable reloadData];
    
    logoView.hidden = signupMode;
}

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
    if (textField == loginField)
        [passwdField becomeFirstResponder];
    else if (textField == passwdField)
        [self login];
    
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   // [self doneAction: nil];
    return YES;
}



#pragma amrk - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (signupMode ? 4 : 1);
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 2;
    if (section == 1)
        return 2;
    if (section == 2)
        return 2;
    if (section == 3)
        return 1;
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? 40 : 0;
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
        return (indexPath.row == 0) ? loginCell : passwdCell;
    /*else if (indexPath.section == 1)
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
    }*/
    
    return nil;
}

/*- (void)slideDownDidStop
{
	// the date picker has finished sliding downwards, so remove it
	[self.pickerView removeFromSuperview];
}*/

/*- (void)dateAction:(id)sender
{
	birthDayCell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.pickerView.date];
}*/

/*- (void)doneAction:(id)sender
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
	
    //self.pickerView.frame = endFrame;
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
}*/

/*- (void)showPicker
{
    [loginField resignFirstResponder];
    [passwdField resignFirstResponder];
    [nameFirstField resignFirstResponder];
    [nameLastField resignFirstResponder];
    
	self.pickerView.date = [self.dateFormatter dateFromString: self.birthDayCell.detailTextLabel.text];
	
	// check if our date picker is already on screen
	if (self.pickerView.superview == nil)
	{
		[self.view.window addSubview: self.pickerView];
		
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
		self.navigationItem.rightBarButtonItem = self.doneButton;
	}
}*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            if (indexPath.row == 0)
                [loginField becomeFirstResponder];
            else
                [passwdField becomeFirstResponder];
            
           // [self doneAction: nil];
            break;
            
       /* case 1:
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
            break;*/
    }
}

- (void)keyboardWillShow:(NSNotification *)n
{
    CGFloat keyboardHeight = [[[n userInfo] valueForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    
    [UIView beginAnimations: nil context:nil];
    [UIView setAnimationCurve:[[[n userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationDuration:[[[n userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    
   // fieldsTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - keyboardHeight);
    // fieldsTable.frame = CGRectMake(40, 80, 690, self.view.frame.size.height - keyboardHeight);
    
    if(IS_IPHONE_4_OR_LESS)
    {
        // fieldsTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height- keyboardHeight);
        fieldsTable.frame = CGRectMake(0, 60, 320, self.view.frame.size.height - keyboardHeight);
        
    }
    else if (IS_IPHONE_5)
    {
        fieldsTable.frame = CGRectMake(0, 65, 320, 500 - keyboardHeight);
        
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
    
    ////fieldsTable.frame = CGRectMake(0, 0, 320,  self.view.frame.size.height - keyboardHeight);
    // fieldsTable.frame = CGRectMake(40, 80, 690, self.view.frame.size.height - keyboardHeight);
    
    if(IS_IPHONE_4_OR_LESS)
    {
        fieldsTable.frame = CGRectMake(0, 60, 320, self.view.frame.size.height - keyboardHeight);
        
    }
    else if (IS_IPHONE_5)
    {
        fieldsTable.frame = CGRectMake(0, 60, 320, self.view.frame.size.height - keyboardHeight);
        
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
