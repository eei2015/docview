#import "LoginViewController.h"
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

//akhil(Vipul) 25-12-13 2.6 Changes
#import "ForgetViewController.h"
#import "ConfirmPassViewController.h"
//akhil(Vipul) 25-12-13 2.6 Changes

#import "MessageBoard.h"
#import <AWSRuntime/AWSRuntime.h>

#import "COPDBackend.h"

//akhil 30-1-15
//IOS Upgradation
//#import "UIDevicePlatform.h"
//akhil 30-1-15
//IOS Upgradation


//akhil 22-1-15
/*
 *  System Versioning Preprocessor Macros
 */
/*#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)*/




/*#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
//akhil 22-1-15*/


@interface LoginViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, TSAlertViewDelegate>

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

- (void)login;
- (void)loginFinished:(COPDUser*)user error:(NSError**)error;
- (void)signupFinished:(COPDUser*)user error:(NSError**)error;
- (void)showError:(NSString*)error;
- (void)updateUIMode;
- (void)doneAction:(id)sender;
-(BOOL)isInternetConnection;

@end

@implementation LoginViewController

@synthesize fieldsTable;
@synthesize loginCell, passwdCell, nameFirstCell, nameLastCell, maleCell, femaleCell;
@synthesize loginField, passwdField, nameFirstField, nameLastField,birthDayCell,dateFormatter;
@synthesize pickerView,doneButton;

