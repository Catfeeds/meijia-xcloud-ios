//
//  ImgWebViewController.h
//  simi
//
//  Created by zrj on 14-12-2.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface ImgWebViewController : FatherViewController
{
    NSString *imgurl;
}

@property (nonatomic, strong) NSString *imgurl;
@property (nonatomic, strong) NSString *title;
@end
