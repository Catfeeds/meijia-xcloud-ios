//
//  PayMentView.h
//  simi
//
//  Created by 白玉林 on 15/9/15.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherView.h"
@protocol BUYDELEGATE <NSObject>

- (void)buyBtnPressedisAli:(BOOL)isAli;
- (void)buyBtnAddRess:(UIButton *)sender;
- (void)buyBtnVolume:(UIButton *)sender;

@end
@interface PayMentView : FatherView
{
    NSString *_zhanghu;
    NSString *_jine;
    NSString *_fanxian;
    
    NSString *_selfmoney;
    NSString *addressString;
    NSString *_volumeString;
    NSString *_actualString;
    
    BOOL isAli;
}

@property (nonatomic, strong)NSString *zhanghu;
@property (nonatomic, strong)NSString *jine;
@property (nonatomic, strong)NSString *fanxian;
@property (nonatomic, strong)NSString *selfmoney;
@property (nonatomic, assign)BOOL ZFB;
@property (nonatomic, assign)int addressID;
@property (nonatomic, strong)NSString *addressString;
@property (nonatomic, strong)NSString *volumeString;
@property (nonatomic, strong)NSString *actualString;

@property (nonatomic, weak) __weak id <BUYDELEGATE> delegate;


- (id)initWithFrame:(CGRect)frame num:(int)num;
@end
