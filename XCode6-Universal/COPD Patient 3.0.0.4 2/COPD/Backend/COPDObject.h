#import <Foundation/Foundation.h>

#define COPD_BACKEND_INVALID_OBJECT @""

//-1


@interface COPDObject : NSObject
{
	//NSInteger objectId;
    NSString *objectId;
	NSDate *createdAt;

	NSMutableDictionary *objectData;
    NSString *objectJSON;
}

//@property(nonatomic, readwrite) NSInteger objectId;
@property(nonatomic, retain) NSString* objectId;

@property(nonatomic, retain) NSDate *createdAt;

@property(nonatomic, retain) NSMutableDictionary *objectData;
@property(nonatomic, retain) NSString *objectJSON;

- (id)init;

- (id)objectForKey:(NSString *)key;

- (void)setObject:(id)object forKey:(NSString*)key;

- (void)save;

- (void)saveInBackground;

- (void)saveChatInBackgroundWithBlock:(void(^)(BOOL succeed, NSError *errorOrNil))block;
- (void)saveInBackgroundWithBlock:(void(^)(BOOL succeed, NSError *errorOrNil))block;

- (void)removeNSNullKeys;

- (BOOL)constructFromString:(NSString*)string;
- (BOOL)constructFromDictionary:(NSDictionary*)dict;
- (BOOL)isSucceed:(NSDictionary*)dict;
@end
