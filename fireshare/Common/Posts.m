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
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
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
        
        
        NSString *dateNowString= [now stringByReplacingOccurrencesOfString:@"+0000"  withString:@""];
        
        
        
        NSDate *dateNow = [dateFormatter dateFromString:dateNowString];
        
        
        NSString *dateServiceString= [[dictionary objectForKey:@"created_at"] stringByReplacingOccurrencesOfString:@"Z"  withString:@""];
        NSDate *dateA =     [[dateFormatter dateFromString:dateServiceString] dateByAddingTimeInterval:-3600*3];
        
        
        
        self.seconds_since = [dateNow timeIntervalSinceDate:dateA];
        self.minutes_since = round(self.seconds_since/60);
        self.hours_since = round(self.seconds_since/3600);
        self.days_since =round(self.seconds_since/86400);
        
        
    }
    
    return self;
}




- (void)encodeWithCoder:(NSCoder *)coder {
 
    
    
}



- (id)initWithCoder:(NSCoder *)aDecoder {
    

    
    return self;
}
@end
