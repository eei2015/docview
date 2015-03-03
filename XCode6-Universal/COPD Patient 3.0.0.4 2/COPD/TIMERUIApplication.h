//
//  TIMERUIApplication.h
//  COPD
//
//  Created by Akhil on 15/10/14.
//  Copyright (c) 2014 TKInteractive. All rights reserved.
//

//akhil 5-11-14
//auto logout

#import <UIKit/UIKit.h>
//the length of time before your application "times out". This number actually represents seconds, so we'll have to multiple it by 60 in the .m file
#define kApplicationTimeoutInMinutes 2.0

//the notification your AppDelegate needs to watch for in order to know that it has indeed "timed out"
#define kApplicationDidTimeoutNotification @"AppTimeOut"

@interface TIMERUIApplication : UIApplication
{
    NSTimer     *myidleTimer;
}
-(void)resetIdleTimer;

@end
