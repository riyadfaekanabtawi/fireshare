//
//  CookBookServices.m
//  
//
//  Created by Riyad Anabtawi on 7/9/15.
//
//

#import "Services.h"
#import "JSONServiceParser.h"
#import "fireshare-Swift.h"
#import "Posts.h"
#import "Users.h"
#import "Functions.h"
@implementation Services




+(void)getAllPostsforScope:(NSString *)country andAddress:(NSString *)address andLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude andHandler:(void (^)(id))handler orErrorHandler:(void (^)(NSError *))errorHandler  {
    

    
    NSDictionary *p = @{
                        
                        @"address" : address,@"country" : country,@"latitude": [NSNumber numberWithFloat:latitude],@"longitude" : [NSNumber numberWithFloat:longitude]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    [manager GET:[NSString stringWithFormat:@"%@posts",BASE_URL] parameters:p success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        
        
        NSMutableArray *media = [NSMutableArray new];
        for (NSDictionary *jsonDict in responseObject ) {
            [media addObject:[[Posts alloc] initWithDictionary:jsonDict]];
        }
        
        
        handler([NSArray arrayWithArray:media]);
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
        errorHandler(error);
        
        
    }];
   
}



+(void)getPostDetailWithID:(NSNumber *)post_id andHandler:(void (^)(id)) handler  orErrorHandler:(void (^)(NSError *)) errorHandler {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    Users *user = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"user_main"]];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@postDetail?id_post=%@&id_user=%@",BASE_URL,post_id,user.user_id]];
    
    
    [[[JSONServiceParser alloc] init] getJSONFromUrl:url withHandler:^(id streamsData) {
        Posts * post = [[Posts alloc] initWithDictionary:streamsData];
        
        
        handler(post);
    } orErrorHandler:^(NSError *err) {
        errorHandler(err);
    }];
}


+(void)getRecipeWithID:(NSNumber *)recipe_id andHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler {
    
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@recipe?id=%@",BASE_URL,recipe_id]];
    
    
    [[[JSONServiceParser alloc] init] getJSONFromUrl:url withHandler:^(id streamsData) {
        
        handler(streamsData);
    } orErrorHandler:^(NSError *err) {
        errorHandler(err);
    }];
}


+(void)getActivities:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler {
    
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@activity/list",BASE_URL]];
    
    
    [[[JSONServiceParser alloc] init] getJSONFromUrl:url withHandler:^(id streamsData) {
        
        handler(streamsData);
    } orErrorHandler:^(NSError *err) {
        errorHandler(err);
    }];
}


+(void)getRecipesCardsWithHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler {
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@recipe/list",BASE_URL]];
    
    
    [[[JSONServiceParser alloc] init] getJSONFromUrl:url withHandler:^(id streamsData) {
        
        NSMutableArray *media = [NSMutableArray new];
        for (NSDictionary *jsonDict in [streamsData objectForKey:@"Records"]) {
            [media addObject:[[Posts alloc] initWithDictionary:jsonDict]];
        }
        
        //[media sortUsingComparator:^NSComparisonResult(Media *obj1, Media *obj2) {
        //    return [obj2.dateCreated compare:obj1.dateCreated];
        //}];
        
        handler([NSArray arrayWithArray:media]);
    } orErrorHandler:^(NSError *err) {
        errorHandler(err);
    }];
}

+(void)getVersionWithHandler:(void (^)(id))handler orErrorHandler:(void (^)(NSError *))errorHandler{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getVersion",BASE_URL]];
    
    
    [[[JSONServiceParser alloc] init] getJSONFromUrl:url withHandler:^(id streamsData) {
        
        
        
        
        
        handler(streamsData);
        
    } orErrorHandler:^(NSError *err) {
        
        errorHandler(err);
        
        
    }];
    
}


+(void)getUserInfoWithId:(NSNumber *)user_id AndHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler {
    
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@user?id=%@",BASE_URL,user_id]];
    
    
    [[[JSONServiceParser alloc] init] getJSONFromUrl:url withHandler:^(id streamsData) {
        
        
        Users *user = [[Users alloc] initWithDictionary:streamsData];
        handler(user);
    } orErrorHandler:^(NSError *err) {
        errorHandler(err);
    }];
}


//POST

+(void)LoginForUserWithUsername:(NSString *)user_name andPassword:(NSString *)password AndHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler {

    NSDictionary *p = @{
                        
                        @"name" : user_name,@"password" : password};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;

    
    [manager POST:[NSString stringWithFormat:@"%@user/login",BASE_URL] parameters:p success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        
        
             handler(responseObject);
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
    errorHandler(error);
        
        
    }];
}


