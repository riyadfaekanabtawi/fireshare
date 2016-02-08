//
//  Functions.m
//  BeepGoosh
//
//  Created by Riyad Anabtawi on 1/11/15.
//  Copyright (c) 2015 Riyad Anabtawi. All rights reserved.
//


#import "Functions.h"
#import <EventKit/EventKit.h>

@implementation Functions{

    
    
}


+(NSDate *)stringToDate:(NSString *)string {
    return [Functions stringToDate:string WithFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
}

+(NSDate *)stringToDate:(NSString *)string WithFormat:(NSString *)format {
    
    if (string == nil || [string isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [formatter dateFromString:string];
}

+(NSString *)dateToString:(NSDate *)date WithFormat:(NSString *)format {
    if (date == nil || [date isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

//+(NSDate *)addDays:(NSInteger)days toDate:(NSDate *)date {
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    [gregorian setTimeZone:[NSTimeZone defaultTimeZone]];
//    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
//    [offsetComponents setDay:days];
//    return [gregorian dateByAddingComponents:offsetComponents toDate: date options:0];
//}
//
//
//+(NSDate *)addMinutes:(NSInteger)minutes toDate:(NSDate *)date {
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    [gregorian setTimeZone:[NSTimeZone defaultTimeZone]];
//    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
//    [offsetComponents setMinute:minutes];
//    return [gregorian dateByAddingComponents:offsetComponents toDate:date options:0];
//}

+(BOOL)isDate:(NSDate *)date inRangeFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate {
    return [date compare:firstDate] == NSOrderedDescending &&
    [date compare:lastDate]  == NSOrderedAscending;
}




//+(void)createReminderNotificationForMedia:(NSString *)mediaId WithTitle:(NSString *)title onDate:(NSDate *)date UntilDate:(NSDate *)endDate {
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSMutableArray *createdReminders = [defaults mutableArrayValueForKey:@"reminders"];
//    
//    NSString *body = [NSString stringWithFormat:@"%@ esta por comenzar", title];
//    
//    UILocalNotification *aNotification = [[UILocalNotification alloc] init];
//    
//    //    aNotification.fireDate = date;
//    aNotification.fireDate = [Functions addMinutes:1 toDate:[NSDate date]];
//    
//    aNotification.timeZone = [NSTimeZone defaultTimeZone];
//    aNotification.soundName = UILocalNotificationDefaultSoundName;
//    aNotification.alertBody = body;
//    aNotification.alertAction = @"";
//    
//    aNotification.userInfo = nil;
//    
//    [[UIApplication sharedApplication] scheduleLocalNotification:aNotification];
//    
//    NSString *calendarIdentifier = [defaults stringForKey:CALENDAR_IDENTIFIER_KEY];
//    EKEventStore *eventStore = [[EKEventStore alloc] init];
//    if (calendarIdentifier != nil) {
//        
//        EKEvent *event = [EKEvent eventWithEventStore:eventStore];
//        EKCalendar *calendar = [eventStore calendarWithIdentifier:calendarIdentifier];
//        event.calendar = calendar;
//        event.alarms = [NSArray arrayWithObject:[EKAlarm alarmWithRelativeOffset:60 * -5]];
//        event.title = title;
//        event.notes = [NSString stringWithFormat:@"%@ via Estadio CDF",title];
//        event.URL = [NSURL URLWithString:@"www.estadiocdf.cl"];
//        event.startDate = date;
//        event.endDate = endDate;
//        
//        
//        NSError *error = nil;
//        BOOL result = [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
//        if (result) {
//            NSLog(@"Saved event to event store.");
//        } else {
//            NSLog(@"Error saving event: %@.", error);
//        }
//    }
//    else {
//        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
//            if (granted) {
//                EKCalendar *calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:eventStore];
//                calendar.title = CALENDAR_TITLE;
//                
//                // Iterate over all sources in the event store and look for the local source
//                EKSource *theSource = nil;
//                for (EKSource *source in eventStore.sources) {
//                    if (source.sourceType == EKSourceTypeLocal) {
//                        theSource = source;
//                        break;
//                    }
//                }
//                
//                if (theSource) {
//                    calendar.source = theSource;
//                } else {
//                    NSLog(@"Error: Local source not available");
//                    return;
//                }
//                
//                NSError *error = nil;
//                BOOL result = [eventStore saveCalendar:calendar commit:YES error:&error];
//                if (result) {
//                    NSLog(@"Saved calendar to event store. %@", calendar.calendarIdentifier);
//                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                    
//                    [defaults setObject:calendar.calendarIdentifier forKey:CALENDAR_IDENTIFIER_KEY];
//                    [defaults synchronize];
//                    
//                    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
//                    event.calendar = calendar;
//                    event.alarms = [NSArray arrayWithObject:[EKAlarm alarmWithRelativeOffset:60 * -5]];
//                    event.title = title;
//                    event.notes = [NSString stringWithFormat:@"%@ via Estadio CDF",title];
//                    event.URL = [NSURL URLWithString:@"www.estadiocdf.cl"];
//                    event.startDate = date;
//                    event.endDate = endDate;
//                    
//                    NSError *error = nil;
//                    BOOL result = [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
//                    if (result) {
//                        NSLog(@"Saved event to event store. %@", calendar.calendarIdentifier);
//                    } else {
//                        NSLog(@"Error saving event: %@.", error);
//                    }
//                    
//                } else {
//                    NSLog(@"Error saving calendar: %@.", error);
//                }
//            }
//            else {
//                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Evento no pudo ser creado en el calendario, no se ha autorizado el acceso" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil] show];
//            }
//        }];
//    }
//    
//    
//    
//    
//    
//    
//    [createdReminders addObject:mediaId];
//    [defaults setObject:createdReminders forKey:@"reminders"];
//    [defaults synchronize];
//}
+(void)createReminderNotificationWithBody:(NSString *)mediaId WithTitle:(NSString *)title onDate:(NSDate *)date UntilDate:(NSDate *)endDate {
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *createdReminders = [defaults mutableArrayValueForKey:@"reminders"];
    UILocalNotification *aNotification = [[UILocalNotification alloc] init];
    aNotification.fireDate = date;
    aNotification.timeZone = [NSTimeZone defaultTimeZone];
    aNotification.soundName = UILocalNotificationDefaultSoundName;
    aNotification.alertBody = title;
    aNotification.alertAction = @"Ver detalles!";
    
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:aNotification];
    
    [createdReminders addObject:mediaId];
    [defaults setObject:createdReminders forKey:@"reminders"];
    [defaults synchronize];
}

+(BOOL)reminderExistsForMedia:(NSString *)mediaId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *createdReminders = [defaults arrayForKey:@"reminders"];
    
    return [createdReminders containsObject:mediaId];
}


+(NSString *)getUUID
{
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    NSString * uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    CFRelease(newUniqueId);
    
    return uuidString;
}

+(NSURL *)getFooterAdUrl {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://54.221.221.249/1024_56.html#%@",[Functions getUUID]]];
}

+(NSURL *)getBannerAddUrl {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://54.221.221.249/1024_78.html#%@",[Functions getUUID]]];
}

+(void)fillContainerView:(UIView *)container WithView:(UIView *)view {
    NSLayoutConstraint *constraintTop = [NSLayoutConstraint constraintWithItem:view
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:container
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *constraintRight = [NSLayoutConstraint constraintWithItem:view
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:container
                                                                       attribute:NSLayoutAttributeLeading
                                                                      multiplier:1.0f constant:0.0f];
    
    
    NSLayoutConstraint *constraintBottom = [NSLayoutConstraint constraintWithItem:view
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:container
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:0.0f];
    
    
    NSLayoutConstraint *constraintLeft = [NSLayoutConstraint constraintWithItem:view
                                                                      attribute:NSLayoutAttributeTrailing
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:container
                                                                      attribute:NSLayoutAttributeTrailing
                                                                     multiplier:1.0f constant:0.0f];
    
    
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [container addSubview:view];
    
    [container addConstraint:constraintTop];
    [container addConstraint:constraintRight];
    [container addConstraint:constraintBottom];
    [container addConstraint:constraintLeft];
}
+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


+(void)addView:(UIView *)view ToContainer:(UIView *)container WithTopMargin:(NSNumber *)topMargin LeftMargin:(NSNumber *)leftMargin BottomMargin:(NSNumber *)bottomMargin RightMargin:(NSNumber *)rightMargin Width:(NSNumber *)width Height:(NSNumber *)height {
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [container addSubview:view];
    
    NSLayoutConstraint *top;
    NSLayoutConstraint *bottom;
    NSLayoutConstraint *left;
    NSLayoutConstraint *right;
    
    NSLayoutConstraint *widthConstraint;
    NSLayoutConstraint *heightConstraint;
    
    if ( topMargin != nil ) {
        top = [NSLayoutConstraint constraintWithItem:view
                                           attribute:NSLayoutAttributeTop
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:container
                                           attribute:NSLayoutAttributeTop
                                          multiplier:1.0
                                            constant:topMargin.floatValue];
        
        [container addConstraint:top];
    }
    
    if ( leftMargin != nil ) {
        left = [NSLayoutConstraint constraintWithItem:view
                                            attribute:NSLayoutAttributeLeading
                                            relatedBy:NSLayoutRelationEqual
                                               toItem:container
                                            attribute:NSLayoutAttributeLeading
                                           multiplier:1.0
                                             constant:leftMargin.floatValue];
        
        [container addConstraint:left];
    }
    
    if ( bottomMargin != nil ) {
        bottom = [NSLayoutConstraint constraintWithItem:view
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:container
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1.0
                                               constant:bottomMargin.floatValue];
        
        [container addConstraint:bottom];
    }
    
    if ( rightMargin != nil ) {
        right = [NSLayoutConstraint constraintWithItem:view
                                             attribute:NSLayoutAttributeTrailing
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:container
                                             attribute:NSLayoutAttributeTrailing
                                            multiplier:1.0
                                              constant:rightMargin.floatValue];
        
        [container addConstraint:right];
    }
    
    if ( width != nil ) {
        widthConstraint = [NSLayoutConstraint constraintWithItem:view
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1.0
                                                        constant:width.floatValue];
        
        [container addConstraint:widthConstraint];
    }
    
    if ( height != nil ) {
        heightConstraint = [NSLayoutConstraint constraintWithItem:view
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:height.floatValue];
        
        [container addConstraint:heightConstraint];
    }
}


+(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}





//BOUNCE

+(void)buttonBounceAnimation:(UIView *)view {
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    
    [UIView animateWithDuration:0.3 / 1.5 animations:^{
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.6, 1.6);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 / 2 animations:^{
            view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                view.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

+(void)buttonBounceAnimation:(UIView *)view withFinalScale:(CGFloat)scale {
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    
    [UIView animateWithDuration:0.3 / 1.5 animations:^{
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.6, 1.6);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                view.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
            }];
        }];
    }];
}


//COLOR

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



//SHAKEIMAGE

+(void)shakeView:(UIView *)view{
    
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    
    shake.fromValue = [NSNumber numberWithFloat:-0.3];
    
    shake.toValue = [NSNumber numberWithFloat:+0.3];
    
    shake.duration = 0.1;
    
    shake.autoreverses = YES;
    
    shake.repeatCount = 4;
    
    [view.layer addAnimation:shake forKey:@"imageView"];
    
    view.alpha = 1.0;
    
    [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:nil];
    
}


+ (NSString *)deviceUUID
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:[[NSBundle mainBundle] bundleIdentifier]])
        return [[NSUserDefaults standardUserDefaults] objectForKey:[[NSBundle mainBundle] bundleIdentifier]];
    
    @autoreleasepool {
        
        CFUUIDRef uuidReference = CFUUIDCreate(nil);
        CFStringRef stringReference = CFUUIDCreateString(nil, uuidReference);
        NSString *uuidString = (__bridge NSString *)(stringReference);
        [[NSUserDefaults standardUserDefaults] setObject:uuidString forKey:[[NSBundle mainBundle] bundleIdentifier]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        CFRelease(uuidReference);
        CFRelease(stringReference);
        return uuidString;
    }
}



+(UIImage *)CreateGradientInView:(CGRect )bounds withStartColor:(UIColor *)startColor andEndColor:(UIColor *)endColor{
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = bounds;
    gradient.colors = @[(id)startColor.CGColor,
                        (id)endColor.CGColor];
    gradient.locations = @[@0.0, @0.77, @1.0];
    
    
    UIGraphicsBeginImageContext(gradient.bounds.size);
    [gradient renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    return gradientImage;
    
    
}



@end
