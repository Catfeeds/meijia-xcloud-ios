//
//  GoodsModel.h
//  ZXShopCart
//
//  Created by Xiang on 16/1/28.
//  Copyright © 2016年 周想. All rights reserved.
//
//  商品模型

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject

/** 添加时间 */
@property (copy, nonatomic) NSString *add_time;

/** 资产ID */
@property (copy, nonatomic) NSString *asset_id;

/** 条形码 */
@property (copy, nonatomic) NSString *barcode;

/** 资产类别ID */
@property (copy, nonatomic) NSString *asset_type_id;

/** 资产名称 */
@property (copy, nonatomic) NSString *name;

/** 公司ID */
@property (copy, nonatomic) NSString *company_id;

/** 存放位置 */
@property (copy, nonatomic) NSString *place;

/** 总价 */
@property (copy, nonatomic) NSString *total_price;

/** 编号 */
@property (copy, nonatomic) NSString *seq;

/** 单价 */
@property (assign, nonatomic) double price;

/** 单位／规格 */
@property (assign, nonatomic) NSString *unit;

/** 商品库存数量 */
@property (assign, nonatomic) int stock;

/** 商品订单数量 */
@property (assign, nonatomic) int orderCount;

/** 时间戳 */
@property (copy, nonatomic) NSString *update_time;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com