- (void)dealloc
{
    [fieldsTable release];
    [loginCell release];
    [passwdCell release];
    [nameFirstCell release];
    [nameLastCell release];
    [maleCell release];
    [femaleCell release];
    [birthDayCell release];

    [loginField release];
    [passwdField release];
    [nameFirstField release];
    [nameLastField release];
    
    [footerView release];
    [dateFormatter release];
    [super dealloc];
}
- (void)viewDidLoad
{
        [super viewDidLoad];
    
   // self.fieldsTable.layer.borderWidth=2;
    //self.view.autoresizesSubviews = YES;
    
   // NSString *strDevicename=[UIDevicePlatform platformString];
    
  //  NSString * fin = [UIDevicePlatform strDevicename]
   // NSString *deviceType = [UIDevice currentDevice].model;
    
   // NSLog(@"model = %@",[UIDevice currentDevice].model);
    //NSLog(@"name = %@",strDevicename);
   // NSLog(@"model = %@",[UIDevice currentDevice].model);
  //  NSLog(@"model = %@",[UIDevice currentDevice].model);

            // it's an iPhone
    //[self platformString];
     //NSLog(@"%@",[self platformString]);
    //self.view.frame = CGRectMake(0, 0, 320, 568);
   /* self.view.layer.borderWidth = 3;
    self.view.layer.borderColor = [[UIColor redColor]CGColor];
    
   
       float scaleFactor = [[UIScreen mainScreen] scale];
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat widthInPixel = screen.size.width * scaleFactor;
    CGFloat heightInPixel = screen.size.height * scaleFactor;
    
     NSLog(@"%0.2f",widthInPixel);
     NSLog(@"%0.2f",heightInPixel);*/
    
   // self.fieldsTable.frame = CGRectMake(0, 0, 320, 568);
 //  NSLog(@"device = %@",[[UIDevice currentDevice] pla]);
    
    [self loadBrandingViews];
    
    self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];

    UILongPressGestureRecognizer * lp = [[[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(handleLogoLongPress:)] autorelease];
    [self.navigationItem.titleView addGestureRecognizer: lp];
    UITapGestureRecognizer * tg = [[[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleLogoTap:)] autorelease];
    [self.navigationItem.titleView addGestureRecognizer: tg];
    
    //fieldsTable.layer.borderWidth = 7;
   // fieldsTable.layer.borderColor = [[UIColor yellowColor]CGColor];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle: @"Help" style: UIBarButtonItemStyleBordered target: self action: @selector(helpClicked)] autorelease];
    headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
   // headerView.frame = CGRectMake(0, 5, self.view.frame.size.width, 40);
    //akhil 16-2-15
    //ios update remwove above space on table view
    
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //akhil 16-2-15
    //ios update remwove above space on table view

   // UILabel* l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 300, 30)] autorelease];
    //self.navigationController.navigationBarHidden = YES;
  // headerView.layer.borderWidth = 5;
    headerView.layer.borderColor = [[UIColor whiteColor]CGColor];
    //akhil 27-1-15
    //IOS Upgradation
     UILabel* l = [[UILabel alloc]init];
   /* if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1){
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
            //l.layer.borderWidth=1;

        }
        else
        {
            l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 0, 450, 30)] autorelease];
            l.font = [UIFont boldSystemFontOfSize:34];
        }
        
    }
    else
    {*/
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
    //akhil 27-1-15
    //IOS Upgradation

   /* UILabel* l = [[UILabel alloc]init];
    if ([UIDevice currentDevice ].userInterfaceIdiom==UIUserInterfaceIdiomPad )
    {
         l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 0, 450, 30)] autorelease];
         l.font = [UIFont boldSystemFontOfSize:34];
    }
    else
    {
        //iphone 4
         CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        if(iOSDeviceScreenSize.height == 480)
        {
            //  l = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 305, 15)] autorelease];
            UILabel* l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 300, 30)] autorelease];
             l.font = [UIFont boldSystemFontOfSize:17];
            l.layer.borderWidth=1;
            //self.navigationController.navigationBarHidden = YES;
        }
        if(iOSDeviceScreenSize.height == 568)
        {
            
        }
    
    }
    //akhil 26-1-15
    //iphone ipad*/
    
    //UILabel* l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 0, 450, 30)] autorelease];
    
   // l.font = [UIFont boldSystemFontOfSize:34]; // 17  - Jatin Chauhan 26-Nov-2013
    l.backgroundColor = [UIColor clearColor];
    l.textColor = [UIColor whiteColor];
    l.shadowColor = [UIColor blackColor];
    l.shadowOffset = CGSizeMake(0, 1);
    
    l.text = @"Welcome to DocView iT3";

    [headerView addSubview:l];
    
    
    //akhil 27-1-15
    //IOS Upgradation
   /* if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1){
        if(IS_IPHONE_4_OR_LESS)
        {
            self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
            loginField.font = [UIFont systemFontOfSize:14];
            
        }
        else
        {
            self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(240, 11, 370, 42)] autorelease];
            loginField.font = [UIFont systemFontOfSize:34];
        }
        
    }
    else
    {*/
       /* if(IS_IPHONE_4_OR_LESS)
        {
           self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, self.fieldsTable.frame.size.width-180, 24)] autorelease];
            loginField.font = [UIFont systemFontOfSize:14];
            
        }
        else if (IS_IPHONE_5)
        {
            self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, self.view.frame.size.width-180, 24)] autorelease];
            loginField.font = [UIFont systemFontOfSize:14];
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
    // [self.loginCell setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    //}
    //akhil 27-1-15
    //IOS Upgradation

    
   /* //akhil 26-1-15
    //iphone ipad
    if ([UIDevice currentDevice ].userInterfaceIdiom==UIUserInterfaceIdiomPad )
    {
         self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(240, 11, 370, 42)] autorelease];
         loginField.font = [UIFont systemFontOfSize:34];
    }
    else
    {
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        if(iOSDeviceScreenSize.height == 480)
        {
          self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
             loginField.font = [UIFont systemFontOfSize:14];
           // self.loginField.layer.borderWidth = 2;
        }
        if(iOSDeviceScreenSize.height == 568)
        {
            
        }

    }
    //akhil 26-1-15
    //iphone ipad*/
    //self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(240, 11, 370, 42)] autorelease];
    //self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(340, 11, 150, 42)] autorelease];
    //self.loginField.layer.borderWidth=2;
//    self.loginField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
// Jatin Chauhan 22-Nov-2013
    
   // loginField.layer.borderWidth=1;
    loginField.delegate = self;
    loginField.placeholder = @"Enter your Username";
    //loginField.font = [UIFont systemFontOfSize:34]; //   - Jatin Chauhan 26-Nov-2013
    
    //2014-01-20 Vipul ITAD 2.6
    //loginField.placeholder.
    
    loginField.borderStyle = UITextBorderStyleNone;
    loginField.spellCheckingType = UITextSpellCheckingTypeNo;
    loginField.autocorrectionType = UITextAutocorrectionTypeNo;
    loginField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    loginField.text = [[NSUserDefaults standardUserDefaults] valueForKey: USERNAME_SETTING_KEY];
    [loginField addTarget: self action: @selector(loginFieldEditingChanged) forControlEvents: UIControlEventEditingChanged];

 //   self.passwdField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
    
    
    //akhil 27-1-15
    //IOS Upgradation
  /*  if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1){
        if(IS_IPHONE_4_OR_LESS)
        {
            self.passwdField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
            passwdField.font = [UIFont systemFontOfSize:14];
            
        }
        else
        {
            self.passwdField = [[[UITextField alloc] initWithFrame:CGRectMake(240, 11, 370, 42)] autorelease];
            passwdField.font = [UIFont systemFontOfSize:34];
        }
        
    }
    else
    {*/
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
    self.passwdField.layer.borderWidth=1;
   // }
    //akhil 27-1-15
    //IOS Upgradation

  /*  //akhil 26-1-15
    //iphone ipad
    if ([UIDevice currentDevice ].userInterfaceIdiom==UIUserInterfaceIdiomPad )
    {
        self.passwdField = [[[UITextField alloc] initWithFrame:CGRectMake(240, 11, 370, 42)] autorelease];
        passwdField.font = [UIFont systemFontOfSize:34];
    }
    else
    {
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        if(iOSDeviceScreenSize.height == 480)
        {
          self.passwdField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
            passwdField.font = [UIFont systemFontOfSize:14];
            //self.passwdField.layer.borderWidth = 2;
        }
        if(iOSDeviceScreenSize.height == 568)
        {
            
        }
        
    }
    //akhil 26-1-15
    //iphone ipad*/

    //self.passwdField = [[[UITextField alloc] initWithFrame:CGRectMake(240, 11, 370, 42)] autorelease];
    //self.passwdField = [[[UITextField alloc] initWithFrame:CGRectMake(340, 11, 150, 42)] autorelease];

    // Jatin Chauhan 22-Nov-2013
    
    
   // passwdField.font = [UIFont systemFontOfSize:34]; //   - Jatin Chauhan 26-Nov-2013
    //2014-01-20 Vipul ITAD 2.6
    //[[passwdField placeholder] drawInRect:CGRectMake(240, 11, 370, 42) withFont:15];
    
    passwdField.delegate = self;
    passwdField.secureTextEntry = YES;
    passwdField.borderStyle = UITextBorderStyleNone;
    
    
   // self.nameFirstField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
    self.nameFirstField = [[[UITextField alloc] initWithFrame:CGRectMake(240, 11, 370, 42)] autorelease];
    
    //akhil 27-1-15
    //IOS Upgradation
   /* if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1){
        if(IS_IPHONE_4_OR_LESS)
        {
            self.nameFirstField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
            nameFirstField.font = [UIFont systemFontOfSize:14];
            
        }
        else
        {
            self.nameFirstField = [[[UITextField alloc] initWithFrame:CGRectMake(240, 11, 370, 42)] autorelease];
            nameFirstField.font = [UIFont systemFontOfSize:34];
        }
        
    }
    else
    {*/
      /*  if(IS_IPHONE_4_OR_LESS)
        {
            self.nameFirstField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
            nameFirstField.font = [UIFont systemFontOfSize:14];
        }
       else if (IS_IPHONE_5)
        {
            self.nameFirstField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
            nameFirstField.font = [UIFont systemFontOfSize:14];
        }*/
        //akhil 12-2-15
        if(IS_IPHONE_4_OR_LESS || IS_IPHONE_5)
        {
            self.nameFirstField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, self.view.frame.size.width-180, 24)] autorelease];
            nameFirstField.font = [UIFont systemFontOfSize:14];
        }
    //akhil 12-2-15

        else
        {
            self.nameFirstField = [[[UITextField alloc] initWithFrame:CGRectMake(240, 11, 370, 42)] autorelease];
            nameFirstField.font = [UIFont systemFontOfSize:34];
        }
    self.nameFirstField.layer.borderWidth=1;
    //}
    //akhil 27-1-15
    //IOS Upgradation

    /*//akhil 27-1-15
    //iphone ipad
    if ([UIDevice currentDevice ].userInterfaceIdiom==UIUserInterfaceIdiomPad )
    {
        self.nameFirstField = [[[UITextField alloc] initWithFrame:CGRectMake(240, 11, 370, 42)] autorelease];
        nameFirstField.font = [UIFont systemFontOfSize:34];

    }
    else
    {
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        if(iOSDeviceScreenSize.height == 480)
        {
               self.nameFirstField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
            nameFirstField.font = [UIFont systemFontOfSize:14];
        }
        if(iOSDeviceScreenSize.height == 568)
        {
            
        }
    }
    //akhil 27-1-15*/
    nameFirstField.delegate = self;
   // nameFirstField.font = [UIFont systemFontOfSize:34];
    nameFirstField.borderStyle = UITextBorderStyleNone;

    //self.nameLastField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
    self.nameLastField = [[[UITextField alloc] initWithFrame:CGRectMake(240, 11, 370, 42)] autorelease];
    //akhil 27-1-15
    //IOS Upgradation
  /*  if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1){
        if(IS_IPHONE_4_OR_LESS)
        {
            self.nameLastField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
            nameLastField.font = [UIFont systemFontOfSize:14];
            
        }
        else
        {
            self.nameLastField = [[[UITextField alloc] initWithFrame:CGRectMake(240, 11, 370, 42)] autorelease];
            nameLastField.font = [UIFont systemFontOfSize:34];
        }
        
    }
    else
    {*/
     /*   if(IS_IPHONE_4_OR_LESS)
        {
            self.nameLastField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
            nameLastField.font = [UIFont systemFontOfSize:14];
        }
        else if (IS_IPHONE_5)
        {
            self.nameLastField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, 185, 24)] autorelease];
            nameLastField.font = [UIFont systemFontOfSize:14];
        }*/
        //akhil 12-2-15
        if(IS_IPHONE_4_OR_LESS || IS_IPHONE_5)
        {
            self.self.nameLastField = [[[UITextField alloc] initWithFrame:CGRectMake(115, 11, self.view.frame.size.width-180, 24)] autorelease];
            self.nameLastField.font = [UIFont systemFontOfSize:14];
        }
        //akhil 12-2-15
        else
        {
            self.nameLastField = [[[UITextField alloc] initWithFrame:CGRectMake(240, 11, 370, 42)] autorelease];
            nameLastField.font = [UIFont systemFontOfSize:34];
        }
    //}
    //akhil 27-1-15
    //IOS Upgradation
    nameLastField.delegate = self;
    //nameLastField.font = [UIFont systemFontOfSize:34];
    nameLastField.borderStyle = UITextBorderStyleNone;
    
    

    self.loginCell = [[[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:@"login"] autorelease];
    
    NSLog(@"self height = %0.2f",self.view.frame.size.height);
    NSLog(@"self width = %0.2f",self.view.frame.size.width);
    
   /* UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.loginCell.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(30, 30)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.fieldsTable.bounds;
    maskLayer.path = maskPath.CGPath;
    self.loginCell.layer.mask = maskLayer;
    [maskLayer release];*/
    //akhil 22-1-15
    //self.loginCell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(45, 1, 180, 59)] autorelease];
    
    loginCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
   // loginCell.layer.cornerRadius = 10;
    //akhil 27-1-15
    //IOS Upgradation
    /*if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1){
        if(IS_IPHONE_4_OR_LESS)
        {
            l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 90, 42)] autorelease];
            l.font = [UIFont boldSystemFontOfSize:14];
        }
        else
        {
            l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 1, 180, 57)] autorelease];
            l.font = [UIFont boldSystemFontOfSize:34];
        }
        
    }
    else
    {*/
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
    //}
    //akhil 27-1-15
    //IOS Upgradation

    
   /* //akhil 26-1-15
    //iphone ipad
    if ([UIDevice currentDevice ].userInterfaceIdiom==UIUserInterfaceIdiomPad )
    {
         l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 1, 180, 57)] autorelease];
        l.font = [UIFont boldSystemFontOfSize:34];

    }
    else
    {
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        if(iOSDeviceScreenSize.height == 480)
        {
           l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 90, 42)] autorelease];
            l.font = [UIFont boldSystemFontOfSize:14];

        }
        if(iOSDeviceScreenSize.height == 568)
        {
            
        }
        
    }
    //akhil 26-1-15
    //iphone ipad*/

    
   // l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 1, 180, 57)] autorelease];
    //l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 1, 280, 57)] autorelease];
   
   // l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 90, 42)] autorelease];
    //Jatin Chauhan 22-Nov-13
    
    
    l.text = @"Username";
  //  loginCell.layer.borderWidth=2;
  //  l.font = [UIFont boldSystemFontOfSize:34];
    [loginCell addSubview:l];
       
    [loginCell addSubview:loginField];
   // [fieldsTable addSubview:loginCell];//-
    
    self.passwdCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"passwd"] autorelease];
    //self.passwdCell.layer.cornerRadius=5;
    passwdCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
   /* UIBezierPath *maskPath1;
    maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.passwdCell.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = self.fieldsTable.bounds;
    maskLayer1.path = maskPath1.CGPath;
    self.loginCell.layer.mask = maskLayer1;
    [maskLayer1 release];*/

    //akhil 27-1-15
    //IOS Upgradation
    /*if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1){
        if(IS_IPHONE_4_OR_LESS)
        {
            l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 90, 42)] autorelease];
            l.font = [UIFont boldSystemFontOfSize:14];
        }
        else
        {
            l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 1, 180, 57)] autorelease];
            l.font = [UIFont boldSystemFontOfSize:34];
        }
        
    }
    else
    {*/
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
    
    
    //}
    //akhil 27-1-15
    //IOS Upgradation

   /* //akhil 26-1-15
    //iphone ipad
    if ([UIDevice currentDevice ].userInterfaceIdiom==UIUserInterfaceIdiomPad )
    {
            l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 1, 180, 57)] autorelease];
            l.font = [UIFont boldSystemFontOfSize:34];
        
    }
    else
    {
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        if(iOSDeviceScreenSize.height == 480)
        {
            l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 90, 42)] autorelease];
            l.font = [UIFont boldSystemFontOfSize:14];
            
        }
        if(iOSDeviceScreenSize.height == 568)
        {
            
        }
        
    }
    //akhil 26-1-15
    //iphone ipad*/

   // l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 1, 180, 57)] autorelease];
    //l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 1, 280, 57)] autorelease];
    
    //l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 90, 42)] autorelease];

    //Jatin Chauhan 22-Nov-13

    l.text = @"Password";
    //l.font = [UIFont boldSystemFontOfSize:34];
    [passwdCell addSubview:l];
    [passwdCell addSubview:passwdField];
    
    self.nameFirstCell = [[[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:@"nameFirst"] autorelease];
    nameFirstCell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.nameFirstCell.layer.cornerRadius = 5;
   // l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 90, 42)] autorelease];
     l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 1, 180, 57)] autorelease];
    
    l.text = @"First Name";
    l.font = [UIFont boldSystemFontOfSize:34];
    [nameFirstCell addSubview:l];
    [nameFirstCell addSubview:nameFirstField];

    self.nameLastCell = [[[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:@"nameLast"] autorelease];
    nameLastCell.selectionStyle = UITableViewCellSelectionStyleNone;
  //  l = [[[UILabel alloc] initWithFrame:CGRectMake(20, 1, 90, 42)] autorelease];
     l = [[[UILabel alloc] initWithFrame:CGRectMake(55, 1, 180, 57)] autorelease];
    l.text = @"Last Name";
    l.font = [UIFont boldSystemFontOfSize:34];
    [nameLastCell addSubview:l];
    [nameLastCell addSubview:nameLastField];

    self.maleCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"male"] autorelease];
    maleCell.textLabel.text = @"Male";
      maleCell.textLabel.font = [UIFont boldSystemFontOfSize:34];
    
    self.femaleCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"female"] autorelease];
    femaleCell.textLabel.text = @"Female";
     femaleCell.textLabel.font = [UIFont boldSystemFontOfSize:34];

    self.birthDayCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: nil] autorelease];
	self.birthDayCell.textLabel.text = @"Birthday";
	self.birthDayCell.detailTextLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
    self.birthDayCell.textLabel.font = [UIFont boldSystemFontOfSize:34];
    self.birthDayCell.detailTextLabel.font = [UIFont boldSystemFontOfSize:30];
    
    self.pickerView = [[[UIDatePicker alloc] initWithFrame: CGRectZero] autorelease];
    self.pickerView.datePickerMode = UIDatePickerModeDate;
    [self.pickerView addTarget: self action: @selector(dateAction:) forControlEvents: UIControlEventValueChanged];
    [self.pickerView sizeToFit];
    
    self.doneButton = [[[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleDone target: self action: @selector(doneAction:)] autorelease];
    
//    self.fieldsTable = [[[UITableView alloc] initWithFrame: self.view.bounds style:UITableViewStyleGrouped] autorelease];
    
   // self.fieldsTable = [[[UITableView alloc]initWithFrame:CGRectMake(40, 80, 690, 700) style:UITableViewStyleGrouped]autorelease];
  //akhil 22-1-15
    //ios - 8
   // if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    //{
        
      /*  if ([UIDevice currentDevice ].userInterfaceIdiom==UIUserInterfaceIdiomPad )
        {
            self.fieldsTable = [[[UITableView alloc]initWithFrame:CGRectMake(70, 80, 630, 700) style:UITableViewStyleGrouped]autorelease];
        }
        else
        {
            //iphone 4
            CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
            if(iOSDeviceScreenSize.height == 480)
            {
                self.fieldsTable = [[[UITableView alloc]initWithFrame:CGRectMake(0, 50, 320, 460) style:UITableViewStyleGrouped]autorelease];
            }
            if(iOSDeviceScreenSize.height == 568)
            {
                
            }
            
        }
        //akhil 26-1-15*/
    
    //akhil 27-1-15
    //IOS Upgradation
   /* if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1){
        if(IS_IPHONE_4_OR_LESS)
        {
              self.fieldsTable = [[[UITableView alloc]initWithFrame:CGRectMake(0, 60, 320, 460) style:UITableViewStyleGrouped]autorelease];
        }
        else
        {
            self.fieldsTable = [[[UITableView alloc]initWithFrame:CGRectMake(70, 80, 630, 700) style:UITableViewStyleGrouped]autorelease];

        }
        
    }
    else
    {*/
        if(IS_IPHONE_4_OR_LESS)
        {
             // self.fieldsTable = [[[UITableView alloc]initWithFrame:CGRectMake(0, 60, 320, 460) style:UITableViewStyleGrouped]autorelease];
        }
       else if (IS_IPHONE_5)
        {
            //self.fieldsTable = [[[UITableView alloc]initWithFrame:CGRectMake(0, 65, 320, 500) style:UITableViewStyleGrouped]autorelease];

        }
        else
        {
           // self.fieldsTable = [[[UITableView alloc]initWithFrame:CGRectMake(70, 80, 630, 700) style:UITableViewStyleGrouped]autorelease];
          //  self.fieldsTable = [[[UITableView alloc]ini
           //self.fieldsTable = [[UITableView alloc] initWithFrame:CGRectMake(69, 130, 630, 670) style:UITableViewStyleGrouped];
           // [self.fieldsTable setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
          //  self.fieldsTable = UITableViewStyleGrouped;


        }
    // self.fieldsTable = [[[UITableView alloc]initWithFrame:CGRectMake(0, 60, 320, 460) style:UITableViewStyleGrouped]autorelease];
   // self.fieldsTable.layer.borderWidth=2;
    self.fieldsTable.layer.borderColor=[[UIColor redColor]CGColor];
  //  self.fieldsTable
   // }
    //akhil 27-1-15
    //IOS Upgradation


       
    /*}
    else
    {
        //akhil 26-1-15
        
        //iphone 4
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        if(iOSDeviceScreenSize.height == 480)
        {
             self.fieldsTable = [[[UITableView alloc]initWithFrame:CGRectMake(0, 20, 320, 460) style:UITableViewStyleGrouped]autorelease];
        }
        if(iOSDeviceScreenSize.height == 568)
        {
            
        }
        //akhil 26-1-15
        //self.fieldsTable = [[[UITableView alloc]initWithFrame:CGRectMake(40, 80, 690, 700) style:UITableViewStyleGrouped]autorelease];

    }*/
    //akhil 22-1-15
    //ios - 8
 
    // Jatin Chauhan 22-Nov-2013
    
    
    
    
    fieldsTable.backgroundColor = nil;
    fieldsTable.backgroundView = nil;
    fieldsTable.scrollEnabled = NO;
    fieldsTable.delegate = self;
    fieldsTable.dataSource = self;
    //fieldsTable = [UITableView alloc]initWithFrame:<#(CGRect)#> style:<#(UITableViewStyle)#>
    //fieldsTable.layer.cornerRadius = 10;
   // fieldsTable.layer.cornerRadius=5;
   // [fieldsTable setClipsToBounds:YES];
    //akhil 26-1-15
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

    }
    //akhil 26-1-15
    //iphone ipad
     //fieldsTable.rowHeight = 59;
   // fieldsTable.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //[self.view addSubview:fieldsTable];//-
    
    footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    
    loginButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login-active"] forState:UIControlStateSelected];
    [loginButton setTitle:@"Log In" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor colorWithWhite: 0.2 alpha: 1] forState:UIControlStateNormal];
    [loginButton setTitleShadowColor:[UIColor colorWithWhite: 0.92 alpha: 1] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor colorWithWhite: 0.1 alpha: 1] forState:UIControlStateHighlighted];
    [loginButton setTitleShadowColor:[UIColor colorWithWhite: 0.15 alpha: 0.2] forState:UIControlStateHighlighted];
    loginButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [loginButton addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton sizeToFit];
   // loginButton.titleLabel.font = [UIFont boldSystemFontOfSize: 36]; // 18 - Jatin Chauhan 28-Nov-2013
    
