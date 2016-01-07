//
//  Comments.h
//  fireshare
//
//  Created by Riyad Anabtawi on 1/6/16.
//  Copyright © 2016 Riyad Anabtawi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comments : NSObject
-(Comments *)initWithDictionary:(NSDictionary *)dictionary;
@property NSNumber *comment_id;
@property NSString *comment_content;


@end
