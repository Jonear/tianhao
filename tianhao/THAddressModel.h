//
//  THAddressModel.h
//  tianhao
//
//  Created by Jonear on 14-7-6.
//  Copyright (c) 2014年 Jonear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THAddressModel : NSObject

+ (void)fetchAddress:(int)aid
             success:(void (^)(NSArray *))success
             failure:(void (^)(NSError *))failure;

@end