//    loginButton.center = CGPointMake(self.view.frame.size.width/2, 40);
    
    //akhil 22-1-15
    //ios 8
   //  loginButton.frame = CGRectMake(70, 90, 610, 60);
    //loginButton.center = CGPointMake((self.view.frame.size.width/2)-40, 40);
    
    /*
     *  Usage
     */
    
   /* if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        loginButton.frame = CGRectMake(40, 90, 610, 60);
        loginButton.center = CGPointMake((self.view.frame.size.width/2)-70, 40);
    }
    
    else
    {*/
    //akhil 27-1-15
    //IOS Upgradation
    /*if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1){
        if(IS_IPHONE_4_OR_LESS)
        {
            loginButton.center = CGPointMake(self.view.frame.size.width/2, 40);
            loginButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
        }
        else
        {
            loginButton.frame = CGRectMake(60, 90, 610, 60);
            loginButton.center = CGPointMake((self.view.frame.size.width/2)-70, 40);
            loginButton.titleLabel.font = [UIFont boldSystemFontOfSize: 36];
        }
        
    }
    else
    {*/
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
      //[loginButton setAutoresizesSubviews:YES];
    
    //[self.fieldsTable addConstraint:[NSLayoutConstraint constraintWithItem:loginButton attribute:NSLayoutAttributeCenterXWithinMargins relatedBy:NSLayoutAttributeCenterY toItem:self.fieldsTable attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:3.0]];

    //}
    //akhil 27-1-15
    //IOS Upgradation

       /* //akhil 26-1-15
        //iphone ipad
        if ([UIDevice currentDevice ].userInterfaceIdiom==UIUserInterfaceIdiomPad )
        {
            loginButton.frame = CGRectMake(60, 90, 610, 60);
            loginButton.center = CGPointMake((self.view.frame.size.width/2)-40, 40);
             loginButton.titleLabel.font = [UIFont boldSystemFontOfSize: 36];
        }
        else
        {
            //iphone 4
            CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
            if(iOSDeviceScreenSize.height == 480)
            {
                loginButton.center = CGPointMake(self.view.frame.size.width/2, 40);
                 loginButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];

            }
            if(iOSDeviceScreenSize.height == 568)
            {
                
            }
            
        }
        //akhil 26-1-15
        //iphone ipad*/
        //loginButton.frame = CGRectMake(60, 90, 610, 60);
       // loginButton.center = CGPointMake((self.view.frame.size.width/2)-40, 40);
    //}
    
    //akhil 22-1-15
    //ios 8
    
    
    //akhil(Vipul) 25-12-13 2.6 Changes
    //footerView.layer.borderWidth = 2;
    
    forget_password = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [forget_password setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [forget_password setBackgroundImage:[UIImage imageNamed:@"login-active"] forState:UIControlStateSelected];
    [forget_password setTitle:@"Forgot Password" forState:UIControlStateNormal];
    [forget_password setTitleColor:[UIColor colorWithWhite: 0.2 alpha: 1] forState:UIControlStateNormal];
    [forget_password setTitleShadowColor:[UIColor colorWithWhite: 0.92 alpha: 1] forState:UIControlStateNormal];
    [forget_password setTitleColor:[UIColor colorWithWhite: 0.1 alpha: 1] forState:UIControlStateHighlighted];
    [forget_password setTitleShadowColor:[UIColor colorWithWhite: 0.15 alpha: 0.2] forState:UIControlStateHighlighted];
    forget_password.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [forget_password addTarget:self action:@selector(testClicked) forControlEvents:UIControlEventTouchUpInside];
    [forget_password sizeToFit];
   // forget_password.titleLabel.font = [UIFont boldSystemFontOfSize: 36];
    //forget_password.center = CGPointMake(self.view.frame.size.width/2, 40);
    // forget_password.frame = CGRectMake(forget_password.frame.origin.x, forget_password.frame.origin.y+50, forget_password.frame.size.width, forget_password.frame.size.height);
    //forget_password.layer.borderWidth = 2;
    //forget_password.frame = CGRectMake(70, 90, 610, 60);
   // forget_password.center = CGPointMake((self.view.frame.size.width/2)-40, 120);
    
    
    //akhil 27-1-15
    //IOS Upgradation
   /* if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1){
        if(IS_IPHONE_4_OR_LESS)
        {
            forget_password.center = CGPointMake(self.view.frame.size.width/2, 40);
            forget_password.frame = CGRectMake(forget_password.frame.origin.x, forget_password.frame.origin.y+50, forget_password.frame.size.width, forget_password.frame.size.height);
            forget_password.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
        }
        else
        {
            forget_password.frame = CGRectMake(70, 90, 610, 60);
            forget_password.center = CGPointMake((self.view.frame.size.width/2)-70, 120);
            forget_password.titleLabel.font = [UIFont boldSystemFontOfSize: 36];        }
        
    }
    else
    {*/
        if(IS_IPHONE_4_OR_LESS)
        {
           // forget_password.center = CGPointMake(self.view.frame.size.width/2, 40);
          //  forget_password.frame = CGRectMake(forget_password.frame.origin.x, forget_password.frame.origin.y+50, forget_password.frame.size.width, forget_password.frame.size.height);
              forget_password.center = CGPointMake(0, 90);
            forget_password.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
            [forget_password setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];

        }
        else if (IS_IPHONE_5)
        {
           // forget_password.center = CGPointMake(self.view.frame.size.width/2, 40);
            //forget_password.frame = CGRectMake(forget_password.frame.origin.x, forget_password.frame.origin.y+70, forget_password.frame.size.width, forget_password.frame.size.height);
            forget_password.center = CGPointMake(0, 90);
            forget_password.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
            [forget_password setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];

        }
        else
        {
            forget_password.frame = CGRectMake(70, 90, 610, 60);
            forget_password.center = CGPointMake((self.view.frame.size.width/2)-70, 120);
            forget_password.titleLabel.font = [UIFont boldSystemFontOfSize: 36];
        }
    forget_password.layer.borderWidth = 1;
      //[loginButton setAutoresizesSubviews:YES];

    //}
    //akhil 27-1-15
    //IOS Upgradation

        /*   //akhil 26-1-15
        //iphone ipad
        if ([UIDevice currentDevice ].userInterfaceIdiom==UIUserInterfaceIdiomPad )
        {
            forget_password.frame = CGRectMake(70, 90, 610, 60);
            forget_password.center = CGPointMake((self.view.frame.size.width/2)-70, 120);
             forget_password.titleLabel.font = [UIFont boldSystemFontOfSize: 36];
           // forget_password.frame = CGRectMake(70, 90, 610, 60);
            //forget_password.center = CGPointMake((self.view.frame.size.width/2)-40, 120);
        }
        else
        {
            //iphone 4
            CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
            if(iOSDeviceScreenSize.height == 480)
            {
                forget_password.center = CGPointMake(self.view.frame.size.width/2, 40);
                forget_password.frame = CGRectMake(forget_password.frame.origin.x, forget_password.frame.origin.y+50, forget_password.frame.size.width, forget_password.frame.size.height);
                 forget_password.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
            }
            if(iOSDeviceScreenSize.height == 568)
            {
                
            }
            
        }
        //akhil 26-1-15
        //iphone ipad*/

    
    
    //akhil 22-1-15
    //ios 8

    [footerView addSubview:forget_password];
    
    //2014-01-17 Vipul 2.6
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"IsUserLockedClinician"] == 1)
    {
        [forget_password setHidden:YES];
    }
    else
    {
        [forget_password setHidden:NO];
    }
    //2014-01-17 Vipul 2.6
    //akhil(Vipul) 12-12-13 2.6 Changes    
    
    activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray] autorelease];
    activityIndicatorView.center = CGPointMake(loginButton.frame.size.width - 25, loginButton.frame.size.height/2+1);
    [loginButton addSubview: activityIndicatorView];
    
    UIImageView * logos = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"login-logos.png"]] autorelease];
    
    logos.frame = CGRectMake(0, 77, logos.frame.size.width, logos.frame.size.height);
    

    
    [footerView addSubview: logos];
    //2014-09-10 akhil(Vipul) 3.0.0.2 Login button flash
     [self startFlashingbutton];
    //2014-09-10 akhil(Vipul) 3.0.0.2 Login button flash
    [footerView addSubview:loginButton];
    
    //2014-09-10 akhil(Vipul) 3.0.0.2 Login button flash
    UIButton * btn1 =[[UIButton alloc]initWithFrame:loginButton.frame ];
    btn1.layer.borderWidth=0;
    [btn1 addTarget: self action: @selector(test) forControlEvents: UIControlEventTouchUpInside];
    //btn1.layer.borderWidth = 3;
    [footerView addSubview: btn1];
    //2014-09-10 akhil(Vipul) 3.0.0.2 Login button flash
    
    tempIndex = 0;
    signupMode = NO;
    male = YES;
    [self updateUIMode];
    
    
    
    
    NSURL *url = [NSURL URLWithString:@"http://api.pusherapp.com/"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"chatX" , @"channel_name",
                              @"new-message", @"channel_name",
                               [NSString stringWithFormat:@"%f",[[NSDate date]timeIntervalSince1970] ]  , @"auth_timestamp",
                                      nil];
     
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [client postPath:@"apps/27056/channels/chatX/events" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSString *text = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"Response: %@", text);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];

      
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    UILabel * footerLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 0, 28)];
    footerLabel.backgroundColor = [UIColor clearColor];
    footerLabel.textColor = [UIColor whiteColor];
    
    //26-1-15
    //akhil iphone ipad
    if ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
    {
         footerLabel.font = [UIFont boldSystemFontOfSize: 22];
    }
    else
    {
         footerLabel.font = [UIFont boldSystemFontOfSize: 11];
    }
    //26-1-15
    //akhil iphone ipad
    //footerLabel.font = [UIFont boldSystemFontOfSize: 22];
    
    footerLabel.text = [[Content shared] versionString];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    fieldsTable.tableFooterView = footerLabel;

}

