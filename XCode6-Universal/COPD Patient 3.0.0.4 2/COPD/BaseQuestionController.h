#import <UIKit/UIKit.h>
#import "Content.h"
#import "QuestionsViewController.h"

@interface BaseQuestionController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
}

@property (nonatomic, retain) NSDictionary * config;
@property (nonatomic, retain) UITableView * tableView;
@property (nonatomic, retain) COPDRecord * record;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) QuestionsViewController * questionsViewController;
@property (nonatomic, retain) PatientRecord * pRecord;
@property(nonatomic,retain)Questions   *question;
@property (nonatomic, retain) NSMutableArray * patientRecordSet;

- (id)initWithConfig:(NSDictionary *)config;
- (id)initWithQuestion:(Questions *)ques;
- (BOOL)tableViewBased; //default NO
- (BOOL)scrollEnabled; //default NO
- (NSString *)titleForHeaderAtSection:(NSInteger)section;
- (NSString *)helpUrl;
- (BOOL)canGoNext;
- (NSString *)errorText;

@end
