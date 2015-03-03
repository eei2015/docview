#import <UIKit/UIKit.h>

@interface CustomTextView : UITextView
{
    UILabel * placeHolderLabel;
}

@property (nonatomic, retain) NSString * placeHolder;

@end
