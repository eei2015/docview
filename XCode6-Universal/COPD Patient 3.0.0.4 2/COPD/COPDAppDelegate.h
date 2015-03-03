#import <UIKit/UIKit.h>
#import <Bully/Bully.h>

/*Added by pankil for get value from plist 10-07-2013 */

/*pankil for Morr.Patient.Test 10-02-2013 */
 #define CRITTERCISM_ID              //@"524ed2b08b2e335639000001"
 #define API_SECRET                  //@"sajs1j8enpu5elrzzxqcph03mbrx6ilo"
 #define API_KEY                     //@"zo6iksrutg34wglbbpfneyvnwfae"



/*pankil for Morr.Patient.Local
#define CRITTERCISM_ID              @"5245526c558d6a63e5000003"
#define API_SECRET                  @"u0ipgharlnxcnvpydoukm58cwxblseq6"
#define API_KEY                     @"u0ipgharlnxcnvpydoukm58cwxblseq6"
*/
/*pankil for rwdj.patietn.qa
#define CRITTERCISM_ID              @"5242b87a8b2e3368f5000009"
#define API_SECRET                  @"ebj7634apwqhopyjdl0fms1bor9xmzu8"
#define API_KEY                     @"zo6iksrutg34wglbbpfneyvnwfae"
*/
/*Old values updated by pankil for rwdj.patietn.qa
#define CRITTERCISM_ID              @"50461ab4eeaf41381d000004"
#define API_SECRET                  @"7smxcbqc9vppjtbyfkxlqr2oje0k4ivs"
#define API_KEY                     @"zo6iksrutg34wglbbpfneyvnwfae"
*/

//akhil(Vipul) 7-1-14 2.6 Changes
#define ALFTA_NUMERIC_EXP @"ALFTA_NUMERIC_EXP"
#define ALFTA_NUMERIC_EXP_MSG @"ALFTA_NUMERIC_EXP_MSG"
#define COMPLEX_EXP @"COMPLEX_EXP"
#define COMPLEX_EXP_MSG @"COMPLEX_EXP_MSG"
#define PASS_LENGTH_EXP @"PASS_LENGTH_EXP"
#define PASS_LENGTH_EXP_MSG @"PASS_LENGTH_EXP_MSG"
//akhil(Vipul) 7-1-14 2.6 Changes

@interface COPDAppDelegate : NSObject <UIApplicationDelegate,BLYClientDelegate>
{
    
}

@property (nonatomic, retain) BLYClient *client;
@property (nonatomic, retain) BLYChannel *chatChannel;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) UINavigationController *navigationController;

//akhil 21-10-13
@property(nonatomic,retain)NSMutableArray * ary_survey;
//akhil 21-10-13

//akhil(Vipul) 7-1-14 2.6 Chnages
@property (nonatomic,readwrite)NSInteger IsPasswordChangeRequire;
@property (nonatomic,readwrite)NSInteger IsUserLocked;
- (void)showLogin;
//akhil(Vipul) 7-1-14 2.6 changes
@end
