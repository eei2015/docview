#import "COPDBackend.h"
#import "Content.h"
#import "SBJson.h"

@implementation COPDBackend

@synthesize currentUser, baseUrl,currentQuery,accountcode;

//akhil 16-10-13
@synthesize disease_name;

- (id) infoPlistValueForKey:(NSString *)key
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}

- (id)init
{
	self = [super init];

	self.currentUser = [[[COPDUser alloc] init] autorelease];
	self.baseUrl = [self infoPlistValueForKey:@"BaseUrl"];
    
    //Added by Pankil : 09-24-2013
    self.accountcode = [self infoPlistValueForKey:@"AccountCode"];
    //Added by Pankil : 09-24-2013
    
    //Added by Pankil For New Parameter : 10-04-2013
    self.disease_name =[self infoPlistValueForKey:@"Disease Name"];
    //Added by Pankil For New Parameter : 10-04-2013

	return self;
}

- (void)dealloc
{
	self.currentUser = nil;
	[super dealloc];
}

+ (COPDBackend*)sharedBackend
{
	static COPDBackend *backend = nil;

	if (!backend)
	{
		backend = [[COPDBackend alloc] init];
	}

	return backend;
}

- (void)logOut
{
	self.currentUser = nil;
}
-(void)cancelPreviousPerformRequests
{
    if ([self httpClient]) {
        [[[self httpClient] operationQueue] cancelAllOperations];
    }
}

- (AFHTTPClient *)httpClient
{
    
    if (!httpClient)
    {
        httpClient = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString:[COPDBackend sharedBackend].baseUrl]];
    }
    return httpClient;
}
- (void)queryQuestionsForUserWithDiseaseId:(NSString*)diseaseId WithBlock:(COPDQueryCompletionBlock)block
{
    
    if ([[Content shared] handleInternetConnectivity]) {
        if (!self.currentUser)
        {
            block(nil, [NSError errorWithDomain:@"COPDBackend" code:10 userInfo:nil]);
            return;
        }
        AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[COPDBackend sharedBackend].baseUrl]] autorelease];
        
        
        // NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:diseaseId,@"id", nil];
        //[client setAuthorizationHeaderWithUsername:username password:password];
        [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [client setDefaultHeader:@"Accept" value:@"application/json"];
        client.parameterEncoding = AFJSONParameterEncoding;
        //  NSLog(@"%@",param);
        
        [client getPath:[NSString stringWithFormat:DISEASE_QUESTION_PATH, diseaseId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //
            
            COPDQuery *result = [[[COPDQuery alloc] init] autorelease];
           //  NSLog(@"Response: %@",[responseObject objectForKey:@"GetQuestionsByDiseaseIDResult"]);
            
            for (NSDictionary *record in [responseObject objectForKey:@"GetQuestionsByDiseaseIDResult"])
            {
                //    NSLog(@"Response: %d",record.count);
                
                COPDObject *obj = [[[COPDObject alloc] init] autorelease];
                
                if (![obj constructFromDictionary:record])
                {
                    block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
                    return;
                }
                
                
                [result.rows addObject:obj];
            }
            
            block(result, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //
            NSLog(@"%@",error);
            block(nil, [NSError errorWithDomain:@"COPDBackend" code:9 userInfo:nil]);
            
        }];
    }

    
    
	


}
- (void)saveStatusInBackground:(NSDictionary*)param  WithBlock:(void(^)(NSError *errorOrNil))block
{
	// guarantee that we won't crash
	[self retain];
    
	AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[COPDBackend sharedBackend].baseUrl]] autorelease];
    
	//[client setAuthorizationHeaderWithUsername:[COPDBackend sharedBackend].currentUser.username password:[COPDBackend sharedBackend].currentUser.password];
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    client.parameterEncoding = AFJSONParameterEncoding;
    
    //NSLog(@"Object: %@",param);
    
    [client postPath:UPDATE_REPORTSTATUS parameters:param
             success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         /*NSString *responseString = [[[NSString alloc] initWithBytes:[(NSData*)responseObject bytes] length:[(NSData*)responseObject length] encoding:NSUTF8StringEncoding] autorelease];
          
          [self constructFromString:responseString];*/
         [self release];
         block(Nil);
     }
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [self release];
         block(error);
     }];
    
}
- (void)queryAllUsersWithBlock:(COPDQueryCompletionBlock)block
{
    
    if ([[Content shared] handleInternetConnectivity]) {
        if (!self.currentUser)
        {
            block(nil, [NSError errorWithDomain:@"COPDBackend" code:4 userInfo:nil]);
            return;
        }
        
        AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:self.baseUrl]] autorelease];
        
        [client setAuthorizationHeaderWithUsername:self.currentUser.username password:self.currentUser.password];
        [client getPath:COPD_USERS_PATH parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             COPDQuery *result = [[[COPDQuery alloc] init] autorelease];
             
             NSString *responseString = [[[NSString alloc] initWithBytes:[(NSData*)responseObject bytes] length:[(NSData*)responseObject length] encoding:NSUTF8StringEncoding] autorelease];
             
             if (!responseString)
             {
                 block(nil, [NSError errorWithDomain:@"COPDBackend" code:5 userInfo:nil]);
                 return;
             }
             
             NSArray *responseData = (NSArray*)[responseString JSONValue];
             if (!responseData || ![responseData isKindOfClass:[NSArray class]])
             {
                 block(nil, [NSError errorWithDomain:@"COPDBackend" code:6 userInfo:nil]);
                 return;
             }
             
             for (NSDictionary *record in responseData)
             {
                 COPDUser *user = [[[COPDUser alloc] init] autorelease];
                 
                 if (![user constructFromDictionary:record])
                 {
                     block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
                     return;
                 }
                 [result.rows addObject:user];
             }
             
             block(result, nil);
         }
                failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             block(nil, [NSError errorWithDomain:@"COPDBackend" code:9 userInfo:nil]);
         }];
        
	}
}

