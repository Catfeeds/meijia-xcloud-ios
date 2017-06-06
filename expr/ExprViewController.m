//
//  ExprViewController.m
//  yxz
//
//  Created by 白玉林 on 16/5/11.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "ExprViewController.h"
#import "EprSetupViewController.h"
@interface ExprViewController ()
{
    UIView *myTableView;
    NSDictionary *dataArray;
    NSString *carString;

}
@end

@implementation ExprViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled=YES;
    self.img.hidden=YES;
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont-p-back"];
    [_backBtn addSubview:img];
    self.navlabel.text=_titleName;
    _navlabel.textColor = [UIColor whiteColor];
//    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
//    CGRect tmpRect = [self.navlabel.text boundingRectWithSize:CGSizeMake(WIDTH, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil] context:nil];
    self.backlable.backgroundColor=HEX_TO_UICOLOR(0xF7483F, 1.0);
//    self.helpBut.hidden=NO;
//    self.helpBut.frame=FRAME((WIDTH-tmpRect.size.width)/2, 20, tmpRect.size.width+20, 44);
//    UIImageView *image=[[UIImageView alloc]initWithFrame:FRAME(self.helpBut.frame.size.width-20, 12, 20, 20)];
//    image.image=[UIImage imageNamed:@"iconfont_yingyongbangzhu"];
//    [self.helpBut addSubview:image];
    
    UIButton *eyeButton=[[UIButton alloc]initWithFrame:FRAME(14, HEIGHT-46, WIDTH-28, 41)];
    [eyeButton addTarget:self action:@selector(eyeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    eyeButton.backgroundColor=self.backlable.backgroundColor;
    [eyeButton setTitle:@"设置" forState:UIControlStateNormal];
    eyeButton.layer.cornerRadius=5;
    eyeButton.clipsToBounds=YES;
    [self.view addSubview:eyeButton];
    
   
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.navlabel.text];
    [self PLJKLayout];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.navlabel.text];
}
-(void)eyeButtonAction:(UIButton *)button
{
    EprSetupViewController *eprVC=[[EprSetupViewController alloc]init];
    eprVC.teXtFieldName=carString;
    [self.navigationController pushViewController:eprVC animated:YES];
}

-(void)PLJKLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict =@{@"user_id":_manager.telephone};
    NSLog(@"字典数据%@",_dict);
    [_download requestWithUrl:USER_CAR_NEWS dict:_dict view:self.view  delegate:self finishedSEL:@selector(logDowLoadFinish:) isPost:NO failedSEL:@selector(DownFail:)];
}
-(void)logDowLoadFinish:(id)sender
{
    
    NSLog(@"登录后信息：%@",sender);
    NSString *senderString=[NSString stringWithFormat:@"%@",[sender objectForKey:@"data"]];
    if ([senderString isEqualToString:@""]) {
        dataArray=nil;
    }else{
//        NSArray *array=[sender objectForKey:@"data"];
//        if (array.count<10*page) {
//            _hasMore=YES;
//        }else{
//            _hasMore=NO;
//        }
//        if (page==1) {
//            [dataArray removeAllObjects];
//            [dataArray addObjectsFromArray:array];
//        }else{
//            for (int i=0; i<array.count; i++) {
//                if ([dataArray containsObject:array[i]]) {
//                    
//                }else{
//                    [dataArray addObject:array[i]];
//                }
//            }
//            
//        }
        dataArray=[sender objectForKey:@"data"];
        [self viewLayout];
    }
}
-(void)DownFail:(id)sender
{
    NSLog(@"erroe is %@",sender);
}
-(void)viewLayout
{
    [myTableView removeFromSuperview];
    myTableView=[[UIView alloc]initWithFrame:FRAME(0, 64, WIDTH, 91)];
    myTableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:myTableView];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    UILabel *nameLabel=[[UILabel alloc]init];
    nameLabel.text=[NSString stringWithFormat:@"用户名:%@",[delegate.globalDic objectForKey:@"name"]];
    nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    [nameLabel setNumberOfLines:1];
    [nameLabel sizeToFit];
    nameLabel.frame=FRAME(20, 25/2, nameLabel.frame.size.width, 20);
    [myTableView addSubview:nameLabel];
    
    UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, 45, WIDTH, 1)];
    lineView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    [myTableView addSubview:lineView];
    
    UILabel *carlabel=[[UILabel alloc]init];
    carlabel.text=[NSString stringWithFormat:@"车牌号:%@",[dataArray objectForKey:@"car_no"]];
    carString=[NSString stringWithFormat:@"%@",[dataArray objectForKey:@"car_no"]];
    carlabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    [carlabel setNumberOfLines:1];
    [carlabel sizeToFit];
    carlabel.frame=FRAME(20, 46+25/2, carlabel.frame.size.width, 20);
    [myTableView addSubview:carlabel];
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
