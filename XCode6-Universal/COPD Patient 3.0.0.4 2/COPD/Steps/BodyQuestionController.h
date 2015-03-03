//
//  BodyViewController.h
//  COPD
//
//  Created by Pavel Sharanda on 19.06.12.
//

#import "BaseQuestionController.h"

@interface BodyQuestionController : BaseQuestionController
{
    NSMutableArray * btns;
    NSMutableArray * parts;
    NSMutableArray * bodyBtns;
    UIView * bodyButtonsRootView;
}
@end


extern NSString * const kBodyQuestionController_KeyPath_Key;
extern NSString * const kBodyQuestionController_Title_Key;
extern NSString * const kBodyQuestionController_HelpUrl_Key;
extern NSString * const kBodyQuestionController_Error_Key;