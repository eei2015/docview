#import "NIFMailSender.h"
#import "TSAlertView.h"


static NIFMailSender * mailSender = nil;

@interface NIFMailSender () <MFMailComposeViewControllerDelegate>

@end


@implementation NIFMailSender

@synthesize toAddress;
@synthesize subject;
@synthesize body;
@synthesize parentController;
@synthesize attachments;
@synthesize delegate;

+ (NIFMailSender *)shared
{
	if (!mailSender)
	{
		mailSender = [[NIFMailSender alloc] init];
	}
	return mailSender;
}

- (void)clearData
{
	self.toAddress = nil;
	self.subject = nil;
	self.body = nil;
	self.parentController = nil;
	self.attachments = nil;
    self.delegate = nil;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [delegate finishedWithResult: result];
	[self.parentController dismissModalViewControllerAnimated:YES];
	[self clearData];
}

- (void)sendMail
{
	
	if (![MFMailComposeViewController canSendMail])
	{
		[self clearData];
		
		TSAlertView *emailAlert = [[[TSAlertView alloc] initWithTitle:@"Error" 
															 message:@"Sorry, e-mail can't be sent. You have to set up e-mail account first."
															delegate:nil
												   cancelButtonTitle:@"OK"
												   otherButtonTitles: nil] autorelease];
		[emailAlert show];
		
		return;
	}
	
	MFMailComposeViewController* c = [[[MFMailComposeViewController alloc] init] autorelease];
	
	[c setMailComposeDelegate:self];
	
	if (subject)
	{
		[c setSubject:subject];
	}
	if (toAddress) 
	{
		[c setToRecipients:[NSArray arrayWithObject:toAddress]];
	}
	if (body) 
	{
		[c setMessageBody:body isHTML: YES];
	}
	
    for (NSDictionary * d in attachments)
    {
        NSData * attachmentData = [d valueForKey: kAttachmentDataKey];
        NSString* attachmentMimeType = [d valueForKey: kAttachmentMimeTypeKey];
        NSString* attachmentFileName = [d valueForKey: kAttachmentFileNameKey];
        [c addAttachmentData: attachmentData mimeType:attachmentMimeType fileName: attachmentFileName];
    }
	[parentController presentModalViewController:c animated:YES];
}

@end
