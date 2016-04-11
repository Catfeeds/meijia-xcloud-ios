//
//  WholeViewController.h
//  yxz
//
//  Created by 白玉林 on 16/1/11.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface WholeViewController : FatherViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic ,strong)UICollectionView *collectionView;
@property (nonatomic ,strong)NSString *channel_id;
@property (nonatomic ,assign)int whoVCID;
@end
