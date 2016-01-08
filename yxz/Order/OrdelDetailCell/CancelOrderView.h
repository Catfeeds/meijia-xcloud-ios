//
//  CancelOrderCell.h
//  simi
//
//  Created by 赵中杰 on 14/12/20.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherView.h"
#import "ORDERDETAILDataModels.h"
#import "ORDERLISTData.h"

@protocol OEDERDETAILDELEGATE <NSObject>

- (void)OrderBtnPressed:(NSString *)typestr;

@end

@interface CancelOrderView : FatherView
{
    ORDERDETAILData *_mydata;
    
    __weak id <OEDERDETAILDELEGATE> _delegate;
}

@property (nonatomic, strong)ORDERDETAILData *mydata;
@property (nonatomic, weak) __weak id <OEDERDETAILDELEGATE> delegate;

- (id)initWithFrame:(CGRect)frame ordelListData:(ORDERLISTData *)listdata;


@end
