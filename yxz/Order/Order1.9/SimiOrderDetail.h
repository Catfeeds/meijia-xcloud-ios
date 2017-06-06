//
//  SimiOrderDetail.h
//  simi
//
//  Created by 高鸿鹏 on 15/6/22.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimiOrderDetailModel.h"

@protocol simiOrderDetailDelete <NSObject>

-(void)PressDownWithTitle:(NSString *)title;

@end


@interface SimiOrderDetail : UIView
{
    __weak id<simiOrderDetailDelete>_delegate;
    
    SimiOrderDetailModel *_myModel;
}

@property (nonatomic, weak) id<simiOrderDetailDelete>delegate;

@property (nonatomic, strong) SimiOrderDetailModel *myModel;

- (instancetype)initWithFrame:(CGRect)frame withModel:(SimiOrderDetailModel *)orderModel;


@end
