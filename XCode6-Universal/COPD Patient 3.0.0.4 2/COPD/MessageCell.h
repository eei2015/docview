#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell
{
    UIView * bodyFrame;
    UILabel * bodyLabel;
    UILabel * statusLabel;
}

- (void)updateWithBody:(NSString *)body status:(NSString *)status highlighted:(BOOL)highlighted;

@end
