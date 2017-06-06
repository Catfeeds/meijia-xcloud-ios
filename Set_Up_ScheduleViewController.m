//
//  Set_Up_ScheduleViewController.m
//  yxz
//
//  Created by 白玉林 on 16/5/30.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "Set_Up_ScheduleViewController.h"
#import "RemindSetUpPicker.h"
@interface Set_Up_ScheduleViewController ()<RemindSetUpPickerDelegate>
{
    UILabel *myLabel;
    UILabel *myLabel1;
    UILabel *myLabel2;
    UILabel *myLabel3;
    UILabel *myLabel4;
    UIView  *laYoutView;
    RemindSetUpPicker *picker;
    int  buttonIDS;
    NSString *pickerString;
    NSDictionary *remindDic;
    NSArray *nameArray;
}
@end

@implementation Set_Up_ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    buttonIDS=-1;
    UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 20)];
    view.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [self.view addSubview:view];
    self.navlabel.text=@"常用提醒设置";
        [picker removeFromSuperview];
    picker = [[RemindSetUpPicker alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, 220)];
    picker.delegate = self;
    [self.view addSubview:picker];

    [self jsonLayout];
    UIButton *saveBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-60, 27, 50, 30)];
    [saveBut setTitle:@"保存" forState:UIControlStateNormal];
    [saveBut addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:saveBut];
    
    // Do any additional setup after loading the view.
}
-(void)viewLayout
{
    [laYoutView removeFromSuperview];
    laYoutView=[[UIView alloc]initWithFrame:FRAME(0, 64, WIDTH, 51*nameArray.count)];
    laYoutView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:laYoutView];
    for (int i=0; i<nameArray.count; i++) {
        NSDictionary *dic=nameArray[i];
        UIButton *button=[[UIButton alloc]initWithFrame:FRAME(0, 51*i, WIDTH, 51)];
        button.tag=i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [laYoutView addSubview:button];
        
        UIView *lienView=[[UIView alloc]initWithFrame:FRAME(10, 50, WIDTH-20, 1)];
        lienView.backgroundColor=[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
        [button addSubview:lienView];
        
        UILabel *nameLabel=[[UILabel alloc]init];
        nameLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [nameLabel setNumberOfLines:1];
        [nameLabel sizeToFit];
        nameLabel.frame=FRAME(10, 15, nameLabel.frame.size.width, 20);
        [button addSubview:nameLabel];
        UIImageView *bzImage=[[UIImageView alloc]initWithFrame:FRAME(WIDTH-30, (50-15)/2, 15, 15)];
        bzImage.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
        [button addSubview:bzImage];
        int  day=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"alarm_day"]]intValue];
        NSString *myLabelStr;
        if (day==0) {
            myLabelStr=@"不提醒";
        }else if (day==1){
            myLabelStr=@"1天前";
        }else if (day==3){
            myLabelStr=@"3天前";
        }else if (day==7){
            myLabelStr=@"7天前";
        }
        if (i==0) {
            myLabel=[[UILabel alloc]initWithFrame:FRAME(WIDTH-130, 15, 100, 20)];
            myLabel.font=[UIFont fontWithName:@"Heiti SC" size:13];
            myLabel.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
            myLabel.textAlignment=NSTextAlignmentRight;
            myLabel.text=myLabelStr;
            [button addSubview:myLabel];
        }else if (i==1){
            myLabel1=[[UILabel alloc]initWithFrame:FRAME(WIDTH-130, 15, 100, 20)];
            myLabel1.textAlignment=NSTextAlignmentRight;
            myLabel1.font=[UIFont fontWithName:@"Heiti SC" size:13];
            myLabel1.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
            myLabel1.text=myLabelStr;
            [button addSubview:myLabel1];
        }else if (i==2){
            myLabel2=[[UILabel alloc]initWithFrame:FRAME(WIDTH-130, 15, 100, 20)];
            myLabel2.textAlignment=NSTextAlignmentRight;
            myLabel2.font=[UIFont fontWithName:@"Heiti SC" size:13];
            myLabel2.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
            myLabel2.text=myLabelStr;
            [button addSubview:myLabel2];
        }else if (i==3){
            myLabel3=[[UILabel alloc]initWithFrame:FRAME(WIDTH-130, 15, 100, 20)];
            myLabel3.textAlignment=NSTextAlignmentRight;
            myLabel3.font=[UIFont fontWithName:@"Heiti SC" size:13];
            myLabel3.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
            myLabel3.text=myLabelStr;
            [button addSubview:myLabel3];
        }else if (i==4){
            myLabel4=[[UILabel alloc]initWithFrame:FRAME(WIDTH-130, 15, 100, 20)];
            myLabel4.font=[UIFont fontWithName:@"Heiti SC" size:13];
            myLabel4.textAlignment=NSTextAlignmentRight;
            myLabel4.textColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
            myLabel4.text=myLabelStr;
            [button addSubview:myLabel4];
        }
        
        
    }

}
-(void)saveAction
{
    
}
#pragma mark 获取常用提醒接口
-(void)jsonLayout
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *dict=@{@"user_id":_manager.telephone};
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",REMIND_COMMON] dict:dict view:self.view delegate:self finishedSEL:@selector(RemindSuccess:) isPost:NO failedSEL:@selector(RemindFail:)];
}
#pragma mark 获取常用提醒接口成功返回
-(void)RemindSuccess:(id)source
{
    NSLog(@"获取常用提醒接口成功返回%@",source);
    nameArray=[source objectForKey:@"data"];
    [self viewLayout];
}
#pragma mark 获取常用提醒接口失败返回
-(void)RemindFail:(id)source
{
    NSLog(@"获取常用提醒接口失败返回%@",source);
}
-(void)buttonAction:(UIButton *)button
{
    switch (button.tag) {
        case 0:
        {
            buttonIDS=0;
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            picker.frame = CGRectMake(0, HEIGHT-220, WIDTH, 220);
            [UIView commitAnimations];
        }
            break;
        case 1:
        {
            buttonIDS=1;
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            picker.frame = CGRectMake(0, HEIGHT-220, WIDTH, 220);
            [UIView commitAnimations];
        }
            break;
        case 2:
        {
            buttonIDS=2;
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            picker.frame = CGRectMake(0, HEIGHT-220, WIDTH, 220);
            [UIView commitAnimations];
        }
            break;
        case 3:
        {
            buttonIDS=3;
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            picker.frame = CGRectMake(0, HEIGHT-220, WIDTH, 220);
            [UIView commitAnimations];
        }
            break;
        case 4:
        {
            buttonIDS=4;
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            picker.frame = CGRectMake(0, HEIGHT-220, WIDTH, 220);
            [UIView commitAnimations];
        }
            break;
            
        default:
            break;
    }
}
- (void)suanle
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    picker.frame = CGRectMake(0, HEIGHT, WIDTH, 220);
    [UIView commitAnimations];
}

