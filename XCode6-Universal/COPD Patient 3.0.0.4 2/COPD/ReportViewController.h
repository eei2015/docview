#import <UIKit/UIKit.h>
#import "Content.h"

@interface ReportViewController : UITableViewController
{
	BOOL shouldShowReportsList;
	UINavigationController *parentController;
}

@property (nonatomic, retain) COPDRecord * record;
//@property (nonatomic, retain) PatientReport * record;
@property (nonatomic, assign) BOOL shouldShowReportsList;
@property (nonatomic, assign) UINavigationController *parentController;
@property (nonatomic, retain) NSMutableArray * pMedications;
@property (nonatomic, retain) NSMutableArray * iMedications;

-(void)updateReportView:(NSString *)strReportId;

@end
