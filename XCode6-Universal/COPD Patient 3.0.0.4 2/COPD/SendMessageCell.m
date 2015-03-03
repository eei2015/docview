#import "SendMessageCell.h"
#import "CustomTextView.h"
#import <QuartzCore/QuartzCore.h>

@interface SendMessageCell () <UITextViewDelegate>

@end

@implementation SendMessageCell
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        textView = [[[CustomTextView alloc] initWithFrame: CGRectZero] autorelease];
        textView.font = [UIFont systemFontOfSize: 28];//14
        textView.backgroundColor = [UIColor whiteColor];
        textView.delegate = self;
        textView.placeHolder =  @"New message";
        textView.layer.borderColor = [UIColor colorWithRed: 0.676 green: 0.684 blue: 0.686 alpha: 1].CGColor;
        textView.layer.borderWidth = 1;
        textView.layer.cornerRadius = 11;
        [self.contentView addSubview: textView];
        
        sendButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        [sendButton setTitle: @"Send Message" forState: UIControlStateNormal];
        // Jatin Chauhan 28-Nov-2013
        
        sendButton.titleLabel.font = [UIFont systemFontOfSize:28];
        
  //      [sendButton.titleLabel.font =[UIFont systemFontOfSize:17.0]];
                // -Jatin Chauhan 28-Nov-2013
        [sendButton addTarget: self action: @selector(sendButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
        [self.contentView addSubview: sendButton];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat w = self.contentView.frame.size.width;
    CGFloat h = self.contentView.frame.size.height;
    
    CGFloat btnw = 248;//124
    CGFloat btnh = 66;//33
    CGFloat btnpad = 10;
    
    CGFloat pad = 20;// 10
    
    textView.frame = CGRectMake(pad, 10, w - pad*2, h - btnh - btnpad - pad*2);
    sendButton.frame = CGRectMake(w - btnw - pad, h - btnh -10, btnw, btnh);
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self.delegate sendMessageCellTextChanged: self];
    
}

- (void)sendButtonClicked:(UIButton *)btn
{
    if ([textView.text length] > 0)
    {
        [self.delegate sendMessageCellSendText: self];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.delegate sendMessageCellDidStartEditing: self];
}

- (void)setText:(NSString *)text
{
    textView.text = text;
}

- (NSString *)text
{
    return textView.text;
}

- (BOOL)becomeFirstResponder
{
    return [textView becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [textView resignFirstResponder];
}

@end