+(void)deletePost:(NSNumber *)post_id AndHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler {
    
    NSDictionary *p = @{
                        
                        @"id" : post_id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    [manager GET:[NSString stringWithFormat:@"%@post/destroy",BASE_URL] parameters:p success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        
        
        handler(responseObject);
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
        errorHandler(error);
        
        
    }];
}


+(void)deleteComment:(NSNumber *)comment_id AndHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler {
    
    NSDictionary *p = @{
                        
                        @"id" : comment_id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    [manager GET:[NSString stringWithFormat:@"%@deleteComment",BASE_URL] parameters:p success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        
        
        handler(responseObject);
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
        errorHandler(error);
        
        
    }];
}


+(void)denouncePost:(NSNumber *)post_id AndHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler {
    
    NSDictionary *p = @{
                        
                        @"id" : post_id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    [manager GET:[NSString stringWithFormat:@"%@denouncePost",BASE_URL] parameters:p success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        
        
        handler(responseObject);
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
        errorHandler(error);
        
        
    }];
}

+(void)denounceComment:(NSNumber *)comment_id AndHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler {
    
    NSDictionary *p = @{
                        
                        @"id" : comment_id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    [manager GET:[NSString stringWithFormat:@"%@denounceComment",BASE_URL] parameters:p success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        
        
        handler(responseObject);
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
        errorHandler(error);
        
        
    }];
}





+(void)RegisterUserWithUsername:(NSString *)user_name andPassword:(NSString *)password andPasswordConfirmation:(NSString *)password_confirmation andEmailAddress:(NSString *)email andPicture:(NSString *)picture andDeviceToken:(NSString *)device_token AndHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler {
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    int i = arc4random() % 1000;
    NSNumber *number = [NSNumber numberWithInt:i];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *p = @{@"user":@{@"email" : email,@"name" : user_name,@"password" : password,@"password_confirmation":password_confirmation,@"device_token":[defaults objectForKey:@"tokenPush"]},@"image":@{@"id" :number,@"created_at" :[NSDate date],@"updated_at" :[NSDate date],@"image_url" :picture,@"filename" :[NSString stringWithFormat:@"User-%@.jpg",number],@"content_type" :@"image/jpg"}};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    [manager POST:[NSString stringWithFormat:@"%@user/register",BASE_URL] parameters:p success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject objectForKey:@"Result"]){
        
        handler(@"Error");
        }else{
            Users *user = [[Users alloc] initWithDictionary:responseObject];
            
            
            handler(user);
        
        }
       
        
        
        
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
        errorHandler(error);
        
        
    }];
}


+(void)UpdateUserWithUsername:(NSString *)user_name andPassword:(NSString *)password andPasswordConfirmation:(NSString *)password_confirmation andEmailAddress:(NSString *)email andPicture:(NSString *)picture andDeviceToken:(NSString *)device_token andID:(NSNumber *)user_id AndHandler:(void (^)(id)) handler orErrorHandler:(void (^)(NSError *)) errorHandler {
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    int i = arc4random() % 1000;
    NSNumber *number = [NSNumber numberWithInt:i];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *p = @{@"user":@{@"id":user_id,@"email":email,@"name" : user_name,@"password" : password,@"password_confirmation":password_confirmation,@"device_token":[defaults objectForKey:@"tokenPush"]},@"image":@{@"id" :number,@"created_at" :[NSDate date],@"updated_at" :[NSDate date],@"image_url" :picture,@"filename" :[NSString stringWithFormat:@"User-%@.jpg",number],@"content_type" :@"image/jpg"}};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    [manager POST:[NSString stringWithFormat:@"%@user/update",BASE_URL] parameters:p success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        Users *user = [[Users alloc] initWithDictionary:responseObject];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSData *user_data = [NSKeyedArchiver archivedDataWithRootObject:user];
        [defaults setObject:user_data forKey:@"user_main"];
        [defaults synchronize];
        
        
        
        handler(responseObject);
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
        errorHandler(error);
        
        
    }];
}


