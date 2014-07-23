//
//  THProductModel.m
//  tianhao
//
//  Created by Jonear on 14-7-22.
//  Copyright (c) 2014年 Jonear. All rights reserved.
//

#import "THProductModel.h"
#import "RDHttpManager.h"
#import "THProduct.h"

@implementation THProductModel

+ (void)fetchHotProductWithSuccess:(void (^)(NSArray *))success
                           Failure:(void (^)(NSError *))failure
{
    RDHttpManager *manager = [RDHttpManager manager];
    [manager PostRequest:[NSString stringWithFormat:@"%@/fetchHotProduct", THServerUrl]
              parameters:nil
                 success:^(id json){
                     NSArray *array = [[self class] analyzeProduct:json];
                     if (success) {
                         success(array);
                     }
                 }
                 failure:failure];
    [manager start];
}

+ (void)fetchNewProductWithSuccess:(void (^)(NSArray *))success
                           Failure:(void (^)(NSError *))failure
{
    RDHttpManager *manager = [RDHttpManager manager];
    [manager PostRequest:[NSString stringWithFormat:@"%@/fetchDevelopProduct", THServerUrl]
              parameters:nil
                 success:^(id json){
                     NSArray *array = [[self class] analyzeProduct:json];
                     if (success) {
                         success(array);
                     }
                 }
                 failure:failure];
    [manager start];
}

+ (void)fetchProduct:(int)pid
             success:(void (^)(NSArray *))success
             failure:(void (^)(NSError *))failure
{
    RDHttpManager *manager = [RDHttpManager manager];
    [manager PostRequest:[NSString stringWithFormat:@"%@/fetchProduct", THServerUrl]
              parameters:@{@"pid":[NSString stringWithFormat:@"%d", pid]}
                 success:^(id json){
                     NSArray *array = [[self class] analyzeProduct:json];
                     if (success) {
                         success(array);
                     }
                 }
                 failure:failure];
    [manager start];
}

+ (NSArray *)analyzeProduct:(NSString *)jsonStr
{
    NSError *error;
    if ([jsonStr isKindOfClass:[NSString class]]) {
        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error) {
            return nil;
        }
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        for (NSDictionary *json in jsonArray) {
            NSDictionary *dataDic = [json objectForKey:@"fields"];
            
            THProduct *product = [[THProduct alloc] init];
            product.pid = [[json objectForKey:@"pk"] integerValue];
            product.iconUrl = [dataDic objectForKey:@"iconUrl"];
            product.status = [dataDic objectForKey:@"status"];
            product.name = [dataDic objectForKey:@"name"];
            product.price = [[dataDic objectForKey:@"price"] doubleValue];
            product.detail = [dataDic objectForKey:@"detail"];
            product.remarks = [dataDic objectForKey:@"remarks"];
            product.model = [dataDic objectForKey:@"model"];
            product.type = [dataDic objectForKey:@"type"];
            product.createData = [dataDic objectForKey:@"createData"];
            
            [dataArray addObject:product];
        }
        
        return dataArray;
    } else {
        return nil;
    }
    
    return nil;
}

@end
