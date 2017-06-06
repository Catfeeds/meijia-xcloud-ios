//
//  StorageRegisterViewController.m
//  yxz
//
//  Created by 白玉林 on 16/3/31.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "StorageRegisterViewController.h"
#import "AssetsCategoryViewController.h"
#import "AssetsBarCodeViewController.h"
@interface StorageRegisterViewController ()
{
    UIScrollView *myScrollView;
    UILabel *categoryLabel;
    UITextField *nameField;
    UITextField *numberField;
    UITextField *priceField;
    UITextField *standerdField;
    UITextField *numberingField;
    UITextField *positionField;
    NSString *categroyStr;//列别ID
    NSString *nameStr;//产品名称
    NSString *numberStr;//数量
    NSString *priceStr;//单价
    NSString *standerdStr;//规格
    NSString *numberingStr;//编号
    NSString *positionStr;//存放位置
    NSString *barCodeString;//二维码
    AssetsCategoryViewController *assetsVC;
    AssetsBarCodeViewController *barCodeVC;
    int _lastPosition;
    UIView *layoutView;
    
    
}
@end

@implementation StorageRegisterViewController
-(void)viewWillAppear:(BOOL)animated
{
    if (assetsVC.nameStr==nil||assetsVC.nameStr==NULL||[assetsVC.nameStr isEqualToString:@""]) {
        
    }else{
        categroyStr=assetsVC.idsStr;
        categoryLabel.text=assetsVC.nameStr;
    }
    if (barCodeVC.nameString==nil||barCodeVC.nameString==NULL||[barCodeVC.nameString isEqualToString:@""]) {
        
    }else{
        nameField.text=barCodeVC.nameString;
        nameStr=barCodeVC.nameString;
        standerdField.text=barCodeVC.unitStr;
        standerdStr=barCodeVC.unitStr;
        priceField.text=barCodeVC.priceStr;
        priceStr=barCodeVC.priceStr;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    categroyStr=@"";
    nameStr=@"";
    numberStr=@"";
    priceStr=@"";
    standerdStr=@"";
    numberingStr=@"";
    positionStr=@"";
    barCodeString=@"";
    self.navlabel.text=@"入库登记";
    self.backlable.backgroundColor=HEX_TO_UICOLOR(0x11cd6e, 1.0);
    _navlabel.textColor = [UIColor whiteColor];
    self.img.hidden=YES;
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont-p-back"];
    [_backBtn addSubview:img];
    
    myScrollView=[[UIScrollView alloc]initWithFrame:FRAME(0, 64, WIDTH, 51*7)];
    myScrollView.delegate=self;
    myScrollView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:myScrollView];
    layoutView=[[UIView alloc]init];
    [myScrollView addSubview:layoutView];
    [self viewLayout];
    // Do any additional setup after loading the view.
    UIButton *registerBut=[[UIButton alloc]initWithFrame:FRAME(14, HEIGHT-46, WIDTH-28, 41)];
    registerBut.backgroundColor=self.backlable.backgroundColor;
    [registerBut setTitle:@"入库" forState:UIControlStateNormal];
    registerBut.layer.cornerRadius=5;
    registerBut.clipsToBounds=YES;
    [registerBut addTarget:self action:@selector(registerBut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBut];
}
#pragma mark 入库按钮点击方法
-(void)registerBut
{
    
    if (categroyStr==nil||categroyStr==NULL||[categroyStr isEqualToString:@""]) {
        
    }else if (nameStr==nil||nameStr==NULL||[nameStr isEqualToString:@""]){
        
    }else if (numberStr==nil||numberStr==NULL||[numberStr isEqualToString:@""]){
        
    }else if (priceStr==nil||priceStr==NULL||[priceStr isEqualToString:@""]){
        
    }else{
        ISLoginManager *_manager = [ISLoginManager shareManager];
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *company_ID=[NSString stringWithFormat:@"%@",[delegate.globalDic objectForKey:@"company_id"]];
        NSDictionary *_dict = @{@"user_id":_manager.telephone,@"company_id":company_ID,@"asset_type_id":categroyStr,@"name":nameStr,@"total":numberStr,@"price":priceStr,@"barcode":barCodeString,@"unit":standerdStr,@"place":positionStr,@"seq":numberingStr};
        DownloadManager *_download = [[DownloadManager alloc]init];
        [_download requestWithUrl:[NSString stringWithFormat:@"%@",COMPANY_STORAGE_REGISTER] dict:_dict view:self.view delegate:self finishedSEL:@selector(waterOrderSuccess:) isPost:YES failedSEL:@selector(waterOrderFail:)];
    }
    
}
-(void)waterOrderSuccess:(id)source
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)waterOrderFail:(id)source
{
    NSLog(@"%@",source);
}
-(void)viewLayout
{
    NSArray *nameArray=@[@"资产类别:",@"资产名称:",@"数量:",@"单价:",@"规格:",@"编号:",@"存放位置:"];
    for (int i=0; i<nameArray.count; i++) {
        UIButton *button=[[UIButton alloc]initWithFrame:FRAME(0, 51*i, WIDTH, 50)];
        [layoutView addSubview:button];
        UILabel *nameLabel=[[UILabel alloc]init];
        nameLabel.text=[NSString stringWithFormat:@"%@",nameArray[i]];
        nameLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [nameLabel setNumberOfLines:1];
        [nameLabel sizeToFit];
        nameLabel.frame=FRAME(20, 15, nameLabel.frame.size.width, 20);
        [button addSubview:nameLabel];
        UIView *lineView=[[UIView alloc]initWithFrame:FRAME(0, 50+51*i, WIDTH, 1)];
        lineView.backgroundColor=[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
        [layoutView addSubview:lineView];
        switch (i) {
            case 0:
            {
                [button addTarget:self action:@selector(categoryAction) forControlEvents:UIControlEventTouchUpInside];
                categoryLabel=[[UILabel alloc]initWithFrame:FRAME(20+nameLabel.frame.size.width, 15, WIDTH-nameLabel.frame.size.width-60, 20)];
                categoryLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
                categoryLabel.textAlignment=NSTextAlignmentRight;
                [button addSubview:categoryLabel];
                
                UIImageView *timeImg=[[UIImageView alloc]initWithFrame:FRAME(button.frame.size.width-25, (50-15)/2, 15, 15)];
                timeImg.image=[UIImage imageNamed:@"JH_JT_TB_@2x"];
                [button addSubview:timeImg];

            }
                break;
            case 1:
            {
                UIButton *barCodeBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-40, 5, 40, 40)];
                [barCodeBut addTarget:self action:@selector(barCodeAction:) forControlEvents:UIControlEventTouchUpInside];
                [button addSubview:barCodeBut];
                
                UIImageView *barCodeImage=[[UIImageView alloc]initWithFrame:FRAME(10, 10, 20, 20)];
                barCodeImage.image=[UIImage imageNamed:@"iconfont-saotiaoma"];
                [barCodeBut addSubview:barCodeImage];
                nameField=[[UITextField alloc]initWithFrame:FRAME(20+nameLabel.frame.size.width, 15, WIDTH-nameLabel.frame.size.width-60, 20)];
                nameField.delegate=self;
                nameField.textAlignment=NSTextAlignmentRight;
                nameField.placeholder = @"请输入资产名称！";
                nameField.tag=i;
                nameField.font=[UIFont fontWithName:@"Heiti SC" size:13];
                [button addSubview:nameField];

            }
                break;
            case 2:
            {
                numberField=[[UITextField alloc]initWithFrame:FRAME(20+nameLabel.frame.size.width, 15, WIDTH-nameLabel.frame.size.width-40, 20)];
                numberField.delegate=self;
                numberField.textAlignment=NSTextAlignmentRight;
                numberField.placeholder = @"请输入数量！";
                numberField.tag=i;
                numberField.font=[UIFont fontWithName:@"Heiti SC" size:13];
                [button addSubview:numberField];
            }
                break;
            case 3:
            {
                priceField=[[UITextField alloc]initWithFrame:FRAME(20+nameLabel.frame.size.width, 15, WIDTH-nameLabel.frame.size.width-40, 20)];
                priceField.delegate=self;
                priceField.textAlignment=NSTextAlignmentRight;
                priceField.placeholder = @"请输入单价！";
                priceField.tag=i;
                priceField.font=[UIFont fontWithName:@"Heiti SC" size:13];
                [button addSubview:priceField];
            }
                break;
            case 4:
            {
                standerdField=[[UITextField alloc]initWithFrame:FRAME(20+nameLabel.frame.size.width, 15, WIDTH-nameLabel.frame.size.width-40, 20)];
                standerdField.delegate=self;
                standerdField.textAlignment=NSTextAlignmentRight;
                standerdField.placeholder = @"请输入规格！";
                standerdField.tag=i;
                standerdField.font=[UIFont fontWithName:@"Heiti SC" size:13];
                [button addSubview:standerdField];
            }
                break;
            case 5:
            {
                numberingField=[[UITextField alloc]initWithFrame:FRAME(20+nameLabel.frame.size.width, 15, WIDTH-nameLabel.frame.size.width-40, 20)];
                numberingField.delegate=self;
                numberingField.textAlignment=NSTextAlignmentRight;
                numberingField.placeholder = @"请输入编号！";
                numberingField.tag=i;
                numberingField.font=[UIFont fontWithName:@"Heiti SC" size:13];
                [button addSubview:numberingField];
            }
                break;
            case 6:
            {
                positionField=[[UITextField alloc]initWithFrame:FRAME(20+nameLabel.frame.size.width, 15, WIDTH-nameLabel.frame.size.width-40, 20)];
                positionField.delegate=self;
                positionField.textAlignment=NSTextAlignmentRight;
                positionField.placeholder = @"请输入存放位置！";
                positionField.tag=i;
                positionField.font=[UIFont fontWithName:@"Heiti SC" size:13];
                [button addSubview:positionField];
            }
                break;
                
            default:
                break;
        }
    }
    layoutView.frame=FRAME(0, 0, WIDTH, 51*7);
    myScrollView.contentSize=CGSizeMake(WIDTH,layoutView.frame.size.height+1);
}
#pragma mark 资产类别点击方法
-(void)categoryAction
{
    assetsVC=[[AssetsCategoryViewController alloc]init];
    [self.navigationController pushViewController:assetsVC animated:YES];
    
}
#pragma mark 条形码扫描点击方法
-(void)barCodeAction:(UIButton *)button
{
    barCodeVC=[[AssetsBarCodeViewController alloc]init];
    [self.navigationController pushViewController:barCodeVC animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            //            layoutView.frame=FRAME(0, 0, WIDTH, 51*12);
            myScrollView.contentOffset=CGPointMake(0 , 0);
            [UIView commitAnimations];
            
            
            break;
        case 1:
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            //            layoutView.frame=FRAME(0, 0, WIDTH, 51*12);
            myScrollView.contentOffset=CGPointMake(0 , 0);
            [UIView commitAnimations];
            
            break;
        case 4:
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            //            layoutView.frame=FRAME(0, -51, WIDTH, 51*12);
            myScrollView.contentOffset=CGPointMake(0 , 51);
            [UIView commitAnimations];
            
            break;
        case 5:
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            //            layoutView.frame=FRAME(0, -51*2, WIDTH, 51*12);
            myScrollView.contentOffset=CGPointMake(0 , 51*2);
            [UIView commitAnimations];
            
            break;
        case 6:
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            //            layoutView.frame=FRAME(0, -51*2, WIDTH, 51*12);
            myScrollView.contentOffset=CGPointMake(0 , 51*2);
            [UIView commitAnimations];
            
            break;
        default:
            break;
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
            if (nameField.text==nil) {
                nameStr=@"";
            }else{
                nameStr=nameField.text;
            }
            break;
        case 2:
            if (numberField.text==nil) {
                numberStr=@"";
            }else{
                numberStr=numberField.text;
            }
            
            break;
        case 3:
            if (priceField.text==nil) {
                priceStr=@"";
            }else{
                priceStr=textField.text;
            }
            break;
        case 4:
            if (standerdField.text==nil) {
                standerdStr=@"";
            }else{
                standerdStr=standerdField.text;
            }
            break;
        case 5:
            if (numberingField.text==nil) {
                numberingStr=@"";
            }else{
                numberingStr=textField.text;
            }
            break;
        case 6:
            if (positionField.text==nil) {
                positionStr=@"";
            }else{
                positionStr=positionField.text;
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
        [numberField resignFirstResponder];
        [priceField resignFirstResponder];
        [standerdField resignFirstResponder];
        [numberingField resignFirstResponder];
        [positionField resignFirstResponder];
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
