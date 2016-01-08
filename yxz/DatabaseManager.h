//
//  Database.h
//  Stock
//
//  Created by djf on 14-3-3.
//  Copyright (c) 2014年 Ruby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DatabaseManager : NSObject{
    sqlite3             *database;
    NSString            *databasePath;
    
}

//单利方法，维持、返回同一个对象
+ (DatabaseManager *) sharedDatabaseManager;

//打开数据库
- (BOOL)open;

//关闭数据库
- (void)close;

//根据表名查询数据（目前默认查询stock表数据）
- (NSArray *) getDataRecordsByTableName:(NSString *)tableName cityid:(NSInteger)cityid;


- (BOOL) connectedToNetwork;




- (NSString *)getTimeWithstring:(NSString *)timeStr Format:(NSString *)format ;//时间戳

- (NSString *)gettimeForNow;//当前时间的时间戳

//倒序查询
- (NSArray *)chaxunTableName:(NSString *)tableName timeZiduan:(NSString *)ziduan;

// 根据小区id查询数据库里有没有这个小区
- (BOOL)chaxuntableName:(NSString *)tableName cellId:(NSString *)cellid;
@end
