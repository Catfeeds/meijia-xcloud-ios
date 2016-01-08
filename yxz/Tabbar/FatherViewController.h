//
//  FatherViewController.h
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SERVICEBaseClass.h"
#import "SERVICEDataModel.h"
#import "SERVICEData.h"
@interface FatherViewController : UIViewController
{
    UILabel *_navlabel;
    UIButton *_backBtn;
    
    SERVICEBaseClass *_baseSource;
}
@property (nonatomic, strong)UILabel *navlabel;
@property (nonatomic, strong)UIButton *backBtn;
@property (nonatomic, strong)UILabel *backlable;
@property (nonatomic, strong)NSString *hxUserName;
@property (nonatomic, strong)NSString *hxPassword;
@property (nonatomic, strong)NSString *imToUserID;
@property (nonatomic, strong)NSString *imToUserName;
@property (nonatomic, strong)NSString *ID;
@property (nonatomic, strong)UILabel *lineLable;

@property (nonatomic, strong)UILabel *_backLable;

- (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message;


- (void)pushToIM;

- (CGSize)returnMysizeWithCgsize:(CGSize)mysize text:(NSString*)mystring font:(UIFont*)myfont;

- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;

-(UIColor *)getColor:(NSString *)hexColor;

- (NSString *)getTimeWithstring:(NSTimeInterval)time;


//判断是否登录
-(BOOL)loginYesOrNo;

@end
