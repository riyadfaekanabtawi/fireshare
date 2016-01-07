//
//  FavoriteGuideJSONParser.h
//  Nunchee
//
//  Created by Franklin Cruz on 21-08-13.
//  Copyright (c) 2013 SmartboxTV. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JSON_SERVICE_BASE_URL @"http://190.215.44.18/wcfNunchee2/GLFService.svc/"
//#define JSON_SERVICE_BASE_URL @"http://nunchee.sbtvapps.com/GLFService.svc/"

#define JSON_OLD_SERVICE_BASE_URL @"http://190.215.44.18/wcfNunchee/GLFService.svc/"

#define JSON_TRIVIA_SERVICE_BASE_URL @"http://wcftrivia.sbtvapps.com/TriviaService.svc/"
#define JSON_POLLS_SERVICE_BASE_URL @"http://wcfpolls.sbtvapps.com/TriviaService.svc/"

@interface JSONServiceParser : NSObject<NSURLConnectionDelegate>

@property (nonatomic,copy) void (^completionHandler)(id data);
@property (nonatomic,copy) void (^errorHandler)(NSError *error);


-(void)getJSONFromUrl:(NSURL *)url withHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;

-(void)getDataFromUrl:(NSURL *)url withHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *))errorHandler;

-(void)getJSONFromPost:(NSURL *)url sendingData:(NSData *)data withHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;

-(void)getDataFromPost:(NSURL *)url sendingData:(NSData *)data withHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;

@end
