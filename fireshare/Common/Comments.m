//
//  Comments.m
//  fireshare
//
//  Created by Riyad Anabtawi on 1/6/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

#import "Comments.h"

@implementation Comments
-(Comments *)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        
        self.comment_id = [dictionary objectForKey:@"id"];
        self.comment_content = replaceNSNullValue([dictionary objectForKey:@"content"]);
        
        self.user_owner = [[Users alloc] initWithDictionary:[dictionary objectForKey:@"user"]];
        
    }
    
    return self;
}


@end
