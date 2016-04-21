//
//  SchoolTableViewCell.h
//  yxz
//
//  Created by 白玉林 on 16/4/21.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolTableViewCell : UITableViewCell
//用户名

@property(nonatomic,retain) UILabel *text;

//用户介绍

@property(nonatomic,retain) UILabel *nameTime;

//用户头像

@property(nonatomic,retain) UIImageView *myImageView;



//给用户介绍赋值并且实现自动换行

-(void)setIntroductionText:(NSDictionary *)text;

//初始化cell类

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
@end
