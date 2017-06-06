//
//  MeetingViewController.h
//  simi
//
//  Created by 白玉林 on 15/8/10.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface MeetingViewController : FatherViewController<UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic ,assign)int textID;
@property (nonatomic ,assign)int time;
@property (nonatomic ,assign)NSInteger vcID;

@property (nonatomic ,assign)int detailID;

@property (nonatomic, assign)int cardsID;

@property(nonatomic ,assign)int pushID;
@property(nonatomic ,strong)NSString *titleName;
@property(nonatomic ,strong)NSString *cardString;
@end
