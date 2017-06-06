//
//  VideoArticleToolBar.h
//  yxz
//
//  Created by xiaotao on 16/9/13.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoArticleToolBarDelegate <NSObject>

- (void)textFieldButtonClick;

- (void)otherButtonsClick:(UIButton *)button;

@end

@interface VideoArticleToolBar : UIView

@property (weak, nonatomic) id <VideoArticleToolBarDelegate> delegate;
@property (strong, nonatomic) UIImageView *clickImageView;
@end
