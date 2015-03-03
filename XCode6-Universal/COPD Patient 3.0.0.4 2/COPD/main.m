#import <UIKit/UIKit.h>
#import "COPDAppDelegate.h"
#import "TIMERUIApplication.h"
int main(int argc, char *argv[])
{
   /* @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([COPDAppDelegate class]));
    }*/
    //akhil 5-11-14
    //auto logout
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, NSStringFromClass([TIMERUIApplication class]), NSStringFromClass([COPDAppDelegate class]));
    }
    //akhil 5-11-14
    //auto logout

}
