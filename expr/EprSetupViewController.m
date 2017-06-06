//
//  EprSetupViewController.m
//  yxz
//
//  Created by 白玉林 on 16/5/11.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "EprSetupViewController.h"

@interface EprSetupViewController ()
{
    UITextField *carBrandField;
}
@end

@implementation EprSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navlabel.text=@"下单";
    NSArray *titleArray=@[@"用户名:",@"手机号:",@"车牌号:"];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    for (int i=0; i<3; i++) {
        UIView *view=[[UIView alloc]initWithFrame:FRAME(0, 64+61*i, WIDTH, 61)];
        view.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:view];
        
        UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, 60, WIDTH, 1)];
        lineView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
        [view addSubview:lineView];
        UILabel *titleLabel=[[UILabel alloc]init];
        titleLabel.text=[NSString stringWithFormat:@"%@",titleArray[i]];
        titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [titleLabel setNumberOfLines:1];
        [titleLabel sizeToFit];
        titleLabel.frame=FRAME(20, 20, titleLabel.frame.size.width, 20);
        [view addSubview:titleLabel];
        if (i!=2) {
            UILabel *nameLabel=[[UILabel alloc]init];
            nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
            nameLabel.textAlignment=NSTextAlignmentRight;
            nameLabel.frame=FRAME(WIDTH-120, 20, 100, 20);
            [view addSubview:nameLabel];
            if (i==0) {
                nameLabel.text=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"name"]];
            }else{
                nameLabel.text=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"mobile"]];
            }
            
        }else{
            carBrandField=[[UITextField alloc]initWithFrame:FRAME(WIDTH-120, 10, 100, 40)];
            carBrandField.textAlignment=NSTextAlignmentRight;
            if (_teXtFieldName==nil||_teXtFieldName==NULL||[_teXtFieldName isEqualToString:@""]) {
                
            }else{
                carBrandField.text=_teXtFieldName;
            }
            carBrandField.placeholder=@"请输入车牌号";
            carBrandField.delegate=self;
            carBrandField.font=[UIFont fontWithName:@"Heiti SC" size:15];
            [view addSubview:carBrandField];
        }
        
    }
    
    UIButton *eyeButton=[[UIButton alloc]initWithFrame:FRAME(14, HEIGHT-46, WIDTH-28, 41)];
    [eyeButton addTarget:self action:@selector(eyeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    eyeButton.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [eyeButton setTitle:@"提交" forState:UIControlStateNormal];
    eyeButton.layer.cornerRadius=5;
    eyeButton.clipsToBounds=YES;
    [self.view addSubview:eyeButton];
    // Do any additional setup after loading the view.
}

-(void)eyeButtonAction:(UIButton *)button
{
    ISLoginManager *_manager = [ISLoginManager shareManager];
    NSLog(@"有值么%@",_manager.telephone);
    DownloadManager *_download = [[DownloadManager alloc]init];
    NSDictionary *_dict=@{@"user_id":_manager.telephone,@"car_no":carBrandField.text};
    [_download requestWithUrl:USER_CAR_REGISTER dict:_dict view:self.view delegate:self finishedSEL:@selector(carBrandFinish:) isPost:YES failedSEL:@selector(carBrandFail:)];

}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {  // 这个方法是UITextFieldDelegate协议里面的
    NSLog(@"textFieldShouldReturn the keyboard *** %@ ",theTextField.text);
    
    [carBrandField resignFirstResponder]; //这句代码可以隐藏 键盘
   
    return YES;
}
#pragma  mark 车辆登记成功返回
-(void)carBrandFinish:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma  mark 车辆登记失败返回
-(void)carBrandFail:(id)sender
{
    NSLog(@"用户登记车辆失败了 %@",sender);
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