//2014-09-10 akhil(Vipul) 3.0.0.2 Login button flash
- (void)test
{
    NSLog(@"working");
    //flash = NO;
    [self stopFlashingbutton];
    [self login];
}
-(void) startFlashingbutton
{
    //if (flash) return;
    // flash = YES;
    //loginButton_src.alpha = 1.0f;
    [UIView animateWithDuration:1.20
                          delay:0.30
                        options:UIViewAnimationOptionCurveEaseInOut |
     UIViewAnimationOptionRepeat |
     UIViewAnimationOptionAutoreverse |
     UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         loginButton.alpha = 0.4f;
                     }
                     completion:^(BOOL finished)
                    {
                         // Do nothing
                     }];
}
-(void) stopFlashingbutton
{
    // if (!flash) return;
    //flash = NO;
    [UIView animateWithDuration:0.80
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut |
     UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         loginButton.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         // Do nothing
                     }];
    
}
//2014-09-10 akhil(Vipul) 3.0.0.2 Login button flash

//akhil(Vipul) 25-12-13 2.6 Changes
- (void)testClicked
{
#if COPD
    [InAppBrowserController showFromViewController: self withUrl: @"http://help.docviewsolutions.com/copd-app/help.html"];
#elif HFBASE
	//ForgetViewController *help = [[[ForgetViewController alloc] init] autorelease];
	//help.url = @"http://help.docviewsolutions.com/chf-app/help.html";
    ForgetViewController *help ;//= [[[ForgetViewController alloc] init] autorelease];
     //ForgetViewController *help = [[[ForgetViewController alloc] initWithNibName:@"ForgetViewController" bundle:nil] autorelease];
    //akhil 16-1-15
    //ios update
    
     // ForgetViewController *help = [[ForgetViewController alloc] initWithNibName:(IS_IPHONE)?@"ForgetViewController":@"ForgetViewController" bundle:nil];
    if ([UIDevice currentDevice].userInterfaceIdiom ==UIUserInterfaceIdiomPhone )
    {
        help = [[[ForgetViewController alloc] initWithNibName:@"ForgetViewController" bundle:nil] autorelease];
    }
    else
    {
        //vc = [[[LoginViewController alloc] init] autorelease];
       // vc = [[[LoginViewController alloc] initWithNibName:@"Login" bundle:nil] autorelease];
         help = [[[ForgetViewController alloc] initWithNibName:@"ForgetViewController_iPad" bundle:nil] autorelease];
        
    }
    //akhil 16-1-15
    //ios update

	[self.navigationController pushViewController:help animated:YES];
#elif HFB
	HelpViewController *help = [[[HelpViewController alloc] init] autorelease];
	help.url = @"http://www.barnabashealth.org/services/cardiac/education/chf_diagnosing.html";
	[self.navigationController pushViewController:help animated:YES];
#endif
}
//akhil(Vipul) 25-12-13 2.6 Changes

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

