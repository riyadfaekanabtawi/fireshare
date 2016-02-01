//
//  Functions.h
//  BeepGoosh
//
//  Created by Riyad Anabtawi on 1/11/15.
//  Copyright (c) 2015 Riyad Anabtawi. All rights reserved.
//

#import <Foundation/Foundation.h>



#define CALENDAR_IDENTIFIER_KEY @"calendarIdentifier"
#define CALENDAR_TITLE @"FireShare"

@interface Functions : NSObject


+(NSDate *)stringToDate:(NSString *)string;
+(NSDate *)stringToDate:(NSString *)string WithFormat:(NSString *)format;
+(NSString *)dateToString:(NSDate *)date WithFormat:(NSString *)format;
+(UIColor*)colorWithHexString:(NSString*)hex;
//+(NSDate *)addDays:(NSInteger)days toDate:(NSDate *)date;
//+(NSDate *)addMinutes:(NSInteger)minutes toDate:(NSDate *)date;
+(void)buttonBounceAnimation:(UIView *)view withFinalScale:(CGFloat)scale;
+(BOOL)isDate:(NSDate *)date inRangeFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate;
+(void)buttonBounceAnimation:(UIView *)view ;
+(BOOL) NSStringIsValidEmail:(NSString *)checkString;
+(void)addView:(UIView *)view ToContainer:(UIView *)container WithTopMargin:(NSNumber *)topMargin LeftMargin:(NSNumber *)leftMargin BottomMargin:(NSNumber *)bottomMargin RightMargin:(NSNumber *)rightMargin Width:(NSNumber *)width Height:(NSNumber *)height;
+ (NSString *)deviceUUID;
+(void)deleteUserInfo;
+(UIImage *)CreateGradientInView:(CGRect )bounds withStartColor:(UIColor *)startColor andEndColor:(UIColor *)endColor;
+(void)fillContainerView:(UIView *)container WithView:(UIView *)view;
//+(void)createReminderNotificationForMedia:(NSString *)mediaId WithTitle:(NSString *)title onDate:(NSDate *)date UntilDate:(NSDate *)endDate;
//+(void)createReminderNotificationWithBody:(NSString *)mediaId WithTitle:(NSString *)title onDate:(NSDate *)date UntilDate:(NSDate *)endDate;
+(BOOL)reminderExistsForMedia:(NSString *)mediaId;

+(NSString *)getUUID;
+ (UIImage *)imageWithColor:(UIColor *)color;
+(NSURL *)getFooterAdUrl;
+(NSURL *)getBannerAddUrl;

//Shake view

+(void)shakeView:(UIView *)view;
@end
