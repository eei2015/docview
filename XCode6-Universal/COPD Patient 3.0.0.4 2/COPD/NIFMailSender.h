#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@protocol NIFMailSenderDelegate <NSObject>

- (void)finishedWithResult:(MFMailComposeResult)result;

@end



#define kAttachmentDataKey @"kAttachmentDataKey"
#define kAttachmentMimeTypeKey @"kAttachmentMimeTypeKey"
#define kAttachmentFileNameKey @"kAttachmentFileNameKey"

@interface NIFMailSender : NSObject
{
	UIViewController * parentController;
	NSString* toAddress;
	NSString* subject;
	NSString* body;
    
    NSArray * attachments;
    
}

@property (nonatomic, assign) id<NIFMailSenderDelegate> delegate;
@property (nonatomic, assign) UIViewController *parentController;
@property (nonatomic, retain) NSString *toAddress;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSArray * attachments;




+ (NIFMailSender *)shared;

- (void)sendMail;

@end
