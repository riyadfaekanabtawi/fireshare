//
//  Login.m
//  CookBook
//
//  Created by Juan Pablo Arias on 11-04-14.
//  Copyright (c) 2014 SmartboxTV. All rights reserved.
//

#import "Login.h"
#import "AppDelegate.h"
#import "Users.h"

#import "AFHTTPRequestOperationManager.h"
#import "Services.h"


#import "Functions.h"
@import CoreLocation;

@interface Login () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;
@end

@implementation Login {
    NSTimer *timer;
    NSInteger slideIndex;
    NSArray *slides;
   
    NSTimer *_faceAnimationTimer;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self animateLogin ];
    self.username.font = [UIFont fontWithName:FONT_BOLD_ITALIC size:self.username.font.pointSize];
    self.password.font = [UIFont fontWithName:FONT_BOLD_ITALIC size:self.password.font.pointSize];
    self.donthave.font = [UIFont fontWithName:FONT_REGULAR size:self.donthave.font.pointSize];
    self.registerLabel.font = [UIFont fontWithName:FONT_BOLD size:self.registerLabel.font.pointSize];
    self.iniciarSesionLabel.font = [UIFont fontWithName:FONT_BOLD_ITALIC size:self.iniciarSesionLabel.font.pointSize];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self.view layoutIfNeeded];
    slideIndex = 0;

    //------------------------
    // Estilos
    //------------------------
  
    
    
    [super viewDidLoad];
    
    

    self.username.placeholder = NSLocalizedString(@"username", @"");
    self.password.placeholder = NSLocalizedString(@"password", @"");
    self.registerLabel.text = NSLocalizedString(@"Register", @"");
    self.donthave.text = NSLocalizedString(@"Dont have an account yet?", @"");
    
    self.signupLabel.text = NSLocalizedString(@"Log in", @"");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];


    if(![defaults objectForKey:@"FirstTimeTerms"]){
        [self performSegueWithIdentifier:@"terms" sender:self];
        return;
    }
    
    
    
    if([defaults objectForKey:@"user_main"]){
        [self performSegueWithIdentifier:@"home" sender:self];
        
    }
    


}


- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewDidDisappear:(BOOL)animated {
    
//    [_loader endAnimation];
//    [_loader removeFromSuperview];
    
}

-(void)viewDidAppear:(BOOL)animated {

    self.locationManager=[[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    float os_version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (os_version >= 8.000000)
    {
  
        if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
            //and the problem with your code : don't forget to start
            [self.locationManager startUpdatingLocation];
        }else{
           
            //and the problem with your code : don't forget to start
            [self.locationManager startUpdatingLocation];
        }
    }
    else
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
              [self.locationManager startUpdatingLocation];
   
        
    }
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    
//    if (![defaults boolForKey:TUTORIAL_LOGIN_SEEN] || TUTORIAL_ALWAYS_VISIBLE) {
//        [TutorialView createWithScreenImageName:TUTORIAL_LOGIN Delegate:self];
//    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)showLoggedInUI {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ( [defaults objectForKey:@"equipoFavorito"] != nil ) {
        [self performSegueWithIdentifier:@"home" sender:self];
    }
    else {
        [self performSegueWithIdentifier:@"seleccion_equipos" sender:self];
    }
    
}






-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskLandscape;
    }else{
        return UIInterfaceOrientationMaskPortrait;
        
    }
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}





- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        
    }else{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                    @""]];
        
        
    }
}









-(IBAction)Go:(id)sender{
     self.loginButtonView.transform = CGAffineTransformMakeScale(0.01, 0.01);
[UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.30 initialSpringVelocity:6.00 options:UIViewAnimationOptionAllowUserInteraction animations:^{
     self.loginButtonView.transform = CGAffineTransformIdentity;
    
} completion:^(BOOL finished) {
    
    
    
}];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(![self.username.text isEqualToString:@""]&&![self.password.text isEqualToString:@""]){
    
      
    
        NSDictionary *p = @{
                            
                            @"name" : self.username.text,@"password" : self.password.text,@"device_token":[defaults objectForKey:@"tokenPush"]};
        
        
        
        //NSDictionary *security = [EncryptFunction generateSignature:parameters method:@"POST" path:@"user/vote"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        // [manager.requestSerializer setValue:[security objectForKey:@"formatter"] forHTTPHeaderField:@"Date"];
        
        
        
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        
        [manager POST:[NSString stringWithFormat:@"%@user/login",BASE_URL] parameters:p success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [self.username resignFirstResponder];
            [self.password resignFirstResponder];
            
            if ([[responseObject objectForKey:@"Result"] isEqualToString:@"Error"]){
          
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops" message:NSLocalizedString(@"Wrong email or password. Please try again.", nil) preferredStyle:UIAlertControllerStyleAlert];
               
                
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
                 [alert addAction:ok];
                 [self presentViewController:alert animated:YES completion:nil];
                
            }else{
            
            Users *user = [[Users alloc] initWithDictionary:responseObject];
            
            NSData *user_data = [NSKeyedArchiver archivedDataWithRootObject:user];
            [defaults setObject:user_data forKey:@"user_main"];
            [defaults synchronize];
            self.username.text=@"";
            self.password.text=@"";
            
           
            [self performSegueWithIdentifier:@"home" sender:self];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops" message:NSLocalizedString(@"Wrong email or password. Please try again.", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
         
           
    
            
            
        }];

    
    
    
    
    }

    
}






