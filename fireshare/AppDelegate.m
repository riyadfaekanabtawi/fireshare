//
//  AppDelegate.m
//  cookBook
//
//  Created by Riyad Anabtawi on 7/9/15.
//  Copyright (c) 2015 Riyad Anabtawi. All rights reserved.
//

#import "AppDelegate.h"
#import "fireshare-Swift.h"
@interface AppDelegate ()
@property(nonatomic, copy) void (^dispatchHandler)(GAIDispatchResult result);
@end
static NSString *const kTrackingId = @"UA-73548513-1";



@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        for (NSString *font in [UIFont familyNames]) {
            NSLog(@"%@", [UIFont fontNamesForFamilyName:font]);
        }

    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    application.applicationIconBadgeNumber = 0;
    
    
    id localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (localNotif != nil) {
        self.pendingNotification = localNotif;
    }
    
    //[GMSServices provideAPIKey:@"AIzaSyDOEg2ad98Ay7w5SPSemKYmZ_8sGK-5qR4"];
    
    //Analytics
    NSLog(@"[GOOGLE]///////INIT Google Analytics///////");
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
    
    NSString *token = [devToken description];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"tokenPush"];
    [defaults synchronize];
    
    
    //const unsigned char *devTokenBytes = [devToken bytes];
    //self.registered = YES;
    //[self sendProviderDeviceToken:devTokenBytes]; // custom method
    NSLog(@"%@", [[NSString alloc] initWithData:devToken
                                       encoding:NSUTF8StringEncoding]);
    
    //    NSUInteger capacity = [devToken length] * 2;
    //    NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:capacity];
    //    for (int i=0; i<[devToken length]; ++i) {
    //        //        [stringBuffer appendString:[self integerToBinary:(NSUInteger)devTokenBytes[i]]];
    //        [stringBuffer appendFormat:@"%02lx",(unsigned long)devTokenBytes[i]];
    //    }
    //
    //    NSLog(@"%@", stringBuffer);
    //
    //    [SBTVServices loginToSBTVWithDeviceToken:stringBuffer Handler:^(id data) {
    //
    //
    //        NSLog(@"Login bitch!!!!!!! %@", data);
    //    } orErrorHandler:^(NSError *err) {
    //        NSLog(@"Not today bitch!!!! %@", err);
    //    }];
    
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"tokenPush"];
    [defaults synchronize];

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return [AppDelegate supportedInterfaceOrientations];
}

static BOOL _isVideoPlaying = NO;

+(void)setVideoPlaying:(BOOL)isPlaying {
    _isVideoPlaying = isPlaying;
}

+(BOOL)isVideoPlaying {
    return _isVideoPlaying;
}

+(BOOL)shouldAutorotate {
    return YES;
}

+(NSUInteger)supportedInterfaceOrientations {
    if (_isVideoPlaying) {
        return UIInterfaceOrientationMaskAll;
    }
    else {
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            return UIInterfaceOrientationMaskLandscape;
            
        }else{
            return UIInterfaceOrientationMaskPortrait;
            
        }
    }
}

+(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (_isVideoPlaying) {
        return YES;
    }
    else {
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
            
        }else{
            return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
            
        }
        
    }
}
@end
