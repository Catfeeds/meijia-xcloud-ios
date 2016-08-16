//
//
//  LBXScanDemo
//
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "LBXScanViewController.h"
#import "MyQRViewController.h"
#import "ScanResultViewController.h"
#import "FriendsHomeViewController.h"
@interface LBXScanViewController ()
{
    NSString *urlStr;
    UIView *layoutView;
    UIActivityIndicatorView *webActivityView;
    UILabel *webTitleLabel;
    UIWebView *myWebView;
}
@end

@implementation LBXScanViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor blackColor];
}

-(void)butAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self drawScanView];
    
    if (_isQQSimulator) {
        
         [self drawBottomItems];
         [self.view bringSubviewToFront:_topTitle];
    }
    else
        _topTitle.hidden = YES;
    
   
    
    
   
    
    [self performSelector:@selector(startScan) withObject:nil afterDelay:0.2];
}

//绘制扫描区域
- (void)drawScanView
{
    
    if (!_qRScanView)
    {
        CGRect rect = self.view.frame;
        rect.origin = CGPointMake(0, 0);
        
        
        
        
        self.qRScanView = [[LBXScanView alloc]initWithFrame:rect style:_style];
        [self.view addSubview:_qRScanView];
        
    
        
        self.topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(0, 0, 145, 60);
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 50);
        
        //3.5inch iphone
        if ([UIScreen mainScreen].bounds.size.height <= 568 )
        {
            _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 38);
            _topTitle.font = [UIFont systemFontOfSize:14];
        }
        
        
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.text = @"将取景框对准二维码即可自动扫描";
        _topTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_topTitle];
        
    }    
    UIButton *but=[[UIButton alloc]initWithFrame:FRAME(0, 20, 70, 40)];
    //but.backgroundColor=[UIColor redColor];
    [but addTarget:self action:@selector(butAction) forControlEvents:UIControlEventTouchUpInside];
    [_qRScanView addSubview:but];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont-p-back"];
    [but addSubview:img];
      [_qRScanView startDeviceReadyingWithText:@"相机启动中"];
    
    
}

