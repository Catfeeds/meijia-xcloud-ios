//
//  Op_ad_hallViewController.h
//  yxz
//
//  Created by 白玉林 on 16/5/16.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <WatchConnectivity/WatchConnectivity.h>
@interface Op_ad_hallViewController : UIViewController
{
    sqlite3 *simi;
}
-(void)preLoadingImage:(NSArray *)op_adArray;
@end
