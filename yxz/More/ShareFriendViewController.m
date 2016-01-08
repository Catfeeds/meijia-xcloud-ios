//
//  ShareFriendViewController.m
//  simi
//
//  Created by 赵中杰 on 14/12/12.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "ShareFriendViewController.h"
#import "AppDelegate.h"
#import "BaiduMobStat.h"
@interface ShareFriendViewController ()

@end

@implementation ShareFriendViewController
-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"分享好友", nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"分享好友", nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navlabel.text = @"分享好友";
    
    [self makeMainView];
}


- (void)makeMainView
{
    UIImageView *_shareview = [[UIImageView alloc]initWithFrame:FRAME((_WIDTH-175)/2, 64+48, 175, 190)];
    [_shareview setImage:IMAGE_NAMED(@"WXicon_@2x")];
    [self.view addSubview:_shareview];
    
    for (int i = 0; i < 2; i ++) {
        
        UILabel *_label = [[UILabel alloc]initWithFrame:FRAME(0, 64+48+190+15+29*i, _WIDTH, 14)];
        _label.font = MYFONT(13.5);
        _label.textAlignment = NSTextAlignmentCenter;
        
        switch (i) {
            case 0:
                _label.textColor = COLOR_VAULE(178.0);
                _label.text = @"朋友圈";
                break;
                
            case 1:
                _label.textColor = COLOR_VAULE(102.0);
                _label.text = @"分享好友获得10个积分";
                break;

            default:
                break;
                
        }
        
        [self.view addSubview:_label];

        
    }
    
    UIButton *_shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.frame = FRAME(14, 64+48+190+15+29+14+41, WIDTH-28, 41);
    _shareBtn.layer.cornerRadius=5;
    [_shareBtn setBackgroundColor:HEX_TO_UICOLOR(TEXT_COLOR, 1.0)];
    [_shareBtn setTitle:@"分 享 好 友" forState:UIControlStateNormal];
    _shareBtn.titleLabel.font = MYBOLD(15);
//    _shareBtn.layer.cornerRadius = 5.0;
    _shareBtn.layer.masksToBounds = YES;
    [_shareBtn addTarget:self action:@selector(ShareToFriend) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shareBtn];
    
    
    
}


#pragma mark 分享好友
- (void)ShareToFriend
{
    AppDelegate *_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [_delegate sendTextContent];
    
    
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
