#import "ChatViewController.h"
#import "Content.h"
#import <Parse/Parse.h>
#import "SendMessageCell.h"
#import "MessageCell.h"
#import "UIViewController+Branding.h"
#import "SBJson.h"
#import "COPDBackend.h"
@interface ChatViewController () <SendMessageCellDelegate>

@property (nonatomic, retain) NSString * sendText;

- (void)showLoading:(BOOL)show;

@end

@implementation ChatViewController
@synthesize sendText = _sendText;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self name: kDataWasUpdated object: nil];
    [_sendText release];
    [super dealloc];
}

- (void)viewDidLoad
{

    
    [super viewDidLoad];
    
    [self loadBrandingViews];
    self.tableView.backgroundColor = nil;
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //self.tableView.backgroundView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"bg.png"]] autorelease];
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"bg@2x.png"]] autorelease];

    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reload) name: kDataWasUpdated object: nil];
    [self reload];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tableView.frame = CGRectMake(65, 50, 640, 832);

    [super viewWillAppear:animated];
    
    @try {
        /*if (![Content shared].messages)
        {
            [self showLoading: YES];
        }*/
        if ([Content shared].messages)
        {
           [self.tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection: 1] atScrollPosition: UITableViewScrollPositionBottom animated: NO]; 
        }
            
       //  [self.tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection: 1] atScrollPosition: UITableViewScrollPositionBottom animated: NO];*/
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@",exception);
    }
    @finally {
        //
    }
    
    [[COPDBackend sharedBackend] updateChatWithPatientDiseaseId:[[Content shared].copdUser objectForKey:@"PatientDisease_ID"] WithBlock:^(NSError *errorOrNil) {
        //
    }];

    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver: self name: kDataWasUpdated object: nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - data


- (void)reload
{
    Content *content=[Content shared];
     [self showLoading: YES];
    [content queryChatHistoryWithPatientDiseaseId:^(NSError *errorOrNil) {
        //
        if (errorOrNil==nil) {
            [self showLoading: NO];
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection: 1] atScrollPosition: UITableViewScrollPositionBottom animated: NO];
        }
    }];
   
}

- (void)showLoading:(BOOL)show
{
    showLoading = show;
    if (showLoading)
    {
        UIView * v = [[[UIView alloc] initWithFrame: self.view.bounds] autorelease];
        
        UIActivityIndicatorView * av = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite] autorelease];
        av.center = v.center;
        av.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
        [v addSubview: av];
        [av startAnimating];
        [self.tableView.backgroundView addSubview: av];
    }
    else
    {
        [[self.tableView.backgroundView.subviews lastObject] removeFromSuperview];
    }
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (showLoading)
    {
        return 0;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [[Content shared].messages count];
    }
    else if (section == 1)
    {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        //PFObject * message = [[Content shared].messages objectAtIndex: indexPath.row];
        COPDObject * message = [[Content shared].messages objectAtIndex: indexPath.row];
        static NSString * cellId = @"mcell";
        
        MessageCell * cell = [tableView dequeueReusableCellWithIdentifier: cellId];
        if (!cell)
        {
            cell = [[[MessageCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellId] autorelease];
        }
        NSString * body = [message objectForKey: @"Chat_Message"];
        
        NSDateFormatter * df = [[[NSDateFormatter alloc] init] autorelease];
        [df setDateStyle: NSDateFormatterMediumStyle];
        [df setTimeStyle: NSDateFormatterShortStyle];
        
        //NSLog(@"createdAt: %@",message.createdAt);
        
        NSString * status = [df stringFromDate: message.createdAt];
		if ([message objectForKey:@"SenderFullName"] && [[message objectForKey:@"SenderFullName"] length])
		{
			status = [NSString stringWithFormat:@"%@ on %@", [message objectForKey:@"SenderFullName"], status];
		}
        BOOL highlighted = [[message objectForKey: @"IsFromPatient"] boolValue];
        
        [cell updateWithBody: body status: status highlighted: highlighted];
        

        if (![[message objectForKey: @"IsFromPatient"] boolValue] )
        {
            if (![[message objectForKey: @"IsPatientAcknowledged"] boolValue])
            {
                [message setObject: [NSNumber numberWithInt: YES] forKey: @"IsPatientAcknowledged"];
                //[message saveInBackground];
            }
        }
        return cell;
    }
    else if (indexPath.section == 1)
    {
        static NSString * cellId = @"smcell";
        SendMessageCell * cell = [tableView dequeueReusableCellWithIdentifier: cellId];
        if (!cell)
        {
            cell = [[[SendMessageCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellId] autorelease];
        }
        cell.text = self.sendText;
        cell.delegate = self;
        
        return cell;
    }
    return nil;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        COPDObject * message = [[Content shared].messages objectAtIndex: indexPath.row];
        if ([[message objectForKey: @"Chat_Message"] isKindOfClass:[NSString class]]) {
            NSString * body = [message objectForKey: @"Chat_Message"];
            
            
            
            CGSize sz = [body sizeWithFont: [UIFont systemFontOfSize: 28] constrainedToSize: CGSizeMake(self.view.frame.size.width - 40, CGFLOAT_MAX)];
            return sz.height + 25 + 30 + 60;
        }
       
    }
    else if (indexPath.section == 1)
    {
        return 220;
    }
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.dragging)
    {
        CGFloat maxOffset = scrollView.contentSize.height - scrollView.frame.size.height ;
        CGFloat testOffset = scrollView.contentOffset.y - 120;
        if (testOffset <  maxOffset)
        {
            [self.view endEditing: YES];
        }
    }
}


