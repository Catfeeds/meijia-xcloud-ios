//
//  simiViewController.m
//  simi
//
//  Created by 赵中杰 on 14/12/7.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "simiViewController.h"
#import "simiView.h"
#import "HuiYuanCenterController.h"
#import "BuyViewController.h"
#import "BaiduMobStat.h"
@interface simiViewController ()
<
    simiDELEGATE
>

@end

@implementation simiViewController
-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"马上有管家", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"马上有管家", nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    float _height = (_HEIGHT == 480) ? 568 : _HEIGHT;

    self.navlabel.text = @"马上有私秘";
    
    simiView *_myview = [[simiView alloc]initWithFrame:FRAME(0, 0, _WIDTH, _height-64)];
    _myview.delegate = self;
    _myview.backgroundColor = COLOR_VAULE(242.0);
    
    UIScrollView *_myscroll = [[UIScrollView alloc]initWithFrame:FRAME(0, 64, _WIDTH, _HEIGHT-64)];
    if (_HEIGHT == 480) {
        [_myscroll setContentSize:CGSizeMake(_WIDTH, 568-64)];
    }
    [self.view addSubview:_myscroll];
    
    [_myscroll addSubview:_myview];
}

- (void)simiBtnPressedWithName:(NSString *)name
{
    if ([name isEqualToString:@"huiyuanka"]) {
        
        HuiYuanCenterController *_controller = [[HuiYuanCenterController alloc]init];
        [self.navigationController pushViewController:_controller animated:YES];
        
    }else{
        
        BuyViewController *_controller = [[BuyViewController alloc]init];
        _controller.moneystring = @"300";
        [self.navigationController pushViewController:_controller animated:YES];
        
    }
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
