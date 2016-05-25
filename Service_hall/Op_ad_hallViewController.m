//
//  Op_ad_hallViewController.m
//  yxz
//
//  Created by 白玉林 on 16/5/16.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "Op_ad_hallViewController.h"

@interface Op_ad_hallViewController ()
{
    NSArray *array;
    NSString *createPath;
}
@end

@implementation Op_ad_hallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    createPath = [NSString stringWithFormat:@"%@/Op_ad_hallImage", pathDocuments];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"FileDir is exists.");
    }
    // Do any additional setup after loading the view.
}
-(void)preLoadingImage:(NSArray *)op_adArray
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    createPath = [NSString stringWithFormat:@"%@/Op_ad_hallImage", pathDocuments];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"FileDir is exists.");
    }
    
    
    //    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *reatePath = [NSString stringWithFormat:@"%@/simi.db", pathDocuments];
    if(sqlite3_open([reatePath UTF8String], &simi) != SQLITE_OK) {
        sqlite3_close(simi);
        NSLog(@"open database fail");
    }
    //    op_adArray=[sender objectForKey:@"data"];
    for (int i=0; i<op_adArray.count; i++) {
        NSDictionary *dict =op_adArray[i];
        sqlite3_stmt *dbps;
        
        NSString *searchSQL = [NSString stringWithFormat:@"SELECT * from op_ad where id = %@",[dict objectForKey:@"id"]];
        
        const char *searchtUTF8 = [searchSQL UTF8String];
        
        if (sqlite3_prepare_v2(simi, searchtUTF8, -1, &dbps, nil) != SQLITE_OK) {
            NSLog(@"数据查询失败");
            
        }else{
            UIImage * image;
            NSString * filePath;
            while (sqlite3_step(dbps) == SQLITE_ROW) {
                char *t_id = (char *)sqlite3_column_text(dbps, 0);
                NSString *t_idStr = [[NSString alloc] initWithUTF8String:t_id];
                
                char *update_time = (char *)sqlite3_column_text(dbps, 9);
                NSString *update_timeStr = [[NSString alloc] initWithUTF8String:update_time];
                NSString *imageStr=[NSString stringWithFormat:@"opad_%@_%@",t_idStr,update_timeStr];
                
                image =[self loadLocalImage:imageStr];
                filePath = [self imageFilePath:imageStr];
                
            }
            sqlite3_finalize(dbps);
            if (image==nil) {
                
            }else{
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSError *error;
                
                if ([fileManager removeItemAtPath:filePath error:&error] != YES)
                    
                    NSLog(@"Unable to delete file: %@", [error localizedDescription]);
            }
            
        }
        [self preLoadLayout:dict];
    }
    
}




#pragma mark - 加载本地图像
- (UIImage *)loadLocalImage:(NSString *)imageUrl
{
    
    // 获取图像路径
    NSString * filePath = [self imageFilePath:imageUrl];
    
    
    UIImage * image = [UIImage imageWithContentsOfFile:filePath];
    
    
    if (image != nil) {
        return image;
    }
    
    return nil;
}
-(void)preLoadLayout:(NSDictionary *)dict
{
    // 先判断本地沙盒是否已经存在图像，存在直接获取，不存在再下载，下载后保存
    // 存在沙盒的Caches的子文件夹DownloadImages中
    NSString *imageUrl=[NSString stringWithFormat:@"%@",[dict objectForKey:@"img_url"]];
    NSString *t_idStr=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    NSString *update_timeStr=[NSString stringWithFormat:@"%@",[dict objectForKey:@"update_time"]];
    NSString *imageStr=[NSString stringWithFormat:@"opad_%@_%@",t_idStr,update_timeStr];
    UIImage * image = [self loadLocalImage:imageStr];
    
    
    if (image == nil) {
        
        
        // 沙盒中没有，下载
        // 异步下载,分配在程序进程缺省产生的并发队列
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            // 多线程中下载图像
            NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            
            
            // 缓存图片
            [imageData writeToFile:[self imageFilePath:imageStr] atomically:YES];
            
            
        });
    }
    
}
#pragma mark - 获取图像路径
- (NSString *)imageFilePath:(NSString *)imageUrl
{
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:createPath]) {
        
        
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
#pragma mark 拼接图像文件在沙盒中的路径,因为图像URL有"/",要在存入前替换掉,随意用"_"代替
    //    NSString * imageName = [imageUrl stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString * imageFilePath = [createPath stringByAppendingPathComponent:imageUrl];
    
    
    return imageFilePath;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