- (void)viewWillAppear:(BOOL)animated
{
    //akhil(Vipul) 8-1-14 2.6 Changes
    self.navigationItem.hidesBackButton = YES;
    [self.view bringSubviewToFront:self.fieldsTable];
    //akhil(Vipul) 8-1-14 2.6 Changes
    
    //2014-11-19 Vipul Qa changes by Chub
    passwdField.text = @"";
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    //akhil 3-2-15
    //ios upgration
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    //akhil 3-2-15
    //ios upgration

}

- (void)loginFieldEditingChanged
{
    [[NSUserDefaults standardUserDefaults] setValue: [loginField.text length] > 0 ? loginField.text : @"" forKey: USERNAME_SETTING_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
                [self showError:@"Please enter username"];
            else if (![passwdField.text length])
                [self showError:@"Please enter password"];
            else
            {
                [self showLoading: YES];
                [COPDUser validatePatient:loginField.text password:passwdField.text block:^(NSError *errorOrNil) {
                    // NSLog(@"NIL %@",errorOrNil);
                    if (errorOrNil==nil) {
                        [COPDUser logInWithUsernameInBackground:loginField.text password:passwdField.text target:self selector:@selector(loginFinished:error:)];
                    } else {
                        if (errorOrNil.code==-1001) {
                            [self showError:@"No Internet Connection. Please make sure you are connected to the Internet via WiFi or 3G."];
                        } else {
                            if ([[Content shared] isInternetConnection]) {
                                //akhil(Vipul) 7-1-14 2.6 Changes
                                //[self showError:@"Invalid username/password"];
                                COPDAppDelegate * obj_delegate = (COPDAppDelegate *)[[UIApplication sharedApplication]delegate];
                                NSLog(@"password change flage we gate = %d",obj_delegate.IsPasswordChangeRequire);
                                if (obj_delegate.IsPasswordChangeRequire==1)
                                {
                                    NSLog(@"get password change");
                                    ConfirmPassViewController * cofirm = [[ConfirmPassViewController alloc]init];
                                    [self.navigationController pushViewController:cofirm animated:YES];
                                    //[self confirm_password];
                                }
                                //akhil 16-1-14
                                else if (obj_delegate.IsUserLocked)
                                {
                                    //2014-01-17 Vipul 2.6
                                    [forget_password setHidden:YES];
                                    //2014-01-17 Vipul 2.6
                                    [self showError:[NSString stringWithFormat:@"%@",errorOrNil.domain]];
                                }
                                //akhil 16-1-14

                                else
                                {
                                    [self showError:@"Invalid username/password"];
                                }
                                //akhil(Vipul) 7-1-14 2.6 Changes
                            }
                            else {
                                [self showError:@"No Internet Connection. Please make sure you are connected to the Internet via WiFi or 3G."];
                            }

                        }
                                                
                        // [self showError:@"Invalid username/password"];
                        [self showLoading: NO];
                    }
                    
                }];
                
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
        [self updateUIMode];
		loginField.text = user.username;
        
        //2014-11-19 Vipul QA changes by Chub
		//passwdField.text = user.password;
    }
    else
    {
        [self showError:@"Unable to signup"];
    }
}

- (void)loginClicked:(UIButton*)sender
{
//    [Content shared].deviceToken = @"a9b83371274009d7c6f1215ff4e36a9689ff9f54fb36b8f267cc1362b45333d8";
//    BOOL succeeded = [[Content shared] subscribeDeviceToTopic:@"Patient"];
//    
//
//    [[Content shared] sendAmazonNotification:[NSString stringWithFormat:@"TestUser has sent a message"] TopicARN:@"Clinician" EndpointARN:nil];
    //[[Content shared] subscribeDeviceToTopic:@"Patient"];

    
    [self login];
    
}

- (void)handleLogoLongPress:(UILongPressGestureRecognizer *)g
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
}

