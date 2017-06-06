//
//  ScanningViewController.h
//  CXScanning
//
//  Created by artifeng on 16/1/7.
//  Copyright © 2016年 CX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface ScanningViewController : FatherViewController<AVCaptureMetadataOutputObjectsDelegate,NSURLConnectionDataDelegate>
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
@property (strong,nonatomic)NSString *expressStr;
@property(nonatomic ,strong)NSString *express_idStr;
@property (strong,nonatomic)NSString *expressNameStr;


@end
