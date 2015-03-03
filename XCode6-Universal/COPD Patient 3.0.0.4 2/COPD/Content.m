#import "Content.h"
#import <Parse/Parse.h>
#import "COPDBackend.h"
#import "SBJson.h"
#import "Reachability.h"

//akhil 21-10-13
#import "SurveyBanner.h"
//akhil 21-10-13

//2014-02-28 Vipul Amazon SNS
#import <AWSRuntime/AWSRuntime.h>
//2014-02-28 Vipul Amazon SNS

NSString * const kDataWasUpdated = @"DataWasUpdated";
NSString * const kRecordNeedsToBeDisplayed = @"RecordNeedsToBeDisplayed";
NSString * const kResponseReceived = @"ResponseReceived";

NSString* sputumConsistencyItems[4] = 
{
    @"None",
    @"Watery",
    @"Thin",
    @"Thick"
};

NSString* sputumColorItems[5] = 
{
    @"None",
    @"White",
    @"Yellow",
    @"Green",
    @"Brown"
};

NSString* sputumQuantityItems[4] = 
{
    @"None",
    @"< 1 Tbs.",
    @"≥ 1 Tbs.",
    @"> ¼ C"
};

NSString* painItems[8] =


{
    @"Arms",
    @"Wrists",
    @"Hands",
    @"Abdomen",
    @"Thighs",
    @"Calves",
    @"Ankles",
    @"Feet"
    
};
///

@implementation PatientRecord
@synthesize qOptionID,questionID,checkInValue,levelID,statusID,multipleSet,selectedIndex=_selectedIndex,normal,multipleFields,score;
//
-(void)dealloc
{
    self.qOptionID=nil;
    self.questionID=nil;
    self.checkInValue=nil;
    self.multipleSet=nil;
    self.multipleFields=nil;
    [super dealloc];
}
- (id)init
{
    self = [super init];
    if (self)
    {
        self.score=0;
        self.normal=TRUE;
        self.selectedIndex=-1;
        self.multipleSet=[NSMutableSet set];
        self.multipleFields=[NSMutableArray array];
    }
    return self;
}





@end

/*@implementation PatientReport

@synthesize reportId,reportStatusId,reportStatusName,levelId,levelName,reportDate;

-(void)dealloc
{
    self.reportId=nil;
    self.reportDate=nil;
    self.levelName=nil;
    self.reportStatusName=nil;
    [super dealloc];
}
@end*/
///

@implementation COPDRecord

@synthesize breathlessness;
@synthesize sputumQuantity;
@synthesize sputumColor;
@synthesize sputumConsistency;
@synthesize peakFlowMeasurement;
@synthesize tempOver100;
@synthesize beatsPerMinute;
@synthesize breathesPerMinute;
@synthesize cough;
@synthesize wheeze;
@synthesize soreThroat;
@synthesize nasalCongestion;
@synthesize date;
@synthesize reportStatus;
@synthesize score;
@synthesize Id, patientId,treatment,peakFlowMeasurement1,peakFlowMeasurement2,peakFlowMeasurement3,peakFlowSelectedField;

@synthesize CHF_feelToday,CHF_isSwallen,CHF_haveNausea,CHF_weightToday,CHF_weightChanged,CHF_experienceRate,CHF_bodyPartsWithPain,CHF_breathingTodayAtRest,CHF_beenTakingMedications,CHF_somebodyChangedWaterPills,CHF_somebodyChangedHeartMeds,CHF_lowSaltDiet,CHF_haveTroubleInBed,CHF_needHelp,CHF_understandShedule,CHF_filledPrescriptions,CHF_nurseVisit;
@synthesize arrCheckIns;
@synthesize reportId,reportStatusId,reportStatusName,levelId,levelName,reportDate;

- (id)init
{
    self = [super init];
    if (self)
    {
        breathlessness = -1;
        sputumColor = -1;
        sputumQuantity = -1;
        sputumConsistency = -1;
        self.peakFlowMeasurement1 = self.peakFlowMeasurement2 = self.peakFlowMeasurement3 = [NSNumber numberWithInt: -1];
        self.peakFlowSelectedField = [NSNumber numberWithInt: 0];
        
        self.peakFlowMeasurement = -1;
        
        self.CHF_feelToday = [NSNumber numberWithInt: -1];
        
        self.CHF_weightToday = [NSNumber numberWithInt: -1];
        
        self.CHF_weightChanged = [NSNumber numberWithInt: -1];
        
        self.CHF_breathingTodayAtRest = [NSNumber numberWithInt: -1];
        
        self.CHF_isSwallen = [NSNumber numberWithInt: -1];
        self.CHF_bodyPartsWithPain = [NSMutableSet set];
        self.CHF_haveNausea = [NSNumber numberWithInt: -1];
        
        self.CHF_beenTakingMedications = [NSNumber numberWithInt: -1];
        
        self.CHF_somebodyChangedWaterPills = [NSNumber numberWithInt: -1];
        self.CHF_somebodyChangedHeartMeds = [NSNumber numberWithInt: -1];
        
        self.CHF_experienceRate = [NSNumber numberWithInt: -1];
        self.CHF_lowSaltDiet = [NSNumber numberWithInt: -1];
        self.CHF_haveTroubleInBed = [NSNumber numberWithInt: -1];
        
        self.CHF_filledPrescriptions = [NSNumber numberWithInt: -1];
        self.CHF_understandShedule = [NSNumber numberWithInt: -1];
        self.CHF_needHelp = [NSNumber numberWithInt: -1];
		self.CHF_nurseVisit = [NSNumber numberWithInt: -1];
        
    }
    return self;
}

- (CGFloat)score
{
    if (score > 4.5)
    {
        return 4.5;
    }
    return score;
}

- (int)level
{
    if (self.score < 1.0)
    {
        return 0;
    }
    else if (self.score >= 1.0 && self.score < 2.0)
    {
        return 1;
    }
    else if (self.score >= 2.0 && self.score < 3.0)
    {
        return 2;
    }
    else
    {
        return 3;
    }
}

- (BOOL)isGreen
{
    BOOL isGreen_CHF_feelToday = [self.CHF_feelToday intValue] == 0;
    
    //    BOOL isGreen_CHF_weightToday;
    //
    //    BOOL isGreen_CHF_weightChanged;
    
    BOOL isGreen_CHF_breathingTodayAtRest = [self.CHF_breathingTodayAtRest intValue] == 0;
    
    BOOL isGreen_CHF_isSwallen = ![self.CHF_isSwallen boolValue];
    BOOL isGreen_CHF_bodyPartsWithPain = [self.CHF_bodyPartsWithPain count] == 0;
    BOOL isGreen_CHF_haveNausea = ![self.CHF_haveNausea boolValue];
    
    BOOL isGreen_CHF_beenTakingMedications = [self.CHF_beenTakingMedications boolValue];
    
    BOOL isGreen_CHF_somebodyChangedWaterPills  = ![self.CHF_somebodyChangedWaterPills boolValue];
    BOOL isGreen_CHF_somebodyChangedHeartMeds  = ![self.CHF_somebodyChangedHeartMeds boolValue];
    
    BOOL isGreen_CHF_experienceRate = [self.CHF_experienceRate  intValue] == 0;
    
#if HFB
    BOOL isGreen_CHF_lowSaltDiet = [self.CHF_lowSaltDiet boolValue];
    BOOL isGreen_CHF_haveTroubleInBed = ![self.CHF_haveTroubleInBed boolValue];
    BOOL isGreen_CHF_filledPrescriptions = [self.CHF_filledPrescriptions boolValue];
    BOOL isGreen_CHF_understandShedule = [self.CHF_understandShedule boolValue];
    BOOL isGreen_CHF_needHelp = ![self.CHF_needHelp boolValue];
    
    
    return isGreen_CHF_feelToday && isGreen_CHF_breathingTodayAtRest && isGreen_CHF_isSwallen && isGreen_CHF_bodyPartsWithPain && isGreen_CHF_haveNausea && isGreen_CHF_beenTakingMedications && isGreen_CHF_somebodyChangedWaterPills && isGreen_CHF_somebodyChangedHeartMeds && isGreen_CHF_experienceRate && isGreen_CHF_lowSaltDiet && isGreen_CHF_haveTroubleInBed && isGreen_CHF_filledPrescriptions && isGreen_CHF_understandShedule && isGreen_CHF_needHelp;
#else
    return isGreen_CHF_feelToday && isGreen_CHF_breathingTodayAtRest && isGreen_CHF_isSwallen && isGreen_CHF_bodyPartsWithPain && isGreen_CHF_haveNausea && isGreen_CHF_beenTakingMedications && isGreen_CHF_somebodyChangedWaterPills && isGreen_CHF_somebodyChangedHeartMeds && isGreen_CHF_experienceRate;
#endif
    
}



- (void)dealloc
{
    [peakFlowMeasurement1 release];
    [peakFlowMeasurement2 release];
    [peakFlowMeasurement3 release];
    [peakFlowSelectedField release];
    
    [CHF_feelToday release];
    
    [CHF_weightToday release];
    
    [CHF_weightChanged release];
    
    [CHF_breathingTodayAtRest release];
    
    [CHF_isSwallen release];
    [CHF_bodyPartsWithPain release];
    [CHF_haveNausea release];
    
    [CHF_beenTakingMedications release];
    
    [CHF_somebodyChangedWaterPills release];
    [CHF_somebodyChangedHeartMeds release];
    
    [CHF_experienceRate release];
    [CHF_haveTroubleInBed release];
    [CHF_lowSaltDiet release];

    [CHF_filledPrescriptions release];
    [CHF_understandShedule release];
    [CHF_needHelp release];
	[CHF_nurseVisit release];

    
    self.patientId = nil;
    self.Id = nil;
    self.date = nil;
    [super dealloc];
}

- (int)peakFlowMeasurement
{
    if (peakFlowMeasurement != -1)
    {
        return peakFlowMeasurement;
    }
    return MAX(MAX([peakFlowMeasurement1 intValue], [peakFlowMeasurement2 intValue]),[peakFlowMeasurement3 intValue]);
}

@end

@implementation Medication

@synthesize FrequencyCode,MedicationDosageValue,MedicationTitle;

-(void)dealloc
{
    self.FrequencyCode=nil;
    self.MedicationDosageValue=nil;
    self.MedicationTitle=nil;
    [super dealloc];
}

@end


@implementation PatientCheckIn

@synthesize questionID,qLabel,qValue,qQType;
-(void)dealloc
{
    self.qLabel=nil;
    self.questionID=nil;
    self.qValue=nil;
    [super dealloc];
}

@end

@implementation Disease
@synthesize diseaseID=_diseaseID,diseaseTitle=_diseaseTitle;
//
-(void)dealloc
{
    self.diseaseID=nil;
    self.diseaseTitle=nil;
    [super dealloc];
}
@end

@implementation DischargeFormType

@synthesize DFormId,DFormTitle;
-(void)dealloc
{
    self.DFormTitle=nil;
    self.DFormStatus=nil;
   
    [super dealloc];
}

@end


@implementation DischargeFormContent

@synthesize DFormTitle,DFormValue;
-(void)dealloc
{
    self.DFormTitle=nil;
    self.DFormValue=nil;
    
    [super dealloc];
}

@end