- (void)sendMessageCellDidStartEditing:(SendMessageCell *)cell
{
    [self.tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection: 1] atScrollPosition:UITableViewScrollPositionTop animated: YES];
}

- (void)sendMessageCellTextChanged:(SendMessageCell *)cell
{
    self.sendText = cell.text;
}

- (void)sendMessagePush:(NSString *)text messageId:(NSString *)messageId
{
   // [[Content shared]  initBackendForIphone];
    
    // [[Content shared] initBackendForIpad];
    
   /* [[Content shared]  initBackendForIphone];
    
    NSMutableDictionary *data = [[[NSMutableDictionary alloc] init] autorelease];
    [data setObject: @"You've got a new message from patient." forKey:@"alert"];
    [data setObject:[NSNumber numberWithInt:1] forKey:@"badge"];
    [data setObject: messageId forKey:@"messageId"];
    [data setObject: @"default" forKey: @"sound"];
    
    [PFPush sendPushDataToChannelInBackground: @"" withData: data];*/

    NSMutableDictionary *data = [[[NSMutableDictionary alloc] init] autorelease];
   // [data setObject: @"You've got a new message from patient." forKey:@"alert"];
    //2014-01-30 Vipul Push notification message use first name
    //NSString *strUserName=[NSString stringWithFormat:@"%@. %@",[[Content shared].userFirstName substringWithRange:NSMakeRange(0, 1)],[Content shared].userLastName];
    NSString *strUserName=[NSString stringWithFormat:@"%@",[Content shared].userFirstName];
    //2014-01-30 Vipul Push notification message use first name
    /*if ([strUserName length]>100) {
        //
    }*/
    [data setObject: [NSString stringWithFormat:@"%@ has sent a message",strUserName] forKey:@"alert"];
    [data setObject:[NSNumber numberWithInt:1] forKey:@"badge"];
    [data setObject: messageId forKey:@"messageId"];
    [data setObject: @"Default" forKey: @"sound"];
    
    NSMutableDictionary *notifyData=[[[NSMutableDictionary alloc] init] autorelease];
    [notifyData setObject:@"" forKey:@"ParseChannels"];
    [notifyData setObject:[data JSONRepresentation] forKey:@"Notification_Text"];
    [notifyData setObject:[Content shared].copdUser.objectId forKey:@"CreatedBy"];
    
    
    // NSError *error = nil;
    //BOOL succeed=[PFPush sendPushDataToChannel: @"" withData: data error:&error];
    
    //2014-03-04 Vipul Amazon SNS
//    [[Content shared] initBackendForIpad];
//   [PFPush sendPushDataToChannelInBackground:@"" withData:data block:^(BOOL succeeded, NSError *error) {
//        //
//        if (error) {
//            succeeded=FALSE;
//        }
//        [notifyData setObject:@"1" forKey:@"IsFromChat"];
//        [notifyData setObject:[NSString stringWithFormat:@"%u",succeeded] forKey:@"Status"];
//        [notifyData setObject:(error)?error.description:@"" forKey:@"ParseMessage"];
//        [[COPDBackend sharedBackend] saveNotificationInBackground:notifyData WithBlock:^(NSError *errorOrNil) {
//            //
//        }];
//       
//    }];
    [[Content shared] sendAmazonNotification:[NSString stringWithFormat:@"%@ has sent a message",strUserName] TopicARN:@"Clinician" EndpointARN:nil]; 
    [[COPDBackend sharedBackend] saveNotificationInBackground:notifyData WithBlock:^(NSError *errorOrNil) {
                    //
    }];
    //2014-03-04 Vipul Amazon SNS
    
//    [notifyData setObject:@"1" forKey:@"IsFromChat"];
//    [notifyData setObject:[NSString stringWithFormat:@"%u",succeed] forKey:@"Status"];
//    [notifyData setObject:(error)?error.description:@"" forKey:@"ParseMessage"];
//    
//    [[COPDBackend sharedBackend] saveNotificationInBackground:notifyData WithBlock:^(NSError *errorOrNil) {
//        //
//    }];


    

    
    
    
}

