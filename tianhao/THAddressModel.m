//
//  THAddressModel.m
//  tianhao
//
//  Created by Jonear on 14-7-6.
//  Copyright (c) 2014年 Jonear. All rights reserved.
//

#import "THAddressModel.h"
#import "RDHttpManager.h"
#import "THAddress.h"

@implementation THAddressModel


+ (void)fetchAddressWithSuccess:(void (^)(NSArray *))success
                        Failure:(void (^)(NSError *))failure
{
    RDHttpManager *manager = [RDHttpManager manager];
    [manager PostRequest:[NSString stringWithFormat:@"%@/fetchAddress", THServerUrl]
              parameters:nil
                 success:^(id json){
                     NSArray *array = [[self class] analyzeAddress:json];
                     if (success) {
                         success(array);
                     }
                 }
                 failure:failure];
    [manager start];
}


+ (NSArray *)analyzeAddress:(NSString *)jsonStr
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
            
            THAddress *add = [[THAddress alloc] init];
            add.aid = [[json objectForKey:@"pk"] integerValue];
            add.iconUrl = [dataDic objectForKey:@"iconUrl"];
            add.address = [dataDic objectForKey:@"address"];
            add.name = [dataDic objectForKey:@"name"];
            add.telephone = [dataDic objectForKey:@"telephone"];
            add.lat = [[dataDic objectForKey:@"lat"] doubleValue];
            add.lot = [[dataDic objectForKey:@"lot"] doubleValue];
            add.createData = [dataDic objectForKey:@"createDate"];
            
            [dataArray addObject:add];
        }
        
        return dataArray;
    } else {
        return nil;
    }
    
    return nil;
}

@end
