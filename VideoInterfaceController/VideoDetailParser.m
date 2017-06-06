//
//  VideoDetailParser.m
//  yxz
//
//  Created by xiaotao on 16/9/11.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "VideoDetailParser.h"
#import "VideoDetailModel.h"
#import "MJExtension.h"

@implementation VideoDetailParser

- (ReturnCode)parserResponseDataFrom:(NSDictionary *)dic
{
    NSInteger status = [[dic objectForKey:@"status"] integerValue];
    if (status != 0) {
        return RC_FAILED;
    }
    NSMutableArray *detailArray = (NSMutableArray *)self.idCollection;
    NSDictionary *dicData = [dic objectForKey:@"data"];
    VideoDetailModel *model = [VideoDetailModel objectWithKeyValues:dicData];
    [detailArray addObject:model];
    return RC_OK;
}

@end
