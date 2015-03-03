#import "PusherRESTClient.h"
#import "AFNetworking.h"
#import "AFJSONUtilities.h"

#import <CommonCrypto/CommonHMAC.h>


@interface NSString (NSString_MD5)
- (NSString*)MD5;
@end

@implementation NSString (NSString_MD5)
- (NSString*)MD5
{
	// Create pointer to the string as UTF8
	const char *ptr = [self UTF8String];

	// Create byte array of unsigned chars
	unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];

	// Create 16 byte MD5 hash value, store in buffer
	CC_MD5(ptr, strlen(ptr), md5Buffer);

	// Convert MD5 value in the buffer to NSString of hex values
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) 
		[output appendFormat:@"%02x", md5Buffer[i]];

	return output;
}
@end;


@interface NSData (NSData_HexAdditions)
- (NSString*)stringWithHexBytes;
@end

@implementation NSData (NSData_HexAdditions)
- (NSString*)stringWithHexBytes 
{
	static const char hexdigits[] = "0123456789abcdef";
	const size_t numBytes = [self length];
	const unsigned char* bytes = [self bytes];
	char *strbuf = (char *)malloc(numBytes * 2 + 1);
	char *hex = strbuf;
	NSString *hexBytes = nil;

	for (int i = 0; i<numBytes; ++i) 
	{
		const unsigned char c = *bytes++;
		*hex++ = hexdigits[(c >> 4) & 0xF];
		*hex++ = hexdigits[(c ) & 0xF];
	}
	*hex = 0;
	hexBytes = [NSString stringWithUTF8String:strbuf];
	free(strbuf);
	return hexBytes;
}
@end


@interface PusherRESTClient (PrivateMethods)
NSData* hmacForKeyAndData(NSString *key, NSString *data);
@end


@implementation PusherRESTClient

@synthesize appId, apiKey, apiSecret;

+ (PusherRESTClient*)clientWithAppId:(NSString*)pusherAppId apiKey:(NSString*)pusherApiKey apiSecret:(NSString*)pusherApiSecret
{
	PusherRESTClient *client = [[[PusherRESTClient alloc] init] autorelease];
	client.appId = pusherAppId;
	client.apiKey = pusherApiKey;
	client.apiSecret = pusherApiSecret;

	return client;
}

- (id)init
{
	self = [super init];

	self.appId = nil;
	self.apiKey = nil;
	self.apiSecret = nil;

	return self;
}

- (void)dealloc
{
	self.appId = nil;
	self.apiKey = nil;
	self.apiSecret = nil;

	[super dealloc];
}

- (void)pushToChannel:(NSString*)channelName eventName:(NSString*)eventName event:(NSDictionary*)eventData completionBlock:(void (^)(NSError *errorOrNil))block
{
	if (!self.appId || !self.apiKey || !self.apiSecret)
	{
		block([NSError errorWithDomain:@"PusherRESTClient" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Invalid api access credentials" forKey:NSLocalizedDescriptionKey]]);
		return;
	}

	//Prepare the data here

	// Calculating md5 for the post body
	NSError *error = nil;
    NSData *jsonData = AFJSONEncode(eventData, &error);
	if (error || !jsonData)
	{
		block([NSError errorWithDomain:@"PusherRESTClient" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Invalid event dictionary (JSONEncode failed)" forKey:NSLocalizedDescriptionKey]]);
		return;
	}

	NSString *postBody = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];


	// Current time interval since 1970
	NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];


	// Prepare the signature string
	NSString *signatureString = [NSString stringWithFormat:@"POST\n/apps/%@/channels/%@/events\nauth_key=%@&auth_timestamp=%.0f&auth_version=1.0&body_md5=%@&name=%@", self.appId, channelName, self.apiKey, interval, [postBody MD5], eventName];

	NSData *signatureHMAC = hmacForKeyAndData(self.apiSecret, signatureString);


	// Prepare post path
	NSString *postPath = [NSString stringWithFormat:@"apps/%@/channels/%@/events?name=%@&auth_key=%@&auth_version=1.0&auth_timestamp=%.0f&auth_signature=%@&body_md5=%@", self.appId, channelName, eventName, self.apiKey, interval, [signatureHMAC stringWithHexBytes], [postBody MD5]];
	
	AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.pusherapp.com/"]] autorelease];

	client.parameterEncoding = AFJSONParameterEncoding;
	[client postPath:postPath parameters:eventData success:^(AFHTTPRequestOperation *operation, id responseObject)
	{
		NSString *responseString = [[[NSString alloc] initWithBytes:[(NSData*)responseObject bytes] length:[(NSData*)responseObject length] encoding:NSUTF8StringEncoding] autorelease];
		(void)responseString;
		// Uncomment to debug
		// NSLog(@"response\n%@", responseString);
		block(nil);
		return;
		
	}
	failure:^(AFHTTPRequestOperation *operation, NSError *error)
	{
		// Uncomment to debug
		// NSLog(@"ERROR\n%@", error);
		// If there will be any problems, you'll need to tweak a little the AFHTTPClient
		// acceptableStatusCodes in AFHTTPRequestOperation should be set to accept 400+ codes,
		// that way pusher will tell exactly what's wrong
		block([NSError errorWithDomain:@"PusherRESTClient" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Pusher rejected the message" forKey:NSLocalizedDescriptionKey]]);
		return;
	}];
}

NSData *hmacForKeyAndData(NSString *key, NSString *data)
{
	const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
	const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];

	unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];

	CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);

	return [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
}

@end
