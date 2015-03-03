#import <Foundation/Foundation.h>

#import "COPDUser.h"
#import "COPDQuery.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"

//#define DISEASE_ID                  @"e6ca32c7-cf71-4ab4-8f1d-e4799ddf2074"

//#define COPD_BASE_URL @"http://it3stage.docviewsolutions.com/Docviewservice/IpadServiceData.svc/" // STAGE

//#define COPD_BASE_URL @"http://it3.docviewsolutions.com/Docviewservice/IpadServiceData.svc/" // LIVE
//#define COPD_BASE_URL	@"http://192.168.1.24/RestService/IpadServiceData.svc/" //LOCAL

#define VALIDATE_PATIENT			@"ValidatePatient"
#define COPD_PROFILE_PATH			@"GetPatientCredentials"
#define SIGNUP_PATH                 @"SetNewPatient"
#define DISEASE_QUESTION_PATH       @"GetQuestionsByDiseaseID/%@"
#define SAVE_DATA_PATH				@"SetPatientCheckInData"
#define USER_REPORT_PATH			@"GetPatientReportsByID/%@"
#define UPDATE_REPORTSTATUS			@"SetPatientReportStatusByID"
#define NOTIFICATION_SUBSCRIPTION    @"SetNotificationSubscription"
#define NEW_NOTIFICATION            @"SetNewNotification"
#define NEW_CHAT                    @"SetNewChat"
#define UPDATE_CHAT                    @"UpdateChat"
#define GET_CHAT_HISTORY             @"GetChatHistoryByPatientDiseaseID/%@"
#define GET_PATIENT_ACTIVE_REPORTSTATUS  @"GetPatientActiveReportStatus/%@"
#define COPD_USERS_PATH				@"users/"
#define COPD_REPORTS_PATH			@"users/%d/reports/"
#define COPD_SINGLE_REPORT_PATH			@"users/%d/reports/%d/"
#define COPD_SINGLE_USER_PATH			@"users/%d/"
#define COPD_ALL_REPORTS_PATH			@"users/all/reports/"
//NEW

#define PATIENT_UNREAD_MESSAGE  @"GetPatientUnreadMessage"
#define PATIENT_REPORT          @"GetPatientReportByID"
#define PATIENT_ALL_REPORTS          @"GetPatientAllReportsByID/%@"
#define PATIENT_DISCHARGE_FORMTYPE          @"GetPatientDischargeFormType/%@"
#define PATIENT_DISCHARGE_FORM_DETAIL          @"GetPatientDischargeFormDetail"

typedef void (^COPDQueryCompletionBlock)(COPDQuery *query, NSError *errorOrNil);


@interface COPDBackend : NSObject
{
	COPDUser *currentUser;
    COPDQuery *currentQuery;
	NSString *baseUrl;
    //Added by Pankil : 09-24-2013
    NSString *accountcode;
    //Added by Pankil : 09-24-2013
    
    //Added by Pankil For New Parameter : 10-04-2013
    NSString *disease_name;
    //Added by Pankil For New Parameter : 10-04-2013
    
    AFHTTPClient * httpClient;
}

@property(nonatomic, retain) COPDUser *currentUser;
@property (nonatomic, retain) COPDQuery * currentQuery;
@property(nonatomic, retain) NSString *baseUrl;
//Added by Pankil : 09-24-2013
@property(nonatomic, retain) NSString *accountcode;
@property(nonatomic, retain) NSString *disease_name;
//Added by Pankil : 09-24-2013

+ (COPDBackend*)sharedBackend;

- (id)init;
-(void)cancelPreviousPerformRequests;
- (void)queryAllUsersWithBlock:(COPDQueryCompletionBlock)block;
- (void)queryUserWithId:(NSString*)userId withBlock:(COPDQueryCompletionBlock)block;

// IMPORTANT: FOR THOSE 2 METHODS COPDQuery should be release
- (COPDQuery*)queryReportsForUserWithId:(NSString*)userId;
- (void)queryReportsForUserWithId:(NSString*)userId WithBlock:(COPDQueryCompletionBlock)block;


- (void)queryReportsForAllUsersWithBlock:(COPDQueryCompletionBlock)block;

- (void)queryQuestionsForUserWithDiseaseId:(NSString*)diseaseId WithBlock:(COPDQueryCompletionBlock)block;
- (void)queryReportsByPatientDiseaseId:(NSString*)patientDiseaseId WithBlock:(COPDQueryCompletionBlock)block;
- (void)logOut;
-(void)saveNotificationSubscriptionInBackground:(NSDictionary *)param WithBlock:(void(^)(NSError *errorOrNil))block;
-(void)saveNotificationInBackground:(NSDictionary *)param WithBlock:(void(^)(NSError *errorOrNil))block;
- (void)queryChatHistoryWithPatientDiseaseId:(NSString*)patientDiseaseId WithBlock:(COPDQueryCompletionBlock)block;
- (void)updateChatWithPatientDiseaseId:(NSString*)patientDiseaseId WithBlock:(void(^)(NSError *errorOrNil))block;

//NEW
- (void)queryPatientActiveReportStatus:(NSString*)patientId WithBlock:(COPDQueryCompletionBlock)block;
-(void)queryPatientReportById:(NSString*)strReportId WithBlock:(COPDQueryCompletionBlock)block;
-(void)queryPatientUnreadMessage:(NSString*)strPatientDiseaseId Patient:(NSString*)patientId WithBlock:(COPDQueryCompletionBlock)block;
-(void)queryPatientAllReports:(NSString*)strPatientDiseaseId WithBlock:(COPDQueryCompletionBlock)block;
- (void)queryPatientDischargeFormDetailWithBlock:(NSUInteger)iFormType WithBlock:(COPDQueryCompletionBlock)block;
- (void)queryPatientDischargeFormTypeWithBlock:(COPDQueryCompletionBlock)block;
- (void)saveStatusInBackground:(NSDictionary*)param WithBlock:(void(^)(NSError *errorOrNil))block;
@end