- (void)queryUserWithId:(NSString*)userId withBlock:(COPDQueryCompletionBlock)block
{
    
    if ([[Content shared] handleInternetConnectivity]) {
        
        if (!self.currentUser)
        {
            block(nil, [NSError errorWithDomain:@"COPDBackend" code:4 userInfo:nil]);
            return;
        }
        
        AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:self.baseUrl]] autorelease];
        [client setAuthorizationHeaderWithUsername:self.currentUser.username password:self.currentUser.password];
        //[client getPath:[NSString stringWithFormat:COPD_SINGLE_USER_PATH, userId] parameters:nil
        [client getPath:COPD_SINGLE_USER_PATH parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             COPDQuery *result = [[[COPDQuery alloc] init] autorelease];
             
             NSString *responseString = [[[NSString alloc] initWithBytes:[(NSData*)responseObject bytes] length:[(NSData*)responseObject length] encoding:NSUTF8StringEncoding] autorelease];
             
             COPDUser *user = [[[COPDUser alloc] init] autorelease];
             
             if (![user constructFromString:responseString])
             {
                 block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
                 return;
             }
             
             [result.rows addObject:user];
             
             block(result, nil);
         }
                failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             block(nil, [NSError errorWithDomain:@"COPDBackend" code:9 userInfo:nil]);
         }];
    }
}

// NEW


