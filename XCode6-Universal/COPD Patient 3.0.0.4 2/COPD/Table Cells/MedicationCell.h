#import <UIKit/UIKit.h>

@class MedicationCell;

@protocol MedicationCellDelegate <NSObject>

- (void)medicationClickedInCell:(MedicationCell *)cell button:(UIButton *)button;
- (void)dosageClickedInCell:(MedicationCell *)cell button:(UIButton *)button;
- (void)frequenceClickedInCell:(MedicationCell *)cell button:(UIButton *)button;

@optional
- (void)durationClickedInCell:(MedicationCell *)cell button:(UIButton *)button;

@end


@interface MedicationCell : UITableViewCell
{
    UIButton * medicationButton;
    UIButton * dosageButton;
    UIButton * freqButton;
    UIButton * durationButton;
    
    UIView * sep1;
    UIView * sep2;
    UIView * sep3;
    UIView * sep4;
    UIView * sep5;
    BOOL hasDuration;
}

@property (nonatomic, assign) id<MedicationCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier hasDuration:(BOOL)hd;
- (void)updateWithMedication:(NSString *)medication dosage:(NSString *)dosage frequency:(NSString *)frequency duration:(NSString *)duration;

@end
