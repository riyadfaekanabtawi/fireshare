//
//  Users.h
//  fireshare
//
//  Created by Riyad Anabtawi on 1/6/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Users : NSObject
-(Users *)initWithDictionary:(NSDictionary *)dictionary;
@property NSNumber *user_id;
@property NSString *name;
@property NSString *device_token;
@property NSString *email;
@property NSString *avatar_url;
@property NSArray *recipes;
- (void)encodeWithCoder:(NSCoder *)coder;
- (id)initWithCoder:(NSCoder *)aDecoder ;
@end
