//
//  THAnnouncementModel.m
//  tianhao
//
//  Created by Jonear on 14-7-5.
//  Copyright (c) 2014年 Jonear. All rights reserved.
//

#import "THAnnouncementModel.h"
#import "RDHttpManager.h"
#import "THAnnouncement.h"

@implementation THAnnouncementModel

+ (void)fetchAnnouncement:(int)aid
                  success:(void (^)(NSArray *))success
                  failure:(void (^)(NSError *))failure;
{
    RDHttpManager *manager = [RDHttpManager manager];
    [manager PostRequest:[NSString stringWithFormat:@"%@/fetchAnnouncement", THServerUrl]
             parameters:@{@"aid":[NSString stringWithFormat:@"%d", aid]}
                success:^(id json){
                            NSArray *array = [[self class] analyzeAnnouncement:json];
                            if (success) {
                                success(array);
                            }
                        }
                failure:failure];
    [manager start];
}


+ (NSArray *)analyzeAnnouncement:(NSString *)jsonStr
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
            
            THAnnouncement *ann = [[THAnnouncement alloc] init];
            ann.aid = [[json objectForKey:@"pk"] integerValue];
            ann.title = [dataDic objectForKey:@"title"];
            ann.content = [dataDic objectForKey:@"detailUrl"];
            ann.iconurl = [dataDic objectForKey:@"iconUrl"];
            ann.createDate = [dataDic objectForKey:@"createDate"];
            
            [dataArray addObject:ann];
        }
        
        return dataArray;
    } else {
        return nil;
    }
    
    return nil;
}

@end
