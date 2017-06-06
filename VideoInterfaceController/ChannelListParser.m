//
//  ChannelListParser.m
//  yxz
//
//  Created by xiaotao on 16/9/10.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "ChannelListParser.h"
#import "ChannelListModel.h"
#import "MJExtension.h"

@implementation ChannelListParser

- (ReturnCode)parserResponseDataFrom:(NSDictionary *)dic
{
    NSInteger status = [[dic objectForKey:@"status"] integerValue];
    if (status != 0) {
        return RC_FAILED;
    }
    NSMutableArray *arrList = (NSMutableArray *)self.idCollection;
    NSArray *dataArray = [dic objectForKey:@"data"];
    if (dataArray.count <= 0) {
        return RC_FAILED;
    }
    
    for (int i = 0; i < dataArray.count; i ++) {
        NSDictionary *dic = [dataArray objectAtIndex:i];
        ChannelListModel *listModel = [[ChannelListModel alloc] init];
        listModel.channel_id = [[dic objectForKey:@"channel_id"] integerValue];
        listModel.name = [dic objectForKey:@"name"];
        [arrList addObject:listModel];
    }
    
    return RC_OK;
}
@end