- (void)sendMessageCellSendText:(SendMessageCell *)cell
{
   // PFObject * newMessage = [PFObject objectWithClassName: @"Message"];
    BOOL flag=TRUE;
    int index=0;
    NSString *chatText=self.sendText;
    while (flag && chatText.length>0) { // remove white spaces till you find any alphanumeri value
        
        if (![[NSCharacterSet alphanumericCharacterSet] characterIsMember:[chatText characterAtIndex:0]]) {
            NSRange range = NSMakeRange(0,1);
            chatText = [chatText stringByReplacingCharactersInRange:range withString:@""];
        }else {
            flag=FALSE;
        }
        index++;
    }

    
    COPDObject * newMessage =[[[COPDObject alloc] init] autorelease]; //[PFObject objectWithClassName: @"Message"];
    [newMessage setObject: chatText forKey: @"Chat_Message"];
    [newMessage setObject: [Content shared].copdUser.objectId forKey: @"CreatedBy"];
    [newMessage setObject: [Content shared].copdUser.objectId forKey: @"PatientID_FK"];
    [newMessage setObject: [[Content shared].copdUser objectForKey:@"PatientDisease_ID"] forKey: @"PatientDiseaseID_FK"];
    [newMessage setObject: [Content shared].diseaseID forKey: @"Disease_ID"];
    [newMessage setObject: [NSNumber numberWithInt:0] forKey: @"ReportStatus_ID_FK"];
    [newMessage setObject: [NSNumber numberWithInt: YES] forKey: @"IsFromPatient"];
    [newMessage setObject: [NSNumber numberWithInt: NO] forKey: @"IsPatientAcknowledged"];
	[newMessage setObject:[NSString stringWithFormat:@"%@ %@", [Content shared].userFirstName, [Content shared].userLastName] forKey:@"SenderFullName"];
    
    [[Content shared].messages addObject: newMessage];
    [self.tableView insertRowsAtIndexPaths: [NSArray arrayWithObject: [NSIndexPath indexPathForRow: [[Content shared].messages count] - 1  inSection: 0]] withRowAnimation: UITableViewRowAnimationFade];
    self.sendText = nil;
    cell.text = nil;
    [self.tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection: 1] atScrollPosition:UITableViewScrollPositionBottom animated: YES];
    
    [newMessage saveChatInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) 
        {
            [self sendMessagePush: chatText messageId: newMessage.objectId];
            
            
          //  [[Content shared].messages addObject: newMessage];
         //   NSLog(@"%d",[[Content shared].messages count]);
         /*   [self.tableView insertRowsAtIndexPaths: [NSArray arrayWithObject: [NSIndexPath indexPathForRow: [[Content shared].messages count] - 1  inSection: 0]] withRowAnimation: UITableViewRowAnimationFade];
            self.sendText = nil;
            cell.text = nil;
            [self.tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection: 1] atScrollPosition:UITableViewScrollPositionBottom animated: YES];*/
            
            
           /* double delayInSeconds = 0.3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
			dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
            {
                if ([[Content shared] messages])
                {
                    [self.tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection: 1] atScrollPosition:UITableViewScrollPositionBottom animated: YES];
                }
            });
            [self sendMessagePush: chatText messageId: newMessage.objectId];*/

        } else {
            [[Content shared].messages removeLastObject];
            [self.tableView reloadData];
        }
    }];

}

@end
