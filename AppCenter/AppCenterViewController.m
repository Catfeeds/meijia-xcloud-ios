//
//  AppCenterViewController.m
//  yxz
//
//  Created by 白玉林 on 16/2/24.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "AppCenterViewController.h"
#import "Work_or_ToolViewController.h"
#import "GrowUp_or_MakeMoneyViewController.h"
@interface AppCenterViewController ()
{
    UIView *tabBarView;
    UIView *mainView;
    UIView *lineView;
    UIViewController *currentViewController;
}
@end
Work_or_ToolViewController *work_or_ToolViewController;
GrowUp_or_MakeMoneyViewController *growUp_or_MakeMoneyViewController;
@implementation AppCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backlable.backgroundColor=HEX_TO_UICOLOR(0xbfbfbf, 1.0);
    _navlabel.textColor = [UIColor whiteColor];
    self.img.hidden=YES;
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(18, (40-20)/2, 20, 20)];
    img.image = [UIImage imageNamed:@"iconfont-p-back"];
    [_backBtn addSubview:img];
    self.navlabel.text=@"应用中心";
    mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SELF_VIEW_WIDTH, HEIGHT)];
    mainView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:mainView];
    
    work_or_ToolViewController=[[Work_or_ToolViewController alloc]init];
    [self addChildViewController:work_or_ToolViewController];
    
    growUp_or_MakeMoneyViewController=[[GrowUp_or_MakeMoneyViewController alloc]init];
    [self addChildViewController:growUp_or_MakeMoneyViewController];
    
    [mainView addSubview:work_or_ToolViewController.view];
    currentViewController = work_or_ToolViewController;
    
    tabBarView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 44)];
     tabBarView.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    [self.view addSubview:tabBarView];
    lineView=[[UIView alloc]initWithFrame:FRAME(0, 42, WIDTH/2, 2)];
    lineView.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [tabBarView addSubview:lineView];
    
    UIView *_lineLable = [[UILabel alloc]initWithFrame:FRAME(0, 44, SELF_VIEW_WIDTH, 1)];
    _lineLable.backgroundColor = [UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    //_lineLable.alpha = 0.3;
    [tabBarView addSubview:_lineLable];
    
    UIView *shuView=[[UIView alloc]initWithFrame:FRAME(WIDTH/2-0.5, 2, 1, 40)];
    shuView.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    [tabBarView addSubview:shuView];
    NSArray *nameArray=@[@"工作与工具",@"成长与提升"];
    for (int i=0; i<nameArray.count; i++) {
        UIButton *tabbarBut=[[UIButton alloc]initWithFrame:FRAME((WIDTH/2+0.5)*i, 0, WIDTH/2-0.5, 43)];
        tabbarBut.backgroundColor=[UIColor whiteColor];
        [tabbarBut setTitle:nameArray[i] forState:UIControlStateNormal];
        if(i==0){
            [tabbarBut setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
        }else{
            [tabbarBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        tabbarBut.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [tabbarBut addTarget:self action:@selector(tabBarButton:) forControlEvents:UIControlEventTouchUpInside];
        [tabbarBut setTag:(1000+i)];
        [tabBarView addSubview:tabbarBut];
        
    }

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
-(void)tabBarButton:(UIButton *)sender
{
    if ((currentViewController==work_or_ToolViewController&&[sender tag]==1000)||(currentViewController==growUp_or_MakeMoneyViewController&&[sender tag]==1001)) {
        return;
    }
    UIViewController *oldViewController=currentViewController;
    static int currentSelectButtonIndex = 0;
    static int previousSelectButtonIndex=1000;
    currentSelectButtonIndex=(int)sender.tag;
    UIButton *previousBtn=(UIButton *)[self.view viewWithTag:previousSelectButtonIndex];
    [previousBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    previousBtn.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    UIButton *currentBtn = (UIButton *)[self.view viewWithTag:currentSelectButtonIndex];;
    [currentBtn setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
    currentBtn.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:18];
    previousSelectButtonIndex=currentSelectButtonIndex;
    switch (sender.tag) {
        case 1000:
        {
            [self transitionFromViewController:currentViewController toViewController:work_or_ToolViewController duration:0.5 options:0 animations:^{
            }  completion:^(BOOL finished) {
                if(finished){
                    
                    currentViewController=work_or_ToolViewController;
                    
                }else{
                    currentViewController=oldViewController;
                    
                }
                
            }];
        }
            break;
        case 1001:
        {
            [self transitionFromViewController:currentViewController toViewController:growUp_or_MakeMoneyViewController duration:0.5 options:0 animations:^{
            }  completion:^(BOOL finished) {
                if(finished){
                    currentViewController=growUp_or_MakeMoneyViewController;
                    
                }else{
                    currentViewController=oldViewController;
                    
                }
                
            }];
        }
               default:
            break;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame=FRAME(WIDTH/2*(sender.tag-1000), 42, WIDTH/2, 2);
    [UIView commitAnimations];
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
