#import "COPDUser.h"
#import "COPDBackend.h"

#import "SBJson.h"
#import "AFNetworking.h"

//akhil 6-11-14
//auto logout timer
#import "Content.h"
//akhil 6-11-14
//auto logout timer

//akhil (Vipul) 8-1-14 2.6 Chnages
#define PASSWORD_SETTING_KEY @"PASSWORD_SETTING_KEY"
//akhil (Vipul) 8-1-14 2.6 Chnages

@implementation COPDUser

@synthesize password, username;

- (id)init
{
	self = [super init];

	self.username = @"";
	self.password = @"";
	return self;
}

- (void)dealloc
{
	self.username = nil;
	self.password = nil;
	[super dealloc];

}

+ (COPDUser*)user
{
	COPDUser *user = [[[COPDUser alloc] init] autorelease];

	return user;
}
+ (void)validatePatient:(NSString *)username password:(NSString *)password block:(void (^)(NSError *errorOrNil))block

{
    AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[COPDBackend sharedBackend].baseUrl]]] autorelease];
    NSLog(@"client is %@",[COPDBackend sharedBackend].baseUrl);
  
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:username,@"Username",password,@"Password" ,nil];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    client.parameterEncoding = AFJSONParameterEncoding;
    
   NSLog(@"%@",param);
    
    [client postPath:VALIDATE_PATIENT parameters:param
             success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"RES: %@",[responseObject objectForKey:@"ValidatePatientResult"]);
         //NSUInteger error=[[responseObject objectForKey:@"Error"] intValue];
         
         NSString *strError=[[responseObject objectForKey:@"ValidatePatientResult"] objectForKey:@"Error"];
         
         //akhil 6-11-14
         //auto log out timer
         NSLog(@"AutoLockTime = %@",[[responseObject objectForKey:@"ValidatePatientResult"]objectForKey:@"AutoLockTime"]);
         NSInteger timer = [[[responseObject objectForKey:@"ValidatePatientResult"]objectForKey:@"AutoLockTime"]integerValue];
         NSLog(@"timer = %d",timer);
         [Content shared].logout_timer =timer ;
         NSLog(@"net timer = %d",[Content shared].logout_timer);
         //akhil 6-11-14
         //auto log out timer
         
        // NSLog(@"ERROR: %@",strError);
         

         //akhil(Vipul) 2014-01-15 2.6 Changes 
