#import <Foundation/Foundation.h>
#import "COPDUser.h"
//2014-02-28 Vipul Amazon SNS
#import <AWSSNS/AWSSNS.h>

extern NSString* sputumConsistencyItems[4];
extern NSString* sputumColorItems[5];
extern NSString* sputumQuantityItems[4];

@class PFUser,PFObject;

typedef enum
{
    TextArea=1,
    OptionType=2,
    CheckBox=3,
    TextField=4,
    DateTime=5,
    On_Off=6,
    DietControl=7,
    VaccinesControl=8
    
} ContentAttributeType;

typedef enum {
    /*ReportStatusUserAcknowledged = 0,
    ReportStatusSentToPatient = 1,
    ReportStatusSentByPatient = 2,
    ReportStatusRecommendedByNurse = 3,
    ReportStatusApprovedBySupervisor = 4*/
    ReportStatusUserAcknowledged = 5,
    ReportStatusSentToPatient = 4,
    ReportStatusSentByPatient = 1,
    ReportStatusRecommendedByNurse = 2,
    ReportStatusApprovedBySupervisor = 3
    
} ReportStatus;

typedef enum {
    ReportNormalLevel = 1,
    ReportMildLevel = 2,
    ReportModerateLevel = 3,
    ReportSevereLevel = 4
} ReportLevel;

typedef enum{
 
    DischargeForm=1,
    PatientInstructionForm=2,
    Wellness_Pateint_EducationForm=3,
    CardiacDischargeForm=4
    
} MorristownDischargeFormType;

typedef enum {
    SingleSelection = 1,
    MultipleSelection = 2,
    Input = 3,
    Range = 4,
    Option = 5,
} QuestionType;

/// Patient Record //
@interface PatientRecord : NSObject  // All answers are stored

// Insert into patient checkin table
@property(nonatomic,retain)NSString * patientID;
@property(nonatomic,retain)NSString * questionID;
@property(nonatomic,retain)NSString * qOptionID;
@property(nonatomic,retain)NSString * checkInValue;
@property(nonatomic,assign)NSUInteger  selectedIndex; // for internal use
@property(nonatomic,assign)BOOL  normal; // for internal use
@property(nonatomic,assign)NSInteger  score; // for internal use
@property(nonatomic,retain)NSString * patientDiseaseID;
@property (nonatomic, retain) NSMutableSet * multipleSet;
@property (nonatomic, retain) NSMutableArray * multipleFields;

// Insert into Patient Report table
@property(nonatomic,assign)NSUInteger levelID;
@property(nonatomic,assign)NSUInteger statusID;

@end

/// Patient Check In //
@interface PatientCheckIn : NSObject 


@property(nonatomic,retain)NSString * questionID;
@property(nonatomic,retain)NSString * qLabel;
@property(nonatomic,retain)NSString * qValue;
@property(nonatomic,assign)NSUInteger qQType;
@end


//Discharge Form Type

@interface DischargeFormType : NSObject
@property(nonatomic,assign)NSString *DFormId;
@property(nonatomic,assign)NSString *DFormTitle;
@property BOOL *DFormStatus;
@end


//Discharge Form Content

@interface DischargeFormContent : NSObject
@property(nonatomic,assign)NSString *DFormTitle;
@property(nonatomic,retain)NSString *DFormValue;

@end

/*@interface PatientReport : NSObject

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * patientId;
@property(nonatomic,retain)NSString * levelName;
@property(nonatomic,retain)NSString * reportId;
@property(nonatomic,retain)NSString * reportStatusName;
@property(nonatomic,retain)NSDate * reportDate;
@property(nonatomic,assign)NSUInteger  levelId;
@property(nonatomic,assign)NSUInteger  reportStatusId;
@end*/

/// Patient Record //
///

extern NSString * painItems[8];

@interface COPDRecord : NSObject 

