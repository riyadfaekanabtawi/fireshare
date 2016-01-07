//
//  AppDelegate.h
//  cookBook
//
//  Created by Riyad Anabtawi on 7/9/15.
//  Copyright (c) 2015 Riyad Anabtawi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AppiShit

-(void)playLiveVideoAfterMinimizing;
-(void)sbtvAppDidRecieveNotification:(NSDictionary *)notification;
@end
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


+(void)setVideoPlaying:(BOOL)isPlaying;
+(BOOL)isVideoPlaying;
+(BOOL)shouldAutorotate;
+(NSUInteger)supportedInterfaceOrientations;
+(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
@property (nonatomic,retain) NSDictionary *pendingNotification;
@property (nonatomic,retain) id<AppiShit> delegate;

@end

