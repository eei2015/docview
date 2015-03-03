#import <UIKit/UIKit.h>

@class StepsProgressView;
@class BaseViewController;
@class COPDRecord;

@interface QuestionsViewController : UIViewController
{
    CGFloat keyboardHeight;
    UIView * contentView;
    UIButton * nextButton;
    UIButton * prevButton;
    StepsProgressView * stepsProgressView;
    UINavigationController * navigationController;
    BOOL reportConfirmed;
    
    UILabel * errorPopup;
}

@property (nonatomic, retain) COPDRecord * record;
@property (nonatomic, assign) NSMutableArray * questions;
@property (nonatomic, retain) NSMutableArray * patientRecordSet;
@property (nonatomic, retain) NSMutableArray * patientRecordSet_temp;

// Jatin Chauhan 05-Dec-2013
//@property (nonatomic, retain) NSMutableArray * patientRecordSet_after_body;
// -Jatin Chauhan 05-Dec-2013


- (void)reportSent;
- (void)doneClicked;
- (void)nextClicked;
- (void)errorWasFixed;

@end