//         if([strError isEqualToString:@"1"])
//         {
//             block([NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
//             return;
//         }
//         block(nil);
         
         
         //alpha numeric
         NSLog(@"lenght = %d",[[[responseObject objectForKey:@"ValidatePatientResult"]objectForKey:@"AlphaNumericRegEx"] length]);
         if ([[[responseObject objectForKey:@"ValidatePatientResult"]objectForKey:@"AlphaNumericRegEx"]length]>0)
         {
             [[NSUserDefaults standardUserDefaults] setValue: [[responseObject objectForKey:@"ValidatePatientResult"]objectForKey:@"AlphaNumericRegEx"] forKey: ALFTA_NUMERIC_EXP];
             [[NSUserDefaults standardUserDefaults] synchronize];
             [[NSUserDefaults standardUserDefaults] setValue: [[responseObject objectForKey:@"ValidatePatientResult"]objectForKey:@"AlphaNumericMsg"] forKey: ALFTA_NUMERIC_EXP_MSG];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }
         //compex charcter
         if ([[[responseObject objectForKey:@"ValidatePatientResult"]objectForKey:@"ComplexCharRegEx"]length]>0)
         {
             [[NSUserDefaults standardUserDefaults] setValue: [[responseObject objectForKey:@"ValidatePatientResult"]objectForKey:@"ComplexCharRegEx"] forKey: COMPLEX_EXP];
             [[NSUserDefaults standardUserDefaults] synchronize];
             [[NSUserDefaults standardUserDefaults] setValue: [[responseObject objectForKey:@"ValidatePatientResult"]objectForKey:@"ComplexCharMsg"] forKey: COMPLEX_EXP_MSG];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }
         //password length
         if ([[[responseObject objectForKey:@"ValidatePatientResult"]objectForKey:@"PasscodeLengthRegEx"]length]>0)
         {
             [[NSUserDefaults standardUserDefaults] setValue: [[responseObject objectForKey:@"ValidatePatientResult"]objectForKey:@"PasscodeLengthRegEx"] forKey: PASS_LENGTH_EXP];
             [[NSUserDefaults standardUserDefaults] synchronize];
             [[NSUserDefaults standardUserDefaults] setValue: [[responseObject objectForKey:@"ValidatePatientResult"]objectForKey:@"PasscodeLengthMsg"] forKey: PASS_LENGTH_EXP_MSG];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }
         //akhil 7-1-14
         COPDAppDelegate * obj_delegate = (COPDAppDelegate *)[[UIApplication sharedApplication]delegate];
         
         NSLog(@"user lock value =%d",[[[responseObject objectForKey:@"ValidatePatientResult"]objectForKey:@"IsUserLocked"]integerValue]);
         //akhil 16-1-14
         obj_delegate.IsUserLocked = [[[responseObject objectForKey:@"ValidatePatientResult"]objectForKey:@"IsUserLocked"]integerValue];
         NSLog(@"obj delegate user lock value = %d",obj_delegate.IsUserLocked);
         
         //2014-01-17 Vipul 2.6
         [[NSUserDefaults standardUserDefaults] setInteger:obj_delegate.IsUserLocked forKey:@"IsUserLockedClinician"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         //2014-01-17 Vipul 2.6
         
         if ([[[responseObject objectForKey:@"ValidatePatientResult"]objectForKey:@"IsUserLocked"]integerValue]==1)
         {
             NSLog(@"error msg = %@",[[responseObject objectForKey:@"ValidatePatientResult"]objectForKey:@"ErrorMessage"]);
            // NSString * str_error_msg = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"ValidatePatientResult"]objectForKey:@"ErrorMessage"]];
             //2014-01-17 Vipul 2.6
             //block([NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
             block([NSError errorWithDomain:[[responseObject objectForKey:@"ValidatePatientResult"] objectForKey:@"ErrorMessage"] code:18 userInfo:nil] );
             //
         }
         //akhil 16-1-14
         else
         {//akhil 16-1-14
             obj_delegate.IsPasswordChangeRequire =[[[responseObject objectForKey:@"ValidatePatientResult"]objectForKey:@"IsPasswordChangeRequire"] integerValue];
             NSLog(@"obj delegate value = %d",obj_delegate.IsPasswordChangeRequire);
             if ([[[responseObject objectForKey:@"ValidatePatientResult"]objectForKey:@"IsPasswordChangeRequire"]integerValue]==0)
             {
                 if([strError isEqualToString:@"1"])
                 {                     
                     //2014-01-17 Vipul 2.6
                     //block([NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
                     block([NSError errorWithDomain:[[responseObject objectForKey:@"ValidatePatientResult"] objectForKey:@"ErrorMessage"] code:18 userInfo:nil] );
                     //
                     return;
                 }
                 block(nil);
             }
             else
             {
             // [[NSUserDefaults standardUserDefaults] setValue: [[responseObject objectForKey:@"CheckExistingPatientResult"]objectForKey:@"Username"] forKey: USERNAME_SETTING_KEY];
             // [[NSUserDefaults standardUserDefaults] synchronize];
             
             [[NSUserDefaults standardUserDefaults] setValue: [[responseObject objectForKey:@"ValidatePatientResult"]objectForKey:@"Password"] forKey: PASSWORD_SETTING_KEY];
             [[NSUserDefaults standardUserDefaults] synchronize];
             if([strError isEqualToString:@"1"])
             {
                 //2014-01-17 Vipul 2.6
                 //block([NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
                 block([NSError errorWithDomain:[[responseObject objectForKey:@"ValidatePatientResult"] objectForKey:@"ErrorMessage"] code:18 userInfo:nil] );
                 return;
             }
             block(nil);
             
         }
         //akhil(Vipul) 7-1-14 2.6 Changes
         }//16-1-14

     }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERR: %@",error.description);
         block(error);
     }];

}
//working
+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password target:(id)target selector:(SEL)selector
{
	/*AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[COPDBackend sharedBackend].baseUrl]] autorelease];

	[client setAuthorizationHeaderWithUsername:username password:password];
	[client getPath:COPD_PROFILE_PATH parameters:nil
		success:^(AFHTTPRequestOperation *operation, id responseObject)
		{
			NSString *responseString = [[[NSString alloc] initWithBytes:[(NSData*)responseObject bytes] length:[(NSData*)responseObject length] encoding:NSUTF8StringEncoding] autorelease];


			COPDUser *user = [[[COPDUser alloc] init] autorelease];

			user.username = username;
			user.password = password;
			if (![user constructFromString:responseString])
			{
				[target performSelector:selector withObject:nil withObject:[NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]];
				return;
			}

			[COPDBackend sharedBackend].currentUser = user;

			[target performSelector:selector withObject:user withObject:nil];
		}
		failure:^(AFHTTPRequestOperation *operation, NSError *error)
		{
			[target performSelector:selector withObject:nil withObject:error];
		}];*/
    AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[COPDBackend sharedBackend].baseUrl]]] autorelease];
    
    
    NSLog(@"%@",[COPDBackend sharedBackend].baseUrl);
    NSLog(@"disease_name %@",[COPDBackend sharedBackend].disease_name);
    
   //  AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://10.0.0.23/RestService/IpadServiceData.svc/"]] autorelease];
    
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:username,@"Username",password,@"Password",[COPDBackend sharedBackend].disease_name,@"DiseaseName", nil];
    
    
    /*Old Code commented by pankil : 10-07-2013
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:username,@"Username",password,@"Password",@"Heart Failure",@"DiseaseName", nil];
    */
    
	//[client setAuthorizationHeaderWithUsername:username password:password];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    client.parameterEncoding = AFJSONParameterEncoding;
    //NSLog(@"param %@",param);
 
    
	[client postPath:COPD_PROFILE_PATH parameters:param
             success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        // NSLog(@"%@",responseObject);
        //NSLog(@"%@",[responseObject JSONValue]);
         //NSString *responseString = [[[NSString alloc] initWithBytes:[(NSData*)responseObject bytes] length:[(NSData*)responseObject length] encoding:NSUTF8StringEncoding] autorelease];
         
         NSDictionary *response=[responseObject objectForKey:@"GetPatientCredentialsResult"];
         
        NSLog(@"PAT: %@",response);
         
        COPDUser *user = [[[COPDUser alloc] init] autorelease];
         
         user.username = username;
         user.password = password;
         user.objectId=[response objectForKey:@"Patient_ID"];
         if ([user.objectId length]==0)// this is used to check valid user data
         {
             [target performSelector:selector withObject:nil withObject:[NSError errorWithDomain:@"HF" code:18 userInfo:nil]];
             return;
         }
         user.createdAt=[response objectForKey:@"Patient_CreatedDate"];
        /* if (![user constructFromString:responseObject])
         {
             [target performSelector:selector withObject:nil withObject:[NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]];
             return;
         }*/
         
         if (![user constructFromDictionary:response])// this is used to check valid user data, id field should not be empty
         {
             [target performSelector:selector withObject:nil withObject:[NSError errorWithDomain:@"HF" code:18 userInfo:nil]];
             return;
         }
         
         [COPDBackend sharedBackend].currentUser = user;
         
         [target performSelector:selector withObject:user withObject:nil];
         
     }
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
          NSLog(@"Login: %@",error);
          [target performSelector:selector withObject:nil withObject:error];
     }];
}

