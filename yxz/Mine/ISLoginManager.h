//
//  ISLoginManager.h
//  simi
//
//  Created by zrj on 14-11-24.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISLoginManager : NSObject
{
    BOOL _isLogin;
    
    NSString *_telephone;
}

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *listTitle;

+(ISLoginManager *)shareManager;

@end
