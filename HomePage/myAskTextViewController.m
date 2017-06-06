//
//  myAskTextViewController.m
//  yxz
//
//  Created by 白玉林 on 16/6/6.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "myAskTextViewController.h"

@interface myAskTextViewController ()<UITextViewDelegate>
{
    UIScrollView *myScrollView;
    UITextView *myTextView;
    UIView *texView;
    UILabel *numlabel;
    UILabel *subtitieLabel;
    int textViewNum;
    NSString *_textString;
    UILabel *titleLabel;
    UIView *topView;
}
@end

@implementation myAskTextViewController

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int width = keyboardRect.size.width;
    NSLog(@"键盘高度是  %d",height);
    NSLog(@"键盘宽度是  %d",width);
    myTextView.frame=FRAME(0, 0, WIDTH, texView.frame.size.height-height-14);
    numlabel.frame=FRAME(0, myTextView.frame.size.height, WIDTH, 14);
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    myTextView.frame=FRAME(0, 0, WIDTH, texView.frame.size.height-66);
    numlabel.frame=FRAME(0, texView.frame.size.height-14, WIDTH, 14);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.hidden=YES;
    textViewNum=1024;
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    UIButton *liftBut=[[UIButton alloc]initWithFrame:FRAME(0, 20, 60, 44)];
    [liftBut setTitle:@"取消" forState:UIControlStateNormal];
    [liftBut setTitleColor:[UIColor colorWithRed:42/255.0f green:142/255.0f blue:241/255.0f alpha:1] forState:UIControlStateNormal];
    [liftBut addTarget:self action:@selector(liftButAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:liftBut];
    
    UIButton *rightBut=[[UIButton alloc]initWithFrame:FRAME(WIDTH-60, 20, 60, 44)];
    [rightBut setTitle:@"提交" forState:UIControlStateNormal];
    [rightBut setTitleColor:[UIColor colorWithRed:42/255.0f green:142/255.0f blue:241/255.0f alpha:1] forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(rightButAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBut];
    myScrollView=[[UIScrollView alloc]initWithFrame:FRAME(0, 64, WIDTH, HEIGHT-64)];
//    myScrollView.backgroundColor=[UIColor redColor];
    myScrollView.delegate=self;
    [self.view addSubview:myScrollView];
    
    UILabel *label=[[UILabel alloc]init];
    label.text=@"问:";
    label.font=[UIFont fontWithName:@"Heiti SC" size:15];
    [label setNumberOfLines:1];
    [label sizeToFit];
    label.textColor=[UIColor colorWithRed:42/255.0f green:142/255.0f blue:241/255.0f alpha:1];
    label.frame=FRAME(10, 10, label.frame.size.width, 20);
    [myScrollView addSubview:label];
    
    titleLabel=[[UILabel alloc]init];
    titleLabel.text=[NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"title"]];
    titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    UIFont *font=[UIFont fontWithName:@"Heiti SC" size:15];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size = [titleLabel.text boundingRectWithSize:CGSizeMake(WIDTH-label.frame.size.width-15, 42) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    [titleLabel setNumberOfLines:0];
    [titleLabel sizeToFit];
    titleLabel.frame=FRAME(label.frame.size.width+10, 10, WIDTH-label.frame.size.width-15,size.height);
//    titleLabel.backgroundColor=[UIColor whiteColor];
//    NSLog(@"%f",size.height);
    [myScrollView addSubview:titleLabel];
    
    texView=[[UIView alloc]initWithFrame:FRAME(0, 52, WIDTH, myScrollView.frame.size.height-52)];
    texView.backgroundColor=[UIColor whiteColor];
    [myScrollView addSubview:texView];
    [self stringLayout];
    
    myTextView=[[UITextView alloc]initWithFrame:FRAME(0, 0, WIDTH, texView.frame.size.height-14)];
    myTextView.delegate=self;
    myTextView.font=[UIFont fontWithName:@"Heiti SC" size:16];
    [texView addSubview:myTextView];
    subtitieLabel=[[UILabel alloc]initWithFrame:FRAME(5, 10, WIDTH, 20)];
    subtitieLabel.textColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    subtitieLabel.font=[UIFont fontWithName:@"Heiti SC" size:15];
    subtitieLabel.text=@"添加回答";
    [myTextView addSubview:subtitieLabel];
    
    
    
    numlabel=[[UILabel alloc]initWithFrame:FRAME(0, texView.frame.size.height-14, WIDTH, 14)];
    [self stringLayout];
    [texView addSubview:numlabel];
    
    myScrollView.contentSize=CGSizeMake(WIDTH, texView.frame.size.height+texView.frame.origin.y);
    
    
    topView =[[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 25)];
    topView.backgroundColor=[UIColor whiteColor];
    [myTextView setInputAccessoryView:topView];
    UIButton *topBUt=[[UIButton alloc]initWithFrame:FRAME(WIDTH-80, 0, 80, 25)];
    [topBUt addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:topBUt];
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:FRAME(40, 5, 20, 15)];
//    image.backgroundColor=[UIColor redColor];
    image.image=[UIImage imageNamed:@"arrow_xiangxia"];
    [topBUt addSubview:image];
    
    // Do any additional setup after loading the view.
}
-(void)dismissKeyBoard
{
    [myTextView resignFirstResponder];
}
#pragma mark 取消按钮点击
-(void)liftButAction
{
    if (_askVCID==100) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
#pragma mark 提交按钮点击
-(void)rightButAction
{
    if (_textString==nil||_textString==NULL||[_textString isEqualToString:@""]) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(popAlertView) userInfo:nil repeats:NO];
    }else{
        ISLoginManager *_manager = [ISLoginManager shareManager];
        DownloadManager *_download = [[DownloadManager alloc]init];
        NSString *fidStr=[NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"fid"]];
        NSDictionary *dict=@{@"user_id":_manager.telephone,@"fid":fidStr,@"feed_type":@"2",@"comment":_textString};
        [_download requestWithUrl:[NSString stringWithFormat:@"%@",DYNAMIC_COMMENT] dict:dict view:self.view delegate:self finishedSEL:@selector(CommentSuccess:) isPost:YES failedSEL:@selector(CommentFail:)];
    }
    
}
#pragma mark 回答提交成功方法
-(void)CommentSuccess:(id)dataSource
{
    NSLog(@"回答提交成功方法%@",dataSource);
    [self liftButAction];
}
#pragma mark 回答提交失败方法
-(void)CommentFail:(id)dataSource
{
    NSLog(@"回答提交失败方法%@",dataSource);
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==50||alertView.tag==51) {
        
    }else{
        [self.myTimer invalidate];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)popAlertView{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"问题描述不可以为空，请编辑问题描述！" message:nil  delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    alert.tag=199;
    [alert show];
    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:1];
    
}
- (void) dimissAlert:(UIAlertView *)alert {
    if(alert)     {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (range.location>1024)
    {
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"问题描述最多为1024字"  delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
//        alert.tag=50;
//        [alert show];
        textViewNum=0;
        return  NO;
    }
    else
    {
        return YES;
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length==0) {
        subtitieLabel.hidden=NO;
    }else{
        subtitieLabel.hidden=YES;
    }
    if (textView.text.length >1024)
    {
        textView.text = [textView.text substringToIndex:1024];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"答案有点长，控制在1024字内好吗亲？"  delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
        alert.tag=51;
        [alert show];
    }
    _textString=myTextView.text;
    int   existTextNum=(int)[_textString length];
    
    textViewNum=1024-existTextNum;
    [self stringLayout];
}
-(void)stringLayout
{
    NSString *str=[NSString stringWithFormat:@"可输入%d字",textViewNum];
    numlabel.text=str;
    numlabel.font=[UIFont fontWithName:@"Heiti SC" size:12];
    numlabel.textColor=[UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1];
    numlabel.lineBreakMode=NSLineBreakByTruncatingTail;
    numlabel.textAlignment=NSTextAlignmentRight;
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
