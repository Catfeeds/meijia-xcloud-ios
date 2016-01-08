//
//  JifenView.h
//  simi
//
//  Created by 赵中杰 on 14/12/11.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherView.h"

@protocol JIFENDELEGATE <NSObject>

- (void)JifenMingxiOrDuihuan:(NSString *)name;
- (void)GetJifenBtn;

@end

@interface JifenView : FatherView
{
    __weak id <JIFENDELEGATE> _delegate;
    
    NSString *_jifennum;
}

@property (nonatomic, weak) __weak id <JIFENDELEGATE> delegate;

@property (nonatomic, strong) NSString *jifennum;

@end
