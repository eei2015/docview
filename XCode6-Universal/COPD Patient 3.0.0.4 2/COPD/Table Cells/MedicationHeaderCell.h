#import <UIKit/UIKit.h>

@interface MedicationHeaderCell : UITableViewCell
{
    UILabel * medicationLabel;
    UILabel * dosageLabel;
    UILabel * freqLabel;
    UILabel * durationLabel;
    
    UIView * sep1;
    UIView * sep2;
    UIView * sep3;
    UIView * sep4;
    BOOL hasDuration;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier hasDuration:(BOOL)hd;

@property (nonatomic, assign) BOOL simpleHeader;

@end
