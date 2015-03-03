//
//  DischargeFormViewController.h
//  COPD
//
//  Created by Abbas Agha on 15/05/13.
//  Copyright (c) 2013 TKInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DischargeFormViewController : UIViewController
{
    UINavigationController *parentController;
}
@property(nonatomic,retain)NSMutableArray *formTypeArray;
@property (nonatomic, assign) UINavigationController *parentController;
@property (nonatomic, retain) NSMutableArray * pMedications;
@property (nonatomic, retain) NSMutableArray * iMedications;
@end