@implementation QuestionOptions
@synthesize qOptionTitle=_qOptionTitle,qOptionID=_qOptionID,questionID=_questionID,qOptionScore=_qOptionScore;
//
-(void)dealloc
{
    self.qOptionTitle=nil;
    self.qOptionID=nil;
    self.questionID=nil;
   // self.qOptionScore=nil;
    [super dealloc];
}
@end


@implementation Questions
@synthesize questionID=_questionID,questionTemplateID=_questionTemplateID,questionTitle=_questionTitle,questionTypeID=_questionTypeID,
questionAlert=_questionAlert,questionError=_questionError,questionHelp=_questionHelp;
//
-(void)dealloc
{
    self.questionTitle=nil;
    self.questionAlert=nil;
    self.questionError=nil;
    self.questionHelp=nil;
    self.questionID=nil;
    
    [super dealloc];
}
-(id)init
{
    self = [super init];
    self.questionOptions=[NSMutableArray array];
    return  self;
}

@end

@implementation Survey
@synthesize surve_id,surve_name;
//
-(void)dealloc
{
    self.surve_id=nil;
    self.surve_id=nil;
    
    
    [super dealloc];
}
-(id)init
{
    self = [super init];
   // self.questionOptions=[NSMutableArray array];
    return  self;
}

@end


@implementation Content
@synthesize user,lastUpdatedRecordId,recordUpdateReceivedWhileAppWasRunning,records = _records, reloadOccured, rawRecords,lastUpdatedUserId, backendIpadClientKey,backendIphoneClientKey,backendIphoneApplicationId,backendIpadApplicationId, messages, userIsSmoker,diseaseID;
@synthesize userFirstName = _userFirstName;
@synthesize userLastName = _userLastName;
@synthesize questions,activeRecord,deviceToken;
@synthesize activeReportId,userDischargedDate;

//akhil 21-10-13
@synthesize ary_survey;

//2014-02-28 Vipul Amazon SNS
@synthesize AmazonAccessKey, AmazonApplicationARN, AmazonSecretKey, AmazonDeviceEndpointARN, AccountCode;
//2014-02-28 Vipul Amazon SNS

//akhil 5-11-14
//auto logout
@synthesize login_status,logout_timer;
//akhil 5-11-14
//auto logout

static Content *sharedInstance;

+ (Content *)shared 
{
	@synchronized(self) 
    {
		if (sharedInstance == nil)
        {
			sharedInstance = [[Content alloc] init];
		}
	}
	 
	return sharedInstance;
}

- (id) infoPlistValueForKey:(NSString *)key
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}
-(void)dealloc
{
    //activeReportId=nil;
    userDischargedDate=nil;
    [super dealloc];
}
- (id)init
{
    self = [super init];
    if (self)
    {
        //2014-02-28 Vipul Amazon SNS
//        self.backendIphoneClientKey = [self infoPlistValueForKey: @"backendIphoneClientKey"];
//        self.backendIphoneApplicationId = [self infoPlistValueForKey: @"backendIphoneApplicationId"];
//        self.backendIpadClientKey = [self infoPlistValueForKey: @"backendIpadClientKey"];
//        self.backendIpadApplicationId = [self infoPlistValueForKey: @"backendIpadApplicationId"];
        
        self.AmazonAccessKey = [self infoPlistValueForKey:@"AmazonAccessKey"];
        self.AmazonSecretKey = [self infoPlistValueForKey:@"AmazonSecretKey"];
        self.AmazonApplicationARN = [self infoPlistValueForKey:@"AmazonPatientApplicationARN"];
        self.AccountCode = [self infoPlistValueForKey:@"AccountCode"];
        //2014-02-28 Vipul Amazon SNS
    }
    return self;
}

/*- (PatientReport *)recordsFromObject:(COPDObject *)obj
{
    PatientReport * record = [[[PatientReport alloc] init] autorelease];
    record.userId=obj.objectId;
    record.patientId=obj.objectId;
    record.levelId=[[obj objectForKey:@"Level_ID_FK"] intValue];
    record.levelName=[obj objectForKey:@"Level_Name"];
    record.reportStatusId=[[obj objectForKey:@"ReportStatus_ID_FK"] intValue];
    record.reportStatusName=[obj objectForKey:@"ReportStatus_Name"];
    record.reportId=[obj objectForKey:@"Report_ID"];
    record.reportDate=[obj objectForKey:@"Report_CreatedDate"];
    
    
    
    return record;
}*/

