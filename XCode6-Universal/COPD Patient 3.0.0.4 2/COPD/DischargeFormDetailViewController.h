//
//  PatientDischargeFormDetailViewController.h
//  COPD
//
//  Created by Abbas Agha on 15/05/13.
//  Copyright (c) 2013 TKInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKitUI/EventKitUI.h>
#import <EventKit/EventKit.h>

#import <EventKit/EKEventStore.h>

@interface DischargeFormDetailViewController : UIViewController<EKEventEditViewDelegate>
{
    NSUInteger formType;
    
	EKEventStore *eventStore;
	
    
}
@property NSUInteger formType;
@property (nonatomic, retain) NSMutableArray * pMedications;
@property (nonatomic, retain) EKEventStore *eventStore;


- (void) addEvent;


@end
