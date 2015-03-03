#import "COPDQuery.h"


@implementation COPDQuery

@synthesize rows;

- (id)init
{
	self = [super init];

	self.rows = [[[NSMutableArray alloc] init] autorelease];

	return self;
}

- (void)dealloc
{
	self.rows = nil;
	[super dealloc];
}

@end