//- (COPDRecord *)recordFromObject:(PFObject *)rdict
- (COPDRecord *)recordsFromObject:(COPDObject *)obj
{
   // NSLog(@"Obj: %@",[obj objectForKey:@"Report_CreatedDate"]);
   /* NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];*/
    
    COPDRecord * record = [[[COPDRecord alloc] init] autorelease];
    record.Id=obj.objectId;
    record.patientId=obj.objectId;
    record.levelId=[[obj objectForKey:@"Level_ID_FK"] intValue];
    record.levelName=[obj objectForKey:@"Level_Name"];
    record.reportStatusId=[[obj objectForKey:@"ReportStatus_ID_FK"] intValue];
    record.reportStatus = [[obj objectForKey: @"ReportStatus_ID_FK"] intValue];
    record.reportStatusName=[obj objectForKey:@"ReportStatus_Name"];
    record.reportId=[obj objectForKey:@"Report_ID"];
    record.reportDate=obj.createdAt;
    
    NSDictionary *dQuestions=[obj objectForKey:@"Questions"];
    NSMutableArray *arrCIns=[NSMutableArray array];
    NSMutableArray *arrMulti=[NSMutableArray array];
    NSString *strMultiple=@"";
    
    for (NSDictionary *d in dQuestions) {
         PatientCheckIn *pci=nil;
        if ([[d valueForKey:@"QuestionType_ID_FK"] intValue]==MultipleSelection) {
            pci=[[[PatientCheckIn alloc] init] autorelease];
            pci.questionID=[d valueForKey:@"Question_ID_FK"];
            pci.qLabel=[d valueForKey:@"Question_Label"];
            pci.qValue=[d valueForKey:@"QuestionOption_Title"];
            
            pci.qQType=[[d valueForKey:@"QuestionType_ID_FK"] intValue];
            
            [arrMulti addObject:pci];
        
        } else  {
            
            if ([arrMulti count]>0) {
                for (PatientCheckIn *pc in arrMulti) {
                    if ([strMultiple isEqualToString:@""]) {
                        //
                        strMultiple=pc.qValue;
                    } else  {
                        strMultiple=[strMultiple stringByAppendingFormat:@",%@",pc.qValue];
                    }
                }
                pci=[arrMulti objectAtIndex:0];
                pci.questionID=pci.questionID;
                pci.qLabel=pci.qLabel;
                pci.qValue=strMultiple;
                pci.qQType=pci.qQType;
                
                [arrCIns addObject:pci];
            }
            pci=[[[PatientCheckIn alloc] init] autorelease];
            pci.questionID=[d valueForKey:@"Question_ID_FK"];
            pci.qLabel=[d valueForKey:@"Question_Label"];
            pci.qValue=[d valueForKey:@"CheckIn_Value"];
            pci.qQType=[[d valueForKey:@"QuestionType_ID_FK"] intValue];
            
            [arrCIns addObject:pci];
            
            
            [arrMulti removeAllObjects];
            

        }
        
        
    }
   
    
    if ([[obj objectForKey:@"Report_IsActive"] boolValue]==TRUE) {
        self.activeRecord=record;
    }
    record.arrCheckIns=[NSMutableArray arrayWithArray:arrCIns];
    
   // NSLog(@"Med: %@",[obj objectForKey:@"Medication"]);
    
    NSDictionary *dTreatment=[obj objectForKey:@"Medication"];//[NSDictionary dictionaryWithDictionary:[obj objectForKey:@"Medication"]];
    NSString  *strTreatment=@"";
    NSString *strLineBreak=@"";
     NSString *strBrndName=@"";
    if (![dTreatment isEqual:[NSNull null]] && dTreatment.count>0) {
        
        if ([dTreatment isKindOfClass:[NSArray class]]) {
            for (NSDictionary *d in dTreatment) {
                strBrndName=@"";
              //  NSLog(@"D: %@",[d valueForKey:@"Medication_BrandName"]);
                strBrndName=[d valueForKey:@"Medication_BrandName"];
                if (![strTreatment isEqualToString:@""]) {
                    strLineBreak=@"\n";
                }
               //  NSLog(@"D: %@",strBrndName);
               // if (![[d valueForKey:@"Medication_BrandName"] isEqual:[NSNull null]] || [d valueForKey:@"Medication_BrandName"]!=NULL) {
                if (strBrndName.length==0) {
                   strBrndName=@"";//[d valueForKey:@"Medication_BrandName"];
                    strTreatment=[strTreatment stringByAppendingFormat:@"%@%@, %@",strLineBreak,[d valueForKey:@"Medication_Title"],[d valueForKey:@"MedicationDosage_Value"]];
                } else  {
                    strTreatment=[strTreatment stringByAppendingFormat:@"%@%@/%@, %@",strLineBreak,[d valueForKey:@"Medication_Title"],strBrndName,[d valueForKey:@"MedicationDosage_Value"]];
                }
                
            }
        } else {
            strBrndName=@"";
            strBrndName=[dTreatment valueForKey:@"Medication_BrandName"];
            /*if (![[dTreatment valueForKey:@"Medication_BrandName"] isEqual:[NSNull null]] || [dTreatment valueForKey:@"Medication_BrandName"] != NULL) {
                strBrndName=[dTreatment valueForKey:@"Medication_BrandName"];
            }*/
           //  NSLog(@"D: %@",strBrndName);
            if (strBrndName.length==0) {
                strBrndName=@"";//[d valueForKey:@"Medication_BrandName"];
                strTreatment=[strTreatment stringByAppendingFormat:@"%@, %@",[dTreatment valueForKey:@"Medication_Title"],[dTreatment valueForKey:@"MedicationDosage_Value"]];
            } else {
                strTreatment=[strTreatment stringByAppendingFormat:@"%@/%@, %@",[dTreatment valueForKey:@"Medication_Title"],strBrndName,[dTreatment valueForKey:@"MedicationDosage_Value"]];
            }
             
        }
    }
    
   // NSLog(@"Treatment: %@",strTreatment);
    if (![strTreatment isEqualToString:@""]) {
        strTreatment=[strTreatment stringByAppendingFormat:@"\n\n%@",([[obj objectForKey:@"Report_Instructions"] isEqual:[NSNull null]]?@"":[obj objectForKey:@"Report_Instructions"])];
    } else {
        strTreatment=[strTreatment stringByAppendingFormat:@"%@",([[obj objectForKey:@"Report_Instructions"] isEqual:[NSNull null]]?@"":[obj objectForKey:@"Report_Instructions"])];
    }
    record.treatment = strTreatment;
    
  //  NSLog(@"Date :%@",record.reportDate);
   // NSLog(@"Status :%d",record.reportStatusId);
    /*record.Id = rdict.objectId;
    record.patientId = [rdict objectForKey: @"userId"];
    record.date = rdict.createdAt;
    record.reportStatus = [[rdict objectForKey: @"status"] intValue];
    record.treatment = [rdict objectForKey: @"treatment"];
    
#if COPD  
    record.breathlessness = [[rdict objectForKey: @"breathlessness"] floatValue];
    record.sputumQuantity = [[rdict objectForKey: @"sputumQuantity"] intValue];
    record.sputumColor = [[rdict objectForKey: @"sputumColor"] intValue];
    record.sputumConsistency = [[rdict objectForKey: @"sputumConsistency"] intValue];
    record.peakFlowMeasurement = [[rdict objectForKey: @"peakFlowMeasurement"] intValue];
    record.tempOver100 = [[rdict objectForKey: @"tempOver100"] boolValue];
    record.beatsPerMinute = [[rdict objectForKey: @"heartBeatsPerMinute"] intValue];
    record.breathesPerMinute = [[rdict objectForKey: @"breathesPerMinute"] intValue];
    record.cough = [[rdict objectForKey: @"cough"] boolValue];
    record.wheeze = [[rdict objectForKey: @"wheeze"] boolValue];
    record.soreThroat = [[rdict objectForKey: @"soreThroat"] boolValue];
    record.nasalCongestion = [[rdict objectForKey: @"nasalCongestion"] boolValue];
    record.score = [[rdict objectForKey: @"score"] floatValue];

#elif HFBASE
    record.CHF_feelToday = [rdict objectForKey: @"CHF_feelToday"];
    record.CHF_weightToday = [rdict objectForKey: @"CHF_weightToday"];
    record.CHF_weightChanged = [rdict objectForKey: @"CHF_weightChanged"];
    record.CHF_breathingTodayAtRest = [rdict objectForKey: @"CHF_breathingTodayAtRest"];
    record.CHF_isSwallen = [rdict objectForKey: @"CHF_isSwallen"];
    record.CHF_bodyPartsWithPain = [NSMutableSet setWithArray: [rdict objectForKey: @"CHF_bodyPartsWithPain"]];
    record.CHF_haveNausea = [rdict objectForKey: @"CHF_haveNausea"];
    record.CHF_beenTakingMedications = [rdict objectForKey: @"CHF_beenTakingMedications"];
    record.CHF_somebodyChangedWaterPills = [rdict objectForKey: @"CHF_somebodyChangedWaterPills"];
    record.CHF_somebodyChangedHeartMeds  = [rdict objectForKey: @"CHF_somebodyChangedHeartMeds"];
    record.CHF_experienceRate = [rdict objectForKey: @"CHF_experienceRate"];

#elif HFB
    record.CHF_feelToday = [rdict objectForKey: @"CHF_feelToday"];
    record.CHF_weightToday = [rdict objectForKey: @"CHF_weightToday"];
    record.CHF_weightChanged = [rdict objectForKey: @"CHF_weightChanged"];
    record.CHF_breathingTodayAtRest = [rdict objectForKey: @"CHF_breathingTodayAtRest"];
    record.CHF_isSwallen = [rdict objectForKey: @"CHF_isSwallen"];
    record.CHF_bodyPartsWithPain = [NSMutableSet setWithArray: [rdict objectForKey: @"CHF_bodyPartsWithPain"]];
    record.CHF_haveNausea = [rdict objectForKey: @"CHF_haveNausea"];
    record.CHF_beenTakingMedications = [rdict objectForKey: @"CHF_beenTakingMedications"];
    record.CHF_somebodyChangedWaterPills = [rdict objectForKey: @"CHF_somebodyChangedWaterPills"];
    record.CHF_somebodyChangedHeartMeds  = [rdict objectForKey: @"CHF_somebodyChangedHeartMeds"];
    record.CHF_experienceRate = [rdict objectForKey: @"CHF_experienceRate"];
    
    record.CHF_lowSaltDiet = [rdict objectForKey: @"CHF_lowSaltDiet"];
    record.CHF_haveTroubleInBed = [rdict objectForKey: @"CHF_haveTroubleInBed"];
    record.CHF_filledPrescriptions = [rdict objectForKey: @"CHF_filledPrescriptions"];
    record.CHF_understandShedule = [rdict objectForKey: @"CHF_understandShedule"];
    record.CHF_needHelp = [rdict objectForKey: @"CHF_needHelp"];
	record.CHF_nurseVisit = [rdict objectForKey: @"CHF_nurseVisit"];
    
#endif*/
   
    return record;
}
/*
- (void)reload
{
    //[Content cancelPreviousPerformRequestsWithTarget: self selector: @selector(reload) object: nil];
    
    if (!self.user)
    {
        return;
    }

	// Acquire own user info
	PFQuery *ownUserInfo = [PFQuery queryWithClassName:@"PatientInfo"];
	[ownUserInfo whereKey:@"userId" equalTo:self.user.objectId];
	[ownUserInfo findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (objects && [objects count])
		{
			self.userFirstName = [[objects lastObject] valueForKey:@"firstName"];
			self.userLastName = [[objects lastObject] valueForKey:@"lastName"];
			NSLog(@"I'm '%@ %@'.", self.userFirstName, self.userLastName);
		}
	}];

    
#if COPD
    PFQuery * recordsQuery = [PFQuery queryWithClassName: @"COPDRecord"];
#elif HF
    PFQuery * recordsQuery = [PFQuery queryWithClassName: @"CHFRecord"];
#endif

    recordsQuery.limit = INT_MAX;
    [recordsQuery whereKey: @"userId" equalTo: self.user.objectId];
    
    [recordsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        objects = [objects sortedArrayUsingComparator:^NSComparisonResult(PFObject * obj1, PFObject * obj2) {
            NSComparisonResult res = [obj1.createdAt compare: obj2.createdAt];
            if (res == NSOrderedAscending)
            {
                return NSOrderedDescending;
            }
            else if (res == NSOrderedDescending)
            {
                return NSOrderedAscending;
            }
            else
            {
                return NSOrderedSame;
            }
        }];
        
        self.rawRecords = objects;
        
        NSMutableArray * records = [NSMutableArray array];
        
        for (PFObject * rdict in objects)
        {
            [records addObject: [self recordFromObject: rdict]];
        }
        
        PFQuery * q = [PFQuery queryWithClassName: @"Message"];
        q.limit = INT_MAX;
        [q whereKey: @"userId" equalTo: [Content shared].user.objectId];
        [q orderByAscending: @"createdAt"];
        [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.messages = [[objects mutableCopy] autorelease];
            self.records = records;
            self.reloadOccured = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName: kDataWasUpdated object: nil];
            
            if (self.lastUpdatedRecordId && [self.lastUpdatedUserId isEqualToString: self.user.objectId])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName: kRecordNeedsToBeDisplayed object: nil];
            }
            self.lastUpdatedRecordId = nil;
            self.lastUpdatedUserId = nil;
            self.recordUpdateReceivedWhileAppWasRunning = NO;
        }];

        

        
        //[self performSelector: @selector(reload) withObject: nil afterDelay: 60];
    }];

}
*/
-(void)queryPatientAllReports:(void(^)(NSError *errorOrNil))block
{
    COPDBackend *backend = [COPDBackend sharedBackend];
    
    NSString *strPatientDiseaseId=[self.copdUser.objectData valueForKey:@"PatientDisease_ID"];
    
    [backend queryPatientAllReports:strPatientDiseaseId WithBlock:^(COPDQuery *query, NSError *errorOrNil)
     {
         //NSLog(@"%@",query);
          if (query!=nil) {
          
          NSArray *objects = [query.rows sortedArrayUsingComparator:^NSComparisonResult(COPDObject * obj1, COPDObject * obj2)
          {
          NSComparisonResult res = [obj1.createdAt compare: obj2.createdAt];
          if (res == NSOrderedAscending)
          {
              return NSOrderedDescending;
          }
          else if (res == NSOrderedDescending)
          {
          return NSOrderedAscending;
            }
          else
          {
              return NSOrderedSame;
          }
          }];
          
          self.rawRecords = objects;
          
          NSMutableArray *records = [NSMutableArray array];
          
          // NSLog(@"Object: %@",objects);
          
          for (COPDObject *obj in objects)
          {
              //[records addObject:[self recordsFromObject:rdict]];
              COPDRecord * record = [[[COPDRecord alloc] init] autorelease];
              
              record.Id=obj.objectId;
              record.patientId=obj.objectId;
              record.levelId=[[obj objectForKey:@"Level_ID_FK"] intValue];
              //record.levelName=[obj objectForKey:@"Level_Name"];
              record.reportStatusId=[[obj objectForKey:@"ReportStatus_ID_FK"] intValue];
              record.reportStatus = [[obj objectForKey: @"ReportStatus_ID_FK"] intValue];
              //record.reportStatusName=[obj objectForKey:@"ReportStatus_Name"];
              record.reportId=[obj objectForKey:@"Report_ID"];
              record.reportDate=obj.createdAt;
              
              [records addObject:record];
          
          }
              self.records = records;
              block(nil);
          }
          
          
         
         
         
         
    }];
}
-(void)queryPatientReportById:(NSString*)strReportId WithBlock:(void(^)(COPDRecord *record,NSMutableDictionary *medications,NSError *errorOrnil))block
{
    
    
    [[COPDBackend sharedBackend] queryPatientReportById:strReportId WithBlock:^(COPDQuery *query, NSError *errorOrNil) {
        //
        if (errorOrNil==nil) {
            NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
            NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            [formatter setTimeZone:timeZone];
            [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];

             if ([query.rows count]>0) {
                    NSDictionary *data=[query.rows objectAtIndex:0];
                    NSDictionary *reports=[data objectForKey:@"Reports"];
                 
                   
                 
                    COPDObject *rObject = [[[COPDObject alloc] init] autorelease];
                    rObject.objectId=[reports objectForKey:@"Report_ID"];
                    rObject.createdAt=[formatter dateFromString:[reports objectForKey:@"Report_CreatedDate"]];
                 
                    if (![rObject constructFromDictionary:reports])
                    {
                        block(nil,nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
                        return;
                    }
                    COPDRecord *record= [self recordsFromObject:rObject];
                 
                    NSDictionary *pMeds=[data objectForKey:@"pMedications"];
                   NSDictionary *iMeds=[data objectForKey:@"iMedications"];

                 
                 
                 NSMutableDictionary *dictMeds=[NSMutableDictionary dictionary];
                 
                 NSMutableArray *arrInterveneMeds=[NSMutableArray array];
                 
                  NSMutableArray *arrProfileMeds=[NSMutableArray array];
                 
                 
                 if (pMeds && [pMeds count]>0) {
                    
                     
                     if ([pMeds isKindOfClass:[NSArray class]]) {
                         for (NSDictionary *m in pMeds) {
                             
                             Medication *object = [[[Medication alloc] init] autorelease];
                            
                             object.MedicationTitle=[m objectForKey:@"Medication_Title"];
                             object.MedicationDosageValue=[m objectForKey:@"MedicationDosage_Value"];
                             object.FrequencyCode=[m objectForKey:@"Frequency_Code"];
//                             object.FrequencyCode=[m objectForKey:@"Frequency_Title"];
                                 [arrProfileMeds addObject:object];
                         
                         }
                     } else {
                         Medication *object = [[[Medication alloc] init] autorelease];
                         
                       
                         object.MedicationTitle=[pMeds objectForKey:@"Medication_Title"];
                         object.MedicationDosageValue=[pMeds objectForKey:@"MedicationDosage_Value"];
                         object.FrequencyCode=[pMeds objectForKey:@"Frequency_Code"];
//                         object.FrequencyCode=[pMeds objectForKey:@"Frequency_Title"];
                             [arrProfileMeds addObject:object];
                        
                     }

                 }
                 
                 if (iMeds && [iMeds count]>0) {
                     
                     
                     if ([iMeds isKindOfClass:[NSArray class]]) {
                         for (NSDictionary *m in iMeds) {
                             
                             Medication *object = [[[Medication alloc] init] autorelease];
                             
                             object.MedicationTitle=[m objectForKey:@"Medication_Title"];
                             object.MedicationDosageValue=[m objectForKey:@"MedicationDosage_Value"];
                             object.FrequencyCode=[m objectForKey:@"Frequency_Code"];
//                             object.FrequencyCode=[m objectForKey:@"Frequency_Title"];
                             
                             [arrInterveneMeds addObject:object];
                             
                             
                         }
                     } else {
                         Medication *object = [[[Medication alloc] init] autorelease];
                         
                         
                         object.MedicationTitle=[iMeds objectForKey:@"Medication_Title"];
                         object.MedicationDosageValue=[iMeds objectForKey:@"MedicationDosage_Value"];
                         object.FrequencyCode=[iMeds objectForKey:@"Frequency_Code"];
//                         object.FrequencyCode=[iMeds objectForKey:@"Frequency_Title"];
                         
                         [arrInterveneMeds addObject:object];
                         
                     }
                     
                 }
                 [dictMeds setObject:arrInterveneMeds forKey:@"intervene"];
                 [dictMeds setObject:arrProfileMeds forKey:@"profile"];
                 
                 
                    block(record,dictMeds,nil);

             } else {
                 block(nil,nil,nil);
             }
        }
        else {
            block(nil,nil,errorOrNil);
        }
        /*if (errorOrNil==nil) {
            if ([query.rows count]>0) {
                COPDObject *object=[query.rows objectAtIndex:0];
                COPDRecord *record= [self recordsFromObject:object];
                block(record,nil);
            }
           
        } else {
            block(nil,errorOrNil);
        }*/
        
    }];
}
-(void)queryDischargeFormType:(void(^)(NSMutableArray *FormType,NSError *errorOrnil))block
{
    [[COPDBackend sharedBackend] queryPatientDischargeFormTypeWithBlock:^(COPDQuery *query, NSError *errorOrNil) {
        //
        if (errorOrNil==nil) {
            NSMutableArray *arrDFT=[NSMutableArray array];
            for (COPDObject *object in query.rows) {
                DischargeFormType *dft=[[DischargeFormType alloc] init];
                dft.DFormId=[object objectForKey:@"FormType_Id"];
                dft.DFormTitle=[object objectForKey:@"FormType_Title"];
                dft.DFormStatus=[[object objectForKey:@"PDFT_Status"] boolValue];
                self.userDischargedDate=([object.objectData objectForKey:@"DischargedDtae"]==NULL?@"":[object objectForKey:@"DischargedDtae"]);
                [arrDFT addObject:dft];
            }
            block(arrDFT,block);
        }
        
    }];
}
-(void)queryDischargeFormDetail:(NSUInteger)iFormType WithBlock:(void(^)(NSMutableArray *data,NSError *errorOrnil))block

{
    [[COPDBackend sharedBackend] queryPatientDischargeFormDetailWithBlock:iFormType WithBlock:^(COPDQuery *query, NSError *errorOrNil) {
        //
        if (errorOrNil==nil) {
            NSMutableArray *arrDF=[NSMutableArray array];
             if (iFormType==PatientInstructionForm) {
                 for (COPDObject *object in query.rows) {
                     DischargeFormContent *df=[[DischargeFormContent alloc] init];
                     df.DFormTitle=[object objectForKey:@"CA_AppDisplay_Title"];
                     df.DFormValue=[object objectForKey:@"PDF_Value"];
                     [arrDF addObject:df];
                 }
             } else if (iFormType==Wellness_Pateint_EducationForm) {
                for (COPDObject *object in query.rows) {
                    DischargeFormContent *df=[[DischargeFormContent alloc] init];
                    df.DFormTitle=[object objectForKey:@"CA_AppDisplay_Title"];
                    //2014-08-14 Vipul ITAD 3.0 Enhancement
                    //df.DFormValue=[object objectForKey:@"CAV_Title"];
                    df.DFormValue=[object objectForKey:@"PDF_Value"];
                    //2014-08-14 Vipul ITAD 3.0 Enhancement
                    [arrDF addObject:df];
                }
            }else if (iFormType==CardiacDischargeForm) {
                NSUInteger prevCAId=0;
                                
                for (int i=0; i<query.rows.count; i++) { //
                    COPDObject *object=[query.rows objectAtIndex:i];
                    NSUInteger CAId=[[object objectForKey:@"CA_ID_FK"] integerValue];
                    NSUInteger CAType=[[object objectForKey:@"CAT_ID_FK"] integerValue];
                    if (CAId !=prevCAId) {
                        
                        switch (CAType) {
                            case OptionType:
                            case VaccinesControl:
                            {
                                for (int j=1; j<query.rows.count; j++) {
                                    COPDObject *object_1=[query.rows objectAtIndex:j];
                                    NSUInteger CId=[[object_1 objectForKey:@"CA_ID_FK"] integerValue];
                                    NSString *PDFValue=@"";
                                    if (CId==CAId) {
                                        PDFValue=[object_1 objectForKey:@"PDF_Value"];
                                        if (![PDFValue isEqualToString:@"0"]) {
                                            //
                                            DischargeFormContent *df=[[DischargeFormContent alloc] init];
                                            df.DFormTitle=[object_1 objectForKey:@"CA_AppDisplay_Title"];
                                            df.DFormValue=[object_1 objectForKey:@"CAV_Title"];
                                            [arrDF addObject:df];
                                            break;
                                            
                                        }
                                        
                                    }
                                    
                                }
                            }
                                break;
                            case CheckBox:
                            {
                                 NSString *dTitle=[object objectForKey:@"CA_AppDisplay_Title"];
                                NSString *dValue=@"";
                                for (int j=1; j<query.rows.count; j++) {
                                    COPDObject *object_1=[query.rows objectAtIndex:j];
                                    NSUInteger CId=[[object_1 objectForKey:@"CA_ID_FK"] integerValue];
                                    NSString *PDFValue=@"";
                                   
                                    
                                    if (CId==CAId) {
                                        PDFValue=[object_1 objectForKey:@"PDF_Value"];
                                        if (![PDFValue isEqualToString:@"0"]) {
                                            //
                                            if (dValue.length>0) {
                                                dValue=[dValue stringByAppendingFormat:@", %@",[object_1 objectForKey:@"CAV_Title"]];
                                            } else {
                                                dValue=[object_1 objectForKey:@"CAV_Title"];
                                            }
                                           
                                            
                                        }
                                        
                                    }
                                    
                                }
                                DischargeFormContent *df=[[DischargeFormContent alloc] init];
                                df.DFormTitle=dTitle;
                                df.DFormValue=dValue;
                                [arrDF addObject:df];
                            }
                                break;
        
                            case DietControl:
                            {
                                NSString *dTitle=[object objectForKey:@"CA_AppDisplay_Title"];
                                NSString *dValue=@"";
                                for (int j=1; j<query.rows.count; j++) {
                                    COPDObject *object_1=[query.rows objectAtIndex:j];
                                    NSUInteger CId=[[object_1 objectForKey:@"CA_ID_FK"] integerValue];
                                    NSString *PDFValue=@"";
                                    
                                    
                                    if (CId==CAId) {
                                        PDFValue=[object_1 objectForKey:@"PDF_Value"];
                                        if (![PDFValue isEqualToString:@"0"]) {
                                            //
                                            if (dValue.length>0) {
                                                if ([[object_1 objectForKey:@"CAV_Title"] caseInsensitiveCompare:@"other"]==NSOrderedSame) {
                                                    dValue=([object_1 objectForKey:@"PDF_Value"]==NULL?[dValue stringByAppendingFormat:@"%@",@""]:[dValue stringByAppendingFormat:@", %@",[object_1 objectForKey:@"PDF_Value"]]);
                                                } else {
                                                     dValue=[dValue stringByAppendingFormat:@", %@",[object_1 objectForKey:@"CAV_Title"]];
                                                }
                                            
                                            } else {
                                                if ([[object_1 objectForKey:@"CAV_Title"] caseInsensitiveCompare:@"other"]==NSOrderedSame) {
                                                    dValue=([object_1 objectForKey:@"PDF_Value"]==NULL?@"":[object_1 objectForKey:@"PDF_Value"]);
                                                } else {
                                                    dValue=[object_1 objectForKey:@"CAV_Title"];
                                                }
                                                
                                            }
                                            
                                            
                                        }
                                        
                                    }
                                    
                                }
                                DischargeFormContent *df=[[DischargeFormContent alloc] init];
                                df.DFormTitle=dTitle;
                                df.DFormValue=dValue;
                                [arrDF addObject:df];
                            }
                                break;
                            case DateTime:
                            case TextArea:
                            case TextField:
                                
                            {
                                
                                // in case of [NSNull null] values a nil is returned ...
                                
                               // NSLog(@"strVal: %@",[object objectForKey:@"PDF_Value"]);
                                DischargeFormContent *df=[[DischargeFormContent alloc] init];
                                df.DFormTitle=[object objectForKey:@"CA_AppDisplay_Title"];
                                df.DFormValue=([object.objectData objectForKey:@"PDF_Value"]==NULL?@"":[object objectForKey:@"PDF_Value"]);
                                
                               // NSLog(@" df.DFormValue: %@", df.DFormValue);
                                [arrDF addObject:df];
                            }
                                break;
                            default:
                                break;
                        }
                       
                    }
                   
                    prevCAId=[[object objectForKey:@"CA_ID_FK"] integerValue];
                                    
                }
            }
           // NSLog(@"Count: %d",[arrDF count]);
            block(arrDF,block);
        }
    }];
}
-(void)queryChatHistoryWithPatientDiseaseId:(void(^)(NSError *errorOrNil))block
{
    [[COPDBackend sharedBackend] queryChatHistoryWithPatientDiseaseId:[self.copdUser objectForKey:@"PatientDisease_ID"] WithBlock:^(COPDQuery *query, NSError *errorOrNil) {
        //
        if (query!=nil) {
            self.messages = [[query.rows mutableCopy] autorelease];
            
            
        } else {
            self.messages=[NSMutableArray array];
        }
     block(errorOrNil);
     
    }];
}
- (void)reload
{
   // [Content cancelPreviousPerformRequestsWithTarget: self selector: @selector(reload) object: nil];
    
    //if (!self.user)
    @try {
        if (!self.copdUser)
        {
            return;
        }
        
        COPDBackend *backend = [COPDBackend sharedBackend];
        
        [backend cancelPreviousPerformRequests];
        
        NSString *strPatientDiseaseId=[self.copdUser.objectData valueForKey:@"PatientDisease_ID"];
        self.diseaseID=[self.copdUser.objectData valueForKey:@"Disease_ID"];
        
        
        // NSLog(@"%@",self.copdUser.objectData);
        
        self.userFirstName = [self.copdUser.objectData valueForKey:@"Patient_FirstName"];
        self.userLastName = [self.copdUser.objectData  valueForKey:@"Patient_LastName"];
        self.userIsSmoker=[[self.copdUser.objectData  valueForKey:@"isSmoker"] boolValue];
        
      // NSLog(@"start:%@",[NSDate  date]);
        
        [backend queryPatientUnreadMessage:strPatientDiseaseId Patient:self.copdUser.objectId WithBlock:^(COPDQuery *query, NSError *errorOrNil) {
            //
         //  NSLog(@"end:%@, Error: %@",[NSDate  date],errorOrNil);
            if (errorOrNil==nil) {
                if ([query.rows count]>0) {
                    self.activeReportId=[query.rows objectAtIndex:0];// active report id
                    self.chatCount=[[query.rows objectAtIndex:1] integerValue]; // new chat count
                    self.reportCount=[[query.rows objectAtIndex:2] integerValue]; //new report count
                    self.allReportsCount=[[query.rows objectAtIndex:3] integerValue]; //new report count
                }
                self.reloadOccured = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName: kDataWasUpdated object: nil];
                if (self.lastUpdatedRecordId && [self.lastUpdatedUserId isEqualToString: self.copdUser.objectId])
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName: kRecordNeedsToBeDisplayed object: nil];
                }
                self.lastUpdatedRecordId = nil;
                self.lastUpdatedUserId = nil;
                self.activeRecord=nil;
                self.recordUpdateReceivedWhileAppWasRunning = NO;
            } else {
                
            }
            
            
        }];
    }
    @catch (NSException *exception) {
        //
        NSLog(@"Exp: %@",exception);
    }
    
    
	/*[backend queryReportsByPatientDiseaseId:strID WithBlock:^(COPDQuery *query, NSError *errorOrNil)
     {
         //NSLog(@"%@",query);
        /* if (query!=nil) {
             
         NSArray *objects = [query.rows sortedArrayUsingComparator:^NSComparisonResult(COPDObject * obj1, COPDObject * obj2)
                             {
                                 NSComparisonResult res = [obj1.createdAt compare: obj2.createdAt];
                                 if (res == NSOrderedAscending)
                                 {
                                     return NSOrderedDescending;
                                 }
                                 else if (res == NSOrderedDescending)
                                 {
                                     return NSOrderedAscending;
                                 }
                                 else
                                 {
                                     return NSOrderedSame;
                                 }
                             }];
         
         self.rawRecords = objects;
         
         NSMutableArray *records = [NSMutableArray array];
         
        // NSLog(@"Object: %@",objects);
         
             for (COPDObject *rdict in objects)
             {
                 [records addObject:[self recordsFromObject:rdict]];
                 
             }
             self.records = records;
         }
         
         [[COPDBackend sharedBackend] queryChatHistoryWithPatientId:[Content shared].copdUser.objectId WithBlock:^(COPDQuery *query, NSError *errorOrNil) {
             //
             if (query!=nil) {
                 self.messages = [[query.rows mutableCopy] autorelease];
                 
                 
             } else {
                 self.messages=[NSMutableArray array];
             }
             if (errorOrNil==nil) {
                 self.reloadOccured = YES;
                 [[NSNotificationCenter defaultCenter] postNotificationName: kDataWasUpdated object: nil];
                 
                 if (self.lastUpdatedRecordId && [self.lastUpdatedUserId isEqualToString: self.copdUser.objectId])
                 {
                     [[NSNotificationCenter defaultCenter] postNotificationName: kRecordNeedsToBeDisplayed object: nil];
                 }
                 self.lastUpdatedRecordId = nil;
                 self.lastUpdatedUserId = nil;
                 self.recordUpdateReceivedWhileAppWasRunning = NO;
             }
             
         }];*/
         
        
         
         /*   if (self.lastUpdatedRecordId != COPD_BACKEND_INVALID_OBJECT && (self.lastUpdatedUserId == self.user.objectId))
          {
          [[NSNotificationCenter defaultCenter] postNotificationName: kRecordNeedsToBeDisplayed object: nil];
          }
          self.lastUpdatedRecordId = COPD_BACKEND_INVALID_OBJECT;
          self.lastUpdatedUserId = COPD_BACKEND_INVALID_OBJECT;
          self.recordUpdateReceivedWhileAppWasRunning = NO;
          
          [query release];
          
          [self performSelector: @selector(reload) withObject: nil afterDelay: 60];*/
   //  }];
}
//===================
//akhil 21-10-13
-(void):(NSString *)username:(void(^)(NSError *errorOrNil))block;
{
    SurveyBanner * backend = [SurveyBanner sharedBackend];
    
    [backend queryQuestionsForUserWithDiseaseId:username WithBlock:^(COPDQuery *query, NSError *errorOrNil) {
        //
        if (errorOrNil) {
            //
            block(errorOrNil);
            return;
        }
        
        NSMutableArray *response=[NSMutableArray arrayWithArray:query.rows];
        
        self.ary_survey=[NSMutableArray array];
        
        for (COPDObject *obj in response) {
            //   NSLog(@"response: %@",obj.objectData);
            
            Survey *q=[[[Survey alloc] init] autorelease];
            q.surve_id=[obj objectForKey:@"SurveyID"];
            q.surve_name=[obj objectForKey:@"SurveyID"];
            
            NSLog(@"survey name = %@",q.surve_name);
            NSLog(@"survey id = %@",q.surve_id);

           /* q.questionTitle=[obj objectForKey:@"Question_Title"];
            q.questionError=[obj objectForKey:@"Question_Error"];
            q.questionAlert=[obj objectForKey:@"Question_AlertMessage"];
            q.questionHelp=[obj objectForKey:@"Question_Help"];
            q.questionTypeID=[[obj objectForKey:@"QuestionType_ID_FK"] intValue];*/
            
          /*  NSArray *dictOptions=[obj objectForKey:@"QuestionOptions"];
            if (dictOptions.count>0) {
                for (NSDictionary *dOpt in dictOptions) {
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                    QuestionOptions *qp=[[[QuestionOptions alloc] init] autorelease];
                    qp.questionID=[obj objectForKey:@"Question_ID"];
                    qp.qOptionID=[dOpt objectForKey:@"QuestionOption_ID"];
                    qp.qOptionTitle=[dOpt objectForKey:@"QuestionOption_Title"];
                    qp.qOptionValue=[dOpt objectForKey:@"QuestionOption_Value"];
                    qp.qOptionScore=[[dOpt objectForKey:@"QuestionOption_Score"] intValue];
                    [q.questionOptions addObject:qp];
                    [pool drain];
                    
                }
                [self.ary_survey addObject:q];
                
            }*/
             [self.ary_survey addObject:q];
            NSLog(@"self ary survay = %@",self.ary_survey);
            
        }
        
        block(nil);
        
        
    }];

   // [backend queryQuestionsForUserWithDiseaseId:username WithBlock:^(COPDQuery *query, NSError *errorOrNil) {
    //}

}
//akhil 21-10-13
//===================


