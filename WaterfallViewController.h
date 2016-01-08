//
//  WaterfallViewController.h
//  yxz
//
//  Created by 白玉林 on 15/12/4.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface WaterfallViewController : FatherViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIWebViewDelegate>
@property (nonatomic ,strong)UICollectionView *collectionView;

@end