-(void)queryPatientReportById:(NSString*)strReportId  WithBlock:(COPDQueryCompletionBlock)block
{
    @try {
        if ([[Content shared] handleInternetConnectivity]) {
            if (!self.currentUser)
            {
                block(nil, [NSError errorWithDomain:@"COPDBackend" code:10 userInfo:nil]);
                return;
            }
            AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[COPDBackend sharedBackend].baseUrl]] autorelease];
            
            [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
            [client setDefaultHeader:@"Accept" value:@"application/json"];
            client.parameterEncoding = AFJSONParameterEncoding;
            
            NSString *strPDiseaseID=[self.currentUser.objectData valueForKey:@"PatientDisease_ID"];
            
           // NSLog(@"strPDiseaseID=%@",strPDiseaseID);
            
            NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:strReportId,@"ReportID",strPDiseaseID,@"PatientDiseaseID", nil];
            
            NSLog(@"param=%@",param);
            
            [client postPath:PATIENT_REPORT parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //
                
               // NSLog(@"responseObject=%@",responseObject);
             /*   NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
                NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
                [formatter setTimeZone:timeZone];
                [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
                */
                
                NSDictionary *response=[[[responseObject objectForKey:@"GetPatientReportByIDResult"] objectForKey:@"Data"] JSONValue];
                
                
                if (response==nil) {
                    //
                    block(nil, nil);
                    return;
                }
                //  NSLog(@"RESP: %@",response);
                
                NSDictionary *Data=[response objectForKey:@"data"];
              //  NSDictionary *reports=[Data objectForKey:@"Reports"];
             //   NSDictionary *meds=[Data objectForKey:@"Medications"];
                
                
             //    NSLog(@"Data: %@",Data);
                
             //    NSLog(@"reports: %@",reports);
                
               //  NSLog(@"meds: %@",meds);
                
                COPDQuery *result = [[[COPDQuery alloc] init] autorelease];
                
                [result.rows addObject:Data];
                //[result.rows addObject:meds];
                
             
                 block(result, nil);
                
               /* if ([reports isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *r in reports) {
                        COPDObject *object = [[[COPDObject alloc] init] autorelease];
                        object.objectId=[r objectForKey:@"Report_ID"];
                        object.createdAt=[formatter dateFromString:[r objectForKey:@"Report_CreatedDate"]];
                        
                        if (![object constructFromDictionary:r])
                        {
                            block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
                            return;
                        }
                        [result.rows addObject:object];
                    }
                } else {
                    COPDObject *object = [[[COPDObject alloc] init] autorelease];
                    object.objectId=[reports objectForKey:@"Report_ID"];
                    object.createdAt=[formatter dateFromString:[reports objectForKey:@"Report_CreatedDate"]];
                    
                    if (![object constructFromDictionary:reports])
                    {
                        block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
                        return;
                    }
                    [result.rows addObject:object];
                }
                COPDObject *object = [[[COPDObject alloc] init] autorelease];
                NSDictionary *meds=[Data objectForKey:@"Medications"];
                if ([meds isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *m in meds) {
                        if (![object constructFromDictionary:m])
                        {
                            block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
                            return;
                        }
                    }
                   
                } else {
                    if (![object constructFromDictionary:meds])
                    {
                        block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
                        return;
                    }
                }*/
                
                
               
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //
                //   NSLog(@"%@",error);
                block(nil, [NSError errorWithDomain:@"COPDBackend" code:9 userInfo:nil]);
                
            }];
        }
    }
    @catch (NSException *exception) {
        //
        NSLog(@"Error! %@",exception);
    }
    @finally {
        //
    }
}
-(void)queryPatientAllReports:(NSString*)strPatientDiseaseId WithBlock:(COPDQueryCompletionBlock)block
{
    if ([[Content shared] handleInternetConnectivity]) {
        
        if (!self.currentUser)
        {
            block(nil, [NSError errorWithDomain:@"COPDBackend" code:10 userInfo:nil]);
            return;
        }
        
        // NSLog(@"RES Object: %@",patientDiseaseId);
        
        //AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:self.baseUrl]] autorelease];
        
        [[self httpClient]  registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [[self httpClient]  setDefaultHeader:@"Accept" value:@"application/json"];
        [self httpClient] .parameterEncoding = AFJSONParameterEncoding;
        
        
        [[self httpClient]  getPath:[NSString stringWithFormat:PATIENT_ALL_REPORTS,strPatientDiseaseId] parameters:nil
                            success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
            //  NSLog(@"RES Object: %@",responseObject);
             NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
             NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
             [formatter setTimeZone:timeZone];
             [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
             
             
             NSDictionary *response=[[[responseObject objectForKey:@"GetPatientAllReportsByIDResult"] objectForKey:@"Data"] JSONValue];
             
             
             if (response==nil) {
                 //
                 block(nil, nil);
                 return;
             }
             //   NSLog(@"RESP: %@",response);
             
             NSDictionary *Data=[response objectForKey:@"data"];
             NSDictionary *reports=[Data objectForKey:@"Reports"];
             
             
             
             COPDQuery *result = [[[COPDQuery alloc] init] autorelease];
             if ([reports isKindOfClass:[NSArray class]]) {
                 for (NSDictionary *r in reports) {
                     COPDObject *object = [[[COPDObject alloc] init] autorelease];
                     object.objectId=[r objectForKey:@"Report_ID"];
                     object.createdAt=[formatter dateFromString:[r objectForKey:@"Report_CreatedDate"]];
                     
                     if (![object constructFromDictionary:r])
                     {
                         [result release];
                         block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
                         return;
                     }
                     [result.rows addObject:object];
                 }
             } else {
                 COPDObject *object = [[[COPDObject alloc] init] autorelease];
                 object.objectId=[reports objectForKey:@"Report_ID"];
                 object.createdAt=[formatter dateFromString:[reports objectForKey:@"Report_CreatedDate"]];
                 
                 if (![object constructFromDictionary:reports])
                 {
                     block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
                     return;
                 }
                 [result.rows addObject:object];
             }
             block(result, nil);
         }
                            failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"%@",error);
             block(nil, [NSError errorWithDomain:@"COPDBackend" code:15 userInfo:nil]);
         }];
    }
}