-(void)getQuestions:(void(^)(NSError *errorOrNil))block
{
    COPDBackend *backend= [COPDBackend sharedBackend];
    NSString *strDiseaseID=[backend.currentUser objectForKey:@"Disease_ID"];
    
    [backend queryQuestionsForUserWithDiseaseId:strDiseaseID WithBlock:^(COPDQuery *query, NSError *errorOrNil) {
        //
        if (errorOrNil) {
            //
            block(errorOrNil);
            return;
        }
        
        NSMutableArray *response=[NSMutableArray arrayWithArray:query.rows];
        
        self.questions=[NSMutableArray array];
        
        for (COPDObject *obj in response) {
         //   NSLog(@"response: %@",obj.objectData);
             
                Questions *q=[[[Questions alloc] init] autorelease];
                q.questionID=[obj objectForKey:@"Question_ID"];
                q.questionTemplateID=[[obj objectForKey:@"QuestionTemplate_ID_FK"] intValue];
                q.questionTitle=[obj objectForKey:@"Question_Title"];
                q.questionError=[obj objectForKey:@"Question_Error"];
                q.questionAlert=[obj objectForKey:@"Question_AlertMessage"];
                q.questionHelp=[obj objectForKey:@"Question_Help"];
                q.questionTypeID=[[obj objectForKey:@"QuestionType_ID_FK"] intValue];
                
                NSArray *dictOptions=[obj objectForKey:@"QuestionOptions"];
                if (dictOptions.count>0) {
                    for (NSDictionary *dOpt in dictOptions) {
                        NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                        QuestionOptions *qp=[[[QuestionOptions alloc] init] autorelease];
                        qp.questionID=[obj objectForKey:@"Question_ID"];
                        qp.qOptionID=[dOpt objectForKey:@"QuestionOption_ID"];
                        qp.qOptionTitle=[dOpt objectForKey:@"QuestionOption_Title"];
                        qp.qOptionValue=[dOpt objectForKey:@"QuestionOption_Value"];
                        qp.qOptionScore=[[dOpt objectForKey:@"QuestionOption_Score"] intValue];
                        [q.questionOptions addObject:qp];
                        [pool drain];
                        
                    }
             [self.questions addObject:q];  
                
            }
        
        }
     
     block(nil);
        

    }];
}

