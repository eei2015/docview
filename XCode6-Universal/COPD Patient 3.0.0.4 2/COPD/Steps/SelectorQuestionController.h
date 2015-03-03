#import "BaseQuestionController.h"

@class PivotView;

@interface SelectorQuestionController : BaseQuestionController
{
    PivotView * selectorView;
    
    NSInteger currentIndex;
}



@end



extern NSString * const kSelectorViewController_KeyPath_Key;
extern NSString * const kSelectorViewController_Title_Key;
extern NSString * const kSelectorViewController_RangeBegin_Key;
extern NSString * const kSelectorViewController_RangeEnd_Key;
extern NSString * const kSelectorViewController_Subtitle_Key;
extern NSString * const kSelectorViewController_HelpUrl_Key;

