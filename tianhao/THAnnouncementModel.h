//
//  THAnnouncementModel.h
//  tianhao
//
//  Created by Jonear on 14-7-5.
//  Copyright (c) 2014年 Jonear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THAnnouncementModel : NSObject

+ (void)fetchAnnouncement:(int)aid
                  success:(void (^)(NSArray *))success
                  failure:(void (^)(NSError *))failure;

@end
