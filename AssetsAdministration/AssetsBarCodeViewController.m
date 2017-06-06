//
//  AssetsBarCodeViewController.m
//  yxz
//
//  Created by 白玉林 on 16/3/31.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "AssetsBarCodeViewController.h"
#import "AFHTTPRequestOperationManager.h"
#define Height [UIScreen mainScreen].bounds.size.height
#define Width [UIScreen mainScreen].bounds.size.width
#define XCenter self.view.center.x
#define YCenter self.view.center.y

#define SHeight 20

#define SWidth (XCenter+30)
@interface AssetsBarCodeViewController ()
{
    UIImageView * imageView;
    NSMutableData *expData;
}
@end

@implementation AssetsBarCodeViewController

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
            ISLoginManager *_manager = [ISLoginManager shareManager];
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSString *company_ID=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"company_id"]];
            NSDictionary *_dict = @{@"user_id":_manager.telephone,@"company_id":company_ID,@"barcode":_stringValue};
            DownloadManager *_download = [[DownloadManager alloc]init];
            [_download requestWithUrl:[NSString stringWithFormat:@"%@",COMPANY_ASSETS_BARCODE] dict:_dict view:self.view delegate:self finishedSEL:@selector(addDressSuccess:) isPost:NO failedSEL:@selector(addDressFail:)];
            return;
        }
        
    }
    
}
#pragma mark 成功返回方法
-(void)addDressSuccess:(id)source
{
    NSLog(@"%@",source);
    NSDictionary *dic=[source objectForKey:@"data"];
    _barcodeStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"barcode"]];
    _nameString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    _unitStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"unit"]];
    _priceStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]];
    [self backAction];
}
#pragma mark失败返回方法
-(void)addDressFail:(id)source
{
    
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
