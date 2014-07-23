//
//  THProduct.h
//  tianhao
//
//  Created by Jonear on 14-7-22.
//  Copyright (c) 2014年 Jonear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THProduct : NSObject

@property (assign, nonatomic) int pid;
@property (strong, nonatomic) NSString *iconUrl;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *model;
@property (assign, nonatomic) float price;
@property (strong, nonatomic) NSString *detail;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *remarks;
@property (strong, nonatomic) NSString *createData;

@end
