//
//  Database.m
//  Stock
//
//  Created by djf on 14-3-3.
//  Copyright (c) 2014年 Ruby. All rights reserved.
//

#import "DatabaseManager.h"
#import "Reachability.h"
#import "DownloadManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "CellModel.h"
#import "AppDelegate.h"

@implementation DatabaseManager
{
    CellModel *model;
}
#pragma mark -
#pragma mark ====单利实现，初始化====
#pragma mark -
static DatabaseManager *sharedDatabaseManager = nil;
+ (DatabaseManager *) sharedDatabaseManager {
    @synchronized ([DatabaseManager class]) {
        if (sharedDatabaseManager == nil) {
            sharedDatabaseManager = [[DatabaseManager alloc] init];
            if (sharedDatabaseManager) {
                [sharedDatabaseManager open];
            }
            return sharedDatabaseManager;
        }
    }
    return sharedDatabaseManager;
}

+ (DatabaseManager *) alloc {
    @synchronized ([DatabaseManager class]) {
        sharedDatabaseManager = [super alloc];
        return sharedDatabaseManager;
    }
    return nil;
}

- (DatabaseManager *) init {
    if (self == [super init]) {
        
    }
    return self;
}


#pragma mark -
#pragma mark ====数据库的打开、关闭====
#pragma mark -

//打开数据库
- (BOOL)open {
    
//    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"simi.db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL find = [fileManager fileExistsAtPath:[self readyDatabase:@"simi.db"]];
    if (find) {
        if(sqlite3_open([[self readyDatabase:@"simi.db"] UTF8String], &database) != SQLITE_OK) {
            sqlite3_close(database);
            NSLog(@"open database fail");
            return NO;
        }
        return YES;
    }
    
//    NSString *path1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *file = [path1 stringByAppendingPathComponent:@"simi.db"];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:file] == FALSE)
//    {
//        NSString *fromFile = [[NSBundle mainBundle] pathForResource:@"simi.db" ofType:nil];
//        [[NSFileManager defaultManager] copyItemAtPath:fromFile toPath:file error:nil];
//    }
//    // open
//    if (sqlite3_open([file UTF8String], &database) != SQLITE_OK){
//        return NO;
//    }
//    NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    
    return NO;
}

//关闭数据库
- (void) close {
    sqlite3_close(database);
}
#pragma mark 在沙盒路径下拷贝一份数据库  否则数据库是只读属性  不能修改
- (NSString *)readyDatabase:(NSString *)dbName {
    // First, test for existence.
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    success = [fileManager fileExistsAtPath:writableDBPath];
    
    
    // The writable database does not exist, so copy the default to the appropriate location.
    
    if (!success) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!success) {
//            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
        
    }
    return writableDBPath;
}
#pragma mark-
#pragma mark====查找数据====
#pragma mark-
- (NSArray *) getDataRecordsByTableName:(NSString *)tableName cityid:(NSInteger)cityid{
    if (tableName == nil || (tableName && ![tableName isEqualToString:@"cell"])) {
        tableName = @"cell";
    }
    sqlite3_stmt *statement;
    NSString *sqlstring = [NSString stringWithFormat:@"SELECT C_ID,C_CITY_ID,C_NAME,C_ADDRESS,C_STORE_ID,C_OPER_TIME FROM cell WHERE C_CITY_ID=%ld",(long)cityid];
    if (sqlite3_prepare_v2(database, [sqlstring UTF8String], -1, &statement, nil) != SQLITE_OK) {
        NSLog(@"数据查询失败");
        return nil;
    }
    NSMutableArray *dataArray = [NSMutableArray array];
    NSArray *fieldKeys = [NSArray arrayWithObjects:C_ID,CITY_ID,CITY_NAME,CITY_DRESS,CITY_STOREID,CITY_OPENTIME, nil];
    while (sqlite3_step(statement) == SQLITE_ROW) {
        NSMutableDictionary *eachRecord = [[NSMutableDictionary alloc] init];
        int columnCount = sqlite3_column_count(statement);

        for (int i = 0; i < columnCount; i ++) {
            NSString *dataStr = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, i) encoding:NSUTF8StringEncoding];
            if (i < [fieldKeys count] && dataStr != nil && ![dataStr isEqualToString:@""]) {
                [eachRecord setObject:dataStr forKey:[fieldKeys objectAtIndex:i]];
            }
            
        }
        [dataArray addObject:eachRecord];
    }
    sqlite3_finalize(statement);
    return dataArray;
}

