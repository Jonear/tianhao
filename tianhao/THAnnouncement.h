//
//  THAnnouncement.h
//  tianhao
//
//  Created by Jonear on 14-7-5.
//  Copyright (c) 2014年 Jonear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THAnnouncement : NSObject

@property (assign, nonatomic) int aid;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *createDate;
@property (strong, nonatomic) NSString *iconurl;

@end
