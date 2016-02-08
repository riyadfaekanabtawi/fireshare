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
@property NSNumber *minutes_since;
@property NSNumber *hours_since;
@property NSNumber *days_since;
@property NSNumber *seconds_since;
@property NSString *voted_string;
@property Users *user_owner;

@end
