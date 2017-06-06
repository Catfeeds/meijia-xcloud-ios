//
//  RepeatCycle.h
//  simi
//
//  Created by zrj on 14-11-28.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TiXingModel.h"
@protocol repeartDelegate <NSObject>

- (void)repeartdelegate:(NSString *)str Celltag:(NSInteger)tag;

@end

@interface RepeatCycle : UIView<UITableViewDataSource,UITableViewDelegate>
{
 
    __weak id<repeartDelegate>_delegate;
    
    UITableView *_mytableView;
    
    NSArray *titleArray;
    
//    NSInteger celltag; //重复周期选了第几行
    
    NSInteger number;
    
}

@property (nonatomic, weak) id<repeartDelegate>delegate;

- (id)initWithFrame:(CGRect)frame numbenr:(NSInteger )nmb;

@end
