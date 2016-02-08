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
        NSString* now = [dateFormatter stringFromDate:[NSDate date]];
        
        NSDate *dateNow = [dateFormatter dateFromString:now];
        
        NSDate *dateA =     [[dateFormatter dateFromString:[dictionary objectForKey:@"created_at"]] dateByAddingTimeInterval:-3600*2];
        
    
        self.voted_string = [dictionary objectForKey:@"voted_string"];
        self.seconds_since = [NSNumber numberWithInt:fabs([dateNow timeIntervalSinceDate:dateA])];
        self.minutes_since = [NSNumber numberWithInt:fabs([dateNow timeIntervalSinceDate: dateA])/60];
        self.hours_since = [NSNumber numberWithInt:fabs([dateNow timeIntervalSinceDate: dateA])/3600];
        self.days_since = [NSNumber numberWithInt:fabs([dateNow timeIntervalSinceDate: dateA])/86400];
        
    }
    
    return self;
}


@end