-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    
    
    if ([textField.text isEqualToString:@""])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops" message:NSLocalizedString(@"Field cannot be empty.", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
          }
    else
    {
        NSInteger nextTag = textField.tag + 1;
        // Try to find next responder
        UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
        if (nextResponder) {
            // Found next responder, so set it.
            [nextResponder becomeFirstResponder];
        } else {
            // Not found, so remove keyboard.
            [textField resignFirstResponder];
        }
    }

    return NO; // We do not want UITextField to insert line-breaks.
}




#pragma mark - CLself.locationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
   
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops" message:NSLocalizedString(@"Failed to get your location.", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
  
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        self.longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        self.latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
        CLGeocoder *ceo = [[CLGeocoder alloc]init];
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]]; //insert your coordinates
        
        [ceo reverseGeocodeLocation:loc
                  completionHandler:^(NSArray *placemarks, NSError *error) {
                      CLPlacemark *placemark = [placemarks objectAtIndex:0];
//                      NSLog(@"placemark %@",placemark);
//                      //String to hold address
//                     // NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//                      NSLog(@"addressDictionary %@", placemark.addressDictionary);
//                      
//                      NSLog(@"placemark %@",placemark.region);
//                      NSLog(@"placemark %@",placemark.country);  // Give Country Name
//                      NSLog(@"placemark %@",placemark.locality); // Extract the city name
//                      NSLog(@"location %@",placemark.name);
//                      NSLog(@"location %@",placemark.ocean);
//                      NSLog(@"location %@",placemark.postalCode);
//                      NSLog(@"location %@",placemark.subLocality);
                      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                      
                      [defaults setObject:placemark.locality forKey:@"USER_CITY"];
                      [defaults setObject:placemark.country forKey:@"USER_COUNTRY"];
                      [defaults synchronize];
                
                  }
         
         ];

        
        
        
        
        //Call Service  Location
    }
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            // do some error handling
        }
            break;
        default:{
            [self.locationManager startUpdatingLocation];
        }
            break;
    }
}


- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? NSLocalizedString(@"Location services are off", nil) : NSLocalizedString(@"Background location is not enabled", nil);
        NSString *message = NSLocalizedString(@"To use background location you must turn on 'Always' in the Location Services Settings", nil);
        
     
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
}




-(IBAction)home:(id)sender{
    [self performSegueWithIdentifier:@"home" sender:self];


}



-(IBAction)signUpTouchUpInside:(id)sender{
    
    self.registerButtonView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.30 initialSpringVelocity:6.00 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.registerButtonView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
       [self performSegueWithIdentifier:@"signup" sender:self]; 
        
        
    }];
    
    
    
    
}


-(void)animateLogin{
    
    
    CGAffineTransform scale = CGAffineTransformMakeScale(0.0, 0.0);
  
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0,0);
    
    
    self.mark.transform =CGAffineTransformConcat(scale,translate);
    self.signupLabel.transform =CGAffineTransformConcat(scale,translate);
    
    self.usernameView.transform =CGAffineTransformConcat(scale,translate);
    self.passwordView.transform =CGAffineTransformConcat(scale,translate);
    
    
    self.signupLabel.userInteractionEnabled=NO;
    
    
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
        self.mark.transform=CGAffineTransformIdentity;
        self.signupLabel.transform=CGAffineTransformIdentity;
          self.passwordView.transform=CGAffineTransformIdentity;
          self.usernameView.transform=CGAffineTransformIdentity;
          self.signupLabel.userInteractionEnabled=YES;
    } completion:^(BOOL finished) {
        
    }];
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    [self.view setFrame:CGRectMake(0,-110,self.view.frame.size.width,self.view.frame.size.height)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
}




@end
