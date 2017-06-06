//
//  Dynamic_DetailsViewController.h
//  yxz
//
//  Created by 白玉林 on 15/12/28.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface Dynamic_DetailsViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIScrollViewDelegate,UMSocialUIDelegate>
@property (nonatomic ,strong)NSString *dyNamicID;
@end
