//
//  LoadMoreCell.m
//  simi
//
//  Created by 赵中杰 on 15/1/7.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "LoadMoreCell.h"

@implementation LoadMoreCell
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIButton *_loadbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loadbtn.backgroundColor = COLOR_VAULE(244.0);
        _loadbtn.frame = FRAME(0, 0, _CELL_WIDTH, 40);
        [_loadbtn setTag:900];
        [_loadbtn addTarget:self action:@selector(LoadMoreBtnpressed:) forControlEvents:UIControlEventTouchUpInside];
        [_loadbtn setTitle:@"点击加载更多" forState:UIControlStateNormal];
        _loadbtn.titleLabel.font = MYFONT(14);
        [_loadbtn setTitleColor:COLOR_VAULE(144.0) forState:UIControlStateNormal];
        [self addSubview:_loadbtn];
        
    }
    
    return self;
}

- (void)setOrderCount:(NSInteger)orderCount
{
    _orderCount = orderCount;
    
    UIButton *_button = (UIButton *)[self viewWithTag:900];
    
    if (orderCount == 999) {
        [_button setTitle:@"没有更多数据了" forState:UIControlStateNormal];
    }
}

- (NSInteger)orderCount
{
    return _orderCount;
}

- (void)LoadMoreBtnpressed:(UIButton *)sender
{
    if ([sender.currentTitle isEqualToString:@"没有更多数据了"]) {
        
    }else{
        [self.delegate loadMoreOrder];
    }
}

@end