+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password block:(void (^)(COPDUser *user, NSError *errorOrNil))block
{
	AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[COPDBackend sharedBackend].baseUrl]] autorelease];

	[client setAuthorizationHeaderWithUsername:username password:password];
	[client getPath:COPD_PROFILE_PATH parameters:nil
		success:^(AFHTTPRequestOperation *operation, id responseObject)
		{
			NSString *responseString = [[[NSString alloc] initWithBytes:[(NSData*)responseObject bytes] length:[(NSData*)responseObject length] encoding:NSUTF8StringEncoding] autorelease];

			COPDUser *user = [[[COPDUser alloc] init] autorelease];

			user.username = username;
			user.password = password;
			if (![user constructFromString:responseString])
			{
				block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
				return;
			}

			[COPDBackend sharedBackend].currentUser = user;

			block(user, nil);
		}
		failure:^(AFHTTPRequestOperation *operation, NSError *error)
		{
			block(nil, error);
		}];
}

//2014-09-10 Vipul 3.0.0.2 Notification Bug
+(void)UpdateScheduleNotification:(NSString*)DeviceToken PatientID:(NSString*)PatientID
{
    AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[COPDBackend sharedBackend].baseUrl]] autorelease];
    
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:PatientID,@"PatientID", DeviceToken,@"DeviceToken", nil];
        
   
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    client.parameterEncoding = AFJSONParameterEncoding;
        
	[client postPath:@"UpdateDeviceTokenForPatientID" parameters:param
             success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *response=[responseObject objectForKey:@"UpdateDeviceTokenForPatientIDResult"];
         
//         COPDUser *user = [[[COPDUser alloc] init] autorelease];
//         
//         user.username = username;
//         user.password = password;
//         if (![user constructFromString:responseString])
//         {
//             block(nil, [NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]);
//             return;
//         }
//         
//         [COPDBackend sharedBackend].currentUser = user;
//         
//         block(user, nil);
     }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //block(nil, error);
     }];
}

