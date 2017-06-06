//
//  BaseModel.h
//  simi
//
//  Created by 高鸿鹏 on 15/6/17.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject


@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *describe;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *online_reservation_url;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end
