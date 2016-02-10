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


+(void)deleteComment:(NSNumber *)comment_id AndHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;

+(void)getAllPostsforScope:(NSString *)scope andHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;
+(void)getRecipesCardsWithHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;

+(void)getUserInfoWithId:(NSNumber *)user_id AndHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;

+(void)getVersionWithHandler:(void (^)(id))handler orErrorHandler:(void (^)(NSError *))errorHandler;

+(void)getActivities:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;

+(void)getRecipeWithID:(NSNumber *)recipe_id andHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;

+(void)getPostDetailWithID:(NSNumber *)post_id andHandler:(void (^)(id)) handler  orErrorHandler:(void (^)(NSError *)) errorHandler;
//POST

+(void)checkCommentISLiked:(NSNumber *)user_id commentID:(NSNumber *)comment_id AndHandler:(void (^)(id))handler orErrorHandler:(void (^)(NSError *))errorHandler;

+(void)LoginForUserWithUsername:(NSString *)user_name andPassword:(NSString *)password AndHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;

+(void)deletePost:(NSNumber *)post_id AndHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;

+(void)createCommentForPost:(NSNumber *)post_id byUser:(NSNumber *)user_id andComment:(NSString *)comment AndHandler:(void (^)(id))handler orErrorHandler:(void (^)(NSError *))errorHandler;

+(void)UpdateUserWithUsername:(NSString *)user_name andPassword:(NSString *)password andPasswordConfirmation:(NSString *)password_confirmation andEmailAddress:(NSString *)email andPicture:(NSString *)picture andDeviceToken:(NSString *)device_token andID:(NSNumber *)user_id AndHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;


+(void)createPostForUser:(NSNumber *)user_id andTitleOfPost:(NSString *)title andAdress:(NSString *)address andLatitude:(CGFloat )latitude andLongitude:(CGFloat )longitude andCountry:(NSString *)country AndHandler:(void (^)(id))handler orErrorHandler:(void (^)(NSError *))errorHandler;

+(void)RegisterUserWithUsername:(NSString *)user_name andPassword:(NSString *)password andPasswordConfirmation:(NSString *)password_confirmation andEmailAddress:(NSString *)email andPicture:(NSString *)picture andDeviceToken:(NSString *)device_token AndHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;




+(void)denouncePost:(NSNumber *)post_id AndHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;

+(void)denounceComment:(NSNumber *)comment_id AndHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler;

+(void)AddLikeForComment:(NSNumber *)user_id commentID:(NSNumber *)comment_id AndHandler:(void (^)(id))handler orErrorHandler:(void (^)(NSError *))errorHandler;

+(void)removeLikeFromComment:(NSNumber *)user_id commentID:(NSNumber *)comment_id AndHandler:(void (^)(id))handler orErrorHandler:(void (^)(NSError *))errorHandler;


+(void)removeLikeFromPost:(NSNumber *)user_id postID:(NSNumber *)post_id AndHandler:(void (^)(id))handler orErrorHandler:(void (^)(NSError *))errorHandler;

+(void)addLikeToPost:(NSNumber *)user_id postID:(NSNumber *)post_id AndHandler:(void (^)(id))handler orErrorHandler:(void (^)(NSError *))errorHandler;
@end
