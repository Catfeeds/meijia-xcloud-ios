/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "SERVICEBaseClass.h"
#import "SERVICEBaojie.h"
#import "SERVICEZuofan.h"
#import "SERVICEXiyi.h"
#import "SERVICEJiadian.h"
#import "SERVICECaboli.h"
#import "SERVICEGuandao.h"
#import "SERVICEXinju.h"
#import "HuanxinBase.h"
@interface ChatViewController : UIViewController<IFlyRecognizerViewDelegate>
- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup;
- (void)reloadData;

//讯飞
//带界面的听写识别对象
@property (nonatomic,strong) IFlyRecognizerView * iflyRecognizerView;


@property (nonatomic) SERVICEBaseClass *_baseClass;

@property(nonatomic) SERVICEBaojie *_baojie;
@property(nonatomic) SERVICEXiyi *_xiyi;
@property(nonatomic) SERVICEJiadian *_jiadian;
@property(nonatomic) SERVICECaboli *_caboli;
@property(nonatomic) SERVICEGuandao *_guandao;
@property(nonatomic) SERVICEXinju *_xinju;
@property(nonatomic) SERVICEZuofan *_zuofan;
@property (nonatomic) HuanxinBase *baseData;
@end
