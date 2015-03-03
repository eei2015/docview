#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "TSAlertView.h"

#define USERNAME_SETTING_KEY @"USERNAME_SETTING_KEY"

@interface LoginViewController : UIViewController<UIPopoverControllerDelegate,UITextFieldDelegate>
{
   // UITableView*        fieldsTable;
    
  IBOutlet  UITableView*        fieldsTable;
    UITableViewCell*    loginCell;
    UITableViewCell*    passwdCell;
    UITableViewCell*    nameFirstCell;
    UITableViewCell*    nameLastCell;
    UITableViewCell*    maleCell;
    UITableViewCell*    femaleCell;
    UITableViewCell*    birthDayCell;

    UITextField*        loginField;
    UITextField*        passwdField;
    UITextField*        nameFirstField;
    UITextField*        nameLastField;
    
    UIView*             headerView;
    UIView*             footerView;
    
    UIButton*           modeButton;
    UIButton*           loginButton;
    
    BOOL                signupMode;
    BOOL                male;
    
    float               heightWithKeyboard;
    
    int tempIndex;
    
    TSAlertView* waitReportQuestionAlert;
    TSAlertView* viewReportQuestionAlert;
    UIActivityIndicatorView * activityIndicatorView;
    UIButton * logoView;
    //akhil(Vipul) 12-12-13 2.6 Changes
    UIButton *          forget_password;
    //akhil(Vipul) 26-12-13 2.6 Changes
    UIPopoverController *popoverController;
    //akhil(Vipul) 26-12-13 2.6 Changes
}

- (NSString*)getLogin;
- (NSString*)getPassword;
- (int)getTempIndex;

@end
