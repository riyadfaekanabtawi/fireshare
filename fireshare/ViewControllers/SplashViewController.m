//
//  SplashViewController.m
//  fireshare
//
//  Created by Riyad Anabtawi on 3/14/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

#import "SplashViewController.h"
#import "Services.h"
@interface SplashViewController ()

@end

@implementation SplashViewController{

     NSURL *_appURLLink;


}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    if(![defaults objectForKey:@"FirstTimeTerms"]){
        [self performSegueWithIdentifier:@"terms" sender:self];
        return;
    }

    
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


-(void)viewDidAppear:(BOOL)animated{

    [Services  getVersionWithHandler:^(id data) {
        
        
        
        _appURLLink = [NSURL URLWithString:[data objectForKey:@"URL_iOS"]];
        
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *versionWithoutDots = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        NSNumber * versionOurs = [f numberFromString:versionWithoutDots];
        
        
        
        
        NSNumber *remoteVersioon =[f numberFromString:[data objectForKey:@"Version"]];
        NSInteger v1 = [versionOurs integerValue];
        NSInteger v2 = [remoteVersioon isEqual:[NSNull null]] ? -1 : [remoteVersioon integerValue];
        
        if( v1 < v2 ) {
            
            
            
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"New Version", nil)
                                                              message:NSLocalizedString(@"A new version of this app is available", nil)
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                    otherButtonTitles:NSLocalizedString(@"Update", nil), nil];
            [message show];
            return ;
        }else{
            
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            NSDate *dateCalledService = [defaults objectForKey:@"DATE_LOGIN"];
            
            
            if ([defaults objectForKey:@"user_main"]){
                if(![defaults objectForKey:@"DATE_LOGIN"]){
                    
                   // [self performSegueWithIdentifier:@"login" sender:self];
                    
                }else if([[NSDate date] timeIntervalSinceDate:dateCalledService]>=60*24*60*5){
                    
                }else{
                    
                    [self performSegueWithIdentifier:@"homeCache" sender:self];
                }
                
                
            }else{
                
                [self performSegueWithIdentifier:@"login" sender:self];
            }
            
        }
        
        
    } orErrorHandler:^(NSError *err) {
        
    }];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        
    }else{
        
        [[UIApplication sharedApplication] openURL:_appURLLink];
        
        
    }
}


@end
