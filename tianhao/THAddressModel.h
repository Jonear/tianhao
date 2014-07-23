//
//  THAddressModel.h
//  tianhao
//
//  Created by Jonear on 14-7-6.
//  Copyright (c) 2014年 Jonear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THAddressModel : NSObject

+ (void)fetchAddressWithSuccess:(void (^)(NSArray *))success
                        Failure:(void (^)(NSError *))failure;

@end
