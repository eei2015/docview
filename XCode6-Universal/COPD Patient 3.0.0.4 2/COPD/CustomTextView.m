#import "CustomTextView.h"

@implementation CustomTextView
@synthesize placeHolder;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.placeHolder = nil;
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
    if( [self.placeHolder length] > 0 )
    {
        if ( placeHolderLabel == nil )
        {
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            placeHolderLabel.lineBreakMode = UILineBreakModeWordWrap;
            placeHolderLabel.numberOfLines = 0;
            placeHolderLabel.font = self.font;
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.textColor = [UIColor lightGrayColor];
            [self addSubview:placeHolderLabel];
        }
        
        placeHolderLabel.text = self.placeHolder;
        [placeHolderLabel sizeToFit];
    }
    
    placeHolderLabel.hidden = self.text.length > 0;
    
    [super drawRect:rect];
}

- (void)textChanged:(NSNotification *)notification
{
    if ([notification object] == self)
    {
        placeHolderLabel.hidden = self.text.length > 0;
    }    
}

- (void)setText:(NSString *)text 
{
    [super setText:text];
    [self textChanged:nil];
}

@end
