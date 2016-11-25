//
//  Order_DetailsViewController.h
//  yxz
//
//  Created by 白玉林 on 15/11/14.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
//@class Order_DetailsViewController;
//@protocol Order_DetailsViewControllerDelegate <NSObject>
//
//@optional
//
//-(void)payScusses:(Order_DetailsViewController *)order_DetailsView;
//
//@end


@interface Order_DetailsViewController : FatherViewController<UIScrollViewDelegate>
//@property(nonatomic,weak)id<Order_DetailsViewControllerDelegate> order_DetailsViewDelegate;
@property(nonatomic ,strong)NSDictionary *dic;
@property(nonatomic ,strong)NSString *user_ID;
@property(nonatomic ,strong)NSString *order_ID;
@property(nonatomic ,assign)int details_ID;
@end
