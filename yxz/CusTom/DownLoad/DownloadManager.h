//
//  DownloadManager.h
//  simi
//
//  Created by 赵中杰 on 14/11/25.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadManager : NSObject


- (void)requestWithUrl:(NSString *)url dict:(NSDictionary *)parameters view:(UIView *)myview delegate:(id)downloaddelegate finishedSEL:(SEL)finished isPost:(BOOL)isPost failedSEL:(SEL)failed;

@end
