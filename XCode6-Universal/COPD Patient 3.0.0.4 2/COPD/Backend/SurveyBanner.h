//
//  SurveyBanner.h
//  COPD
//
//  Created by Akhil on 17/10/13.
//  Copyright (c) 2013 TKInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "COPDQuery.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"

typedef void (^COPDQueryCompletionBlock_new)(COPDQuery *query, NSError *errorOrNil);
#define GET_SURVEY			@"CheckForSurvey/%@"


@interface SurveyBanner : NSObject
{
	NSString *Survey_title;
	BOOL Survey_attend;
}
@property (nonatomic, retain) NSString *Survey_title;

@property (nonatomic, readwrite)BOOL Survey_attend;


+ (SurveyBanner*)sharedBackend;

- (id)init;
//+ (void)get_survey_update:(NSString *)patient_id password:(NSString *)password block:(void (^)(COPDUser *user, NSError *errorOrNil))block;
//+ (void)get_survey_update:(NSString *)patient_id block:(void(^)(BOOL succeed, NSError *errorOrNil))block;
//+ (void)get_survey_update:(NSString *)username password:(NSString *)password target:(id)target selector:(SEL)selector;
+ (void)get_survey_update:(NSString *)username target:(id)target selector:(SEL)selector;

- (void)queryQuestionsForUserWithDiseaseId:(NSString*)diseaseId WithBlock:(COPDQueryCompletionBlock_new)block;

//-(void)querySurvey_url:(NSString*)survey_id:(NSString*)patient_id: WithBlock:(void(^)(COPDRecord *record,NSMutableDictionary *medications,NSError *errorOrnil))block;


//- (void)queryUserWithId:(NSString*)userId withBlock:(COPDQueryCompletionBlock)block;


- (void)saveInBackground;
@end
