//
//  THAddress.h
//  tianhao
//
//  Created by Jonear on 14-7-6.
//  Copyright (c) 2014年 Jonear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THAddress : NSObject

@property (assign, nonatomic) int aid;
@property (strong, nonatomic) NSString *iconUrl;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *telephone;
@property (assign, nonatomic) double lat;
@property (assign, nonatomic) double lot;
@property (strong, nonatomic) NSString *createData;

@end
