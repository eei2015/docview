//
//  ConfirmPassViewController.h
//  COPD
//
//  Created by Akhil on 12/12/13.
//  Copyright (c) 2013 TKInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Parse/Parse.h"
#import "TSAlertView.h"
#import "LoginViewController.h"
#import "ForgetViewController.h"

#define USERNAME_SETTING_KEY @"USERNAME_SETTING_KEY"
#define PASSWORD_SETTING_KEY @"PASSWORD_SETTING_KEY"

/*#define ALFTA_NUMERIC_EXP @"ALFTA_NUMERIC_EXP"
#define ALFTA_NUMERIC_EXP_MSG @"ALFTA_NUMERIC_EXP_MSG"
#define COMPLEX_EXP @"COMPLEX_EXP"
#define COMPLEX_EXP_MSG @"COMPLEX_EXP_MSG"
#define PASS_LENGTH_EXP @"PASS_LENGTH_EXP"
#define PASS_LENGTH_EXP_MSG @"PASS_LENGTH_EXP_MSG"*/


@interface ConfirmPassViewController : UIViewController
{
   // UITableView*        fieldsTable;
   IBOutlet UITableView*        fieldsTable;

    UITableViewCell*    loginCell;
    UITableViewCell*    passwdCell;
   // UITableViewCell*    nameFirstCell;
  //  UITableViewCell*    nameLastCell;
    
    UITextField*        loginField;
    UITextField*        passwdField;
    
    UIView*             headerView;
    UIView*             footerView;
    
    UIButton*           loginButton;
    
    //2014-01-20 Vipul ITAD 2.6
    UIButton*           CancelButton;
    //2014-01-20 Vipul ITAD 2.6
    
    float               heightWithKeyboard;
    
    int tempIndex;
    BOOL                signupMode;
    
    NSInteger flag_validate;
    NSString * str_invalide_msg;


    
    TSAlertView* waitReportQuestionAlert;
    TSAlertView* viewReportQuestionAlert;
    UIActivityIndicatorView * activityIndicatorView;
    UIButton * logoView;
    
  


}

@end