- (void)handleLogoTap:(UITapGestureRecognizer *) g
{
    loginField.text = @"";
    passwdField.text = @"";
}

- (void)updateUIMode
{    
    fieldsTable.scrollEnabled = signupMode;
    [modeButton setTitle:(signupMode ? @"Back" : @"Sign Up") forState:UIControlStateNormal];
    [loginButton setTitle:(signupMode ? @"Sign Up" : @"Log In") forState:UIControlStateNormal];
    
    //akhil(Vipul) 25-12-13 2.6 Changes
    if (signupMode)
    {
        forget_password.hidden = YES;
    }
    else
    {
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"IsUserLockedClinician"] == 1)
        {
            [forget_password setHidden:YES];
        }
        else
        {
            [forget_password setHidden:NO];
        }
    }
    //[forget_password setTitle:@"Forget" forState:UIControlStateNormal];
    //akhil(Vipul) 25-12-13 2.6 Changes
    
    [passwdField setPlaceholder:(signupMode?@"Min. 6 characters":@"Enter your Password")];
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
            //akhil(Vipul) 7-1-14 2.6 Changes
//            //[Content shared].user = u;
//            [Content shared].copdUser = u;
//            [self presentMainScreen];
            COPDAppDelegate * obj_delegate = (COPDAppDelegate *)[[UIApplication sharedApplication]delegate];
            NSLog(@"password change flage we gate = %d",obj_delegate.IsPasswordChangeRequire);
            if (obj_delegate.IsPasswordChangeRequire==1)
            {
                NSLog(@"get password change");
                ConfirmPassViewController * cofirm = [[ConfirmPassViewController alloc]init];
                [self.navigationController pushViewController:cofirm animated:YES];
                //[self confirm_password];
            }            
            else
            {
                //2014-09-10 Vipul 3.0.0.2 Notification Bug
                [COPDUser UpdateScheduleNotification:[Content shared].deviceToken PatientID:u.objectId];
                //2014-09-10 Vipul 3.0.0.2 Notification Bug
                
                //[Content shared].user = u;
                [Content shared].copdUser = u;
                
                //akhil 5-11-14
                //auto logout
                [Content shared].login_status=1;
                //akhil 5-11-14
                //auto logout

                [self presentMainScreen];
            }
            //akhil(Vipul) 7-1-14 2.6 Changes

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
    [self doneAction: nil];
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
        //akhil(Vipul) 25-12-13 2.6 Changes
        //return 80;
    
        switch (signupMode)
        {
            case 0:
                return 160;
                break;
            
            default:
                return 80;
                break;
        }
        //akhil(Vipul) 25-12-13 2.6 Changes
    
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
    /*UIImage *rowBackground;
    UIImage *selectionBackground;
    NSInteger sectionRows = [tableView numberOfRowsInSection:[indexPath section]];
    NSInteger row = [indexPath row];
    if (row == 0 && row == sectionRows - 1)
    {
        rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
        selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
    }
    else if (row == 0)
    {
        rowBackground = [UIImage imageNamed:@"topRow.png"];
        selectionBackground = [UIImage imageNamed:@"topRowSelected.png"];
    }
    else if (row == sectionRows - 1)
    {
        rowBackground = [UIImage imageNamed:@"bottomRow.png"];
        selectionBackground = [UIImage imageNamed:@"bottomRowSelected.png"];
    }
    else
    {
        rowBackground = [UIImage imageNamed:@"middleRow.png"];
        selectionBackground = [UIImage imageNamed:@"middleRowSelected.png"];
    }*/
    
    
    if (indexPath.section == 0)
        return (indexPath.row == 0) ? loginCell : passwdCell;
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
    
    NSLog(@"x=%0.2f",fieldsTable.frame.origin.x);
    NSLog(@"y=%0.2f",fieldsTable.frame.origin.y);
    NSLog(@"he=%0.2f",fieldsTable.frame.size.height);
    NSLog(@"we=%0.2f",fieldsTable.frame.size.width);

	
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
        //2014-01-15 akhil(Vipul) 2.6 Changes
