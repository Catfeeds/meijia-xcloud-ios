//
//  ScanningViewController.m
//  CXScanning
//
//  Created by artifeng on 16/1/7.
//  Copyright © 2016年 CX. All rights reserved.
//

#import "ScanningViewController.h"
#import "AFHTTPRequestOperationManager.h"
#define Height [UIScreen mainScreen].bounds.size.height
#define Width [UIScreen mainScreen].bounds.size.width
#define XCenter self.view.center.x
#define YCenter self.view.center.y

#define SHeight 20

#define SWidth (XCenter+30)


@interface ScanningViewController ()
{
    UIImageView * imageView;
    NSMutableData *expData;
}

@end

@implementation ScanningViewController

- (void)viewDidLoad {
    expData=[[NSMutableData alloc]init];
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(10,100, WIDTH-20, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor blueColor];
    labIntroudction.text=@"将条码二维码放入框中就能自动扫描";
    [self.view addSubview:labIntroudction];
    
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20,(Height-100)/2,WIDTH-40,100)];
    imageView.image = [UIImage imageNamed:@"scanscanBg.png"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame)+5, CGRectGetMinY(imageView.frame)+5, WIDTH-50,2)];
    _line.image = [UIImage imageNamed:@"scanLine@2x.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setupCamera];
}
-(void)viewWillDisappear:(BOOL)animated
{
   
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(CGRectGetMinX(imageView.frame)+5, CGRectGetMinY(imageView.frame)+5+2*num, WIDTH-50,2);
       
        if (num ==(int)((90)/2)) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame =CGRectMake(CGRectGetMinX(imageView.frame)+5, CGRectGetMinY(imageView.frame)+5+2*num, WIDTH-50,2);
        
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}


- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    _output.rectOfInterest =[self rectOfInterestByScanViewRect:imageView.frame];//CGRectMake(0.1, 0, 0.9, 1);//
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode];
    

    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResize;
    _preview.frame =self.view.bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    [self.view bringSubviewToFront:imageView];

    [self setOverView];
    
    // Start
    [_session startRunning];
}
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
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    if(_stringValue==nil||_stringValue==NULL||[_stringValue isEqualToString:@""])
    {
        
    }else{
        return;
    }
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        /**
         *  获取扫描结果
         */
        _stringValue = metadataObject.stringValue;
        if(_stringValue==nil||_stringValue==NULL||[_stringValue isEqualToString:@""])
        {
            
        }else{
            NSString *urlString = [NSString stringWithFormat:@"http://m.kuaidi100.com/autonumber/auto?num=%@",_stringValue];
            // 初始化一个NSURL对象
            NSURL *url = [NSURL URLWithString:urlString];
            // 初始化一个请求
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            // 设置请求方法，可以省略，默认就是GET请求
            request.HTTPMethod = @"GET";
            // 如果60秒过后服务器还没有相应，就算请求超时
            request.timeoutInterval = 2;
            // 初始化一个连接
            NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
            // 开始一个异步请求
            [conn start];
            return;
        }
        
    }
}
// 服务器接收到请求时
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"22222222%@",connection);
}
// 当收到服务器返回的数据时触发, 返回的可能是资源片段
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"333333333%@",data);
    [expData appendData:data];
}
// 当服务器返回所有数据时触发, 数据返回完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // 解析成字符串数据
    NSString *str = [[NSString alloc] initWithData:expData encoding:NSUTF8StringEncoding];
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    NSArray *array=(NSArray *)dic;
    NSDictionary *arrayDic=array[0];
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"simi.db"];
    sqlite3_open([path UTF8String], &express);
    
    sqlite3_stmt *statement;
    NSString *sql =[NSString stringWithFormat:@"SELECT * FROM express where ecode = '%@'",[arrayDic objectForKey:@"comCode"]] ;
    
    if (sqlite3_prepare_v2(express, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *city_id = (char *)sqlite3_column_text(statement, 0);
            NSString *city_idStr = [[NSString alloc] initWithUTF8String:city_id];
            
            char *name = (char *)sqlite3_column_text(statement, 1);
            NSString *nameStr = [[NSString alloc] initWithUTF8String:name];
            
            char *add_time = (char *)sqlite3_column_text(statement, 2);
            NSString *add_timeStr = [[NSString alloc] initWithUTF8String:add_time];
            
            char *province_id = (char *)sqlite3_column_text(statement, 3);
            NSString *province_idStr = [[NSString alloc] initWithUTF8String:province_id];
            
            char *is_enable = (char *)sqlite3_column_text(statement, 7);
            NSString *is_enableStr = [[NSString alloc] initWithUTF8String:is_enable];
            
            char *zip_code = (char *)sqlite3_column_text(statement, 8);
            NSString *zip_codeStr = [[NSString alloc] initWithUTF8String:zip_code];
            
            NSDictionary *dic=@{@"express_id":city_idStr,@"ecode":nameStr,@"name":add_timeStr,@"is_hot":province_idStr,@"add_time":is_enableStr,@"update_time":zip_codeStr};
            _express_idStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"express_id"]];
            _expressNameStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        }
        sqlite3_finalize(statement);
    }

    
    NSLog(@"%@", str);
    NSLog(@"111111%@",str);
    [self backAction];
}
// 请求数据失败时触发
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
}
-(void)todoSomething
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backAction
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething) object:nil];
    [self performSelector:@selector(todoSomething) withObject:nil afterDelay:0.2f];
    
    //    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    
}
- (CGRect)rectOfInterestByScanViewRect:(CGRect)rect {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    CGFloat x = (height - CGRectGetHeight(rect)) / 2 / height;
    CGFloat y = (width - CGRectGetWidth(rect)) / 2 / width;
    
    CGFloat w = CGRectGetHeight(rect) / height;
    CGFloat h = CGRectGetWidth(rect) / width;
   
    return CGRectMake(x, y, w, h);
}

#pragma mark - 添加模糊效果
- (void)setOverView {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    CGFloat x = CGRectGetMinX(imageView.frame);
    CGFloat y = CGRectGetMinY(imageView.frame);
    CGFloat w = CGRectGetWidth(imageView.frame);
    CGFloat h = CGRectGetHeight(imageView.frame);
    
    [self creatView:CGRectMake(0, 64, width, y-64)];
    [self creatView:CGRectMake(0, y, x, h)];
    [self creatView:CGRectMake(0, y + h, width, height - y - h)];
    [self creatView:CGRectMake(x + w, y, width - x - w, h)];
}

- (void)creatView:(CGRect)rect {
    CGFloat alpha = 0.5;
    UIColor *backColor = [UIColor grayColor];
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backColor;
    view.alpha = alpha;
    [self.view addSubview:view];
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