- (void)drawBottomItems
{
    if (_bottomItemsView) {
        
        return;
    }
    
    self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-100,
                                                                      CGRectGetWidth(self.view.frame), 100)];
    
    _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    [self.view addSubview:_bottomItemsView];
    
    CGSize size = CGSizeMake(65, 87);
    self.btnFlash = [[UIButton alloc]init];
    _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
    _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/2, CGRectGetHeight(_bottomItemsView.frame)/2);
     [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    [_btnFlash addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnPhoto = [[UIButton alloc]init];
    _btnPhoto.bounds = _btnFlash.bounds;
    _btnPhoto.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/4, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_nor"] forState:UIControlStateNormal];
    [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_down"] forState:UIControlStateHighlighted];
    [_btnPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnMyQR = [[UIButton alloc]init];
    _btnMyQR.bounds = _btnFlash.bounds;
    _btnMyQR.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame) * 3/4, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnMyQR setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_nor"] forState:UIControlStateNormal];
    [_btnMyQR setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_down"] forState:UIControlStateHighlighted];
    [_btnMyQR addTarget:self action:@selector(myQRCode) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomItemsView addSubview:_btnFlash];
    [_bottomItemsView addSubview:_btnPhoto];
    [_bottomItemsView addSubview:_btnMyQR];   
    
}

//启动设备
- (void)startScan
{
    if ( ![LBXScanWrapper isGetCameraPermission] )
    {
        [_qRScanView stopDeviceReadying];
        
        [self showError:@"   请到设置隐私中开启本程序相机权限   "];
        return;
    }
    
  
    
    if (!_scanObj )
    {
        __weak __typeof(self) weakSelf = self;
         // AVMetadataObjectTypeQRCode   AVMetadataObjectTypeEAN13Code
//        self.scanObj = [[LBXScanWrapper alloc]initWithPreView:self.view
//                                              ArrayObjectType:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code]
//                                                      success:^(NSArray<LBXScanResult *> *array){
//                            [weakSelf scanResultWithArray:array];
//        }];
        self.scanObj = [[LBXScanWrapper alloc]initWithPreView:self.view
                                              ArrayObjectType:nil
                                                      success:^(NSArray<LBXScanResult *> *array){
                                                          [weakSelf scanResultWithArray:array];
                                                      }];
    }
    [_scanObj startScan];


    [_qRScanView stopDeviceReadying];
    
    [_qRScanView startScanAnimation];
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [_scanObj stopScan];
    [_qRScanView stopScanAnimation];
}


- (void)showError:(NSString*)str
{
    [LBXAlertAction showAlertWithTitle:@"提示" msg:str chooseBlock:nil buttonsStatement:@"知道了",nil];
}

- (void)openLocalPhotoAlbum
{
    if ([LBXScanWrapper isGetPhotoPermission])
    {
        [self openLocalPhoto];
    }
    else
        [self showError:@"      请到设置->隐私中开启本程序相册权限     "];
}


- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    NSLog(@"%lu",(unsigned long)array.count);
    if (array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
     
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        NSLog(@"scanResult:%@",result.strScanned);
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //震动提醒
    //[LBXScanWrapper systemVibrate];
    //声音提醒
    //[LBXScanWrapper systemSound];
    
    
    //[self popAlertMsgWithScanResult:strResult];
    
    [self showNextVCWithScanResult:scanResult];
   
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"识别失败";
    }
    
    __weak __typeof(self) weakSelf = self;
    
    [LBXAlertAction showAlertWithTitle:@"扫码内容" msg:strResult chooseBlock:^(NSInteger buttonIdx) {
        
        //点击完，继续扫码
        [weakSelf.scanObj startScan];
    } buttonsStatement:@"知道了",nil];
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    
    //_user_id=strResult.strScanned;
   // vc.strCodeType = strResult.strBarCodeType;
    NSLog(@"111%@ -222%@ -333%@",strResult.imgScanned,strResult.strBarCodeType,strResult.strScanned);
    [self isPureInt:_user_id];
    if([strResult.strScanned rangeOfString:@"http://www.bolohr.com/d/open.html?"].location !=NSNotFound)
    {
        NSURL *url=[NSURL URLWithString:strResult.strScanned];
       [[NSNotificationCenter defaultCenter] postNotificationName:@"URLOPEN" object:url];
        
    }else{
        urlStr=[NSString stringWithFormat:@"%@",strResult.strScanned];
        [self webLayout];
        NSLog(@"%@",urlStr);
    }
    
   
}

#pragma mark －－－－－－－－－webView相关
-(void)webLayout
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [layoutView removeFromSuperview];
    layoutView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
    layoutView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:layoutView];
    
    [myWebView removeFromSuperview];
    myWebView= [[UIWebView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
    myWebView.delegate=self;
    //self.meWebView.hidden=YES;
    myWebView.scrollView.delegate=self;
    [layoutView addSubview:myWebView];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlStr]];
    //NSLog(@"gourl  =  %@",_imgurl);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
    
    UIButton *liftButton=[[UIButton alloc]initWithFrame:FRAME(10, 20, 50, 30)];
    //liftButton.backgroundColor=[UIColor blackColor];
    [liftButton addTarget:self action:@selector(liftWebButAction) forControlEvents:UIControlEventTouchUpInside];
    [layoutView addSubview:liftButton];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:FRAME(18, 5, 10, 20)];
    image.image = [UIImage imageNamed:@"title_left_back"];
    [liftButton addSubview:image];
    
    webTitleLabel=[[UILabel alloc]initWithFrame:FRAME(60, 20, WIDTH-120, 30)];
    webTitleLabel.textAlignment=NSTextAlignmentCenter;
    webTitleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    [layoutView addSubview:webTitleLabel];
    
    UIButton *rightButton=[[UIButton alloc]initWithFrame:FRAME(WIDTH-60, 20, 50, 30)];
    //rightButton.backgroundColor=[UIColor blackColor];
    [rightButton addTarget:self action:@selector(rightButAction) forControlEvents:UIControlEventTouchUpInside];
    [layoutView addSubview:rightButton];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(10, 0, 30, 30)];
    img.image = [UIImage imageNamed:@"WEB_QX"];
    [rightButton addSubview:img];
}
-(void)rightButAction
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [layoutView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)liftWebButAction
{
    if([myWebView canGoBack])
    {
        [myWebView goBack];
    }else{
        [layoutView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [webActivityView removeFromSuperview];
    webActivityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    webActivityView.center = CGPointMake(WIDTH/2, HEIGHT/2);
    webActivityView.color = [UIColor redColor];
    [webActivityView startAnimating];
    [myWebView addSubview:webActivityView];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webActivityView stopAnimating]; // 结束旋转
    [webActivityView setHidesWhenStopped:YES]; //当旋转结束时隐藏
    webTitleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark －－－－－－－－－webView相关

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
#pragma mark -底部功能项
//打开相册
- (void)openPhoto
{
    [self openLocalPhoto];
}

//开关闪光灯
- (void)openOrCloseFlash
{
    [_scanObj openOrCloseFlash];
    
    self.isOpenFlash =!self.isOpenFlash;
    
    if (self.isOpenFlash)
    {
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    }
    else
    [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
}

- (void)myQRCode
{
    MyQRViewController *vc = [MyQRViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --打开相册并识别图片
+ (UIViewController*)getWindowTopViewController
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

/*!
 *  打开本地照片，选择图片识别
 */
- (void)openLocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
   
    
    picker.allowsEditing = YES;
    
    
    [self presentViewController:picker animated:YES completion:nil];
}



//当选择一张图片后进入这里

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];    
    
    __block UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    __weak __typeof(self) weakSelf = self;
    [LBXScanWrapper recognizeImage:image success:^(NSArray<LBXScanResult *> *array) {
        
        [weakSelf scanResultWithArray:array];
    }];
    
   
    
    //系统自带识别方法
    /*
     CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
     NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
     if (features.count >=1)
     {
     CIQRCodeFeature *feature = [features objectAtIndex:0];
     NSString *scanResult = feature.messageString;
     
     NSLog(@"%@",scanResult);
     }
     */
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"cancel");
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}



@end