//		[self.view.window addSubview: self.pickerView];
//		
//		// size up the picker view to our screen and compute the start/end frame origin for our slide up animation
//		//
//		// compute the start frame
//		CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
//		CGSize pickerSize = [self.pickerView sizeThatFits:CGSizeZero];
//		CGRect startRect = CGRectMake(0.0,
//									  screenRect.origin.y + screenRect.size.height,
//									  pickerSize.width, pickerSize.height);
//		self.pickerView.frame = startRect;
//		
//		// compute the end frame
//		CGRect pickerRect = CGRectMake(0.0,
//									   screenRect.origin.y + screenRect.size.height - pickerSize.height,
//									   pickerSize.width,
//									   pickerSize.height);
//		// start the slide up animation
//		[UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.3];
//		
//        // we need to perform some post operations after the animation is complete
//        [UIView setAnimationDelegate:self];
//		
//        self.pickerView.frame = pickerRect;
//		
//        // shrink the table vertical size to make room for the date picker
//        CGRect newFrame = fieldsTable.frame;
//        newFrame.size.height -= self.pickerView.frame.size.height;
//        fieldsTable.frame = newFrame;
//		[UIView commitAnimations];
//		
//		// add the "Done" button to the nav bar
//		self.navigationItem.rightBarButtonItem = self.doneButton;
        
        UIViewController* popoverContent = [[UIViewController alloc] init];
        
        UIView *popoverView = [[UIView alloc] init];
        //akhil 27-1-15
       /* //IOS Upgradation
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1){
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
       /* //akhil 27-1-15
        //IOS Upgradation
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
        {
            popoverView.backgroundColor = [UIColor clearColor];
        }
        
        else
        {
            popoverView.backgroundColor = [UIColor blackColor];
        }
         //akhil 22-1-15*/
        
        
        //UIDatePicker *datePicker=[[UIDatePicker alloc]init];
        pickerView.frame=CGRectMake(0,0,320, 216);
        //pickerView.datePickerMode = UIDatePickerModeDate;
        [popoverView addSubview:pickerView];
        
        popoverContent.view = popoverView;
        popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        popoverController.delegate=self;
        [popoverContent release];
        
        
        [popoverController setPopoverContentSize:CGSizeMake(320, 216) animated:NO];
        
        //akhil 27-1-15
        //IOS Upgradation
      /*  if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
        {
             [popoverController presentPopoverFromRect:CGRectMake(225, 420, 320, 216) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
        else
        {
           [popoverController presentPopoverFromRect:CGRectMake(225, 370, 320, 216) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }*/
        [popoverController presentPopoverFromRect:CGRectMake(225, 370, 320, 216) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
        //akhil 27-1-15
        //IOS Upgradation

        /* //akhil 22-1-15
        //ios 8
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
        {
            [popoverController presentPopoverFromRect:CGRectMake(225, 420, 320, 216) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

        }
        else
        {
            [popoverController presentPopoverFromRect:CGRectMake(225, 370, 320, 216) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

        }
         //akhil 22-1-15
          //ios 8*/
               //akhil(Vipul) 26-12-13 2.6 Changes

	}
}

