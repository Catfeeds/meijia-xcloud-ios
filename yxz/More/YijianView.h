//
//  YijianView.h
//  simi
//
//  Created by 赵中杰 on 14/12/19.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherView.h"

@protocol YIJIANDELEGATE <NSObject>

- (void)TijiaoYijianBtnPressed:(NSString *)message;

@end

@interface YijianView : FatherView

@property (nonatomic, weak) __weak id <YIJIANDELEGATE> delegate;

@end
