//
//  SurveyBanner.m
//  COPD
//
//  Created by Akhil on 17/10/13.
//  Copyright (c) 2013 TKInteractive. All rights reserved.
//

#import "SurveyBanner.h"
#import "COPDBackend.h"

#import "SBJson.h"
#import "AFNetworking.h"

#import "COPDAppDelegate.h"
#import "Content.h"

@implementation SurveyBanner

@synthesize Survey_attend, Survey_title;

- (id)init
{
	self = [super init];
    
	self.Survey_title = @"";
	self.Survey_attend = NO;
	return self;
}

- (void)dealloc
{
	self.Survey_title = Nil;
	self.Survey_attend = NO;
	[super dealloc];
    
}


//akhil 19-10-13
//ahi aa methono user karvo
//-(void)getQuestions:(void(^)(NSError *errorOrNil))block
//content.m ma 6

+ (void)get_survey_update:(NSString *)username target:(id)target selector:(SEL)selector;
{
    
    COPDAppDelegate * obj_dele = (COPDAppDelegate *)[[UIApplication sharedApplication]delegate];

   // __block NSMutableArray * ary = [[NSMutableArray alloc]init];
    
	    AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[COPDBackend sharedBackend].baseUrl]]] autorelease];
    
    //AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[COPDBackend sharedBackend].baseUrl]]] autorelease];

    NSLog(@"%@",[COPDBackend sharedBackend].baseUrl);
    
    NSLog(@"username = %@",username);
    
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:username,@"Patient_ID", nil];
    
   [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    client.parameterEncoding = AFJSONParameterEncoding;
     NSLog(@"%@",param);
    
    
	//[client postPath:GET_SURVEY parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     //[client getPath:GET_SURVEY parameters:nil  success:^(AFHTTPRequestOperation *operation, id responseObject)
       [client getPath:[NSString stringWithFormat:GET_SURVEY, username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         //  NSLog(@"responseObject: %@",responseObject);
         NSDictionary *response=[[[responseObject objectForKey:@"CheckForSurveyResult"] objectForKey:@"Data"] JSONValue];
         
         if (response.count>0)
         {
             
                        NSMutableDictionary * dict = [[response valueForKey:@"data"]valueForKey:@"Survey"];
             NSLog(@"dict = %@",dict);
             NSLog(@"count = %d",dict.count);
             
             for (int i =0; i<dict.count; i++)
             {
                 
                 Survey *q=[[[Survey alloc] init] autorelease];
                 q.surve_id=[dict valueForKey:@"SurveyID"];
                 q.surve_name=[dict valueForKey:@"SurveyID"];
                 
              
                 
                
             }
              [obj_dele.ary_survey addObject:dict];
             NSLog(@"obj dele =%@",obj_dele.ary_survey);
             NSLog(@"obj dele count =%d",obj_dele.ary_survey.count);
             

         }
         
        
         
         
       //  NSLog(@"RESP: %@",response);
         //NSLog(@"dict count = %d",response.count);
         
               
         
         if (response==nil) {
             //
             //block(nil, nil);
             return;
         }
         
         
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
            */
        
         /*NSString *activeReportId=[[Data objectForKey:@"Report"] valueForKey:@"activeReportId"];
         NSString *chatCount=[[Data valueForKey:@"ChatCount"] valueForKey:@"chatCount"];
         NSDictionary *reportCount=[[Data objectForKey:@"ActiveReportCount"] valueForKey:@"activeReportCount"];
         NSDictionary *allReportsCount=[[Data objectForKey:@"ReportCount"] valueForKey:@"reportCount"];
         
         
         COPDQuery *result = [[[COPDQuery alloc] init] autorelease];
         [result.rows addObject:(activeReportId.length>0)?activeReportId:@""];
         [result.rows addObject:chatCount];
         [result.rows addObject:reportCount];
         [result.rows addObject:allReportsCount];*/
         
         
         
         
        // block(response, nil);
         
     }
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Login: %@",error);
        // block(nil, [NSError errorWithDomain:@"COPDBackend" code:9 userInfo:nil]);
         
     }];
}



- (void)queryQuestionsForUserWithDiseaseId:(NSString*)diseaseId WithBlock:(COPDQueryCompletionBlock_new)block
{
    
    if ([[Content shared] handleInternetConnectivity]) {
        /*if (!self.currentUser)
        {
            block(nil, [NSError errorWithDomain:@"COPDBackend" code:10 userInfo:nil]);
            return;
        }*/
        
      /*  NSString * str_url = [NSString stringWithFormat:@"%@",[NSURL URLWithString:[COPDBackend sharedBackend].baseUrl]];
        str_url = [str_url stringByAppendingFormat:@"%@",GET_SURVEY];
        str_url = [str_url stringByAppendingFormat:@"%@",diseaseId];
        
        NSLog(@"usl pass = %@",str_url);*/
      AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[COPDBackend sharedBackend].baseUrl]] autorelease];
        
        // AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSString stringWithFormat:@"%@",str_url]] autorelease];
        
        
        // NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:diseaseId,@"id", nil];
        //[client setAuthorizationHeaderWithUsername:username password:password];
        [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [client setDefaultHeader:@"Accept" value:@"application/json"];
        client.parameterEncoding = AFJSONParameterEncoding;
      
         NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:diseaseId,@"Patient_ID", nil];
        NSLog(@"%@",param);
        
          [client getPath:[NSString stringWithFormat:GET_SURVEY, diseaseId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
           
       // [client getPath:[NSString stringWithFormat:DISEASE_QUESTION_PATH, diseaseId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            //
            
            COPDQuery *result = [[[COPDQuery alloc] init] autorelease];
              NSLog(@"Response: %@",[responseObject objectForKey:@"CheckForSurveyResult"]);
            
            for (NSDictionary *record in [responseObject objectForKey:@"CheckForSurveyResult"])
            {
                    NSLog(@"Response: %d",record.count);
                
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

/*+(void)saveChatInBackgroundWithBlock:(void(^)(BOOL succeed, NSError *errorOrNil))block
{
    AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[COPDBackend sharedBackend].baseUrl]]] autorelease];
    
    //NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:username,@"Username",password,@"Password" ,nil];
    
    
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    client.parameterEncoding = AFJSONParameterEncoding;
    
    //NSLog(@"Object: %@",[self objectData]);
    
    [client postPath:NEW_CHAT parameters:[self objectData]
             success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         // NSLog(@"RES: %@",[responseObject objectForKey:@"SetNewChatResult"]);
         // NSUInteger error=[[responseObject objectForKey:@"Error"] intValue];
         
         NSString *strError=[[responseObject objectForKey:@"SetNewChatResult"] objectForKey:@"Error"];
         
         // NSLog(@"ERROR: %@",strError);
         
         
         if([strError isEqualToString:@"1"])
         {
             block(FALSE,[NSError errorWithDomain:@"COPDBackend" code:11 userInfo:nil]);
             return;
         }
         block(TRUE,nil);
         
     }
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@",error.description);
         block(FALSE,error);
     }];

}*/

@end
