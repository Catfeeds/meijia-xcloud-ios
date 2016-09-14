//
//  VideoArticleParser.m
//  yxz
//
//  Created by xiaotao on 16/9/13.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "VideoArticleParser.h"
#import "VideoArticleModel.h"
#import "MJExtension.h"

@implementation VideoArticleParser

- (ReturnCode)parserResponseDataFrom:(NSDictionary *)dic
{
    NSInteger status = [[dic objectForKey:@"status"] integerValue];
    if (status != 0) {
        return RC_FAILED;
    }
    NSMutableArray *articleArray = (NSMutableArray *)self.idCollection;
    id data = [dic objectForKey:@"data"];
    if ([data isKindOfClass:[NSString class]]) {
        return RC_FAILED;
    } else if ([data isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)data;
        for (int i = 0; i < array.count; i ++) {
            NSDictionary *dic = [array objectAtIndex:i];
            VideoArticleModel *model = [VideoArticleModel objectWithKeyValues:dic];
            [articleArray addObject:model];
        }
        return RC_OK;
    }
    return RC_FAILED;
}

@end
