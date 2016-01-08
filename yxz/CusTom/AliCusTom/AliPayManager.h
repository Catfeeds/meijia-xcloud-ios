//
//  AliPayManager.h
//  simi
//
//  Created by 赵中杰 on 14/12/20.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PayData.h"

@protocol payDelegate <NSObject>

- (void)PaySuccess;

@end

@interface AliPayManager : NSObject

{
    __weak id<payDelegate>_delegate;
}

- (void)requestWitDelegate:(id)downloaddelegate data:(PayData *)paydata finishedSEL:(SEL)finished notyurl:(NSString *)notyurl;

@property (nonatomic ,strong)PayData *mydata;

@property (nonatomic, weak) id<payDelegate>delegate;

@property (nonatomic ,assign)NSInteger categoryID;

@end
