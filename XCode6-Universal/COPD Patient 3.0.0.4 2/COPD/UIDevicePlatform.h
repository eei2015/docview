//
//  UIDevicePlatform.h
//  Emoji
//
//  Created by Kyle Frost on 10/2/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevicePlatform : NSObject
+(UIDevicePlatform *)objDeviceClass;
+(NSString *)platform;
+(NSString *)platformString;

@end
