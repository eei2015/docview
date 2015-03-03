#import "COPDAppDelegate.h"

#import "LoginViewController.h"
#import "Content.h"
#import "QuestionsViewController.h"
#import "SplashViewController.h"
#import  "Crittercism.h"
#import "COPDBackend.h"

//2014-02-28 Vipul Amazon SNS
#import <AWSRuntime/AWSRuntime.h>
#import "NSObject+SBJSON.h"
//2014-02-28 Vipul Amazon SNS

//akhil 15-10-14 auto log out
#import "TIMERUIApplication.h"
//akhil 15-10-14 auto log out





@interface COPDAppDelegate (PrivateMethods)
- (void)pushNotificationTest;
@end

@implementation COPDAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize client,chatChannel;

//akhil 21-10-13
@synthesize ary_survey;
//akhil 21-10-13

//akhil(Vipul) 7-1-14 2.6 Changes
@synthesize IsPasswordChangeRequire,IsUserLocked;
//akhil(Vipul) 7-1-14 2.6 Changes

- (void)showLogin
{
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
	//LoginViewController * vc = [[[LoginViewController alloc] initWithNibName:@"View" bundle:nil] autorelease];
     // LoginViewController *vc = [[LoginViewController alloc] initWithNibName:(IS_IPHONE)?@"View":@"Login" bundle:nil];
    
    //[vc.view setFrame:[[UIScreen mainScreen] applicationFrame]];
    //vc.view.frame = CGRectMake(0, 0, 320, 568);
     //NSLog(@"%0.2f",vc.view.frame.size.height);

    self.navigationController = [[[UINavigationController alloc] initWithRootViewController: vc] autorelease];
    self.window.rootViewController = self.navigationController;
    
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    //self.window.frame = CGRectMake(0, 0, 320, 568);
   // NSLog(@"self. w he = %0.2f",self.window.frame.size.height);
   // NSLog(@"self. w we = %0.2f",self.window.frame.size.width);

    //[[Content shared] initBackendForIpad];
   // [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound]; // to get Device token
    
    //[PFUser logOut];
    
//    NSDictionary *infoPList = [[NSBundle mainBundle] infoDictionary];
//    NSString *appName = [infoPList objectForKey:@"CFBundleDisplayName"];
//    NSLog(@"aaa %@",appName);
    
    //akhil 21-10-13
    ary_survey  =[[NSMutableArray alloc]init];
     //akhil 21-10-13
    
    SplashViewController * vc = [[[SplashViewController alloc] init] autorelease];
   // vc.view.frame = CGRectMake(0, 0, 320, 568) ;
    
    //Added by Pankil For setup Crash Reprot Parameter : 10-07-2013
    
    NSString *crittercism_id=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CRITTERCISM_ID"];
    
    NSString *api_secret=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"API_SECRET"];
    
    NSString *api_key=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"API_KEY"];
    
    //Added by Pankil For setup Crash Reprot Parameter : 10-07-2013
     
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController: vc] autorelease];
    [Crittercism initWithAppID:crittercism_id andKey:api_key andSecret:api_secret andMainViewController: vc];

    self.navigationController.navigationBarHidden = YES;
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];

    
    application.applicationIconBadgeNumber = 0;
    [Content shared].recordUpdateReceivedWhileAppWasRunning = NO;
    [Content shared].lastUpdatedRecordId = [[launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey] valueForKey: @"recId"];
    [Content shared].lastUpdatedUserId = [[launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey] valueForKey: @"userId"];
    