- (void)hours:(NSString *)hours
{
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    picker.frame = CGRectMake(0, SELF_VIEW_HEIGHT, SELF_VIEW_WIDTH, 220);
    [UIView commitAnimations];
    pickerString=[NSString stringWithFormat:@"%@",hours];
    [self labelLayout];
}
-(void)labelLayout
{
    
    if (buttonIDS==0) {
        myLabel.text=pickerString;
    }else if (buttonIDS==1){
        myLabel1.text=pickerString;
    }else if (buttonIDS==2){
        myLabel2.text=pickerString;
    }else if (buttonIDS==3){
        myLabel3.text=pickerString;
    }else if (buttonIDS==4){
        myLabel4.text=pickerString;
    }
    NSDictionary *dic=nameArray[buttonIDS];
    NSString *string;
    if ([pickerString isEqualToString:@"1天前"]) {
        string=@"1";
    }else if ([pickerString isEqualToString:@"3天前"]){
        string=@"3";
    }else if ([pickerString isEqualToString:@"7天前"]){
        string=@"7";
    }else if ([pickerString isEqualToString:@"不提醒"]){
        string=@"0";
    }
    NSString *set_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"setting_id"]];
    
    ISLoginManager *_manager = [ISLoginManager shareManager];
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *dict=@{@"user_id":_manager.telephone,@"setting_id":set_id,@"alarm_day":string};
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",SETUP_REMIND] dict:dict view:self.view delegate:self finishedSEL:@selector(SetUpSuccess:) isPost:YES failedSEL:@selector(SetUpFail:)];
}
-(void)SetUpSuccess:(id)source
{
    [self jsonLayout];
}
-(void)SetUpFail:(id)source
{
    NSLog(@"%@",source);
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
