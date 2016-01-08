//
//  simiView.h
//  simi
//
//  Created by 赵中杰 on 14/12/9.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherView.h"

@protocol simiDELEGATE <NSObject>

- (void)simiBtnPressedWithName:(NSString *)name;

@end

@interface simiView : FatherView

@property (nonatomic, weak) __weak id <simiDELEGATE> delegate;

@end
