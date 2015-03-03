#import <UIKit/UIKit.h>

@class CustomTextView;
@class SendMessageCell;

@protocol SendMessageCellDelegate <NSObject>

- (void)sendMessageCellDidStartEditing:(SendMessageCell *)cell;
- (void)sendMessageCellTextChanged:(SendMessageCell *)cell;
- (void)sendMessageCellSendText:(SendMessageCell *)cell;

@end

@interface SendMessageCell : UITableViewCell
{
    CustomTextView * textView;
    UIButton * sendButton;
}

@property (nonatomic, assign) id<SendMessageCellDelegate> delegate;
@property (nonatomic, retain) NSString * text;

@end
