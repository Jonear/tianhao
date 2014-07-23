//
//  THProductModel.h
//  tianhao
//
//  Created by Jonear on 14-7-22.
//  Copyright (c) 2014年 Jonear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THProductModel : NSObject

+ (void)fetchHotProductWithSuccess:(void (^)(NSArray *))success
                           Failure:(void (^)(NSError *))failure;

+ (void)fetchNewProductWithSuccess:(void (^)(NSArray *))success
                           Failure:(void (^)(NSError *))failure;

+ (void)fetchProduct:(int)pid
             success:(void (^)(NSArray *))success
             failure:(void (^)(NSError *))failure;

@end