@property (nonatomic, copy) NSString * Id;
@property (nonatomic, copy) NSString * patientId;
@property (nonatomic, copy) NSDate * date; 
@property (nonatomic, assign) CGFloat breathlessness;
@property (nonatomic, assign) int sputumQuantity;
@property (nonatomic, assign) int sputumColor;
@property (nonatomic, assign) int sputumConsistency;
@property (nonatomic, copy) NSNumber * peakFlowMeasurement1;
@property (nonatomic, copy) NSNumber * peakFlowMeasurement2;
@property (nonatomic, copy) NSNumber * peakFlowMeasurement3;
@property (nonatomic, copy) NSNumber * peakFlowSelectedField;
@property (nonatomic, assign) int peakFlowMeasurement;
@property (nonatomic, assign) BOOL tempOver100;
@property (nonatomic, assign) int beatsPerMinute;
@property (nonatomic, assign) int breathesPerMinute;
@property (nonatomic, assign) BOOL cough;
@property (nonatomic, assign) BOOL wheeze;
@property (nonatomic, assign) BOOL soreThroat;
@property (nonatomic, assign) BOOL nasalCongestion;
@property (nonatomic, assign) ReportStatus reportStatus;
@property (nonatomic, assign) float score;
@property (nonatomic, copy) NSString * treatment;

@property (nonatomic, retain) NSNumber * CHF_feelToday;
@property (nonatomic, retain) NSNumber * CHF_weightToday;
@property (nonatomic, retain) NSNumber * CHF_weightChanged;
@property (nonatomic, retain) NSNumber * CHF_breathingTodayAtRest;
@property (nonatomic, retain) NSNumber * CHF_isSwallen;
@property (nonatomic, retain) NSMutableSet * CHF_bodyPartsWithPain;
@property (nonatomic, retain) NSNumber * CHF_haveNausea;
@property (nonatomic, retain) NSNumber * CHF_beenTakingMedications;
@property (nonatomic, retain) NSNumber * CHF_somebodyChangedWaterPills;
@property (nonatomic, retain) NSNumber * CHF_somebodyChangedHeartMeds;
@property (nonatomic, retain) NSNumber * CHF_experienceRate;
@property (nonatomic, retain) NSNumber * CHF_lowSaltDiet;
@property (nonatomic, retain) NSNumber * CHF_haveTroubleInBed;
@property (nonatomic, retain) NSNumber * CHF_filledPrescriptions;
@property (nonatomic, retain) NSNumber * CHF_understandShedule;
@property (nonatomic, retain) NSNumber * CHF_needHelp;
@property (nonatomic, retain) NSNumber * CHF_nurseVisit;

@property (nonatomic, retain) NSArray * arrCheckIns;
@property(nonatomic,retain)NSString * levelName;
@property(nonatomic,retain)NSString * reportId;
@property(nonatomic,retain)NSString * reportStatusName;
@property(nonatomic,retain)NSDate * reportDate;
@property(nonatomic,assign)NSUInteger  levelId;
@property(nonatomic,assign)NSUInteger  reportStatusId;



- (int)level;

- (BOOL)isGreen;

@end

// Disease ///

@interface Medication : NSObject


@property (nonatomic, assign) NSString * FrequencyCode;
@property (nonatomic, assign) NSString * MedicationDosageValue;
@property (nonatomic, assign) NSString * MedicationTitle;


@end


/// Disease ///

@interface Disease : NSObject

@property(nonatomic,retain)NSString * diseaseID;
@property(nonatomic,retain)NSString * diseaseTitle;

@end

/// Disease ///

/// Questions options //


@interface QuestionOptions : NSObject

@property(nonatomic,assign)NSString * qOptionID; //retain
@property(nonatomic,assign)NSString * questionID;
@property(nonatomic,assign)NSString * qOptionTitle;
@property(nonatomic,assign)NSString * qOptionValue;
@property(nonatomic,assign)NSInteger  qOptionScore;
@property(nonatomic,assign)NSUInteger optionIndex;
@end

/// Questions options //

/// Questions //
@interface Questions : NSObject
@property(nonatomic,assign)NSString * questionID; //retain
@property(nonatomic,assign)NSUInteger questionTypeID;
@property(nonatomic,assign)NSUInteger  questionTemplateID;
@property(nonatomic,assign)NSString * questionTitle;
@property(nonatomic,assign)NSString * questionError;
@property(nonatomic,assign)NSString * questionAlert;
@property(nonatomic,assign)NSString * questionHelp;
@property(nonatomic,retain)NSMutableArray * questionOptions;

@end


//akhil 21-10-13
@interface Survey : NSObject
@property(nonatomic,assign)NSString * surve_name; //retain
@property(nonatomic,assign)NSString * surve_id;
@end
//akhil 21-10-13


@interface Content : NSObject
{
    NSMutableDictionary * soundCache;
}

@property (nonatomic, retain) COPDUser * copdUser;
@property (nonatomic, retain) COPDRecord * activeRecord;
@property (nonatomic, retain) PFUser * user;
@property (nonatomic, retain) NSString *userFirstName;
@property (nonatomic, retain) NSString *userLastName;
@property (nonatomic, retain) NSString *userDischargedDate;
@property (nonatomic, retain) NSString *deviceToken;

