#import <UIKit/UIKit.h>
#import "BaseQuestionController.h"

@class DigitsView;

@interface DigitsQuestionController : BaseQuestionController
{
    DigitsView * digitsView;
}

@end

extern NSString * const kDigitsQuestionController_Title_Key;
extern NSString * const kDigitsQuestionController_HelpUrl_Key;
extern NSString * const kDigitsQuestionController_Divider_Key;
extern NSString * const kDigitsQuestionController_SelectedFieldKeyPath_Key;
extern NSString * const kDigitsQuestionController_Fields_Key;

extern NSString * const kDigitsQuestionController_Field_KeyPath_Key;
extern NSString * const kDigitsQuestionController_Field_RangeBegin_Key;
extern NSString * const kDigitsQuestionController_Field_RangeEnd_Key;
extern NSString * const kDigitsQuestionController_Field_Prompt_Key;
extern NSString * const kDigitsQuestionController_Field_Error_Key;




