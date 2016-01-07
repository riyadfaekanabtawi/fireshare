//
//  CookBookServices.h
//  
//
//  Created by Riyad Anabtawi on 7/9/15.
//
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
@interface Services : NSObject



+(void)getAllPosts:(void (^)(id)) handler  orErrorHandler:(void (^)(NSError *)) errorHandler;
+(void)getRecipesCardsWithHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;

+(void)getUserInfoWithId:(NSNumber *)user_id AndHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;

+(void)getActivities:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;
+(void)getRecipeWithID:(NSNumber *)recipe_id andHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;
//POST


+(void)LoginForUserWithUsername:(NSString *)user_name andPassword:(NSString *)password AndHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;

+(void)deletePost:(NSNumber *)post_id AndHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;

+(void)createCommentForPost:(NSNumber *)post_id byUser:(NSNumber *)user_id andComment:(NSString *)comment AndHandler:(void (^)(id))handler orErrorHandler:(void (^)(NSError *))errorHandler;


+(void)createPostForUser:(NSNumber *)user_id andTitleOfPost:(NSString *)title AndHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;

+(void)RegisterUserWithUsername:(NSString *)user_name andPassword:(NSString *)password andPasswordConfirmation:(NSString *)password_confirmation andEmailAddress:(NSString *)email andPicture:(NSString *)picture andDeviceToken:(NSString *)device_token AndHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;
@end
