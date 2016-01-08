//
//  TiXingModel.m
//  simi
//
//  Created by 赵中杰 on 14/11/29.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "TiXingModel.h"

@implementation TiXingModel

@synthesize duixiang,biaoti,time,date,zhouqi,beizhu,number,listTitle,week,userTextFieldText;

- (id)init
{
    self = [super init];
    
    if (self) {
        self.duixiang = @"";
        self.userTextFieldText = @"";
    }
    
    return self;
}

@end