- (void)handleLogin
{
    
    
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound];
    
    // Tell Parse about the device token.
    // Subscribe to the global broadcast channel.
    
  /*  @try {
        NSString *strChannel=[NSString stringWithFormat: @"user%@",self.copdUser.objectId];
     
        [self initBackendForIphone];
        NSError * error = nil;
        NSSet * channels = [PFPush getSubscribedChannels: &error];
        for (NSString * s in channels)
        {
            [PFPush unsubscribeFromChannel: s error: &error];
        }
        
     //   BOOL isSucceed=[PFPush subscribeToChannel: strChannel error: &error];
        
        [PFPush subscribeToChannelInBackground:strChannel block:^(BOOL succeeded, NSError *error) {
            //
                
                NSMutableDictionary *data=[[[NSMutableDictionary alloc] init] autorelease];
                [data setObject:strChannel forKey:@"ParseChannels"];
                [data setObject:@"patient" forKey:@"UserRole"];
                [data setObject:@"ios" forKey:@"DeviceType"];
                [data setObject:(self.deviceToken)?self.deviceToken:@"" forKey:@"DeviceToken"];
                [data setObject:self.copdUser.objectId forKey:@"CreatedBy"];
                [data setObject:[NSString stringWithFormat:@"%u",succeeded] forKey:@"Status"];
                [data setObject:(error)?error.description:@"" forKey:@"ParseMessage"];
                // NSLog(@"%u",isSucceed);
                // NSLog(@"%@",error);
                
                [[COPDBackend sharedBackend] saveNotificationSubscriptionInBackground:data WithBlock:^(NSError *errorOrNil) {
                    //
                    
                }];

        
           
        }];
        
               
        //NSLog(@"%u",isSucceed);
        // NSLog(@"subscribed to channel %@",  [NSString stringWithFormat: @"user%@",self.copdUser.objectId]);
        
        
      //  [self initBackendForIpad];
    }
    @catch (NSException *exception) {
        //
    }
    @finally {
        //
    }*/
   
}

- (void)handleLogout
{
    self.userIsSmoker = NO;
    self.reloadOccured = NO;
    //[self initBackendForIphone];
   // [PFPush unsubscribeFromChannelInBackground: user.objectId];
    self.user = nil;
   // [self initBackendForIpad];
}

- (void)initBackendForIphone
{
    //NSLog(@"initBackendForIphone: [%@] [%@]",self.backendIphoneApplicationId,self.backendIphoneClientKey);
    [Parse setApplicationId: self.backendIphoneApplicationId clientKey: self.backendIphoneClientKey];
    NSLog(@"IPHONE appid %@ and clientkey %@ ",self.backendIphoneApplicationId,self.backendIphoneClientKey);
}