- (void)queryPatientDischargeFormTypeWithBlock:(COPDQueryCompletionBlock)block
{
    if ([[Content shared] handleInternetConnectivity]) {
        if (!self.currentUser)
        {
            block(nil, [NSError errorWithDomain:@"COPDBackend" code:4 userInfo:nil]);
            return;
        }
        
        AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[COPDBackend sharedBackend].baseUrl]]] autorelease];
        
        NSString *strPDiseaseID=[self.currentUser.objectData valueForKey:@"PatientDisease_ID"];
       
        [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [client setDefaultHeader:@"Accept" value:@"application/json"];
        client.parameterEncoding = AFJSONParameterEncoding;
        
        [client getPath:[NSString stringWithFormat:PATIENT_DISCHARGE_FORMTYPE,strPDiseaseID] parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             COPDQuery *result = [[[COPDQuery alloc] init] autorelease];
             
            
             
             NSDictionary *responseData = [[[responseObject objectForKey:@"GetPatientDischargeFormTypeResult"] objectForKey:@"Data"] JSONValue];
             
          //   NSLog(@"responseData: %@",responseData);
             
             NSDictionary *formType=[[responseData objectForKey:@"data" ] valueForKey:@"FormTitle"];
             
             
          //    NSLog(@"formType: %@",formType);
             
             for (NSDictionary *record in formType)
             {
                 COPDObject *object = [[[COPDObject alloc] init] autorelease];
                 object.objectId=[record valueForKey:@"FormType_Id"];
                 if (![object constructFromDictionary:record])
                 {
                     block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
                     return;
                 }
                 [result.rows addObject:object];
             }
             
             block(result, nil);
         }
                failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"%@",error);
             block(nil, [NSError errorWithDomain:@"COPDBackend" code:9 userInfo:nil]);
         }];
        
	}
}
- (void)queryPatientDischargeFormDetailWithBlock:(NSUInteger)iFormType WithBlock:(COPDQueryCompletionBlock)block
{
    if ([[Content shared] handleInternetConnectivity]) {
        if (!self.currentUser)
        {
            block(nil, [NSError errorWithDomain:@"COPDBackend" code:4 userInfo:nil]);
            return;
        }

    AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[COPDBackend sharedBackend].baseUrl]]] autorelease];
    
    
     NSString *strPDiseaseID=[self.currentUser.objectData valueForKey:@"PatientDisease_ID"];
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:strPDiseaseID,@"PatientDiseaseID",[NSNumber numberWithInteger:iFormType],@"FormTypeID", nil];
    
	//[client setAuthorizationHeaderWithUsername:username password:password];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    client.parameterEncoding = AFJSONParameterEncoding;
   // NSLog(@"%@",param);
    
    
	[client postPath:PATIENT_DISCHARGE_FORM_DETAIL parameters:param
             success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         COPDQuery *result = [[[COPDQuery alloc] init] autorelease];
         //  NSLog(@"responseObject: %@",responseObject);
         NSDictionary *response=[[[responseObject objectForKey:@"GetPatientDischargeFormDetailResult"] objectForKey:@"Data"] JSONValue];
         
       //  NSLog(@"RESP: %@",response);
         
         if (response==nil) {
             //
             block(nil, nil);
             return;
         }
         NSDictionary *formType=[[response objectForKey:@"data" ] valueForKey:@"DischargeData"];
         
         
         //    NSLog(@"formType: %@",formType);
         if ([formType isKindOfClass:[NSArray class]]) {
             for (NSDictionary *record in formType)
             {
                 COPDObject *object = [[[COPDObject alloc] init] autorelease];
                 object.objectId=[record valueForKey:@"CAV_ID_FK"];
                 if (![object constructFromDictionary:record])
                 {
                     block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
                     return;
                 }
                 [result.rows addObject:object];
             }
         } else {
            
                 COPDObject *object = [[[COPDObject alloc] init] autorelease];
                 object.objectId=[formType valueForKey:@"CAV_ID_FK"];
                 if (![object constructFromDictionary:formType])
                 {
                     block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
                     return;
                 }
                 [result.rows addObject:object];
         }
         
         
         block(result, nil);

         
         
     }
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Login: %@",error);
         block(nil, [NSError errorWithDomain:@"COPDBackend" code:9 userInfo:nil]);
         
     }];
    }
}
-(void)queryPatientUnreadMessage:(NSString*)strPatientDiseaseId Patient:(NSString*)patientId WithBlock:(COPDQueryCompletionBlock)block
{
    AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[COPDBackend sharedBackend].baseUrl]]] autorelease];

    
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:patientId,@"Patient_ID",strPatientDiseaseId,@"Patient_Disease_ID", nil];
	//[client setAuthorizationHeaderWithUsername:username password:password];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    client.parameterEncoding = AFJSONParameterEncoding;
     // NSLog(@"%@",param);
    
    
	[client postPath:PATIENT_UNREAD_MESSAGE parameters:param
             success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
       //  NSLog(@"responseObject: %@",responseObject);
         NSDictionary *response=[[[responseObject objectForKey:@"GetPatientUnreadMessageResult"] objectForKey:@"Data"] JSONValue];
         
         //NSLog(@"RESP: %@",response);
         
         if (response==nil) {
             //
             block(nil, nil);
             return;
         }
         
         NSDictionary *Data=[response objectForKey:@"data"];
         NSString *activeReportId=[[Data objectForKey:@"Report"] valueForKey:@"activeReportId"];
         NSString *chatCount=[[Data valueForKey:@"ChatCount"] valueForKey:@"chatCount"];
         NSDictionary *reportCount=[[Data objectForKey:@"ActiveReportCount"] valueForKey:@"activeReportCount"];
         NSDictionary *allReportsCount=[[Data objectForKey:@"ReportCount"] valueForKey:@"reportCount"];
        
         
         COPDQuery *result = [[[COPDQuery alloc] init] autorelease];
         [result.rows addObject:(activeReportId.length>0)?activeReportId:@""];
          [result.rows addObject:chatCount];
          [result.rows addObject:reportCount];
          [result.rows addObject:allReportsCount];
         
         
         
         
         block(result, nil);
 
     }
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Login: %@",error);
          block(nil, [NSError errorWithDomain:@"COPDBackend" code:9 userInfo:nil]);
        
     }];
}
- (void)queryPatientActiveReportStatus:(NSString*)patientId WithBlock:(COPDQueryCompletionBlock)block

