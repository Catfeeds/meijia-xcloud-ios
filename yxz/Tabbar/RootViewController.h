//
//  RootViewController.h
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import "AppDelegate.h"
@interface RootViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIWebViewDelegate>
@property (nonatomic ,strong)UICollectionView *collectionView;
@property (nonatomic, strong)UIImageView *tab;
@property (nonatomic ,assign)int  tabBarID;;
@property (nonatomic, strong)NSString*lngString;
@property (nonatomic, strong)NSString*latString;
@property (nonatomic, strong)NSString* cityStr;
@property (nonatomic, strong)NSString* addressName;
@end