/*
#if HFX
    client = [[BLYClient alloc] initWithAppKey:@"6e0a8f3551b4db0077b2" delegate:self];
     chatChannel = [client subscribeToChannelWithName:@"chatX"];
#elif HFB
    client = [[BLYClient alloc] initWithAppKey:@"cc19c3628cde269f1d1a" delegate:self];
    chatChannel = [client subscribeToChannelWithName:@"chatB"];
#elif HFM
    client = [[BLYClient alloc] initWithAppKey:@"95bc2223b939f0b84811" delegate:self];
    chatChannel = [client subscribeToChannelWithName:@"chatM"];
#endif
*/
    
    [self performSelector: @selector(showLogin) withObject: nil afterDelay: 0];
    
    
    //akhil 5-11-14 auto log out
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidTimeout:) name:kApplicationDidTimeoutNotification object:nil];
    [Content shared].login_status=0;
    //akhil 5-11-14
    //auto logout

    
	// push notifications test
	//[self performSelector:@selector(pushNotificationTest) withObject:nil afterDelay:60.0];
    
    return YES;
}
//akhil 5-11-14 auto log out
-(void)applicationDidTimeout:(NSNotification *) notif
{
    //NSLog (@"time exceeded!!");
    NSLog(@"time out detected");
    [[Content shared] handleLogout];
    //[PFUser logOut];
    NSLog(@"conte user = %@",[[Content shared]user]);
    //* NSLog(@"conte user = %@",[[Content shared]userFirstName]);
    
    NSLog(@"content shared login stauts flag value = %d",[Content shared].login_status);
    
    /* NSLog(@"conte user = %@",[COPDBackend sharedBackend].currentUser.username);
     NSLog(@"conte user = %d",[COPDBackend sharedBackend].currentUser.username.length);*/
    if ([Content shared].login_status==0)
    {
        NSLog(@"no login yet");
    }
    else
    {
        NSLog(@"time out detected do process for logout");
        //akhil 15-10-14
        //auto logout
        //reset value
        NSUserDefaults *prefs1 = [NSUserDefaults standardUserDefaults];
        [prefs1 setInteger:0 forKey:@"Patient_flag"];
        NSInteger myInt = [[prefs1 valueForKey:@"Patient_flag"]integerValue];
        NSLog(@"vlu = %d",myInt);
        [prefs1 setValue:@"" forKey:@"Patient_name"];
        NSString * str_name = [prefs1 valueForKey:@"Patient_name"];
        NSLog(@"patient name get = %@",str_name);
        
        [[NSUserDefaults standardUserDefaults] setValue: @"" forKey: USERNAME_SETTING_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [Content shared].login_status = 0;
        
        //auto logout
        //SNF
        
        NSLog(@"do log out process");
        COPDAppDelegate * appDelegate = (COPDAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.navigationController dismissViewControllerAnimated:YES completion:^{
            //
        }];
    }
    [(TIMERUIApplication *)[UIApplication sharedApplication] resetIdleTimer];
     
}
//akhil 5-11-14 auto log out

- (void)bullyClientDidConnect:(BLYClient *)client{}
- (void)bullyClient:(BLYClient *)client didReceiveError:(NSError *)error{}
- (void)bullyClientDidDisconnect:(BLYClient *)client{}
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)pushNotificationTest
{
	//NSLog(@"starting incoming push notification test");
	NSDictionary *notifInfo = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"UGVf3E6dU8", @"zoEMwSdZda", nil] forKeys:[NSArray arrayWithObjects:@"recId", @"userId", nil]];
	[self application:nil didReceiveRemoteNotification:notifInfo];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    //2014-03-05 Vipul Amazon SNS
    //[[Content shared] initBackendForIphone];
    
    @try {
        
        NSString *deviceToken = [[newDeviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
        [Content shared].deviceToken=deviceToken;
        
        //2014-03-04 Vipul Amazon SNS        
//        [PFPush storeDeviceToken:newDeviceToken];
//        
//        NSString *strChannel=[NSString stringWithFormat: @"user%@",[[Content shared] copdUser].objectId];
//        
//       // [self initBackendForIphone];
//        NSError * error = nil;
//        NSSet * channels = [PFPush getSubscribedChannels: &error];
//        for (NSString * s in channels)
//        {
//            [PFPush unsubscribeFromChannel: s error: &error];
//        }
//        
//          BOOL succeeded=[PFPush subscribeToChannel: strChannel error: &error];
//        
//        //[PFPush subscribeToChannelInBackground:strChannel block:^(BOOL succeeded, NSError *error) {
//            //
        
        
        BOOL succeeded = [[Content shared] subscribeDeviceToTopic:@"Patient"];
        //
//        int64_t delayInSeconds = 10;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        
            NSMutableDictionary *data=[[[NSMutableDictionary alloc] init] autorelease];
            //2014-03-04 Vipul Amazon SNS
            //[data setObject:strChannel forKey:@"ParseChannels"];
            [data setObject:[[Content shared] AmazonDeviceEndpointARN] forKey:@"ParseChannels"];
            //
            [data setObject:@"patient" forKey:@"UserRole"];
            [data setObject:@"ios" forKey:@"DeviceType"];
            [data setObject:deviceToken forKey:@"DeviceToken"];
            [data setObject:[Content shared].copdUser.objectId forKey:@"CreatedBy"];
            [data setObject:[NSString stringWithFormat:@"%u",succeeded] forKey:@"Status"];
            //2014-03-04 Vipul Amazon SNS
            //[data setObject:(error)?error.description:@"" forKey:@"ParseMessage"];
            [data setObject:@"" forKey:@"ParseMessage"];
            //
            // NSLog(@"%u",isSucceed);
            // NSLog(@"%@",error);
            
            [[COPDBackend sharedBackend] saveNotificationSubscriptionInBackground:data WithBlock:^(NSError *errorOrNil) {
                //
                
            }];
            
        //});
        //}];
        
        
        //NSLog(@"%u",isSucceed);
        // NSLog(@"subscribed to channel %@",  [NSString stringWithFormat: @"user%@",self.copdUser.objectId]);
        
        
        //  [self initBackendForIpad];
                
    }
    @catch (NSException *exception) {
        //
        NSLog(@"%@",exception);
    }
    @finally {
        //
    }

    // Tell Parse about the device token.
    //NSLog(@"DT: %@",newDeviceToken);
   /* @try {
        NSString *deviceToken = [[newDeviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
        [Content shared].deviceToken=deviceToken;
        
        [PFPush storeDeviceToken:newDeviceToken];
        

    }
    @catch (NSException *exception) {
        //
    }
    @finally {
        //
    }*/
    
    
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo 
{
    //2014-02-28 Vipul Amazon SNS
//    application.applicationIconBadgeNumber = 0;
//    if ([userInfo objectForKey: @"recId"])
//    {
//        [Content shared].recordUpdateReceivedWhileAppWasRunning = YES;
//        [Content shared].lastUpdatedRecordId = [userInfo valueForKey: @"recId"];
//        [Content shared].lastUpdatedUserId = [userInfo valueForKey: @"userId"];
//    }
//    [PFPush handlePush:userInfo];
//    application.applicationIconBadgeNumber = 0;
//    [[Content shared] reload];
    
     
    application.applicationIconBadgeNumber = 0;
    NSString *msg = [NSString stringWithFormat:@"%@", [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
    //NSString *msg = [userInfo objectForKey:@"message"];
    NSLog(@"%@",msg);
    [[Content universalAlertsWithTitle:@"Push Notification Received" andMessage:msg] show];
    [[Content shared] reload];
    //2014-02-28 Vipul Amazon SNS
}


- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
