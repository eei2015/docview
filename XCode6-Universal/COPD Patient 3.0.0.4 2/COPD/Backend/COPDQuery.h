#import <Foundation/Foundation.h>


@interface COPDQuery : NSObject
{
	// will store COPDObjects as query rows
	NSMutableArray *rows;
}

@property(nonatomic, retain) NSMutableArray *rows;


- (id)init;

@end