+(void)createPostForUser:(NSNumber *)user_id andTitleOfPost:(NSString *)title andAdress:(NSString *)address andLatitude:(CGFloat )latitude andLongitude:(CGFloat )longitude andCountry:(NSString *)country AndHandler:(void (^)(id))handler orErrorHandler:(void (^)(NSError *))errorHandler{


    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    
    NSNumber *lat = [NSNumber numberWithFloat:latitude];
     NSNumber *longi = [NSNumber numberWithFloat:longitude];
    NSDictionary *p = @{@"id":user_id,
                        @"title":title,
                        @"address":address,
                        @"latitude":lat,
                        @"longitude":longi,
                        @"country":country
                        };
    [manager POST:[NSString stringWithFormat:@"%@recipe/create",BASE_URL] parameters:p success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        Posts *post = [[Posts alloc] initWithDictionary:responseObject];
       
        
        
        handler(post);
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
        errorHandler(error);
        
        
    }];
}


+(void)createCommentForPost:(NSNumber *)post_id byUser:(NSNumber *)user_id andComment:(NSString *)comment AndHandler:(void (^)(id))handler orErrorHandler:(void (^)(NSError *))errorHandler{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    int i = arc4random() % 1000;
    NSNumber *number = [NSNumber numberWithInt:i];
    
    
        NSDictionary *parameters = @{@"user_posting":@{@"id" :user_id},@"recipe_commented":@{@"id" :post_id},@"comment":@{@"id" :number,@"content" :comment,@"recipe_id" :post_id,@"created_at" :[NSDate date],@"updated_at" :[NSDate date]}};
    
    [manager POST:[NSString stringWithFormat:@"%@comment/create",BASE_URL] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        Comments *comment = [[Comments alloc] initWithDictionary:responseObject];
        
        
        
        handler(comment);
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
        errorHandler(error);
        
        
    }];
}





+(void)addLikeToPost:(NSNumber *)user_id postID:(NSNumber *)post_id AndHandler:(void (^)(id))handler orErrorHandler:(void (^)(NSError *))errorHandler{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSDictionary *p = @{@"id_user":user_id,
                        @"id_post":post_id
                        
                        };
    [manager POST:[NSString stringWithFormat:@"%@like",BASE_URL] parameters:p success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
 
        
        if ([responseObject objectForKey:@"Result"]){
            handler(@"ERROR");
            
        }else{
            
            handler(@"OK");
        }
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
        errorHandler(error);
        
        
    }];
}



+(void)checkCommentISLiked:(NSNumber *)user_id commentID:(NSNumber *)comment_id AndHandler:(void (^)(id))handler orErrorHandler:(void (^)(NSError *))errorHandler{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    NSDictionary *p = @{@"id_user":user_id,
                        @"id_comment":comment_id
                        
                        };
    
    [manager GET:[NSString stringWithFormat:@"%@check_if_liked_comment",BASE_URL] parameters:p success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        handler([responseObject objectForKey:@"Result"]);
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
        errorHandler(error);
        
        
    }];
}





+(void)removeLikeFromPost:(NSNumber *)user_id postID:(NSNumber *)post_id AndHandler:(void (^)(id))handler orErrorHandler:(void (^)(NSError *))errorHandler{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSDictionary *p = @{@"id_user":user_id,
                        @"id_post":post_id
                        
                        };
    [manager POST:[NSString stringWithFormat:@"%@dislike",BASE_URL] parameters:p success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        if ([responseObject objectForKey:@"Result"]){
            handler(@"ERROR");
            
        }else{
            
            handler(@"OK");
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
        errorHandler(error);
        
        
    }];
}




+(void)removeLikeFromComment:(NSNumber *)user_id commentID:(NSNumber *)comment_id AndHandler:(void (^)(id))handler orErrorHandler:(void (^)(NSError *))errorHandler{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSDictionary *p = @{@"id_user":user_id,
                        @"id_comment":comment_id
                        
                        };
    [manager POST:[NSString stringWithFormat:@"%@dislikeComment",BASE_URL] parameters:p success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        if ([responseObject objectForKey:@"Result"]){
            handler(@"ERROR");
            
        }else{
            
            handler(@"OK");
        }
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
        errorHandler(error);
        
        
    }];
}


+(void)AddLikeForComment:(NSNumber *)user_id commentID:(NSNumber *)comment_id AndHandler:(void (^)(id))handler orErrorHandler:(void (^)(NSError *))errorHandler{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSDictionary *p = @{@"id_user":user_id,
                        @"id_comment":comment_id
                        
                        };
    [manager POST:[NSString stringWithFormat:@"%@likeComment",BASE_URL] parameters:p success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([responseObject objectForKey:@"Result"]){
        handler(@"ERROR");
        
        }else{
        
        handler(@"OK");
        }
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
        errorHandler(error);
        
        
    }];
}

@end