{
    @try {
        if ([[Content shared] handleInternetConnectivity]) {
            if (!self.currentUser)
            {
                block(nil, [NSError errorWithDomain:@"COPDBackend" code:10 userInfo:nil]);
                return;
            }
            AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[COPDBackend sharedBackend].baseUrl]] autorelease];
            
            [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
            [client setDefaultHeader:@"Accept" value:@"application/json"];
            client.parameterEncoding = AFJSONParameterEncoding;
            
            
            [client getPath:[NSString stringWithFormat:GET_PATIENT_ACTIVE_REPORTSTATUS, patientId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //
                // NSLog(@"Response: %@",responseObject);
                
                NSDictionary *response=[[[responseObject objectForKey:@"GetPatientActiveReportStatusResult"] objectForKey:@"Data"] JSONValue];
                
                if (response==nil) {
                    //
                    block(nil, nil);
                    return;
                }
                
                
               // NSLog(@"Response: %@",response);
                NSDictionary *Data=[response objectForKey:@"data"];
                NSDictionary *Reports=[Data objectForKey:@"Reports"];
                NSString *strStatus=[Reports valueForKey:@"ReportStatus_ID_FK"];
                
                COPDQuery *result = [[[COPDQuery alloc] init] autorelease];
                [result.rows addObject:strStatus];
                
                
                
                
                block(result, nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //
                //   NSLog(@"%@",error);
                block(nil, [NSError errorWithDomain:@"COPDBackend" code:9 userInfo:nil]);
                
            }];
        }
    }
    @catch (NSException *exception) {
        //
        NSLog(@"Error! %@",exception);
    }
    @finally {
        //
    }
   
    
}
/// END NEW
- (COPDQuery*)queryReportsForUserWithId:(NSString*)userId
{
	__block BOOL finished = false;
	__block NSError *e = nil;
	__block COPDQuery *q = nil;

	[self queryReportsForUserWithId:userId WithBlock:^(COPDQuery *query, NSError *errorOrNil)
	{
		e = errorOrNil;
		q = query;
		finished = true;
	}];

	NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:0.1];
	while (!finished && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil])
	{
		loopUntil = [NSDate dateWithTimeIntervalSinceNow:0.1];
	}

	return q;
}

- (void)queryReportsForAllUsersWithBlock:(COPDQueryCompletionBlock)block
{
    if ([[Content shared] handleInternetConnectivity]) {
        if (!self.currentUser)
        {
            block(nil, [NSError errorWithDomain:@"COPDBackend" code:10 userInfo:nil]);
            return;
        }
        
        AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:self.baseUrl]] autorelease];
        
        [client setAuthorizationHeaderWithUsername:self.currentUser.username password:self.currentUser.password];
        [client getPath:COPD_ALL_REPORTS_PATH parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             COPDQuery *result = [[[COPDQuery alloc] init] autorelease];
             
             NSString *responseString = [[[NSString alloc] initWithBytes:[(NSData*)responseObject bytes] length:[(NSData*)responseObject length] encoding:NSUTF8StringEncoding] autorelease];
             
             if (!responseString)
             {
                 block(nil, [NSError errorWithDomain:@"COPDBackend" code:11 userInfo:nil]);
                 return;
             }
             
             NSArray *responseData = (NSArray*)[responseString JSONValue];
             if (!responseData || ![responseData isKindOfClass:[NSArray class]])
             {
                 block(nil, [NSError errorWithDomain:@"COPDBackend" code:12 userInfo:nil]);
                 return;
             }
             
             for (NSDictionary *record in responseData)
             {
                 COPDObject *object = [[[COPDObject alloc] init] autorelease];
                 
                 if (![object constructFromDictionary:record])
                 {
                     block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
                     return;
                 }
                 [result.rows addObject:object];
             }
             
             block(result, nil);
         }
                failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             block(nil, [NSError errorWithDomain:@"COPDBackend" code:15 userInfo:nil]);
         }];
        
    }
	
}

