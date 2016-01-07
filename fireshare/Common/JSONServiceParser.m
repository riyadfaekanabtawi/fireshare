//
//  FavoriteGuideJSONParser.m
//  Nunchee
//
//  Created by Franklin Cruz on 21-08-13.
//  Copyright (c) 2013 SmartboxTV. All rights reserved.
//

#import "JSONServiceParser.h"

//Connects to JSON services and returns it's result as objective C objects
@implementation JSONServiceParser {
    NSMutableData *webData;
    NSDate *startTime;
    BOOL passRawData;
}

@synthesize completionHandler;

//Connects to a service with HTTP GET method and returns the response as parsed JSON
-(void)getJSONFromUrl:(NSURL *)url withHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *))errorHandler {

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [self setHeaders:request];
    self.completionHandler = handler;
    self.errorHandler = errorHandler;

    passRawData = NO;

    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
    webData = [NSMutableData data];

    startTime = [NSDate date];
}


//Connects to a service with HTTP GET method and returns the response as parsed raw NSData
-(void)getDataFromUrl:(NSURL *)url withHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *))errorHandler {


    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
 [self setHeaders:request];
    self.completionHandler = handler;
    self.errorHandler = errorHandler;

    passRawData = YES;

    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
    webData = [NSMutableData data];

    startTime = [NSDate date];
}

//Connects to a service with HTTP POST method and returns the response as parsed JSON
-(void)getJSONFromPost:(NSURL *)url sendingData:(NSData *)data withHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
 [self setHeaders:request];
    self.completionHandler = handler;
    self.errorHandler = errorHandler;

    passRawData = NO;

    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
    webData = [NSMutableData data];

    startTime = [NSDate date];
}

//Connects to a service with HTTP POST method and returns the response as raw NSData
-(void)getDataFromPost:(NSURL *)url sendingData:(NSData *)data withHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
     [self setHeaders:request];
    //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    self.completionHandler = handler;
    self.errorHandler = errorHandler;

    passRawData = YES;

    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
    webData = [NSMutableData data];

    startTime = [NSDate date];
}

-(void) connection: (NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response {
    [webData setLength:0];
}


-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [webData appendData:data];
}


-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error en la Conexion %@", error.localizedDescription);
    //TODO: Display error to final user?
    if (self.errorHandler) {
        self.errorHandler(error);
    }
}


-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    //NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:startTime];
    //NSLog(@"JSON - Time: %f", secondsBetween);
    //NSLog(@"JSON - Bytes: %d", [webData length]);

    if (passRawData) {
        self.completionHandler(webData);
        return;
    }

    NSString *tmp = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    
    //NSDate *parseStart = [NSDate date];
    NSError *error = nil;
    id object = [NSJSONSerialization
                 JSONObjectWithData:[tmp dataUsingEncoding:NSUTF8StringEncoding]
                 options: 0
                 error:&error];

    //secondsBetween = [[NSDate date] timeIntervalSinceDate:parseStart];
    //NSLog(@"JSON - ParseTime: %f", secondsBetween);
    if(error) {
        //TODO: Display error
        //NSLog(@"JSON is not well formed! %@", error.localizedDescription);
        //NSLog(@"%@", [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding]);
        if (self.errorHandler) {
            self.errorHandler(error);
        }
        
        return;
    }


    if([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {

        if(self.completionHandler) {
            self.completionHandler(object);
        }

    }
    else {
        NSLog(@"We have some weird result! is not an array nor a dictionary! WTF!!!!");
    }

    //webData = nil;
}
-(void)setHeaders:(NSMutableURLRequest *)request {
//    [request addValue:[NSString stringWithFormat:@"%@ %@", [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion]] forHTTPHeaderField:@"SBTV_OS"];
//    [request addValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"SBTV_VERSION"];
}
@end
