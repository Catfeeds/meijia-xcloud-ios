//
//  Po_ad_ImagViewController.m
//  yxz
//
//  Created by 白玉林 on 16/5/25.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "Po_ad_ImagViewController.h"

@interface Po_ad_ImagViewController ()
{
    NSArray *array;
    NSString *createPath;
}
@end

@implementation Po_ad_ImagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    createPath = [NSString stringWithFormat:@"%@/PreLoadingImage", pathDocuments];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"FileDir is exists.");
    }
    // Do any additional setup after loading the view.
}
-(void)preLoadingImage:(NSString *)channel_id page:(NSString *)page post_or_get:(NSString *)InterfaceStr
{
    int pa=[page intValue];
    for (int i=0; i<3; i++) {
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSString *pageStr=[NSString stringWithFormat:@"%d",pa];
        NSDictionary *dict=@{@"channel_id":channel_id,@"page":pageStr};
        [_download requestWithUrl:InterfaceStr dict:dict view:self.view delegate:self finishedSEL:@selector(ChannelSuccess:) isPost:NO failedSEL:@selector(ChannelFailure:)];
        pa++;
    }
    
}

#pragma mark 获取频道列表成功返回方法
-(void)ChannelSuccess:(id)sender
{
    NSLog(@"获取频道列表成功数据%@",sender);
    //    arrayImage=[sender objectForKey:@"data"];
    NSString *dataString=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    if (dataString==nil||dataString==NULL||dataString.length==0||[dataString isEqualToString:@""]) {
        
    }else{
        array=[sender objectForKey:@"data"];
        [self preLoadLayout];
    }
    
    
}
#pragma mark 获取频道列表失败返回方法
-(void)ChannelFailure:(id)sender
{
    NSLog(@"获取频道列表失败数据%@",sender);
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
-(void)preLoadLayout
{
    
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic=array[i];
        // 先判断本地沙盒是否已经存在图像，存在直接获取，不存在再下载，下载后保存
        // 存在沙盒的Caches的子文件夹DownloadImages中
        NSString *imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"img_url"]];
        UIImage * image = [self loadLocalImage:imageUrl];
        
        
        if (image == nil) {
            
            
            // 沙盒中没有，下载
            // 异步下载,分配在程序进程缺省产生的并发队列
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                // 多线程中下载图像
                NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                
                
                // 缓存图片
                [imageData writeToFile:[self imageFilePath:imageUrl] atomically:YES];
                
                
            });
        }
        
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
    NSString * imageName = [imageUrl stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString * imageFilePath = [createPath stringByAppendingPathComponent:imageName];
    
    
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
