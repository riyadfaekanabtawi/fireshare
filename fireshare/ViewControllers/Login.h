//
//  Login.h
//  CookBook
//
//  Created by Riyad Faek Anabtawi on 11-04-14.
//  Copyright (c) 2015 Riyad Anabtawi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TIME_STEP 5.0f
@protocol LoginDelegate;

@interface Login : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic, weak) id<LoginDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UILabel *donthave;
@property (weak, nonatomic) IBOutlet UILabel *signupLabel;

@property (weak, nonatomic) IBOutlet UIImageView *mark;

@property (weak, nonatomic) IBOutlet UIView *usernameView;

@property (weak, nonatomic) IBOutlet UIView *loginButtonView;
@property (weak, nonatomic) IBOutlet UIView *registerButtonView;

@property (weak, nonatomic) IBOutlet UILabel *iniciarSesionLabel;
@property (weak, nonatomic) IBOutlet UIView *passwordView;

@end

@protocol LoginDelegate <NSObject>
- (void)conexionEstablecida;
@end