#import <Foundation/Foundation.h>


///////////// Usage example
// Sample code of using PusherRestClient:
// TODO - remove
//PusherRESTClient *pusherClient = [PusherRESTClient clientWithAppId:@"27122" apiKey:@"09c21608dd33a4db4d11" apiSecret:@"ba1622be782600de3e5e"];
//[pusherClient pushToChannel:@"test" eventName:@"test_user" event:[NSDictionary dictionaryWithObject:@"test record" forKey:@"event"] completionBlock:^(NSError *errorOrNil)
// {
//	 if (!errorOrNil)
//		 NSLog(@"push succeeded");
//	 else
//		 NSLog(@"push failed\n%@", [errorOrNil localizedDescription]);
// }];
/////////////////

@interface PusherRESTClient : NSObject
{
	NSString *appId;
	NSString *apiKey;
	NSString *apiSecret;
}

@property(nonatomic, retain) NSString *appId;
@property(nonatomic, retain) NSString *apiKey;
@property(nonatomic, retain) NSString *apiSecret;

+ (PusherRESTClient*)clientWithAppId:(NSString*)pusherAppId apiKey:(NSString*)pusherApiKey apiSecret:(NSString*)pusherApiSecret;

- (void)pushToChannel:(NSString*)channelName eventName:(NSString*)eventName event:(NSDictionary*)eventData completionBlock:(void (^)(NSError *errorOrNil))block;

@end
