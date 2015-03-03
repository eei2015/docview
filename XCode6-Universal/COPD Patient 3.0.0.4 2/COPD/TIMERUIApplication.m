//
//  TIMERUIApplication.m
//  COPD
//
//  Created by Akhil on 15/10/14.
//  Copyright (c) 2014 TKInteractive. All rights reserved.
//
//akhil 5-11-14
//auto logout
#import "TIMERUIApplication.h"
#import "Content.h"

@implementation TIMERUIApplication
//here we are listening for any touch. If the screen receives touch, the timer is reset
-(void)sendEvent:(UIEvent *)event
{
    [super sendEvent:event];
    
    if (!myidleTimer)
    {
        [self resetIdleTimer];
    }
    
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0)
    {
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        if (phase == UITouchPhaseBegan)
        {
            [self resetIdleTimer];
        }
        
    }
}
//as labeled...reset the timer
-(void)resetIdleTimer
{
    if (myidleTimer)
    {
        [myidleTimer invalidate];
    }
    //convert the wait period into minutes rather than seconds
    //int timeout = kApplicationTimeoutInMinutes * 60;
    //myidleTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO];
    
    //akihl 6-11-14
    //auto logout timer
    int timeout = [Content shared].logout_timer*60;
    NSLog(@"timer = %d",timeout);
    if (timeout ==0)
    {
        myidleTimer = [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO];
    }
    else
    {
        myidleTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO];
    }
    //akihl 6-11-14
    //auto logout timer
    
}
//if the timer reaches the limit as defined in kApplicationTimeoutInMinutes, post this notification
-(void)idleTimerExceeded
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationDidTimeoutNotification object:nil];
}


@end
