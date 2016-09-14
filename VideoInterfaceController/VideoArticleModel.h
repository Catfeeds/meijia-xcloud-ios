//
//  VideoArticleModel.h
//  yxz
//
//  Created by xiaotao on 16/9/13.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoArticleModel : NSObject

@property (assign, nonatomic) int channel_id;
@property (assign, nonatomic) int article_id;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *img_url;
@property (copy, nonatomic) NSString *total_view;
@property (copy, nonatomic) NSString *add_time;
@end
