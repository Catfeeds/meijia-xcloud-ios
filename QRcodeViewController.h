//
//  QRcodeViewController.h
//  yxz
//
//  Created by 白玉林 on 15/11/20.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface QRcodeViewController : FatherViewController<AVCaptureMetadataOutputObjectsDelegate>
@property (strong,nonatomic)AVCaptureDevice * device;

@property (strong,nonatomic)AVCaptureDeviceInput * input;

@property (strong,nonatomic)AVCaptureMetadataOutput * output;

@property (strong,nonatomic)AVCaptureSession * session;

@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@end