//2014-09-10 Vipul 3.0.0.2 Notification Bug

- (void)signUpInBackgroundWithTarget:(id)target selector:(SEL)selector
{
	/*AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[COPDBackend sharedBackend].baseUrl]] autorelease];

	[self setObject:self.username forKey:@"username"];
	[self setObject:self.password forKey:@"password"];

	[client postPath:COPD_USERS_PATH parameters:self.objectData
		success:^(AFHTTPRequestOperation *operation, id responseObject)
		{
			NSString *responseString = [[[NSString alloc] initWithBytes:[(NSData*)responseObject bytes] length:[(NSData*)responseObject length] encoding:NSUTF8StringEncoding] autorelease];

			if (responseString && [responseString JSONValue])
			{
		 		[target performSelector:selector withObject:self withObject:nil];
			}
			else
			{
				[target performSelector:selector withObject:nil withObject:[NSError errorWithDomain:@"COPDBackend" code:20 userInfo:nil]];
			}
	 	}
		failure:^(AFHTTPRequestOperation *operation, NSError *error)
	 	{
			[target performSelector:selector withObject:nil withObject:error];
		}];*/
    AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[COPDBackend sharedBackend].baseUrl]] autorelease];
    
    [self setObject:self.username forKey:@"Username"];
	[self setObject:self.password forKey:@"Password"];
    
    [self setObject:[COPDBackend sharedBackend].disease_name forKey:@"DiseaseName"];
    
    /*Old Code commented By pankil : 10-07-2013
    [self setObject:@"Heart Failure" forKey:@"DiseaseName"];
    */
    
   // NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:username,@"Password",password,@"Username",@"e6ca32c7-cf71-4ab4-8f1d-e4799ddf2074",@"DiseaseID", nil];
	//[client setAuthorizationHeaderWithUsername:username password:password];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    client.parameterEncoding = AFJSONParameterEncoding;
    // NSLog(@"%@",self.objectData);
    
    
    
	[client postPath:SIGNUP_PATH parameters:self.objectData
             success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        // NSLog(@"%@",[responseObject objectForKey:@"SetNewPatientResult"]);
         //   NSLog(@"%@",[responseObject JSONValue]);
         //NSString *responseString = [[[NSString alloc] initWithBytes:[(NSData*)responseObject bytes] length:[(NSData*)responseObject length] encoding:NSUTF8StringEncoding] autorelease];
         
         
         COPDUser *user = [[[COPDUser alloc] init] autorelease];
         
         user.username = username;
         user.password = password;
         /* if (![user constructFromString:responseObject])
          {
          [target performSelector:selector withObject:nil withObject:[NSError errorWithDomain:@"COPDBackend" code:18 userInfo:nil]];
          return;
          }*/
         if (![user isSucceed:[responseObject objectForKey:@"SetNewPatientResult"]])// this is used to check valid user data, id field should not be empty
         {
             [target performSelector:selector withObject:nil withObject:[NSError errorWithDomain:@"HF" code:18 userInfo:nil]];
             return;
         }
         
         [COPDBackend sharedBackend].currentUser = user;
         
         [target performSelector:selector withObject:user withObject:nil];
         
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"API Error%@",error);
         [target performSelector:selector withObject:nil withObject:error];
     }];

}

- (void)saveInBackground
{
	// guarantee that we won't crash
	[self retain];

	AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[COPDBackend sharedBackend].baseUrl]] autorelease];

	[client setAuthorizationHeaderWithUsername:[COPDBackend sharedBackend].currentUser.username password:[COPDBackend sharedBackend].currentUser.password];

	if ([self.objectId isEqualToString:COPD_BACKEND_INVALID_OBJECT])
	{
		[self release];
		return;
	}

	//[client putPath:[NSString stringWithFormat:COPD_SINGLE_USER_PATH, self.objectId, self.objectId] parameters:self.objectData
	[client putPath:COPD_SINGLE_USER_PATH parameters:self.objectData
    success:^(AFHTTPRequestOperation *operation, id responseObject)
		{
			NSString *responseString = [[[NSString alloc] initWithBytes:[(NSData*)responseObject bytes] length:[(NSData*)responseObject length] encoding:NSUTF8StringEncoding] autorelease];

			[self constructFromString:responseString];

			[self release];
		}
		failure:^(AFHTTPRequestOperation *operation, NSError *error)
		{
			[self release];
		}];
}

@end
