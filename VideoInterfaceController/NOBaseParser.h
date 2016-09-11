//
//  NOBaseParser.h
//  yxz
//
//  Created by xiaotao on 16/9/10.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

// 返回码
typedef enum _rc_ {
    // 通用
    RC_OK,
    RC_FAILED,

} ReturnCode;

#import <Foundation/Foundation.h>

@interface NOBaseParser : NSObject

@property (nonatomic, assign) id idCollection;

- (ReturnCode)parserResponseDataFrom:(NSDictionary *)dic;
@end
