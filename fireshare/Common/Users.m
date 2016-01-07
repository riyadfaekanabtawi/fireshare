//
//  Users.m
//  fireshare
//
//  Created by Riyad Anabtawi on 1/6/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

#import "Users.h"
#import "Posts.h"
@implementation Users
-(Users *)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        
        self.name = [dictionary objectForKey:@"name"];
        self.email = [dictionary objectForKey:@"email"];
        self.device_token = [dictionary objectForKey:@"device_token"];
        self.avatar_url = [NSString stringWithFormat:@"%@%@",BASE_URL,[dictionary objectForKey:@"photo"]];
        self.user_id = [dictionary objectForKey:@"id"];
        
        NSMutableArray *array = [NSMutableArray new];
        
        for (NSDictionary *dic in [dictionary objectForKey:@"recipes"]){
            
            [array addObject:[[Posts alloc] initWithDictionary:dic]];
            
            
        }
        
        self.recipes = array;
        
    }
    
    return self;
}




- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"user_name"];
    [coder encodeObject:self.user_id forKey:@"user_id"];
    [coder encodeObject:self.email forKey:@"user_email"];
    [coder encodeObject:self.device_token forKey:@"user_token"];
    [coder encodeObject:self.avatar_url forKey:@"user_avatar"];
    [coder encodeObject:self.recipes forKey:@"user_recipes"];
    
     [coder encodeObject:self.user_id forKey:@"user_id"];
    
    
}



- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self.name = [aDecoder decodeObjectForKey:@"user_name"];
    self.email = [aDecoder decodeObjectForKey:@"user_email"];
    self.avatar_url = [aDecoder decodeObjectForKey:@"user_avatar"];
    self.device_token = [aDecoder decodeObjectForKey:@"user_token"];
    self.user_id = [aDecoder decodeObjectForKey:@"user_id"];
    self.recipes = [aDecoder decodeObjectForKey:@"user_recipes"];
    self.user_id = [aDecoder decodeObjectForKey:@"user_id"];
    return self;
}

@end
