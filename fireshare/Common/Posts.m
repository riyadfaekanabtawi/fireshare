//
//  Posts.m
//  fireshare
//
//  Created by Riyad Anabtawi on 1/6/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

#import "Posts.h"
#import "Comments.h"
@implementation Posts{

 NSDateFormatter *dateFormatter;

}


-(Posts *)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    if (self) {
        
        self.post_title = [dictionary objectForKey:@"title"];
        self.post_id = [dictionary objectForKey:@"id"];
        self.post_likes = [dictionary objectForKey:@"likes"];
        self.post_date = [dictionary objectForKey:@"device_token"];
        self.post_user = [[Users alloc] initWithDictionary:[dictionary objectForKey:@"user"]];
     
        
        NSMutableArray *array = [NSMutableArray new];
        
        for (NSDictionary *dic in [dictionary objectForKey:@"comments"]){
            
            [array addObject:[[Comments alloc] initWithDictionary:dic]];
            
            
        }
        
        self.comments = array;
        
        NSString* now = [dateFormatter stringFromDate:[NSDate date]];
        
        NSDate *dateNow = [dateFormatter dateFromString:now];
        
        NSDate *dateA =     [[dateFormatter dateFromString:[dictionary objectForKey:@"created_at"]] dateByAddingTimeInterval:-3600*1];
        
        
        
        self.seconds_since = [NSNumber numberWithInt:fabs([dateNow timeIntervalSinceDate:dateA])];
        self.minutes_since = [NSNumber numberWithInt:fabs([dateNow timeIntervalSinceDate: dateA])/60];
        self.hours_since = [NSNumber numberWithInt:fabs([dateNow timeIntervalSinceDate: dateA])/3600];
        self.days_since = [NSNumber numberWithInt:fabs([dateNow timeIntervalSinceDate: dateA])/86400];
        
        
    }
    
    return self;
}




- (void)encodeWithCoder:(NSCoder *)coder {
 
    
    
}



- (id)initWithCoder:(NSCoder *)aDecoder {
    

    
    return self;
}
@end
