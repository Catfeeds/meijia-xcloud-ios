//
//  UserinfoView.h
//  simi
//
//  Created by 赵中杰 on 14/12/23.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherView.h"
#import "USERINFOData.h"
@protocol userInfoDelegate <NSObject>

- (void)selectBrnPressedWithTag:(NSInteger)btntag;

@end

@interface UserinfoView : FatherView <UITextFieldDelegate>
{
    USERINFOData *_mydata;
    __weak id <userInfoDelegate>_delegate;
    UIImage *_headeImage;
}

@property (nonatomic, retain) USERINFOData *mydata;

@property (nonatomic, weak) id<userInfoDelegate>delegate;

@property (nonatomic, copy) UIImageView *headImg;
@property (nonatomic, strong)UIImage *headeImage;
@end