//- (void)queryReportsForUserWithId:(NSInteger)userId WithBlock:(COPDQueryCompletionBlock)block

 - (void)queryReportsForUserWithId:(NSString*)userId WithBlock:(COPDQueryCompletionBlock)block
{
 /* // THIS IS A COPY/PASTE, I KNOW IT
 // I ASSUME THAT THOSE 2 METHODS WILL BE PRETTY DIFFERENT IN THE FUTURE
 if (!self.currentUser)
 {
 block(nil, [NSError errorWithDomain:@"COPDBackend" code:10 userInfo:nil]);
 return;
 }
 
 AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:self.baseUrl]] autorelease];
 
 [client setAuthorizationHeaderWithUsername:self.currentUser.username password:self.currentUser.password];
 //[client getPath:[NSString stringWithFormat:COPD_REPORTS_PATH, userId] parameters:nil
 [client getPath:USER_REPORT_PATH parameters:nil
 success:^(AFHTTPRequestOperation *operation, id responseObject)
 {
 COPDQuery *result = [[COPDQuery alloc] init];
 
 NSString *responseString = [[[NSString alloc] initWithBytes:[(NSData*)responseObject bytes] length:[(NSData*)responseObject length] encoding:NSUTF8StringEncoding] autorelease];
 
 if (!responseString)
 {
 [result release];
 block(nil, [NSError errorWithDomain:@"COPDBackend" code:11 userInfo:nil]);
 return;
 }
 
 NSArray *responseData = (NSArray*)[responseString JSONValue];
 if (!responseData || ![responseData isKindOfClass:[NSArray class]])
 {
 [result release];
 block(nil, [NSError errorWithDomain:@"COPDBackend" code:12 userInfo:nil]);
 return;
 }
 
 for (NSDictionary *record in responseData)
 {
 COPDObject *object = [[[COPDObject alloc] init] autorelease];
 
 if (![object constructFromDictionary:record])
 {
 [result release];
 block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
 return;
 }
 [result.rows addObject:object];
 }
 
 block(result, nil);
 }
 failure:^(AFHTTPRequestOperation *operation, NSError *error)
 {
 block(nil, [NSError errorWithDomain:@"COPDBackend" code:15 userInfo:nil]);
 }];
 */
}

