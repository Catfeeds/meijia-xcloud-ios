//
//  VideoArticleToolBar.h
//  yxz
//
//  Created by xiaotao on 16/9/13.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^textFieldButtonClick) ();

@interface VideoArticleToolBar : UIView

@property (copy, nonatomic) textFieldButtonClick block;
@end
