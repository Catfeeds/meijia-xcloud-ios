//
//  DropDown.h
//  yxz
//
//  Created by 白玉林 on 16/3/14.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DropDownDelegate
-(void)pullDownAnimated:(int)open;
@end
@interface DropDown : UIView<UITableViewDelegate,UITableViewDataSource> {
    UITableView *tv;//下拉列表
    NSArray *tableArray;//下拉列表数据
    UIButton *textField;//文本输入框
    BOOL showList;//是否弹出下拉列表
    CGFloat tabheight;//table下拉列表的高度
    CGFloat frameHeight;//frame的高度
}
@property (nonatomic, assign) id<DropDownDelegate> delegate;
@property (nonatomic,retain) UITableView *tv;
@property (nonatomic,retain) NSArray *tableArray;
@property (nonatomic,strong) UIButton *textField;
- (void)dropdown;
@end
