//
//  VideoDetailModel.h
//  yxz
//
//  Created by xiaotao on 16/9/11.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoDetailModel : NSObject

@property (assign, nonatomic) int channel_id;
@property (assign, nonatomic) int article_id;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *img_url;
@property (copy, nonatomic) NSString *total_view;
@property (copy, nonatomic) NSString *add_time;
@property (assign, nonatomic) float price;
@property (assign, nonatomic) float dis_price;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *keywords;
@property (copy, nonatomic) NSString *video_url;
@property (copy, nonatomic) NSString *category;
@property (copy, nonatomic) NSString *content_desc;
@property (copy, nonatomic) NSString *goto_url;
@property (assign, nonatomic) int is_join;
@property (assign, nonatomic) int partner_user_id;
@property (assign, nonatomic) int service_type_id;
@property (assign, nonatomic) int service_price_id;
@property (copy, nonatomic) NSString * vid;
@end