- (void)initBackendForIpad
{
    //NSLog(@"initBackendForIpad: [%@] [%@]",self.backendIpadApplicationId,self.backendIpadClientKey);
    [Parse setApplicationId: self.backendIpadApplicationId clientKey: self.backendIpadClientKey];
    NSLog(@"IPAD appid %@ and clientkey %@ ",self.backendIpadApplicationId,self.backendIpadClientKey);
}

- (void)calcScoreForRecord:(COPDRecord *)record
{
    PFQuery * q = [PFQuery queryWithClassName: @"PatientInfo"];
    [q whereKey: @"userId" equalTo: [Content shared].user.objectId];
    
    PFObject * patientInfo = nil;
    
    NSArray * objects = [q findObjects];
    
    if ([objects count] == 0)
    {
        patientInfo = [PFObject objectWithClassName: @"PatientInfo"];
    }
    else
    {
        patientInfo = [objects lastObject];
    }
    
    float bl_breathlessness = [[patientInfo objectForKey: @"blBreathlessness"] floatValue];
    int bl_sputumQuantity = [[patientInfo objectForKey: @"blSputumQuantity"] intValue];
    int bl_sputumColor = [[patientInfo objectForKey: @"blSputumColor"] intValue];
    int bl_sputumConsistency = [[patientInfo objectForKey: @"blSputumConsistency"] intValue];
    int bl_peakFlowMeasurement = [[patientInfo objectForKey: @"blPeakFlow"] intValue];
    //int bl_tempOver100 = [[patientInfo objectForKey: @"blTempOver100"] boolValue];
    int bl_cough = [[patientInfo objectForKey: @"blCough"] boolValue];
    int bl_wheeze = [[patientInfo objectForKey: @"blWheeze"] boolValue];
    int bl_soreThroat = [[patientInfo objectForKey: @"blSoreThroat"] boolValue];
    int bl_nasalCongestion = [[patientInfo objectForKey: @"blNasalCongestion"] boolValue];
    
    
    record.score = 0;
    
    //Add 1.0 if breathless is >= 3 increments above baseline value.
    if (record.breathlessness > bl_breathlessness)
    {
        if (record.breathlessness - bl_breathlessness >= 3)
        {
            record.score += 1.0;
        }
    }
    
    //Add 0.5 if sputum quantity is higher than baseline.
    if (record.sputumQuantity > bl_sputumQuantity)
    {
        record.score += 0.5;
    }
    
    
    if (record.sputumQuantity > 0)
    {
        //Add 0.5 if sputum color is None or White and changes to Yellow, Green or Brown.
        //Add 0.5 if sputum color is None, White, Brown or Yellow and changes to Green.
        
        if (bl_sputumColor == 0 || bl_sputumColor == 1)
        {
            if (record.sputumColor == 2 || record.sputumColor == 3 || record.sputumColor == 4) 
            {
                record.score += 0.5;
            }
        }
        else if (bl_sputumColor == 0 || bl_sputumColor == 1 ||  bl_sputumColor == 2 ||  bl_sputumColor == 4)
        {
            if (record.sputumColor == 3) 
            {
                record.score += 0.5;
            }
        }
        
        //2.5 max
        
        //Add 0.5 if sputum consistency is change from baseline and change is from none/watery/thin to Thick.
        
        if (bl_sputumConsistency != record.sputumConsistency && record.sputumConsistency == 3)
        {
            record.score += 0.5;
        }
    }

    
    //Add 1.0 if peak flow measurement is less than or equal to 80% of baseline value.
    
    CGFloat m = 0.8*bl_peakFlowMeasurement;
    
    if (record.peakFlowMeasurement <= m)
    {
        record.score += 1.0;
    }
    
    //Add 0.5 if temperate is over 100.
    
    if (record.tempOver100) 
    {
        record.score += 0.5;
    }
    
    
    //Add 0.5 is 2 or more minor symptoms (cough, wheeze, sore throat, nasal congestion) are YES and a change from baseline.
    
    int minor = 0;
    
    if (record.cough && !bl_cough)
    {
        minor++;
    }
    
    if (record.wheeze && !bl_wheeze)
    {
        minor++;
    }
    
    if (record.soreThroat && !bl_soreThroat)
    {
        minor++;
    }
    
    if (record.nasalCongestion && !bl_nasalCongestion)
    {
        minor++;
    }
    
    if (minor >= 2)
    {
        record.score += 0.5;
    }
}
///
- (BOOL)isGreen:(NSMutableArray *)records
{
    
    BOOL green=TRUE;
    for (PatientRecord *rec in records) {
        
        if(rec.score>0 || rec.multipleSet.count>0)
        {
            green=FALSE;
            break;
        }
    }
    
    return  green;
    
}
- (void)sendRecord:(COPDRecord *)record
{
}
//
/*
#if COPD
- (void)sendRecord:(COPDRecord *)record
{
    PFQuery * recordsQuery = [PFQuery queryWithClassName: @"COPDRecord"];
    [recordsQuery whereKey: @"userId" equalTo: [Content shared].user.objectId];
    
    NSArray * allRecordsForUser = [recordsQuery findObjects];
    
    for (PFObject * rec in allRecordsForUser)
    {
        if ([[rec objectForKey: @"status"] intValue] != ReportStatusUserAcknowledged)
        {
            [rec setObject:[NSNumber numberWithInt: ReportStatusUserAcknowledged] forKey:@"status"];
            [rec save];
        }
    }
    
    [self calcScoreForRecord: record];
    
    PFObject* result = [PFObject objectWithClassName:@"COPDRecord"];
    
    [result setObject: [Content shared].user.objectId forKey:@"userId"];
    
    [result setObject:[NSNumber numberWithFloat:record.breathlessness] forKey:@"breathlessness"];
    [result setObject:[NSNumber numberWithInt:record.sputumQuantity] forKey:@"sputumQuantity"];
    [result setObject:[NSNumber numberWithInt:record.sputumColor] forKey:@"sputumColor"];
    [result setObject:[NSNumber numberWithInt:record.sputumConsistency] forKey:@"sputumConsistency"];
    [result setObject:[NSNumber numberWithInt:record.peakFlowMeasurement] forKey:@"peakFlowMeasurement"];
    [result setObject:[NSNumber numberWithBool:record.tempOver100] forKey:@"tempOver100"];
    [result setObject:[NSNumber numberWithInt:record.beatsPerMinute] forKey:@"heartBeatsPerMinute"];
    [result setObject:[NSNumber numberWithInt:record.breathesPerMinute] forKey:@"breathesPerMinute"];
    
    [result setObject:[NSNumber numberWithBool:record.cough] forKey:@"cough"];
    [result setObject:[NSNumber numberWithBool:record.wheeze] forKey:@"wheeze"];
    [result setObject:[NSNumber numberWithBool:record.soreThroat] forKey:@"soreThroat"];
    [result setObject:[NSNumber numberWithBool:record.nasalCongestion] forKey:@"nasalCongestion"];
    
    
    [result setObject:[NSNumber numberWithFloat: record.score] forKey: @"score"];
    
    if (record.score < 1)
    {
        [result setObject:[NSNumber numberWithInt: ReportStatusUserAcknowledged] forKey:@"status"]; 
    }
    else
    {
        [result setObject:[NSNumber numberWithInt: ReportStatusSentByPatient] forKey:@"status"]; 
    }
    
    [result save];
    record.Id = result.objectId;
    
    NSMutableDictionary *data = [[[NSMutableDictionary alloc] init] autorelease];
    [data setObject: [NSString stringWithFormat: @"New report received from %@", [[Content shared].user valueForKey: @"username"]] forKey:@"alert"];
    [data setObject:[NSNumber numberWithInt:1] forKey:@"badge"];
    [data setObject: [Content shared].user.objectId forKey:@"userId"];
    NSError * error = nil;
    [PFPush sendPushDataToChannel: @"" withData: data error: &error];
}
#endif

#if HFBASE
- (void)sendRecord:(COPDRecord *)record
{
    PFQuery * recordsQuery = [PFQuery queryWithClassName: @"CHFRecord"];
    [recordsQuery whereKey: @"userId" equalTo: [Content shared].user.objectId];
    
    NSArray * allRecordsForUser = [recordsQuery findObjects];
    
    for (PFObject * rec in allRecordsForUser)
    {
        if ([[rec objectForKey: @"status"] intValue] != ReportStatusUserAcknowledged)
        {
            [rec setObject:[NSNumber numberWithInt: ReportStatusUserAcknowledged] forKey:@"status"];
            [rec save];
        }
    }
    
    if (![record.CHF_isSwallen boolValue]) {
        record.CHF_haveNausea = [NSNumber numberWithInt: NO];
        record.CHF_bodyPartsWithPain = [NSMutableSet set];
    }
    
    PFObject* result = [PFObject objectWithClassName:@"CHFRecord"];
    
    [result setObject: [Content shared].user.objectId forKey:@"userId"];
    
    
    [result setObject: record.CHF_feelToday forKey:@"CHF_feelToday"];
    
    [result setObject: record.CHF_weightToday forKey:@"CHF_weightToday"];
    
    [result setObject: record.CHF_weightChanged forKey:@"CHF_weightChanged"];
    
    [result setObject: record.CHF_breathingTodayAtRest forKey:@"CHF_breathingTodayAtRest"];
    
    [result setObject: record.CHF_isSwallen forKey:@"CHF_isSwallen"];
    [result setObject: [record.CHF_bodyPartsWithPain allObjects] forKey:@"CHF_bodyPartsWithPain"];
    [result setObject: record.CHF_haveNausea forKey:@"CHF_haveNausea"];
    
    [result setObject: record.CHF_beenTakingMedications forKey:@"CHF_beenTakingMedications"];
    
    [result setObject: record.CHF_somebodyChangedWaterPills forKey:@"CHF_somebodyChangedWaterPills"];
    [result setObject: record.CHF_somebodyChangedHeartMeds forKey:@"CHF_somebodyChangedHeartMeds"];
    
    [result setObject: record.CHF_experienceRate forKey:@"CHF_experienceRate"];
    
    if ([record isGreen])
    {
        [result setObject:[NSNumber numberWithInt: ReportStatusUserAcknowledged] forKey:@"status"];
    }
    else
    {
        [result setObject:[NSNumber numberWithInt: ReportStatusSentByPatient] forKey:@"status"];
    }
   
    
    NSError * error = nil;
    [result save: &error];
    
    NSLog(@"%@",error);
    
    record.Id = result.objectId;
    
    NSMutableDictionary *data = [[[NSMutableDictionary alloc] init] autorelease];
    [data setObject: [NSString stringWithFormat: @"New report received from %@", [[Content shared].user valueForKey: @"username"]] forKey:@"alert"];
    [data setObject:[NSNumber numberWithInt:1] forKey:@"badge"];
    [data setObject: [Content shared].user.objectId forKey:@"userId"];
    error = nil;
    [PFPush sendPushDataToChannel: @"" withData: data error: &error];
    NSLog(@"%@",error);
}
#endif

#if HFB
- (void)sendRecord:(COPDRecord *)record
{
    PFQuery * recordsQuery = [PFQuery queryWithClassName: @"CHFRecord"];
    [recordsQuery whereKey: @"userId" equalTo: [Content shared].user.objectId];
    
    NSArray * allRecordsForUser = [recordsQuery findObjects];
    
    for (PFObject * rec in allRecordsForUser)
    {
        if ([[rec objectForKey: @"status"] intValue] != ReportStatusUserAcknowledged)
        {
            [rec setObject:[NSNumber numberWithInt: ReportStatusUserAcknowledged] forKey:@"status"];
            [rec save];
        }
    }
    
    if (![record.CHF_isSwallen boolValue]) {
        record.CHF_haveNausea = [NSNumber numberWithInt: NO];
        record.CHF_bodyPartsWithPain = [NSMutableSet set];
        record.CHF_haveTroubleInBed = [NSNumber numberWithInt: NO];
    }
    
    PFObject* result = [PFObject objectWithClassName:@"CHFRecord"];
    
    [result setObject: [Content shared].user.objectId forKey:@"userId"];
    

    [result setObject: record.CHF_feelToday forKey:@"CHF_feelToday"];
    
    [result setObject: record.CHF_weightToday forKey:@"CHF_weightToday"];
    
    [result setObject: record.CHF_weightChanged forKey:@"CHF_weightChanged"];
    
    [result setObject: record.CHF_breathingTodayAtRest forKey:@"CHF_breathingTodayAtRest"];
    
    [result setObject: record.CHF_isSwallen forKey:@"CHF_isSwallen"];
    [result setObject: [record.CHF_bodyPartsWithPain allObjects] forKey:@"CHF_bodyPartsWithPain"];
    [result setObject: record.CHF_haveNausea forKey:@"CHF_haveNausea"];
    
    [result setObject: record.CHF_beenTakingMedications forKey:@"CHF_beenTakingMedications"];
    
    [result setObject: record.CHF_somebodyChangedWaterPills forKey:@"CHF_somebodyChangedWaterPills"];
    [result setObject: record.CHF_somebodyChangedHeartMeds forKey:@"CHF_somebodyChangedHeartMeds"];
    
    [result setObject: record.CHF_experienceRate forKey:@"CHF_experienceRate"];
    
    [result setObject: record.CHF_lowSaltDiet forKey:@"CHF_lowSaltDiet"];
    [result setObject: record.CHF_haveTroubleInBed forKey:@"CHF_haveTroubleInBed"];
    [result setObject: record.CHF_filledPrescriptions forKey:@"CHF_filledPrescriptions"];
    [result setObject: record.CHF_understandShedule forKey:@"CHF_understandShedule"];
    [result setObject: record.CHF_needHelp forKey:@"CHF_needHelp"];
	[result setObject: record.CHF_nurseVisit forKey:@"CHF_nurseVisit"];
    
    if ([record isGreen])
    {
        [result setObject:[NSNumber numberWithInt: ReportStatusUserAcknowledged] forKey:@"status"];
    }
    else
    {
        [result setObject:[NSNumber numberWithInt: ReportStatusSentByPatient] forKey:@"status"];
    }
    
    NSError * error = nil;
    [result save: &error];
    
    NSLog(@"%@",error);
    
    record.Id = result.objectId;
    
    NSMutableDictionary *data = [[[NSMutableDictionary alloc] init] autorelease];
    [data setObject: [NSString stringWithFormat: @"New report received from %@", [[Content shared].user valueForKey: @"username"]] forKey:@"alert"];
    [data setObject:[NSNumber numberWithInt:1] forKey:@"badge"];
    [data setObject: [Content shared].user.objectId forKey:@"userId"];
    error = nil;
    [PFPush sendPushDataToChannel: @"" withData: data error: &error];
    NSLog(@"%@",error);
}
#endif
 */
