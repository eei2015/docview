#import "UIViewController+Branding.h"

//akhil 22-1-15
/*
 *  System Versioning Preprocessor Macros
 */
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


@implementation UIViewController (Branding)

- (void)loadBrandingViews
{
//    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]] autorelease];
    
    //akhil 27-1-15
    if ([UIDevice currentDevice ].userInterfaceIdiom==UIUserInterfaceIdiomPad )
    {
          self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo@2x.png"]] autorelease];
    }
    else
    {
          self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]] autorelease];
    }
     //akhil 27-1-15
    //self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo@2x.png"]] autorelease];

    self.navigationItem.titleView.userInteractionEnabled = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
//    UIImageView * bg = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"bg.png"]] autorelease];
    UIImageView * bg = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"bg@2x.png"]] autorelease];

    /*//akhil 27-1-15
    if ([UIDevice currentDevice ].userInterfaceIdiom==UIUserInterfaceIdiomPad )
    {
        bg = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"bg@2x.png"]] autorelease];
    }
    else
    {
        bg = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"bg.png"]] autorelease];

    }
    
    
    bg.frame = CGRectMake(65, 50, 640, 832);
    
    //akhil 27-1-15
    //iphone ipad
    if ([UIDevice currentDevice ].userInterfaceIdiom==UIUserInterfaceIdiomPad )
    {
          bg.frame = CGRectMake(65, 50, 640, 832);
    }
    else
    {
        //iphone 4
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        if(iOSDeviceScreenSize.height == 480)
        {
              bg.frame = CGRectMake(0, 0, 320, 480);
        }
        if(iOSDeviceScreenSize.height == 568)
        {
             bg.frame = CGRectMake(0, 0, 320, 567);
        }
        
    }
    //akhil 27-1-15
    //iphone ipad*/
    
    //akhil 28-1-15
    //IOS Upgradation
  /*  if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1){
        if(IS_IPHONE_4_OR_LESS)
        {
            
            
            bg = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"bg.png"]] autorelease];
              bg.frame = CGRectMake(0, 0, 320, 480);

        }
        
        else
        {
              bg = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"bg@2x.png"]] autorelease];
            bg.frame = CGRectMake(65, 50, 640, 832);

        }
        
    }
    else
    {*/
        if(IS_IPHONE_4_OR_LESS)
        {
            NSLog(@"%0.2f",[ [ UIScreen mainScreen ] bounds ].size.height);
                      bg = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"bg.png"]] autorelease];
            bg.frame = CGRectMake(0, 0, 320, 480);
            //bg.frame = CGRectMake(0, 0, 640, 960);

        }
        else if (IS_IPHONE_5)
        {
            bg = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"bg.png"]] autorelease];
            bg.frame = CGRectMake(0, 0, 320, 568);
        }
        else
        {
              bg = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"bg@2x.png"]] autorelease];
         //  bg.frame = CGRectMake(65, 50, 640, 832);
              bg.frame = CGRectMake(65, 110, 640, 832);
           // bg.frame = CGRectMake(0, 0, 320, 568);

        }
   // }
    //akhil 27-1-15
    //IOS Upgradation

   

//    bg.center = CGPointMake ( self.view.center.x, bg.center.y );
//    bg.center = CGPointMake(self.view.center.y, bg.center.x);
//    NSLog(@"view.center.x = %0.2f",self.view.center.x);
//    NSLog(@"bg.center.y = %0.2f",bg.center.x);
//    NSLog(@"self.view.center.y = %0.2f",self.view.center.y);
//    NSLog(@"bg.center.x = %0.2f",bg.center.x);

    
  //  bg.layer.borderWidth = 5;
  //  bg.layer.borderColor = [[UIColor redColor]CGColor];
    
    NSLog(@"view x = %0.2f",self.view.frame.origin.x);
    NSLog(@"view y = %0.2f",self.view.frame.origin.y);
    NSLog(@"view widht = %0.2f",self.view.frame.size.width);
    NSLog(@"view height = %0.2f",self.view.frame.size.height);


    if ([self isKindOfClass: [UITableViewController class]])
    {
        UITableViewController * tc = (UITableViewController *)self;
        tc.tableView.backgroundView = bg;
    }
    else
    {
        [self.view addSubview: bg];
        //[bg sendSubviewToBack:self.view];
    }
    
}

@end
