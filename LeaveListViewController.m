//
//  LeaveListViewController.m
//  yxz
//
//  Created by 白玉林 on 16/1/28.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "LeaveListViewController.h"
#import "MYLaunchViewController.h"
#import "MYApprovalViewController.h"

@interface LeaveListViewController ()
{
    UIView *mainView;
    UIView *lineView;
    UIView *tabBarButView;
    UIViewController *currentViewController;
}
@end
MYLaunchViewController *myLaunchViewController;
MYApprovalViewController *myApprovalViewController;
@implementation LeaveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navlabel.text=@"请假审批";
    self.backlable.backgroundColor=HEX_TO_UICOLOR(0x11cd6e, 1.0);
    mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SELF_VIEW_WIDTH, HEIGHT)];
//    mainView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:mainView];
    
    myLaunchViewController=[[MYLaunchViewController alloc]init];
    [self addChildViewController:myLaunchViewController];
    
    myApprovalViewController=[[MYApprovalViewController alloc]init];
    [self addChildViewController:myApprovalViewController];
    
    [mainView addSubview:myLaunchViewController.view];
    currentViewController = myLaunchViewController;
    tabBarButView=[[UIView alloc]initWithFrame:FRAME(0, 64, WIDTH, 42)];
    [self.view addSubview:tabBarButView];
    UIView *verticalView=[[UIView alloc]initWithFrame:FRAME(WIDTH/2-0.5, 0, 1, 41)];
    verticalView.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [tabBarButView addSubview:verticalView];
    UIView *crossView=[[UIView alloc]initWithFrame:FRAME(0, 41, WIDTH, 1)];
    crossView.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [tabBarButView addSubview:crossView];
    
    NSArray *nameArray=@[@"我发起的",@"待我审批的"];
    for (int i=0; i<nameArray.count; i++) {
        UIButton *tabbarBut=[[UIButton alloc]initWithFrame:FRAME((WIDTH/2+0.5)*i, 0, WIDTH/2-0.5, 40)];
        [tabbarBut setTitle:nameArray[i] forState:UIControlStateNormal];
        if(i==0){
            [tabbarBut setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
        }else{
            [tabbarBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        tabbarBut.titleLabel.font=[UIFont fontWithName:@"Arial" size:15];
        [tabbarBut addTarget:self action:@selector(tabBarButton:) forControlEvents:UIControlEventTouchUpInside];
        [tabbarBut setTag:(1000+i)];
        [tabBarButView addSubview:tabbarBut];
        
    }
    lineView=[[UIView alloc]initWithFrame:FRAME(0, 40, WIDTH/2, 2)];
    lineView.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [tabBarButView addSubview:lineView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}
-(void)tabBarButton:(UIButton *)sender
{
    
    if ((currentViewController==myLaunchViewController&&[sender tag]==1000)||(currentViewController==myApprovalViewController&&[sender tag]==1001)) {
        return;
    }
    UIViewController *oldViewController=currentViewController;
    static int currentSelectButtonIndex = 0;
    static int previousSelectButtonIndex=1000;
    currentSelectButtonIndex=(int)sender.tag;
    UIButton *previousBtn=(UIButton *)[self.view viewWithTag:previousSelectButtonIndex];
    [previousBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    previousBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:15];
    UIButton *currentBtn = (UIButton *)[self.view viewWithTag:currentSelectButtonIndex];;
    [currentBtn setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
    currentBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:18];
    previousSelectButtonIndex=currentSelectButtonIndex;
    switch (sender.tag) {
        case 1000:
        {
            [self transitionFromViewController:currentViewController toViewController:myLaunchViewController duration:0.5 options:0 animations:^{
            }  completion:^(BOOL finished) {
                if(finished){
                    
                    currentViewController=myLaunchViewController;
                    
                }else{
                    currentViewController=oldViewController;
                    
                }
                
            }];
        }
            break;
        case 1001:
        {
            [self transitionFromViewController:currentViewController toViewController:myApprovalViewController duration:0.5 options:0 animations:^{
            }  completion:^(BOOL finished) {
                if(finished){
                    currentViewController=myApprovalViewController;
                    
                }else{
                    currentViewController=oldViewController;
                    
                }
                
            }];
        }
            break;
        default:
            break;
    }

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame=FRAME(WIDTH/2*(sender.tag-1000), 40, WIDTH/2, 2);
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
