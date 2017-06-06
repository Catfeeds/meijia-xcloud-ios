//
//  CellModel.h
//  simi
//
//  Created by zrj on 15-2-2.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellModel : NSObject
@property (nonatomic, strong) id cellID;;
@property (nonatomic, assign) int city_id;
@property (nonatomic, strong) NSString *cell_name;
@property (nonatomic, strong) NSString *cell_addr;
@property (nonatomic, strong) NSString *addr_lng;
@property (nonatomic, strong) NSString *addr_lat;
@property (nonatomic, assign) int add_time;
@property (nonatomic, assign) int available;

- (instancetype)initWithArray:(NSArray *)array index:(NSInteger)index;
@end