//C_OPER_TIME
#pragma mark 倒序根据时间字段查最后一条数据
- (NSString *)chaxunTableName:(NSString *)tableName timeZiduan:(NSString *)ziduan
{
    if (tableName == nil || (tableName && ![tableName isEqualToString:@"cell"])) {
        tableName = @"cell";
    }
    sqlite3_stmt *dbps;
    
    NSString *daoSearch = [NSString stringWithFormat:@"SELECT C_OPER_TIME,C_NAME FROM %@ order by %@ DESC LIMIT 1",tableName,ziduan];
//     NSString *daoSearch = [NSString stringWithFormat:@"SELECT C_OPER_TIME FROM cell order by C_ID DESC LIMIT 1"];
//    NSString *daoSearch = [NSString stringWithFormat:@"SELECT * from cell where C_ID = "];
    
    const char *searchtUTF8 = [daoSearch UTF8String];
    
    NSString *str;
    
    if (sqlite3_prepare_v2(database, searchtUTF8, -1, &dbps, nil) != SQLITE_OK) {
        NSLog(@"数据查询失败");
        return nil;
    }else{
//        NSLog(@"查询成功");
        
        while (sqlite3_step(dbps) == SQLITE_ROW) {
            
            char *abc0 = (char *)sqlite3_column_text(dbps, 0);  //表里第0个字段的值
            NSLog(@"%s",abc0);
            char *abc = (char *)sqlite3_column_text(dbps, 0);  //表里第0个字段的值
                    NSLog(@"%s",abc);
            
            str = [[NSString alloc]initWithCString:abc encoding:NSUTF8StringEncoding];
            
           NSString *str2 = [self getTimeWithstring:*(NSTimeInterval *)sqlite3_column_text(dbps, 0)];
            
//           NSLog(@"%@",str2);
            
            [self qingqiu:str2];
            
        }
        
    }

    return str;
    
}
#pragma mark 根据小区id查询数据库里有没有这个小区
- (BOOL)chaxuntableName:(NSString *)tableName cellId:(NSString *)cellid
{
    if (tableName == nil || (tableName && ![tableName isEqualToString:@"cell"])) {
        tableName = @"cell";
    }
    sqlite3_stmt *dbps;
    
    NSString *searchSQL = [NSString stringWithFormat:@"SELECT * from %@ where C_ID = %@",tableName,cellid];
    
    const char *searchtUTF8 = [searchSQL UTF8String];
    
    if (sqlite3_prepare_v2(database, searchtUTF8, -1, &dbps, nil) != SQLITE_OK) {
        NSLog(@"数据查询失败");
        
        return NO;
    }else{
        NSLog(@"查询成功");
        
        while (sqlite3_step(dbps) == SQLITE_ROW) { //查询有这个小区
            char *abc = (char *)sqlite3_column_text(dbps, 8);
            NSString *str = [[NSString alloc]initWithCString:abc encoding:NSUTF8StringEncoding];
            NSLog(@"str : %@",str);
            [self updatetableName:@"cell"];
            return YES;
        }

//        [self deleteTableName:@"cell" cellId:1];
            [self insertIntoTableName:@"cell"];  ////查询没有这个小区
        
        return YES;
    }
}
#pragma mark 如果有这个小区id就更新这个小区
- (void)updatetableName:(NSString *)tablename
{
    if (tablename == nil || (tablename && ![tablename isEqualToString:@"cell"])) {
        tablename = @"cell";
    }
    
    NSString *oper_time = [self getTimeWithstring:model.add_time];
    
    sqlite3_stmt *dbps = nil;
    
    NSString *updateSQL = [NSString stringWithFormat:@"update %@ set C_CITY_ID = %i , C_NAME = '%@' , C_ADDRESS = '%@', C_ADDR_LNG = '%@', C_ADDR_LAT = '%@', C_OPER_TIME = '%@' where C_ID = %@",tablename,model.city_id,model.cell_name,model.cell_addr,model.addr_lng,model.addr_lat,oper_time,model.cellID];
    
    const char *searchtUTF8 = [updateSQL UTF8String];
    
    int result = sqlite3_prepare_v2(database, searchtUTF8, -1, &dbps, NULL);
    
    if (result == SQLITE_OK) {
        if (sqlite3_step(dbps) == SQLITE_DONE) {
//          int vvv = sqlite3_step(dbps);
//          NSLog(@"vvv=%d",vvv);
//        
//            if (sqlite3_step(dbps) == SQLITE_DONE) {
//                sqlite3_finalize(dbps);
                NSLog(@"更新成功");
//            }
        }
    }

    sqlite3_finalize(dbps);

}
#pragma mark 如果没有这个小区就插入这条数据
- (void)insertIntoTableName:(NSString *)tablename
{
    NSString *oper_time = [self getTimeWithstring:model.add_time];
    
    sqlite3_stmt *dbps ;
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO cell (C_ID, C_CITY_ID, C_NAME, C_ADDRESS, C_STORE_ID, C_ADDR_LNG, C_ADDR_LAT, C_OPER_TIME) VALUES (%@, %i, '%@', '%@', 17, '%@', '%@', '%@')",model.cellID,model.city_id,model.cell_name,model.cell_addr,model.addr_lng,model.addr_lat,oper_time];
    
    const char *insertUTF8 = [insertSQL UTF8String];
    
    int result = sqlite3_prepare_v2(database, insertUTF8, -1, &dbps, NULL);
    
    if(result == SQLITE_OK){
        NSLog(@"插入成功");

        if (sqlite3_step(dbps) == SQLITE_DONE) {
            sqlite3_finalize(dbps);
            NSLog(@"成功");
        }
    }else{
        NSLog(@"插入失败");
    }
}
#pragma mark 删除
- (void)deleteTableName:(NSString *)tablename cellId:(int)cellid{
    sqlite3_stmt *dbps ;
    
    NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM cell where C_ID = %i",cellid];
    
    const char *insertUTF8 = [insertSQL UTF8String];
    
    int result = sqlite3_prepare_v2(database, insertUTF8, -1, &dbps, NULL);
    
    if(result == SQLITE_OK){
        NSLog(@"删除成功");
        if (sqlite3_step(dbps) == SQLITE_DONE) {
            sqlite3_finalize(dbps);
            NSLog(@"成功");
        }
        
    }else{
        NSLog(@"删除失败");
    }
    
}
- (void)qingqiu:(NSString *)str
{
    NSString *chuo = [self getTimeWithstring:str Format:@"yyy-MM-dd HH:mm:ss"];
    NSMutableDictionary *sourceDic = [[NSMutableDictionary alloc]init];
    [sourceDic setObject:chuo  forKey:@"t"];

    NSLog(@"请求dic = %@",sourceDic);
    
    AFHTTPRequestOperationManager *mymanager = [AFHTTPRequestOperationManager manager];
    [mymanager GET:[NSString stringWithFormat:@"%@simi/app/dict/get_cells.json",SERVER_DRESS] parameters:sourceDic success:^(AFHTTPRequestOperation *opretion, id responseObject){
        
        NSInteger _status= [[responseObject objectForKey:@"status"] integerValue];
        NSString * _message= [responseObject objectForKey:@"msg"];
        
        if (_status == 0) {
            
            NSArray *arr = [responseObject objectForKey:@"data"];
            
            NSLog(@"arr = %@",arr);
            for (int i = 0; i < arr.count; i++) {
                model = [[CellModel alloc]initWithArray:arr index:i];
                int available = model.available;   //1 = 可用 0 = 不可用, 在同步的时候注意如果等于 0 ，则小区下拉不出现
                
                if (available == 1) {
                    
                    id cellId = model.cellID;
                    
                    [self chaxuntableName:@"cell" cellId:[NSString stringWithFormat:@"%@",cellId]]; //cellid 是接口返回的  根据他去看本地数据库有没有这个小区
                }
                
                if (available == 0) {
                    [self deleteTableName:@"cell" cellId:[model.cellID intValue]];
                }
            }
            
            APPLIACTION.stockDataArray = [[DatabaseManager sharedDatabaseManager]getDataRecordsByTableName:@"cell" cityid:2];

            APPLIACTION.tianjinArray = [[DatabaseManager sharedDatabaseManager] getDataRecordsByTableName:@"cell" cityid:3];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_message  delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
            
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *opration, NSError *error){
        
        NSLog(@"%@",error);
        
    }];

}


#pragma mark
#pragma mark 判断网络连接
- (BOOL) connectedToNetwork
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    if ([r currentReachabilityStatus] == NotReachable) {
        [self showAlertViewWithTitle:@"网络错误" message:@"网络连接失败，请稍后再试"];
        return NO;
        
    }else{
        return YES;
    }
    
}

#pragma mark
#pragma mark AlertView
- (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message

{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message  delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
    
    [alert show];
}

/*
 *  string转化为日期
 *  yyyy-MM-dd HH:mm:ss格式string
 */
//- (NSDate *)makeDate:(NSString *)strDate
//{
//    NSDateFormatter *df=[[NSDateFormatter alloc] init];
//    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *date=[df dateFromString:strDate];
//
//    NSLog(@"%@",date);
//    return date;
//}

// str 转时间戳
- (NSString *)getTimeWithstring:(NSString *)timeStr Format:(NSString *)format
{

    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    NSDate *date=[df dateFromString:timeStr];
    NSLog(@"date:%@",date);
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];

    return timeSp;
}
//当前时间的时间戳
- (NSString *)gettimeForNow
{
    NSDate *datenow = [NSDate date];//现在时间
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow dateByAddingTimeInterval: interval];
    NSLog(@"%@", localeDate);
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    return timeSp;
}
//时间戳转字符串
- (NSString *)getTimeWithstring:(NSTimeInterval)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *theday = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *day = [dateFormatter stringFromDate:theday];
    
    return day;
}
@end
