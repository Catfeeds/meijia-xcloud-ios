//
//  MsLikeView.h
//  yxz
//
//  Created by apple on 2017/4/25.
//  Copyright © 2017年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^likeViewBlock)(NSDictionary * dataDict);
@interface MsLikeView : UITableView
@property(nonatomic,strong)NSArray * dataArr;
@property(nonatomic,copy)likeViewBlock selectLikeBook;
@end