- (void)queryReportsByPatientDiseaseId:(NSString*)patientDiseaseId WithBlock:(COPDQueryCompletionBlock)block
{
	// THIS IS A COPY/PASTE, I KNOW IT
	// I ASSUME THAT THOSE 2 METHODS WILL BE PRETTY DIFFERENT IN THE FUTURE
    if ([[Content shared] handleInternetConnectivity]) {
        
	if (!self.currentUser)
	{
		block(nil, [NSError errorWithDomain:@"COPDBackend" code:10 userInfo:nil]);
		return;
	}

   // NSLog(@"RES Object: %@",patientDiseaseId);
    
	//AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:self.baseUrl]] autorelease];

    [[self httpClient]  registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [[self httpClient]  setDefaultHeader:@"Accept" value:@"application/json"];
    [self httpClient] .parameterEncoding = AFJSONParameterEncoding;

    
	[[self httpClient]  getPath:[NSString stringWithFormat:USER_REPORT_PATH,patientDiseaseId] parameters:nil
    success:^(AFHTTPRequestOperation *operation, id responseObject)
		{
           // NSLog(@"RES Object: %@",responseObject);
            NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
            NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            [formatter setTimeZone:timeZone];
            [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];

            
            NSDictionary *response=[[[responseObject objectForKey:@"GetPatientReportsByIDResult"] objectForKey:@"Data"] JSONValue];
            
        
            if (response==nil) {
                //
                block(nil, nil);
                return;
            }
         //   NSLog(@"RESP: %@",response);
            
            NSDictionary *Data=[response objectForKey:@"data"];
            NSDictionary *reports=[Data objectForKey:@"Reports"];

        
            
            COPDQuery *result = [[[COPDQuery alloc] init] autorelease];
            if ([reports isKindOfClass:[NSArray class]]) {
                for (NSDictionary *r in reports) {
                    COPDObject *object = [[[COPDObject alloc] init] autorelease];
                    object.objectId=[r objectForKey:@"Report_ID"];
                    object.createdAt=[formatter dateFromString:[r objectForKey:@"Report_CreatedDate"]];
                    
                    if (![object constructFromDictionary:r])
                    {
                        [result release];
                        block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
                        return;
                    }
                    [result.rows addObject:object];
                }
            } else {
                COPDObject *object = [[[COPDObject alloc] init] autorelease];
                object.objectId=[reports objectForKey:@"Report_ID"];
              object.createdAt=[formatter dateFromString:[reports objectForKey:@"Report_CreatedDate"]];
                
				if (![object constructFromDictionary:reports])
				{
					block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
					return;
				}
				[result.rows addObject:object];
            }
            block(result, nil);
            /*for (NSDictionary *record in reports)
            {
                COPDObject *object = [[[COPDObject alloc] init] autorelease];
                object.objectId=[record objectForKey:@"Report_ID"];
                object.createdAt=[record objectForKey:@"Report_CreatedDate"];
                
				if (![object constructFromDictionary:record])
				{
					[result release];
					block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
					return;
				}
				[result.rows addObject:object];
            }
            block(result, nil);*/
            
			/*COPDQuery *result = [[COPDQuery alloc] init];

			NSString *responseString = [[[NSString alloc] initWithBytes:[(NSData*)responseObject bytes] length:[(NSData*)responseObject length] encoding:NSUTF8StringEncoding] autorelease];

			if (!responseString)
			{
				[result release];
				block(nil, [NSError errorWithDomain:@"COPDBackend" code:11 userInfo:nil]);
				return;
			}

			NSArray *responseData = (NSArray*)[responseString JSONValue];
			if (!responseData || ![responseData isKindOfClass:[NSArray class]])
			{
				[result release];
				block(nil, [NSError errorWithDomain:@"COPDBackend" code:12 userInfo:nil]);
				return;
			}

			for (NSDictionary *record in responseData)
			{
				COPDObject *object = [[[COPDObject alloc] init] autorelease];

				if (![object constructFromDictionary:record])
				{
					[result release];
					block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
					return;
				}
				[result.rows addObject:object];
			}

			block(result, nil);*/
		}
		failure:^(AFHTTPRequestOperation *operation, NSError *error)
		{
            NSLog(@"%@",error);
			block(nil, [NSError errorWithDomain:@"COPDBackend" code:15 userInfo:nil]);
		}];
    }
}
#pragma Chat

- (void)updateChatWithPatientDiseaseId:(NSString*)patientDiseaseId WithBlock:(void(^)(NSError *errorOrNil))block;
{
    if ([[Content shared] handleInternetConnectivity]) {
        
    AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[COPDBackend sharedBackend].baseUrl]]] autorelease];
    
        NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:patientDiseaseId,@"PatientDiseaseID" ,nil];
        
      //  NSLog(@"param:%@",param);
        
        [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [client setDefaultHeader:@"Accept" value:@"application/json"];
        client.parameterEncoding = AFJSONParameterEncoding;
        
        
        [client postPath:UPDATE_CHAT parameters:param
                 success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             //NSLog(@"RES: %@",[responseObject objectForKey:@"SetNotificationSubscriptionResult"]);
             // NSUInteger error=[[responseObject objectForKey:@"Error"] intValue];
             
             NSString *strError=[[responseObject objectForKey:@"UpdateChatResult"] objectForKey:@"Error"];
             
             // NSLog(@"ERROR: %@",strError);
             
             
             if([strError isEqualToString:@"1"])
             {
                 block([NSError errorWithDomain:@"COPDBackend" code:11 userInfo:nil]);
                 return;
             }
             block(nil);
             
         }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"%@",error.description);
             block(error);
         }];
    }

}
- (void)queryChatHistoryWithPatientDiseaseId:(NSString*)patientDiseaseId WithBlock:(COPDQueryCompletionBlock)block
{
    
     if ([[Content shared] handleInternetConnectivity]) {
         if (!self.currentUser)
         {
             block(nil, [NSError errorWithDomain:@"COPDBackend" code:10 userInfo:nil]);
             return;
         }
         AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[COPDBackend sharedBackend].baseUrl]] autorelease];
         
         [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
         [client setDefaultHeader:@"Accept" value:@"application/json"];
         client.parameterEncoding = AFJSONParameterEncoding;
         
         
         [client getPath:[NSString stringWithFormat:GET_CHAT_HISTORY, patientDiseaseId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //
             // NSLog(@"Response: %@",responseObject);
             
             NSDictionary *response=[[[responseObject objectForKey:@"GetChatHistoryByPatientDiseaseIDResult"] objectForKey:@"Data"] JSONValue];
             
             if (response==nil) {
                 //
                 block(nil, nil);
                 return;
             }
             
             NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
             NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
             [formatter setTimeZone:timeZone];
             [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
             
             NSDictionary *Data=[response objectForKey:@"chathistory"];
             NSDictionary *chats=[Data objectForKey:@"chat"];
             
             COPDQuery *result = [[[COPDQuery alloc] init] autorelease];
             
             //  NSLog(@"chats: %@",chats);
             
             if ([chats isKindOfClass:[NSArray class]]) {
                 for (NSDictionary *r in chats) {
                     COPDObject *object = [[[COPDObject alloc] init] autorelease];
                     object.objectId=[r objectForKey:@"Chat_ID"];
                     object.createdAt=[formatter dateFromString:[r objectForKey:@"CreatedDate"]];
                     
                     if (![object constructFromDictionary:r])
                     {
                         [result release];
                         block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
                         return;
                     }
                     [result.rows addObject:object];
                 }
             } else {
                 COPDObject *object = [[[COPDObject alloc] init] autorelease];
                 object.objectId=[chats objectForKey:@"Chat_ID"];
                 object.createdAt=[formatter dateFromString:[chats objectForKey:@"CreatedDate"]];
                 
                 if (![object constructFromDictionary:chats])
                 {
                     [result release];
                     block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
                     return;
                 }
                 [result.rows addObject:object];
             }
             
             
             
             
             block(result, nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //
             //   NSLog(@"%@",error);
             block(nil, [NSError errorWithDomain:@"COPDBackend" code:9 userInfo:nil]);
             
         }];
     }
    
    
	
    
    
}


#pragma Notifications

-(void)saveNotificationSubscriptionInBackground:(NSDictionary *)param WithBlock:(void(^)(NSError *errorOrNil))block
{
    if ([[Content shared] handleInternetConnectivity]) {
        AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[COPDBackend sharedBackend].baseUrl]]] autorelease];
        
        //NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:username,@"Username",password,@"Password" ,nil];
        
        //NSLog(@"param:%@",param);
        
        [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [client setDefaultHeader:@"Accept" value:@"application/json"];
        client.parameterEncoding = AFJSONParameterEncoding;
        
        
        [client postPath:NOTIFICATION_SUBSCRIPTION parameters:param
                 success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             //NSLog(@"RES: %@",[responseObject objectForKey:@"SetNotificationSubscriptionResult"]);
             // NSUInteger error=[[responseObject objectForKey:@"Error"] intValue];
             
             NSString *strError=[[responseObject objectForKey:@"SetNotificationSubscriptionResult"] objectForKey:@"Error"];
             
             // NSLog(@"ERROR: %@",strError);
             
             
             if([strError isEqualToString:@"1"])
             {
                 block([NSError errorWithDomain:@"COPDBackend" code:11 userInfo:nil]);
                 return;
             }
             block(nil);
             
         }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"%@",error.description);
             block(error);
         }];
    }
    

}
-(void)saveNotificationInBackground:(NSDictionary *)param WithBlock:(void(^)(NSError *errorOrNil))block
{
    
    if ([[Content shared] handleInternetConnectivity]) {
        AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[COPDBackend sharedBackend].baseUrl]]] autorelease];
        
        //NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:username,@"Username",password,@"Password" ,nil];
        
        //  NSLog(@"param:%@",param);
        
        [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [client setDefaultHeader:@"Accept" value:@"application/json"];
        client.parameterEncoding = AFJSONParameterEncoding;
        
        
        [client postPath:NEW_NOTIFICATION parameters:param
                 success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             //  NSLog(@"RES: %@",[responseObject objectForKey:@"SetNewNotificationResult"]);
             // NSUInteger error=[[responseObject objectForKey:@"Error"] intValue];
             
             NSString *strError=[[responseObject objectForKey:@"SetNewNotificationResult"] objectForKey:@"Error"];
             
             // NSLog(@"ERROR: %@",strError);
             
             
             if([strError isEqualToString:@"1"])
             {
                 block([NSError errorWithDomain:@"COPDBackend" code:11 userInfo:nil]);
                 return;
             }
             block(nil);
             
         }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"%@",error.description);
             block(error);
         }];
    }
    

}
@end
