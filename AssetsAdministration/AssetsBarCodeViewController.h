//
//  AssetsBarCodeViewController.h
//  yxz
//
//  Created by 白玉林 on 16/3/31.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface AssetsBarCodeViewController : FatherViewController<AVCaptureMetadataOutputObjectsDelegate,NSURLConnectionDataDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    sqlite3 *express;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;
@property (strong,nonatomic)NSString *stringValue;
@property (strong,nonatomic)NSString *barcodeStr;
@property(nonatomic ,strong)NSString *nameString;
@property (strong,nonatomic)NSString *unitStr;
@property (strong,nonatomic)NSString *priceStr;
@end
