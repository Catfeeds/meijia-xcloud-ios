//
//  DetailsViewController.h
//  simi
//
//  Created by 白玉林 on 15/8/5.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface DetailsViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UMSocialUIDelegate>
//@property(nonatomic ,assign)NSInteger *A;
@property(nonatomic ,assign)int pathId;
@property(nonatomic ,assign)int card_ID;
@property(nonatomic ,assign)int S;
@property(nonatomic ,assign)int L;
@end
