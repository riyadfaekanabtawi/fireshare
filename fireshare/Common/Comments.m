//
//  Comments.m
//  fireshare
//
//  Created by Riyad Anabtawi on 1/6/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

#import "Comments.h"

@implementation Comments{

 NSDateFormatter *dateFormatter;

}
-(Comments *)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        self.comment_id = [dictionary objectForKey:@"id"];
        self.comment_content = replaceNSNullValue([dictionary objectForKey:@"content"]);
        
        self.user_owner = [[Users alloc] initWithDictionary:[dictionary objectForKey:@"user"]];
        self.voted_string = [dictionary objectForKey:@"voted_string"];
       
        NSString* now = [dateFormatter stringFromDate:[NSDate date]];
        
        
        NSString *dateNowString= [now stringByReplacingOccurrencesOfString:@"+0000"  withString:@""];
        
        
        
        NSDate *dateNow = [dateFormatter dateFromString:dateNowString];
        
        
        NSString *dateServiceString= [[dictionary objectForKey:@"created_at"] stringByReplacingOccurrencesOfString:@"Z"  withString:@""];
        NSDate *dateA =     [[dateFormatter dateFromString:dateServiceString] dateByAddingTimeInterval:-3600*3];
        
        self.likes = [dictionary objectForKey:@"likes"];
        
        self.seconds_since = [dateNow timeIntervalSinceDate:dateA];
        self.minutes_since = round(self.seconds_since/60);
        self.hours_since = round(self.seconds_since/3600);
        self.days_since =round(self.seconds_since/86400);
        
    }
    
    return self;
}


@end
