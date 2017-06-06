//
//  UsedDressViewController.h
//  simi
//
//  Created by zrj on 14-11-13.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@protocol userDressDelegate <NSObject>

- (void)GetDressCellname:(NSString *)cellname menapi:(NSString *)menpai DressId:(int)dressID cityID:(double)cityId;

@end

@interface UsedDressViewController : FatherViewController
{
    __weak id<userDressDelegate>_delegate;
}

@property (nonatomic ,weak) id<userDressDelegate>delegate;

@property (nonatomic ,strong) NSString *Cname;
@property (nonatomic ,strong) NSString *ctiyString;
@property (nonatomic ,strong) NSString *addCityID;
@end
