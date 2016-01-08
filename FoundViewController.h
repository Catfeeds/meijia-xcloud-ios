//
//  FoundViewController.h
//  simi
//
//  Created by 白玉林 on 15/7/31.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import "EGORefreshTableHeaderView.h"
@interface FoundViewController : FatherViewController<UIScrollViewDelegate,UIWebViewDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate>
{
    //下拉视图
    EGORefreshTableHeaderView * _refreshHeaderView;
    //刷新标识，是否正在刷新过程中
    BOOL _reloading;
}
@property(strong, nonatomic)UIWebView *meWebView;
//@property(nonatomic ,strong)UIScrollView *scrollerView;
@property(nonatomic ,strong)UIImageView *lineImageView;
@property(nonatomic ,strong) NSString *imgurl;
@property(nonatomic ,assign)NSInteger vcID;
@end
