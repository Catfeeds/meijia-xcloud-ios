//
//  QRcodeViewController.m
//  yxz
//
//  Created by 白玉林 on 15/11/20.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//
//#import <AVFoundation/AVFoundation.h>
#import "QRcodeViewController.h"
#import "LBXScanViewController.h"
#import <objc/message.h>
@interface QRcodeViewController ()//<AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation QRcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    UIButton *button=[[UIButton alloc]initWithFrame:FRAME(50, 100, WIDTH-100, 40)];
    button.backgroundColor=[UIColor redColor];
    [button addTarget:self action:@selector(butAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
//    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    
//    // Input
//    
//    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
//    
//    // Output
//    
//    _output = [[AVCaptureMetadataOutput alloc]init];
//    
//    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    
//    _session = [[AVCaptureSession alloc]init];
//    
//    [_session setSessionPreset:AVCaptureSessionPresetHigh];
//    
//    if ([_session canAddInput:self.input])
//        
//    {
//        
//        [_session addInput:self.input];
//        
//    }
//    
//    if ([_session canAddOutput:self.output])
//        
//    {
//        
//        [_session addOutput:self.output];
//        
//    }
//    
//    // 条码类型 AVMetadataObjectTypeQRCode
//    
//    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
//    
//    
//    // Preview
//    
//    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
//    
//    _preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
//    
//    _preview.frame =self.view.layer.bounds;
//    
//    [self.view.layer insertSublayer:_preview atIndex:0];
//    
//    
//    // Start
//    
//    [_session startRunning];
//    
//    
//   // 然后实现 AVCaptureMetadataOutputObjectsDelegate
//    
//
//    // Do any additional setup after loading the view.
}
-(void)butAction
{
    NSArray *arrayItems = @[@[@"模拟qq扫码界面",@"qqStyle"]];
    NSArray* array = arrayItems[0];
    NSString *methodName = [array lastObject];
    
    SEL normalSelector = NSSelectorFromString(methodName);
    if ([self respondsToSelector:normalSelector]) {
        
        ((void (*)(id, SEL))objc_msgSend)(self, normalSelector);
    }
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -模仿qq界面
- (void)qqStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //qq里面的线条图片
    UIImage *imgLine = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    style.animationImage = imgLine;
    
    LBXScanViewController *vc = [LBXScanViewController new];
    vc.style = style;
    vc.isQQSimulator = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

//- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
//
//{
//    
//    NSString *stringValue;
//    
//    if ([metadataObjects count] >0)
//        
//    {
//        
//        //停止扫描
//        
//        [_session stopRunning];
//        
//        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
//        
//        stringValue = metadataObject.stringValue;
//        
//        NSLog(@"stringValue  %@",stringValue);
//        
//    }
//    
//    
//}
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
