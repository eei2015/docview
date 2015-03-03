//
//  ForgetViewController.h
//  COPD
//
//  Created by Akhil on 11/12/13.
//  Copyright (c) 2013 TKInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "TSAlertView.h"
#define USERNAME_SETTING_KEY @"USERNAME_SETTING_KEY"



@interface ForgetViewController : UIViewController<UIPopoverControllerDelegate>
{
    IBOutlet UITableView*        fieldsTable;
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
    
    //2014-01-20 Vipul 2.6
    UIButton*           CancelButton;
    //2014-01-20 Vipul 2.6
    
    BOOL                signupMode;
    BOOL                male;
    
    float               heightWithKeyboard;
    
    int tempIndex;
    
    TSAlertView* waitReportQuestionAlert;
    TSAlertView* viewReportQuestionAlert;
    UIActivityIndicatorView * activityIndicatorView;
    UIButton * logoView;
    //akhil 26-12-13
     UIPopoverController *popoverController;
    //akhil 26-12-13



}

@end
