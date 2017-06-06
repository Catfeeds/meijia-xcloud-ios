//
//  Application_ListViewController.m
//  yxz
//
//  Created by 白玉林 on 16/7/12.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "Application_ListViewController.h"
#import "ApplyFriendsListViewController.h"
@interface Application_ListViewController ()
{
    UIView *mainView;
    UIViewController *currentViewController;
    UIView *linereadView;
}
@end
ApplyFriendsListViewController * firstViewController;
ApplyFriendsListViewController * memberViewController;
@implementation Application_ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    firstViewController = [[ApplyFriendsListViewController alloc]init];
    firstViewController.listID=1001;
    [self addChildViewController:firstViewController];
    
    
    memberViewController = [[ApplyFriendsListViewController alloc]init];
    memberViewController.listID=1002;
    [self addChildViewController:memberViewController];
    
    mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SELF_VIEW_WIDTH, HEIGHT-49)];
    [self.view addSubview:mainView];
    [mainView addSubview:firstViewController.view];
    currentViewController = firstViewController;
    
    NSArray *nameArray=@[@"好友申请",@"成员申请"];
    for (int i=0; i<nameArray.count; i++) {
        UIButton *button=[[UIButton alloc]initWithFrame:FRAME(0+(WIDTH/2+0.5)*i, 64, WIDTH/2-0.5, 40)];
        button.tag=1000+i;
        if(i==0){
            [button setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1] forState:UIControlStateNormal];
        }
        
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:FRAME(0, 104, WIDTH, 0.5)];
    lineLabel.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    [self.view addSubview:lineLabel];
    linereadView=[[UIView alloc]initWithFrame:FRAME(0, 102, WIDTH/2, 2)];
    linereadView.backgroundColor=[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1];
    [self.view addSubview:linereadView];
    // Do any additional setup after loading the view.
}
-(void)buttonAction:(UIButton *)button
{
    static int currentSelectButtonIndex = 0;
    static int previousSelectButtonIndex=1000;
    currentSelectButtonIndex=(int)button.tag;
    UIButton *previousBtn=(UIButton *)[self.view viewWithTag:previousSelectButtonIndex];
    [previousBtn setTitleColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1] forState:UIControlStateNormal];
    previousBtn.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    UIButton *currentBtn = (UIButton *)[self.view viewWithTag:currentSelectButtonIndex];;
    [currentBtn setTitleColor:[UIColor colorWithRed:232/255.0f green:55/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
    currentBtn.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    previousSelectButtonIndex=currentSelectButtonIndex;
    
    
//    lineImageView.frame=CGRectMake(huang, 48, width, 2);
    
    if ((currentViewController==firstViewController&&[button tag]==1000)||(currentViewController==memberViewController&&[button tag]==1001) ) {
        return;
    }
    UIViewController *oldViewController=currentViewController;
    switch (button.tag) {
        case 1000:
        {
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            linereadView.frame=FRAME(0, 102, WIDTH/2, 2);
            [UIView commitAnimations];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            
            
            [self transitionFromViewController:currentViewController toViewController:firstViewController duration:0.5 options:0 animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    
                    currentViewController=firstViewController;
                    
                }else{
                    currentViewController=oldViewController;
                    
                }
            }];
        }
            break;
        case 1001:
        {
            [UIView beginAnimations: @"Animation" context:nil];
            [UIView setAnimationDuration:0.3];
            linereadView.frame=FRAME(WIDTH/2, 102, WIDTH/2, 2);
            [UIView commitAnimations];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
           
            
            [self transitionFromViewController:currentViewController toViewController:memberViewController duration:0.5 options:0 animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    
                    currentViewController=memberViewController;
                  
                }else{
                    currentViewController=oldViewController;
                    
                }
            }];
            
            
        }
            break;
        default:
            break;
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
