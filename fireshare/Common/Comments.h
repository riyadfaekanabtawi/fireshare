//
//  Comments.h
//  fireshare
//
//  Created by Riyad Anabtawi on 1/6/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Users.h"
@interface Comments : NSObject
-(Comments *)initWithDictionary:(NSDictionary *)dictionary;
@property NSNumber *comment_id;
@property NSString *comment_content;
@property NSString *comment_date;
@property CGFloat minutes_since;
@property CGFloat hours_since;
@property CGFloat days_since;
@property CGFloat seconds_since;
@property NSNumber *likes;
@property NSString *voted_string;
@property Users *user_owner;

@end
