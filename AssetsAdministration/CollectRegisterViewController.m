//
//  CollectRegisterViewController.m
//  yxz
//
//  Created by 白玉林 on 16/3/31.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "CollectRegisterViewController.h"
#import "CollectCategoryViewController.h"
#import "ConTentViewController.h"
@interface CollectRegisterViewController ()
{
    CollectCategoryViewController *cateVC;
    UITextField *nameField;
    UITextField *mobleField;
    UILabel *purposeLabel;
    NSString *nameString;
    NSString *mobleString;
    NSString *purposeString;
    UIView *collectView;
    UIScrollView *myScrollView;
    UIView *layoutView;
    UIButton *purposeBut;
    UILabel *lineLabel;
    ConTentViewController *viewController;
    int _lastPosition;
    NSArray *collectDataArray;
}
@end

@implementation CollectRegisterViewController
-(void)viewWillAppear:(BOOL)animated
{
    if (viewController.textString==nil||viewController.textString==NULL||[viewController.textString isEqualToString:@""]) {
        
    }else{
        purposeString=viewController.textString;
        purposeLabel.text=purposeString;
    }
//    if (cateVC.collectData.count>0) {
        collectDataArray=cateVC.collectData;
        [self purViewLayout];
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    nameString=@"";
    mobleString=@"";
    purposeString=@"";
    self.navlabel.text=@"领用登记";
    self.backlable.backgroundColor=HEX_TO_UICOLOR(0x11cd6e, 1.0);
    _navlabel.textColor = [UIColor whiteColor];
    self.img.hidden=YES;
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont-p-back"];
    [_backBtn addSubview:img];
    myScrollView=[[UIScrollView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-110)];
    myScrollView.delegate=self;
    [self.view addSubview:myScrollView];
    
    layoutView=[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 51*4)];
    layoutView.backgroundColor=[UIColor whiteColor];
    [myScrollView addSubview:layoutView];
    
    purposeBut=[[UIButton alloc]initWithFrame:FRAME(0, layoutView.frame.size.height-51, WIDTH, 51)];
    [layoutView addSubview:purposeBut];
    lineLabel=[[UILabel alloc]initWithFrame:FRAME(0, layoutView.frame.size.height-1, WIDTH, 1)];
    lineLabel.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    [layoutView addSubview:lineLabel];
    
    UIButton *collectBut=[[UIButton alloc]initWithFrame:FRAME(14, HEIGHT-46, WIDTH-28, 41)];
    collectBut.backgroundColor=self.backlable.backgroundColor;
    [collectBut setTitle:@"领用" forState:UIControlStateNormal];
    [collectBut addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    collectBut.layer.cornerRadius=5;
    collectBut.clipsToBounds=YES;
    [self.view addSubview:collectBut];
    [self viewLayput];
    // Do any additional setup after loading the view.
}
-(void)viewLayput
{
    NSArray *array=@[@"姓名:",@"手机号:",@"领用用品:",@"用途:"];
    for (int i=0; i<array.count; i++) {
        if (i!=3) {
            UIButton *button=[[UIButton alloc]initWithFrame:FRAME(0, 51*i, WIDTH, 50)];
            button.tag=i;
            button.backgroundColor=[UIColor whiteColor];
            [layoutView addSubview:button];
            UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, 50+51*i, WIDTH, 1)];
            lineView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
            [layoutView addSubview:lineView];
            UILabel *label=[[UILabel alloc]init];
            label.text=[NSString stringWithFormat:@"%@",array[i]];
            label.font=[UIFont fontWithName:@"Heiti SC" size:15];
            [label setNumberOfLines:1];
            [label sizeToFit];
            label.frame=FRAME(20, 15, label.frame.size.width, 20);
            [button addSubview:label];
            switch (i) {
                case 0:
                {
                    nameField=[[UITextField alloc]initWithFrame:FRAME(label.frame.size.width+20, 15, WIDTH-label.frame.size.width-40, 20)];
                    nameField.delegate=self;
                    nameField.returnKeyType = UIReturnKeyDone;
                    nameField.textAlignment=NSTextAlignmentRight;
                    nameField.placeholder=@"请输入姓名!";
                    nameField.tag=i;
                    nameField.font=[UIFont fontWithName:@"Heiti SC" size:15];
                    [button addSubview:nameField];
                }
                    break;
                case 1:
                {
                    mobleField=[[UITextField alloc]initWithFrame:FRAME(label.frame.size.width+20, 15, WIDTH-label.frame.size.width-40, 20)];
                    mobleField.delegate=self;
                    mobleField.returnKeyType = UIReturnKeyDone;
                    mobleField.textAlignment=NSTextAlignmentRight;
                    mobleField.placeholder=@"请输手机号!";
                    mobleField.tag=i;
                    mobleField.font=[UIFont fontWithName:@"Heiti SC" size:15];
                    [button addSubview:mobleField];
                }
                    break;
                case 2:
                {
                    [button addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UILabel *textlab=[[UILabel alloc]initWithFrame:FRAME(label.frame.size.width+20, 15, WIDTH-label.frame.size.width-40, 20)];
                    textlab.text=@"点击选择用品";
                    textlab.font=[UIFont fontWithName:@"Heiti SC" size:15];
                    textlab.textColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
                    [button addSubview:textlab];
                    collectView=[[UIView alloc]initWithFrame:FRAME(0, button.frame.size.width+button.frame.origin.y+1, WIDTH, 0)];
                    collectView.backgroundColor=[UIColor redColor];
                    collectView.backgroundColor=[UIColor whiteColor];
                    [myScrollView addSubview:collectView];
                }
                    break;
                default:
                    break;
            }
        }else{
            purposeBut.tag=i;
            purposeBut.frame=FRAME(0, layoutView.frame.size.height-51, WIDTH, 50);
            [purposeBut addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *label=[[UILabel alloc]init];
            label.text=[NSString stringWithFormat:@"%@",array[i]];
            label.font=[UIFont fontWithName:@"Heiti SC" size:15];
            [label setNumberOfLines:1];
            [label sizeToFit];
            label.frame=FRAME(20, 15, label.frame.size.width, 20);
            [purposeBut addSubview:label];
            purposeLabel=[[UILabel alloc]initWithFrame:FRAME(label.frame.size.width+20, 15, WIDTH-label.frame.size.width-40, 20)];
            purposeLabel.textAlignment=NSTextAlignmentRight;
            purposeLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
            [purposeBut addSubview:purposeLabel];

        }

    }
    layoutView.frame=FRAME(0, 0, WIDTH, 51*4+collectView.frame.size.height);
    myScrollView.contentSize=CGSizeMake(WIDTH,layoutView.frame.size.height);
    
}
-(void)purViewLayout
{
    for (int i=0; i<cateVC.collectData.count; i++) {
        NSDictionary *dic=cateVC.collectData[i];
        UIButton *button=[[UIButton alloc]initWithFrame:FRAME(0, 51*i, WIDTH, 50)];
        button.tag=i;
        button.backgroundColor=[UIColor whiteColor];
        [collectView addSubview:button];
        UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, 50+51*i, WIDTH, 1)];
        lineView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
        [collectView addSubview:lineView];
        UILabel *label=[[UILabel alloc]init];
        label.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        label.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [label setNumberOfLines:1];
        [label sizeToFit];
        label.frame=FRAME(20, 15, WIDTH-100, 20);
        [button addSubview:label];
        UILabel *numLabel=[[UILabel alloc]initWithFrame:FRAME(WIDTH-80, 15, 60, 20)];
        numLabel.textAlignment=NSTextAlignmentCenter;
        numLabel.text=[NSString stringWithFormat:@"数量:%@",[dic objectForKey:@"number"]];
        numLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [button addSubview:numLabel];
    }
    collectView.frame=FRAME(0, 51*3, WIDTH, 51*cateVC.collectData.count);
    layoutView.frame=FRAME(0, 0, WIDTH, 51*4+collectView.frame.size.height);
    purposeBut.frame=FRAME(0, layoutView.frame.size.height-51, WIDTH, 50);
    lineLabel.frame=FRAME(0, layoutView.frame.size.height-1, WIDTH, 1);
    myScrollView.contentSize=CGSizeMake(WIDTH,layoutView.frame.size.height);
}
-(void)collectAction:(UIButton *)button
{
    if (button.tag==2) {
        cateVC=[[CollectCategoryViewController alloc]init];
        cateVC.collectArray=collectDataArray;
        [self.navigationController pushViewController:cateVC animated:YES];
    }else{
        viewController=[[ConTentViewController alloc]init];
        viewController.textString=purposeString;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
-(void)buttonAction:(UIButton *)button
{
    if (cateVC.collectData.count>0) {
        if ((nameString==nil&&mobleString==nil)||(nameString==NULL&&mobleString==NULL)||([nameString isEqualToString:@""]&&[mobleString isEqualToString:@""])) {
            UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"姓名和手机号不可同时为空！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tsView show];
        }else{
            ISLoginManager *_manager = [ISLoginManager shareManager];
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cateVC.dataArray options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSString *company_ID=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"company_id"]];
            NSDictionary *_dict = @{@"user_id":_manager.telephone,@"company_id":company_ID,@"asset_json":jsonString,@"name":nameString,@"mobile":mobleString,@"purpose":purposeString};
            DownloadManager *_download = [[DownloadManager alloc]init];
            [_download requestWithUrl:[NSString stringWithFormat:@"%@",COMPANY_COLLECT_REGISTER] dict:_dict view:self.view delegate:self finishedSEL:@selector(waterOrderSuccess:) isPost:YES failedSEL:@selector(waterOrderFail:)];
        }
        
    }else{
        UIAlertView *tsView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"领用用品不可为空，请选择！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [tsView show];

    }

}
-(void)waterOrderSuccess:(id)source
{
    NSLog(@"%@",source);
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)waterOrderFail:(id)source
{
    NSLog(@"%@",source);
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            if (nameField.text==nil) {
                nameString=@"";
            }else{
                nameString=nameField.text;
            }
            break;
        case 1:
            if (mobleField.text==nil) {
                mobleString=@"";
            }else{
                mobleString=mobleField.text;
            }
            
            break;
        default:
            break;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {  // 这个方法是UITextFieldDelegate协议里面的
    NSLog(@"textFieldShouldReturn the keyboard *** %@ ",theTextField.text);
    [theTextField resignFirstResponder]; //这句代码可以隐藏 键盘
    [UIView beginAnimations: @"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    myScrollView.contentOffset=CGPointMake(0 , 0);
    [UIView commitAnimations];
    
    return YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 25) {
        _lastPosition = currentPostion;
        NSLog(@"ScrollUp now");
    }
    else if (_lastPosition - currentPostion > 25)
    {
        UITextField *tex=[[UITextField alloc]init];
        [tex resignFirstResponder]; //这句代码可以隐藏 键盘
        [nameField resignFirstResponder];
        [mobleField resignFirstResponder];
        _lastPosition = currentPostion;
        NSLog(@"ScrollDown now");
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
