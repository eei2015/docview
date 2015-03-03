#import <UIKit/UIKit.h>


@class ChatViewController, ReportViewController,DischargeFormViewController;


@interface HFMessagesViewController : UIViewController
{
	UISegmentedControl *segmentedControl;

	ReportViewController *instructionsController;
	ChatViewController *chatController;
    DischargeFormViewController *dischargeFormViewController;
	UILabel *noReportsLabel;
}

@end
