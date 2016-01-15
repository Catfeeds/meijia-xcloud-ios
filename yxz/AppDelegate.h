//
//  AppDelegate.h
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <WatchConnectivity/WatchConnectivity.h>

#import "MainViewController.h"
#import "ApplyViewController.h"
#import "IChatManagerDelegate.h"
#import "SERVICEBaseClass.h"
#import "HuanxinBase.h"
//#import "BPush.h"
//#import ""

#import "GeTuiSdk.h"
@protocol appDelegate <NSObject>

- (void)LoginSuccessNavPush;
- (void)LoginFailNavpush;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate,IChatManagerDelegate,GeTuiSdkDelegate,WCSessionDelegate>
{
    sqlite3 *database;
    NSArray *_stockDataArray;
    NSArray *_tianjinArray;
    
    EMConnectionState _connectionState;
    
    __weak id<appDelegate> delegate;
    NSString *_pushDeviceToken;
}

@property (nonatomic, weak) id<appDelegate> deletate;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *mainController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSArray *stockDataArray;
@property (nonatomic, strong) NSArray *tianjinArray;

@property (nonatomic, strong) NSMutableArray *repartArray;
@property (nonatomic, strong) NSString  *callNum;
@property (nonatomic, strong) SERVICEBaseClass *_baseSource;
@property (nonatomic, strong) HuanxinBase *huanxinBase;
@property (nonatomic, strong) NSData *deviceToken;
@property (nonatomic, strong) UIApplication *application;
@property (nonatomic, strong) NSString  *leiName;
@property (nonatomic, assign) int pushID;

@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *clientId;
@property (retain, nonatomic) NSString *payloadId;
@property (assign, nonatomic) int lastPayloadIndex;
@property (assign, nonatomic) SdkStatus sdkStatus;

@property (nonatomic) BOOL pushBool;

@property (nonatomic ,strong) NSDictionary *globalDic;
@property (nonatomic ,strong) NSMutableArray *riliArray;
- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)ChoseRootController;

- (void) sendTextContent;

- (void)huanxin;

@end
