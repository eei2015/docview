#import <Foundation/Foundation.h>

#import "COPDObject.h"


@interface COPDUser : COPDObject
{
	NSString *password;
	NSString *username;
}

@property (nonatomic, retain) NSString *password;

@property (nonatomic, retain) NSString *username;


- (id)init;

+ (COPDUser*)user;

+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password target:(id)target selector:(SEL)selector;

+ (void)validatePatient:(NSString *)username password:(NSString *)password block:(void (^)(NSError *errorOrNil))block;


+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password block:(void (^)(COPDUser *user, NSError *errorOrNil))block;

//2014-09-10 Vipul 3.0.0.2 Schedule Notification Bug
+(void)UpdateScheduleNotification:(NSString*)DeviceToken PatientID:(NSString*)PatientID;
//2014-09-10 Vipul 3.0.0.2 Schedule Notification Bug

- (void)signUpInBackgroundWithTarget:(id)target selector:(SEL)selector;

- (void)saveInBackground;

@end
