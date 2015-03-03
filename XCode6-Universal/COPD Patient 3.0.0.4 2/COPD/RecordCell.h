#import <UIKit/UIKit.h>
#import "Content.h"

@interface RecordCell : UITableViewCell

@property (nonatomic, readonly) UIView * scoreHolderView;
@property (nonatomic, readonly) UILabel * scoreView;
@property (nonatomic, readonly) UILabel * dateView;
@property (nonatomic, readonly) UILabel * statusView;

- (void)updateWithRecordForHistory:(COPDRecord *)record;
- (void)updateWithRecordForReport:(COPDRecord *)record;

@end