@property (nonatomic, retain) NSString* lastUpdatedRecordId;
@property (nonatomic, retain) NSString* lastUpdatedUserId;
@property (nonatomic, retain) NSArray * records;
@property (nonatomic, retain) NSArray * rawRecords;
@property (nonatomic, assign) BOOL recordUpdateReceivedWhileAppWasRunning;
@property (nonatomic, assign) BOOL reloadOccured;

@property (nonatomic, retain) NSMutableArray * messages;

@property (nonatomic, retain) NSString * backendIphoneClientKey;
@property (nonatomic, retain) NSString * backendIphoneApplicationId;
@property (nonatomic, retain) NSString * backendIpadClientKey;
@property (nonatomic, retain) NSString * backendIpadApplicationId;
@property (nonatomic, assign) BOOL userIsSmoker;
@property (nonatomic, retain) NSMutableArray * questions;

@property(nonatomic,retain)NSMutableArray * ary_survey;

@property(nonatomic,assign)NSUInteger  chatCount;
@property(nonatomic,assign)NSUInteger  reportCount;
@property(nonatomic,assign)NSUInteger  allReportsCount;
@property(nonatomic,retain)NSString  * activeReportId;
@property(nonatomic,assign)NSString  * diseaseID;

//2014-02-28 Vipul Amazon SNS
@property (nonatomic, assign) NSString * AccountCode;
@property (nonatomic, assign) NSString * AmazonAccessKey;
@property (nonatomic, assign) NSString * AmazonSecretKey;
@property (nonatomic, assign) NSString * AmazonApplicationARN;
@property (nonatomic, assign) NSString * AmazonDeviceEndpointARN;
//2014-02-28 Vipul Amazon SNS

//akhil 5-11-14
//auto logout
@property(nonatomic,readwrite)NSInteger login_status;
@property(nonatomic,readwrite)NSInteger logout_timer;
//akhil 5-11-14
//auto logout

- (BOOL)isInternetConnection;
- (id) infoPlistValueForKey:(NSString *)key;
- (BOOL)handleInternetConnectivity;
+ (Content *)shared;
- (void)reload;
- (void)handleLogin;
- (void)handleLogout;
- (COPDRecord *)recordFromObject:(PFObject *)rdict;

- (void)initBackendForIphone;
- (void)initBackendForIpad;

- (void)sendRecord:(COPDRecord *)record;
- (void)sendReport:(NSMutableArray *)records Block:(void(^)(NSError *errorOrNil))block;;
- (BOOL)isGreen:(NSMutableArray *)records;

- (void)playSound:(NSString *)fileName;

- (void)checkIfUserSmokerWithCompletiotionBlock:(void (^)())block;
-(void)getQuestions:(void(^)(NSError *errorOrNil))block;

//akhil 21-10-13
-(void)getSurvey:(NSString *)username:(void(^)(NSError *errorOrNil))block;
//akhil 21-10-13


-(void)queryPatientReportById:(NSString*)strReportId WithBlock:(void(^)(COPDRecord *record,NSMutableDictionary *medications,NSError *errorOrnil))block;
-(void)queryPatientAllReports:(void(^)(NSError *errorOrNil))block;
-(void)queryChatHistoryWithPatientDiseaseId:(void(^)(NSError *errorOrNil))block;
- (NSString *)versionString;
-(void)queryDischargeFormDetail:(NSUInteger)iFormType WithBlock:(void(^)(NSMutableArray *data,NSError *errorOrnil))block;
-(void)queryDischargeFormType:(void(^)(NSMutableArray *FormType,NSError *errorOrnil))block;

//2014-02-28 Vipul Amazon SNS
- (AmazonSNSClient*)GetAmazonSNSClient;
-(NSString*)createApplicationEndpoint:(NSString*)endPointDeviceToken;
-(BOOL)subscribeDeviceToTopic:(NSString*)TopicName;
-(void)sendAmazonNotification:(NSString*)Message TopicARN:(NSString*)topicARN EndpointARN:(NSString*)endpointARN;

+(UIAlertView *)universalAlertsWithTitle:(NSString*)title andMessage:(NSString*)message;
//2014-02-28 Vipul Amazon SNS
@end


extern NSString * const kDataWasUpdated;
extern NSString * const kRecordNeedsToBeDisplayed;
extern NSString * const kResponseReceived;