- (void)sendReport:(NSMutableArray *)records Block:(void (^)(NSError *))block
{
    @try {
        NSDictionary *PatientCheckInData=nil;
        NSMutableArray *arrRecords=[NSMutableArray array];
        BOOL isGreen=TRUE;
        for (PatientRecord *rec in records) {
            //
            
            ///  NSLog(@"%@",rec.qOptionID);
            // NSLog(@"%@",rec.questionID);
            // NSLog(@"Question ID : %@",rec.questionID);
            //NSLog(@"Normal : %d",rec.score);
            
            PatientCheckInData=[NSDictionary dictionaryWithObjectsAndKeys:
                                rec.questionID,@"Question_ID_FK",
                                rec.qOptionID,@"QuestionOption_ID_FK",
                                rec.checkInValue,@"CheckIn_Value",
                                nil];
            
            [arrRecords addObject:PatientCheckInData];
            /*if(isGreen==TRUE  && (!rec.normal || rec.multipleSet.count>0))
            {
                isGreen=FALSE;
               
            }*/
            if(isGreen==TRUE  && (rec.score>0 || rec.multipleSet.count>0))
            {
                isGreen=FALSE;
                
            }
            
        }
        
        
        //NSLog(@"%@",PatientCheckInData);
        //  [[[Content shared].user objectData] objectForKey:@"PatientDisease_ID_FK"],@"PatientDisease_ID_FK",
        //[Content shared].user.objectId,@"Patient_ID_FK",
        
        // NSLog(@"PD : %@",[[[COPDBackend sharedBackend] currentUser] objectData]);
        
        //NSLog(@"P : %@",[[COPDBackend sharedBackend] currentUser].objectId);
        
       // NSLog(@"Green: %u",isGreen);
        NSDictionary *dictPatientData=[NSDictionary dictionaryWithObjectsAndKeys:
                                       [[[[COPDBackend sharedBackend] currentUser] objectData] objectForKey:@"PatientDisease_ID"],@"PatientDisease_ID_FK",
                                       [[COPDBackend sharedBackend] currentUser].objectId,@"Patient_ID_FK",
                                       (isGreen)?[NSString stringWithFormat:@"%d",ReportNormalLevel]:[NSString stringWithFormat:@"%d",ReportSevereLevel],@"Level_ID_FK",
                                       [NSString stringWithFormat:@"%d",ReportStatusSentByPatient],@"ReportStatus_ID_FK",arrRecords,@"PatientCheckInDetails",nil];
        
        
        //SBJsonWriter *jsonWriter = [[[SBJsonWriter alloc] init] autorelease];
        
        //NSString *jsonString = [jsonWriter stringWithObject:dictPatientData];  // for web service
        
       // NSLog(@"JSON : %@",jsonString);
        
        // NSLog(@"%@",arrRecords);
        //NSLog(@"%d",[arrRecords count]);
        
        COPDObject* result = [[[COPDObject alloc] init] autorelease];
        
        result.objectData=[NSMutableDictionary dictionaryWithDictionary:dictPatientData];
        // result.objectJSON=jsonString;
        
        
        
        [result saveInBackgroundWithBlock:^(BOOL succeed, NSError *errorOrNil) {
            //
            if (succeed && errorOrNil==nil) {
                NSMutableDictionary *data = [[[NSMutableDictionary alloc] init] autorelease];
                
                //2014-01-30 Vipul Push notification message use first name
                //[data setObject: [NSString stringWithFormat: @"New report received from %@", [Content shared].copdUser.username] forKey:@"alert"];
                [data setObject: [NSString stringWithFormat: @"New report received from %@", [Content shared].userFirstName] forKey:@"alert"];
                //2014-01-30 Vipul Push notification message use first name
                
                [data setObject:[NSNumber numberWithInt:1] forKey:@"badge"];
                [data setObject: [Content shared].copdUser.objectId forKey:@"userId"];
                [data setObject:@"1" forKey:@"checkin"];
                
                
                NSMutableDictionary *notifyData=[[[NSMutableDictionary alloc] init] autorelease];
                [notifyData setObject:@"" forKey:@"ParseChannels"];
                [notifyData setObject:[data JSONRepresentation] forKey:@"Notification_Text"];
                [notifyData setObject:self.copdUser.objectId forKey:@"CreatedBy"];
                
                
                 NSError *error = nil;
                //
                
                //2014-03-04 Vipul Amazon SNS
//                [self initBackendForIpad];
//                BOOL succeed=[PFPush sendPushDataToChannel: @"" withData: data error: &error];
                [[Content shared] sendAmazonNotification:[NSString stringWithFormat: @"New report received from %@", [Content shared].userFirstName] TopicARN:@"Clinician" EndpointARN:nil];                
                //2014-03-04 Vipul Amazon SNS
                
                [notifyData setObject:@"0" forKey:@"IsFromChat"];
                [notifyData setObject:[NSString stringWithFormat:@"%u",succeed] forKey:@"Status"];
                [notifyData setObject:(error)?error:@"" forKey:@"ParseMessage"];
                
                block(errorOrNil);
                
                [[COPDBackend sharedBackend] saveNotificationInBackground:notifyData WithBlock:^(NSError *errorOrNil) {
                    //
                   // block(errorOrNil);
                }];
                
                COPDObject * newMessage =[[[COPDObject alloc] init] autorelease];
                //2014-01-30 Vipul Push notification message use first name
                //[newMessage setObject: [NSString stringWithFormat: @"%@ acknowledged treatment", [Content shared].copdUser.username] forKey: @"Chat_Message"];
                [newMessage setObject: [NSString stringWithFormat: @"%@ acknowledged treatment", [Content shared].userFirstName] forKey: @"Chat_Message"];
                //2014-01-30 Vipul Push notification message use first name
                [newMessage setObject: self.copdUser.objectId forKey: @"CreatedBy"];
                [newMessage setObject: self.copdUser.objectId forKey: @"PatientID_FK"];
                [newMessage setObject: [self.copdUser objectForKey:@"PatientDisease_ID"] forKey: @"PatientDiseaseID_FK"];
                [newMessage setObject: self.diseaseID forKey: @"Disease_ID"];
                [newMessage setObject: [NSNumber numberWithInt:ReportStatusSentByPatient] forKey: @"ReportStatus_ID_FK"];
                [newMessage setObject: [NSNumber numberWithInt: YES] forKey: @"IsFromPatient"];
                [newMessage setObject: [NSNumber numberWithInt: NO] forKey: @"IsPatientAcknowledged"];
                [newMessage setObject:[NSString stringWithFormat:@"%@ %@", self.userFirstName, [Content shared].userLastName] forKey:@"SenderFullName"];
                
                [newMessage saveChatInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    NSLog(@"ERR: %@",error);
                }];
               /* [PFPush sendPushDataToChannelInBackground:@"" withData:data block:^(BOOL succeeded, NSError *error) {
                    //
                    [notifyData setObject:@"0" forKey:@"IsFromChat"];
                    [notifyData setObject:[NSString stringWithFormat:@"%u",succeeded] forKey:@"Status"];
                    [notifyData setObject:(error)?error:@"" forKey:@"ParseMessage"];
                    
                    [[COPDBackend sharedBackend] saveNotificationInBackground:notifyData WithBlock:^(NSError *errorOrNil) {
                        //
                    }];
                    
                }];*/
            }
        }];
        
        
        
               
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"Error %@",exception);
    }
    @finally {
        //
    }
    
    
}


- (void)playSound:(NSString *)fileName
{

        if (!soundCache)
        {
            soundCache = [[NSMutableDictionary alloc] init];
        }
        NSNumber * sid = [soundCache objectForKey: fileName];
        if (!sid)
        {
            NSURL*pathURL = [NSURL fileURLWithPath : [[NSBundle mainBundle] pathForResource : fileName ofType : nil]];
            SystemSoundID audioEffect;
            AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &audioEffect);
            sid = [NSNumber numberWithUnsignedInteger: audioEffect];
        }
        AudioServicesPlaySystemSound([sid unsignedIntegerValue]);
}

