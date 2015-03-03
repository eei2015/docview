#import "COPDObject.h"
#import "COPDBackend.h"

#import "AFNetworking.h"
#import "SBJson.h"


@interface COPDObject (PrivateMethods)
- (void)saveExistingObject;
- (void)createNewObject;
@end


@implementation COPDObject

@synthesize objectId, objectData, createdAt,objectJSON;

- (id)init
{
	self = [super init];

	// initialize with invalid id
	self.objectId = COPD_BACKEND_INVALID_OBJECT;
	self.createdAt = [[[NSDate alloc] init] autorelease];
	self.objectData = [[[NSMutableDictionary alloc] init] autorelease];
    
	return self;
}

- (void)dealloc
{
	self.createdAt = nil;
	self.objectData = nil;
    self.objectJSON=nil;
	[super dealloc];
}

- (id)objectForKey:(NSString *)key
{
	if (![self.objectData objectForKey:key])
	{
		return nil;
	}
	if ([[self.objectData objectForKey:key] isKindOfClass:[NSNull class]])
	{
		return nil;
	}

	return [self.objectData objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString*)key
{
	[self.objectData setValue:object forKey:key];
}

- (void)save
{
	//[self removeNSNullKeys];

	if (self.objectId == COPD_BACKEND_INVALID_OBJECT)
	{
		[self createNewObject];
	}
	else
	{
		[self saveExistingObject];
	}
}

- (void)saveInBackground
{
	// guarantee that we won't crash
	[self retain];

	AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[COPDBackend sharedBackend].baseUrl]] autorelease];

	//[client setAuthorizationHeaderWithUsername:[COPDBackend sharedBackend].currentUser.username password:[COPDBackend sharedBackend].currentUser.password];

    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    client.parameterEncoding = AFJSONParameterEncoding;
    
   // NSLog(@"Object: %@",[COPDBackend sharedBackend].baseUrl);
    
    [client postPath:UPDATE_REPORTSTATUS parameters:self.objectData
             success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         /*NSString *responseString = [[[NSString alloc] initWithBytes:[(NSData*)responseObject bytes] length:[(NSData*)responseObject length] encoding:NSUTF8StringEncoding] autorelease];
         
         [self constructFromString:responseString];*/
         [self release];
     }
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Eror: %@",error);
         [self release];
     }];
    
    
/*	if (self.objectId == COPD_BACKEND_INVALID_OBJECT)
	{
		//[client postPath:[NSString stringWithFormat:COPD_REPORTS_PATH, [COPDBackend sharedBackend].currentUser.objectId] parameters:self.objectData
        [client postPath:COPD_REPORTS_PATH parameters:self.objectData
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
	else
	{
		//[client putPath:[NSString stringWithFormat:COPD_SINGLE_REPORT_PATH, [[self objectForKey:@"user_id"] intValue], self.objectId] parameters:self.objectData
	[client putPath:COPD_SINGLE_REPORT_PATH parameters:self.objectData	
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
	}*/
    
}
- (void)saveChatInBackgroundWithBlock:(void(^)(BOOL succeed, NSError *errorOrNil))block {
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
    
}
- (void)saveInBackgroundWithBlock:(void(^)(BOOL succeed, NSError *errorOrNil))block {
    __block BOOL finished = false;
    
    
	AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[COPDBackend sharedBackend].baseUrl]] autorelease];
    
	//[client setAuthorizationHeaderWithUsername:[COPDBackend sharedBackend].currentUser.username password:[COPDBackend sharedBackend].currentUser.password];
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    client.parameterEncoding = AFJSONParameterEncoding;
    
    NSLog(@"%@", self.objectData);
    
	if (self.objectId == COPD_BACKEND_INVALID_OBJECT)
	{
		//[client postPath:[NSString stringWithFormat:COPD_REPORTS_PATH, [COPDBackend sharedBackend].currentUser.objectId] parameters:self.objectData
        [client postPath:SAVE_DATA_PATH parameters:self.objectData
                 success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
            
             finished = true;
             block(true,nil);
         }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             block(FALSE,error);
             NSLog(@"%@",error);
             finished = true;
         }];
	}
    
	NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:0.1];
	while (!finished && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil])
	{
		loopUntil = [NSDate dateWithTimeIntervalSinceNow:0.1];
	}

}
- (void)saveExistingObject
{
	__block BOOL finished = false;

	AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[COPDBackend sharedBackend].baseUrl]] autorelease];

	//[client setAuthorizationHeaderWithUsername:[COPDBackend sharedBackend].currentUser.username password:[COPDBackend sharedBackend].currentUser.password];


	//[client putPath:[NSString stringWithFormat:COPD_SINGLE_REPORT_PATH, [[self objectForKey:@"user_id"] intValue], self.objectId] parameters:self.objectData
      //  [client putPath:COPD_SINGLE_REPORT_PATH parameters:self.objectData
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    client.parameterEncoding = AFJSONParameterEncoding;
    
     [client putPath:SAVE_DATA_PATH parameters:self.objectData
success:^(AFHTTPRequestOperation *operation, id responseObject)
		{
			NSString *responseString = [[[NSString alloc] initWithBytes:[(NSData*)responseObject bytes] length:[(NSData*)responseObject length] encoding:NSUTF8StringEncoding] autorelease];

			[self constructFromString:responseString];
			finished = true;
		}
		failure:^(AFHTTPRequestOperation *operation, NSError *error)
		{
             NSLog(@"%@",error);
			finished = true;
		}];

	NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:0.1];
	while (!finished && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil])
	{
		loopUntil = [NSDate dateWithTimeIntervalSinceNow:0.1];
	}
}

