//
//  Posts.m
//  fireshare
//
//  Created by Riyad Anabtawi on 1/6/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

#import "Posts.h"
#import "Comments.h"
@implementation Posts


-(Posts *)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        
        self.post_title = [dictionary objectForKey:@"title"];
        self.post_id = [dictionary objectForKey:@"id"];
        self.post_likes = [dictionary objectForKey:@"likes"];
        self.post_date = [dictionary objectForKey:@"device_token"];
        //self.post_user =
     
        
        NSMutableArray *array = [NSMutableArray new];
        
        for (NSDictionary *dic in [dictionary objectForKey:@"comments"]){
            
            [array addObject:[[Comments alloc] initWithDictionary:dic]];
            
            
        }
        
        self.comments = array;
        
    }
    
    return self;
}




- (void)encodeWithCoder:(NSCoder *)coder {
 
    
    
}



- (id)initWithCoder:(NSCoder *)aDecoder {
    

    
    return self;
}
@end