//akhil(Vipul) 26-12-13 2.6 Changes
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
//akhil(Vipul) 26-12-13 2.6 Changes

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            if (indexPath.row == 0)
                [loginField becomeFirstResponder];
            else
                [passwdField becomeFirstResponder];
            
            [self doneAction: nil];
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
    
    // fieldsTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - keyboardHeight);
    
    
    
  //  fieldsTable.frame = CGRectMake(40, 80, 690, self.view.frame.size.height - keyboardHeight);
    //akhil 28-1-15
    //IOS Upgradation
   /* if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1){
        if(IS_IPHONE_4_OR_LESS)
        {
            fieldsTable.frame = CGRectMake(0, 50, 320, self.view.frame.size.height - keyboardHeight);
            
        }
        else
        {
            
            fieldsTable.frame = CGRectMake(70, 80, 630, self.view.frame.size.height - keyboardHeight);
        }
        
    }
    else
    {*/
    NSLog(@"key board height we get = %0.2f",keyboardHeight);
        if(IS_IPHONE_4_OR_LESS)
        {
            // fieldsTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height- keyboardHeight);
           // fieldsTable.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight);
           // fieldsTable.frame = CGRectMake(0, 60, self.fieldsTable.frame.size.width, self.view.frame.size.height - keyboardHeight);

            
        }
        else if (IS_IPHONE_5)
        {
           // fieldsTable.frame = CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight);
           // fieldsTable.frame = CGRectMake(0, 65, self.fieldsTable.frame.size.width, self.view.frame.size.height - keyboardHeight);

            
        }
        
        else
        {
            
            //fieldsTable.frame = CGRectMake(70, 80, 630, self.view.frame.size.height - keyboardHeight);
            //  fieldsTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - keyboardHeight);
        }
    //}
    //akhil 28-1-15
    //IOS Upgradation

    
    // Jatin Chauhan 22-Nov-2013
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *) n
{
    CGFloat keyboardHeight = 0;
    
    [UIView beginAnimations: nil context:nil];
    [UIView setAnimationCurve:[[[n userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationDuration:[[[n userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    
    //  fieldsTable.frame = CGRectMake(0, 0, 320,  self.view.frame.size.height - keyboardHeight);
    
    
    
    //fieldsTable.frame = CGRectMake(40, 80, 690, self.view.frame.size.height - keyboardHeight);
    //akhil 28-1-15
    //IOS Upgradation
    /*if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1){
        if(IS_IPHONE_4_OR_LESS)
        {
            fieldsTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height- keyboardHeight);
            
        }
        else
        {
            fieldsTable.frame = CGRectMake(70, 80, 630, self.view.frame.size.height - keyboardHeight);
        }
        
    }
    else
    {*/
        if(IS_IPHONE_4_OR_LESS)
        {
            //fieldsTable.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight);
           // fieldsTable.frame = CGRectMake(0, 60, self.fieldsTable.frame.size.width, self.view.frame.size.height - keyboardHeight);

            
        }
        else if (IS_IPHONE_5)
        {
            //fieldsTable.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight);
           // fieldsTable.frame = CGRectMake(0, 65, self.fieldsTable.frame.size.width, self.view.frame.size.height - keyboardHeight);

            
        }
        else
        {
           // fieldsTable.frame = CGRectMake(70, 80, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight);
        }
    ///}
    //akhil 28-1-15
    //IOS Upgradation

    
    
    
    // Jatin Chauhan 22-Nov-2013
    
    [UIView commitAnimations];
}



/*- (void)keyboardWillShow:(NSNotification *)n
{
    CGFloat keyboardHeight = [[[n userInfo] valueForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    
    [UIView beginAnimations: nil context:nil];
    [UIView setAnimationCurve:[[[n userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationDuration:[[[n userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    
   // fieldsTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - keyboardHeight);
    
    
    //akhil 28-1-15
    //IOS Upgradation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1){
        if(IS_IPHONE_4_OR_LESS)
        {
            fieldsTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - keyboardHeight);

        }
              else
        {
            
            fieldsTable.frame = CGRectMake(70, 80, 630, self.view.frame.size.height - keyboardHeight);
        }
        
    }
    else
    {
        if(IS_IPHONE_4_OR_LESS)
        {
           // fieldsTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height- keyboardHeight);
             fieldsTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - keyboardHeight);

        }
        else if (IS_IPHONE_5)
        {
            fieldsTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - keyboardHeight);

        }

        else
        {
            
           fieldsTable.frame = CGRectMake(70, 80, 630, self.view.frame.size.height - keyboardHeight);
           //  fieldsTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - keyboardHeight);
        }
    }
    //akhil 28-1-15
    //IOS Upgradation

    
       // self.fieldsTable = [[[UITableView alloc]initWithFrame:CGRectMake(40, 80, 690, 700) style:UITableViewStyleGrouped]autorelease];
        


    
    //fieldsTable.frame = CGRectMake(40, 80, 690, self.view.frame.size.height - keyboardHeight);


// Jatin Chauhan 22-Nov-2013
    
    [UIView commitAnimations];
}*/

/*- (void)keyboardWillHide:(NSNotification *) n
{
    CGFloat keyboardHeight = 0;
    
    [UIView beginAnimations: nil context:nil];
    [UIView setAnimationCurve:[[[n userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationDuration:[[[n userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    
  //  fieldsTable.frame = CGRectMake(0, 0, 320,  self.view.frame.size.height - keyboardHeight);
    
    
    //akhil 28-1-15
    //IOS Upgradation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1){
        if(IS_IPHONE_4_OR_LESS)
        {
            fieldsTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height- keyboardHeight);
            
        }
        else
        {
            fieldsTable.frame = CGRectMake(70, 80, 630, self.view.frame.size.height - keyboardHeight);
        }
        
    }
    else
    {
        if(IS_IPHONE_4_OR_LESS)
        {
            fieldsTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - keyboardHeight);
            
        }
        else
        {
            fieldsTable.frame = CGRectMake(70, 80, 630, self.view.frame.size.height - keyboardHeight);
        }
    }
    //akhil 28-1-15
    //IOS Upgradation

    
        
        
    //}
    //akhil 23-1-15
    
    
   // fieldsTable.frame = CGRectMake(40, 80, 690, self.view.frame.size.height - keyboardHeight);
    
    // Jatin Chauhan 22-Nov-2013
    
    [UIView commitAnimations];
}*/


@end