- (void)checkIfUserSmokerWithCompletiotionBlock:(void (^)())block
{
   /* PFQuery * q = [PFQuery queryWithClassName: @"PatientInfo"];
    [q whereKey: @"userId" equalTo: user.objectId];
    
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        PFObject * patientInfo = [objects lastObject];
        if (patientInfo)
        {
            self.userIsSmoker = [[patientInfo objectForKey: @"smoker"] boolValue];
        }
        block();
    }];*/
    
}

- (BOOL)isInternetConnection
{
	Reachability *reachability = [Reachability reachabilityForInternetConnection];
	NetworkStatus networkStatus = [reachability currentReachabilityStatus];
	return !(networkStatus == NotReachable);
}
-(BOOL)handleInternetConnectivity
{
    if (![self isInternetConnection]) {
        [[[[UIAlertView alloc] initWithTitle:@"Error !!" message:@"No Internet Connection. Please make sure you are connected to the Internet via WiFi or 3G." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        return false;
    }
    return true;
}
- (NSString *)versionString
{    NSString * version=  [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
    return [NSString stringWithFormat: @"v %@ (%u)", version, [[[UIDevice currentDevice] uniqueIdentifier] hash]];
}

//2014-02-28 Vipul Amazon SNS
-(AmazonSNSClient*)GetAmazonSNSClient
{
    AmazonSNSClient* snsClient = [[AmazonSNSClient alloc] initWithAccessKey:self.AmazonAccessKey withSecretKey:self.AmazonSecretKey];
    snsClient.endpoint = [AmazonEndpoints snsEndpoint:US_WEST_2];
    
    return snsClient;
    
}

-(BOOL)subscribeDeviceToTopic:(NSString*)TopicName{
    
    
    //Find Topic if already exists
    NSString *TopicARN = nil;
    
    NSString *topicNameToFind = [NSString stringWithFormat:@":%@_%@", TopicName, self.AccountCode];
    NSString *nextToken = nil;
    do {
        SNSListTopicsRequest *listTopicsRequest = [[[SNSListTopicsRequest alloc] initWithNextToken:nextToken] autorelease];
        SNSListTopicsResponse *response = [[self GetAmazonSNSClient] listTopics:listTopicsRequest];
        if(response.error != nil)
        {
            NSLog(@"Error: %@", response.error);
            //return nil;
        }
        
        for (SNSTopic *topic in response.topics) {
            if ( [topic.topicArn hasSuffix:topicNameToFind]) {
                TopicARN = topic.topicArn;
                break;                
            }
        }        
        nextToken = response.nextToken;
    } while (nextToken != nil);
    //
    
    if(TopicARN == nil)
    {
        //If Topic is not there then create a new topic
        SNSCreateTopicRequest *ctr = [[[SNSCreateTopicRequest alloc] initWithName:[NSString stringWithFormat:@"%@_%@", TopicName, self.AccountCode]] autorelease];
        SNSCreateTopicResponse *CretaeTopicResponse = [[self GetAmazonSNSClient] createTopic:ctr];
        if(CretaeTopicResponse.error != nil)
        {
            NSLog(@"Error: %@", CretaeTopicResponse.error);
            return nil;
        }
        
        // Adding the DisplayName attribute to the Topic allows for SMS notifications.
        SNSSetTopicAttributesRequest *st = [[[SNSSetTopicAttributesRequest alloc] initWithTopicArn:CretaeTopicResponse.topicArn andAttributeName:@"DisplayName" andAttributeValue:[NSString stringWithFormat:@"%@_%@", TopicName, self.AccountCode]] autorelease];
        SNSSetTopicAttributesResponse *setTopicAttributesResponse = [[self GetAmazonSNSClient] setTopicAttributes:st];
        if(setTopicAttributesResponse.error != nil)
        {
            NSLog(@"Error: %@", setTopicAttributesResponse.error);
            return nil;
        }
        
        TopicARN = CretaeTopicResponse.topicArn;
        //
    }
    
    //Find Endpoint(Device) if already subscribed to Topic
    SNSListEndpointsByPlatformApplicationRequest *le = [[[SNSListEndpointsByPlatformApplicationRequest alloc] init] autorelease];
    le.platformApplicationArn = self.AmazonApplicationARN;
    SNSListEndpointsByPlatformApplicationResponse *response = [[self GetAmazonSNSClient] listEndpointsByPlatformApplication:le];
    if(response.error != nil)
    {
        NSLog(@"Error: %@", response.error);
        [[Content universalAlertsWithTitle:@"Device can not be Subscribe" andMessage:response.error.description] show];
        return NO;
    }
    bool isDeviceSubscribed = NO;
    do {
        for(int i=0;i<[response.endpoints count];i++)
        {
            SNSEndpoint *Endpoints = (SNSEndpoint*) [response.endpoints objectAtIndex:i];
            NSMutableDictionary *EndpointAttributes = (NSMutableDictionary*) [Endpoints attributes];
            if([[EndpointAttributes objectForKey:@"Token"] isEqualToString:deviceToken])
            {
                self.AmazonDeviceEndpointARN = Endpoints.endpointArn;
                isDeviceSubscribed = YES;
                break;
            }
        }
    }
    while (response.nextToken != nil);
    //
    
    //Subscribed Endpoint(Device) to Topic if not subscribed
    if(!isDeviceSubscribed)
    {
        SNSCreatePlatformEndpointRequest *endpointReq = [[SNSCreatePlatformEndpointRequest alloc] init];
        endpointReq.platformApplicationArn = [[Content shared] AmazonApplicationARN];
        endpointReq.token = deviceToken;
        //
        //[[Content shared] deviceToken];
        
        SNSCreatePlatformEndpointResponse *endpointResponse = [[self GetAmazonSNSClient] createPlatformEndpoint:endpointReq];
           if (endpointResponse.error != nil) {
               NSLog(@"Error: %@", endpointResponse.error);
               //[[Constants universalAlertsWithTitle:@"CreateApplicationEndpoint Error" andMessage:endpointResponse.error.userInfo.description] show];
               //return NO;
           }
        
        self.AmazonDeviceEndpointARN = endpointResponse.endpointArn;
        
        SNSSubscribeRequest *sr = [[SNSSubscribeRequest alloc] initWithTopicArn:TopicARN andProtocol:@"application" andEndpoint:endpointResponse.endpointArn] ;
                
        SNSSubscribeResponse *subscribeResponse = [[self GetAmazonSNSClient] subscribe:sr];
               
        if(subscribeResponse.error != nil)
        {
            NSLog(@"Error: %@", subscribeResponse.error);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[Content universalAlertsWithTitle:@"Subscription Error" andMessage:subscribeResponse.error.userInfo.description] show];
            });
            
            return NO;
        }        
        return YES;
    }
    else
        return YES;
    //
}

-(void)sendAmazonNotification:(NSString*)Message TopicARN:(NSString*)topicARN EndpointARN:(NSString *)endpointARN
{
    
    NSString *TopicARN = nil;
    
    NSString *topicNameToFind = [NSString stringWithFormat:@":%@", [NSString stringWithFormat:@"%@_%@", topicARN, self.AccountCode]];
    NSString *nextToken = nil;
    do {
        SNSListTopicsRequest *listTopicsRequest = [[[SNSListTopicsRequest alloc] initWithNextToken:nextToken] autorelease];
        SNSListTopicsResponse *response = [[self GetAmazonSNSClient] listTopics:listTopicsRequest];
        if(response.error != nil)
        {
            NSLog(@"Error: %@", response.error);
            //return nil;
        }
        
        for (SNSTopic *topic in response.topics) {
            if ( [topic.topicArn hasSuffix:topicNameToFind]) {
                TopicARN = topic.topicArn;
                break;
            }
        }
        nextToken = response.nextToken;
    } while (nextToken != nil);
    //
    
    if(TopicARN == nil)
    {
        //If Topic is not there then create a new topic
        SNSCreateTopicRequest *ctr = [[[SNSCreateTopicRequest alloc] initWithName:[NSString stringWithFormat:@"%@_%@", topicARN, self.AccountCode]] autorelease];
        SNSCreateTopicResponse *CretaeTopicResponse = [[self GetAmazonSNSClient] createTopic:ctr];
        if(CretaeTopicResponse.error != nil)
        {
            NSLog(@"Error: %@", CretaeTopicResponse.error);
            //return nil;
        }
        
        // Adding the DisplayName attribute to the Topic allows for SMS notifications.
        SNSSetTopicAttributesRequest *st = [[[SNSSetTopicAttributesRequest alloc] initWithTopicArn:CretaeTopicResponse.topicArn andAttributeName:@"DisplayName" andAttributeValue:[NSString stringWithFormat:@"%@_%@", topicARN, self.AccountCode]] autorelease];
        SNSSetTopicAttributesResponse *setTopicAttributesResponse = [[self GetAmazonSNSClient] setTopicAttributes:st];
        if(setTopicAttributesResponse.error != nil)
        {
            NSLog(@"Error: %@", setTopicAttributesResponse.error);
            //return nil;
        }
        
        TopicARN = CretaeTopicResponse.topicArn;
        //
    }    
    
    SNSPublishRequest *pRequest = [[SNSPublishRequest alloc] init];
    if (endpointARN != nil)
    {
        pRequest.targetArn = self.AmazonDeviceEndpointARN;
        pRequest.message = [NSString stringWithFormat:@"%@%@%@", @"{\"APNS\":\"{\\\"aps\\\":{\\\"alert\\\":\\\"", Message, @"\\\",\\\"sound\\\":\\\"default\\\"}}\"}"];
    }
        //@"arn:aws:sns:us-west-2:772930350700:endpoint/APNS/Amazon_SNS_Demo_Patient/680dddea-111a-3f4f-bdd2-5aaad53ab7a1";
        //
        //[self createApplicationEndpoint:endpointDeviceToken];
    else if (topicARN != nil)
    {
        pRequest.topicArn = TopicARN;
        pRequest.message = [NSString stringWithFormat:@"%@%@%@", @"{\"default\": \"test\", \"APNS\": \"{\\\"aps\\\":{\\\"alert\\\":\\\"", Message, @"\\\",\\\"sound\\\":\\\"default\\\",\\\"App\\\":\\\"Patient\\\"}}\"}"];
    }
        //@"arn:aws:sns:us-west-2:772930350700:Patient";
        //
    else
    {
        [[Content universalAlertsWithTitle:@"Notification error" andMessage:@"Endpoint not found!!!"] show];
        return;
    }
    //pRequest.topicArn = @"arn:aws:sns:us-west-2:772930350700:Amazon_SNS_Demo_Topic";
    //pRequest.message = Message;
    pRequest.messageStructure = @"json";
    
    SNSPublishResponse *pResponse = [[self GetAmazonSNSClient] publish:pRequest];
    if(pResponse.error != nil)
        [[Content universalAlertsWithTitle:@"Notification error" andMessage:pResponse.error.description] show];
}

+(UIAlertView *)universalAlertsWithTitle:(NSString*)title andMessage:(NSString*)message {
    return [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
}
//2014-02-28 Vipul Amazon SNS


@end