- (void)createNewObject
{
	__block BOOL finished = false;


	AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[COPDBackend sharedBackend].baseUrl]] autorelease];

	//[client setAuthorizationHeaderWithUsername:[COPDBackend sharedBackend].currentUser.username password:[COPDBackend sharedBackend].currentUser.password];

    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    client.parameterEncoding = AFJSONParameterEncoding;
    
	if (self.objectId == COPD_BACKEND_INVALID_OBJECT)
	{
		//[client postPath:[NSString stringWithFormat:COPD_REPORTS_PATH, [COPDBackend sharedBackend].currentUser.objectId] parameters:self.objectData
        [client postPath:SAVE_DATA_PATH parameters:self.objectData
        success:^(AFHTTPRequestOperation *operation, id responseObject)
			{
				//NSString *responseString = [[[NSString alloc] initWithBytes:[(NSData*)responseObject bytes] length:[(NSData*)responseObject length] encoding:NSUTF8StringEncoding] autorelease];

				//[self constructFromString:responseString];
         //       NSLog(@"%@",responseObject);
				finished = true;
			}
			failure:^(AFHTTPRequestOperation *operation, NSError *error)
			{
                NSLog(@"%@",error);
				finished = true;
			}];
	}

	NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:0.1];
	while (!finished && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil])
	{
		loopUntil = [NSDate dateWithTimeIntervalSinceNow:0.1];
	}
}

- (void)removeNSNullKeys
{
	NSArray *keys = [self.objectData allKeys];

	for (NSString *key in keys)
	{
		if (![self.objectData valueForKey:key] || [[self.objectData valueForKey:key] isKindOfClass:[NSNull class]])
		{
			[self.objectData removeObjectForKey:key];
		}
	}
}

- (BOOL)constructFromString:(NSString*)string
{
	static NSDateFormatter *formatter = nil;

	if (!formatter)
	{
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"];
	}

	if (string)
	{
		NSDictionary *responseData = (NSDictionary*)[string JSONValue];
		if (responseData && [responseData isKindOfClass:[NSDictionary class]])
		{
			NSString *objectIdNumber = [responseData objectForKey:@"id"];
			if (objectIdNumber && [objectIdNumber isKindOfClass:[NSString class]])
			{
				NSString *creationDateStr = [responseData objectForKey:@"created_at"];
				if (creationDateStr && [creationDateStr isKindOfClass:[NSString class]])
				{
					NSDate *creationDate = [formatter dateFromString:creationDateStr];
					if (creationDate)
					{
						self.objectId = objectIdNumber;//[objectIdNumber intValue];
						self.createdAt = creationDate;
						self.objectData = [[[NSMutableDictionary alloc] initWithDictionary:responseData] autorelease];

						[self removeNSNullKeys];

						return true;
					}
				}
			}
		}
	}

	return false;
}
- (BOOL)isSucceed:(NSDictionary*)dict
{
    NSUInteger error=[[dict objectForKey:@"Error"] intValue];
    
    if(error==0)
    {
        return TRUE;
    }
    return false;
}
/*- (BOOL)constructFromDictionary:(NSDictionary*)dict
{
	static NSDateFormatter *formatter = nil;

	if (!formatter)
	{
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"];
	}

	if (dict && [dict isKindOfClass:[NSDictionary class]])
	{
		NSNumber *objectIdNumber = [dict objectForKey:@"id"];
		if (objectIdNumber && [objectIdNumber isKindOfClass:[NSNumber class]])
		{
			NSString *creationDateStr = [dict objectForKey:@"created_at"];
			if (creationDateStr && [creationDateStr isKindOfClass:[NSString class]])
			{
				NSDate *creationDate = [formatter dateFromString:creationDateStr];
				if (creationDate)
				{
					self.objectId = [objectIdNumber intValue];
					self.createdAt = creationDate;
					self.objectData = [[[NSMutableDictionary alloc] initWithDictionary:dict] autorelease];

					[self removeNSNullKeys];

					return true;
				}
			}
		}
	}
}*/
- (BOOL)constructFromDictionary:(NSDictionary*)dict
{
   /* static NSDateFormatter *formatter = nil;
    
	if (!formatter)
	{
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"];
	}*/
    
   // NSLog(@"%@",dict);
    
	if (dict && [dict isKindOfClass:[NSDictionary class]])
	{
       
       // NSUInteger error=[[dict objectForKey:@"Error"] intValue];
       // if(error==0)
       // {
            //NSString *objectIdNumber = [dict objectForKey:@"Patient_ID"];
            //NSString *creationDateStr = [dict objectForKey:@"Patient_CreatedDate"];
            //NSDate *creationDate =[NSDate dateWithTimeIntervalSince1970:[creationDateStr doubleValue]];
            //self.objectId = objectIdNumber;//[objectIdNumber intValue];
            //self.createdAt = creationDate;
            self.objectData = [[[NSMutableDictionary alloc] initWithDictionary:dict] autorelease];
            
            [self removeNSNullKeys];
            
            return true;

       // }
		
		
	}

	return false;
}

@end
