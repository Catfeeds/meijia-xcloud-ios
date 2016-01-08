//
//  WebViewController.h
//  yxz
//
//  Created by 白玉林 on 15/11/13.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import "EGORefreshTableHeaderView.h"
@interface WebViewController : FatherViewController<UIWebViewDelegate,UIScrollViewDelegate,EGORefreshTableHeaderDelegate>
{
    //下拉视图
    EGORefreshTableHeaderView * _refreshHeaderView;
    //刷新标识，是否正在刷新过程中
    BOOL _reloading;
}
@property(strong, nonatomic)UIWebView *meWebView;
@property(nonatomic ,strong)NSString *_weburl;
@end
