//
//  Posts.h
//  fireshare
//
//  Created by Riyad Anabtawi on 1/6/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Users.h"
@interface Posts : NSObject
-(Posts *)initWithDictionary:(NSDictionary *)dictionary;
@property NSNumber *post_id;
@property NSNumber *post_likes;
@property NSString *post_title;
@property NSString *post_date;
@property Users *post_user;

@property NSArray *comments;
- (void)encodeWithCoder:(NSCoder *)coder;
- (id)initWithCoder:(NSCoder *)aDecoder ;
@end
