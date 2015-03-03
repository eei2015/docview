#import <UIKit/UIKit.h>


#define GET_SURVEY_NEW			@"CheckForSurvey/%@"
@interface MainViewController : UIViewController
{
	UITableView *tableView;
    BOOL myInboxVisible;
    BOOL allVisible;
    UIButton * sendMessageButton;
    UILabel * statusLabel;
    NSString *strImageid;
    
    __block NSString *strServeyURL;
    
    // __block NSString *strServeyList;

   
}

@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) NSString *strImageid;

@end
