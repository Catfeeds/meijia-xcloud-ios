/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "ChatViewController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "SRRefreshView.h"
#import "DXChatBarMoreView.h"
#import "DXRecordView.h"
#import "DXFaceView.h"
#import "EMChatViewCell.h"
#import "EMChatTimeCell.h"
#import "ChatSendHelper.h"
#import "MessageReadManager.h"
#import "MessageModelManager.h"
#import "LocationViewController.h"
#import "ChatGroupDetailViewController.h"
#import "UIViewController+HUD.h"
#import "WCAlertView.h"
#import "NSDate+Category.h"
#import "DXMessageToolBar.h"
#import "DXChatBarMoreView.h"
#import "ChatViewController+Category.h"
#import "EMConversation.h"
#import "LoginViewController.h"

#import "FirstViewController.h"
//讯飞
#import "Definition.h"
//#import "UIPlaceHolderTextView.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlyTextUnderstander.h"
#define KPageCount 20

#import "BaojieViewController.h"
#import "SERVICEBaseClass.h"
#import "ZuoFanViewController.h"
#import "XiYiViewController.h"
#import "JiaDianViewController.h"
#import "CaBoliViewController.h"
#import "GuanDaoViewController.h"
#import "XinjuViewController.h"
#import "ListTableViewController.h"
#import "MineViewController.h"
#import "ImgWebViewController.h"
#import "UserDressMapViewController.h"
#import "DownloadManager.h"
#import "ISLoginManager.h"
#import "WeiXinPay.h"
#import "ChatModel.h"
#import "ChatOrderView.h"
#import "SimiOrderDetaileVC.h"
@interface ChatViewController ()<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SRRefreshDelegate, IChatManagerDelegate, DXChatBarMoreViewDelegate, DXMessageToolBarDelegate, LocationViewDelegate, IDeviceManagerDelegate,chatOrderViewDelegate>
{
    UIMenuController *_menuController;
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    NSIndexPath *_longPressIndexPath;
    
    NSInteger _recordingCount;
    
    dispatch_queue_t _messageQueue;
    
    NSMutableArray *_messages;
    BOOL _isScrollToBottom;
    NSString *voice;
    SERVICEBaseClass *_baselass;
    IFlyTextUnderstander * underStand;
    ChatOrderView *orderView ;
    ChatModel *chatmodel;
    
    DXMessageToolBar *dx;
    
    UIButton *voiceButton;
    int voiceId;
}

@property (nonatomic) BOOL isChatGroup;
@property (strong, nonatomic) NSString *chatter;

@property (strong, nonatomic) NSMutableArray *dataSource;//tableView数据源
@property (strong, nonatomic) SRRefreshView *slimeView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DXMessageToolBar *chatToolBar;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) MessageReadManager *messageReadManager;//message阅读的管理者
@property (strong, nonatomic) EMConversation *conversation;//会话管理者
@property (strong, nonatomic) NSDate *chatTagDate;

@property (strong, nonatomic) NSMutableArray *messages;
@property (nonatomic) BOOL isScrollToBottom;
@property (nonatomic) BOOL isPlayingAudio;

@end

@implementation ChatViewController
@synthesize _baseClass;
@synthesize _baojie,_zuofan,_xiyi,_jiadian,_caboli,_guandao,_xinju;
@synthesize baseData;
- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _isPlayingAudio = NO;
        _chatter = chatter;
        _isChatGroup = isGroup;
        _messages = [NSMutableArray array];
        
        //根据接收者的username获取当前会话的管理者
        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter isGroup:_isChatGroup];
        [_conversation markAllMessagesAsRead:YES];
    }
    
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"聊天界面的标题%@",self.title);
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self registerBecomeActive];
    _baselass = [[SERVICEBaseClass alloc]init];
    _baselass = _baseClass;
    underStand = [[IFlyTextUnderstander alloc] init];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    
    #pragma warning 以下三行代码必须写，注册为SDK的ChatManager的delegate
    [[[EaseMob sharedInstance] deviceManager] addDelegate:self onQueue:nil];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    //注册为SDK的ChatManager的delegate
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllMessages:) name:@"RemoveAllMessages" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitGroup) name:@"ExitGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertCallMessage:) name:@"insertCallMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:@"applicationDidEnterBackground" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchRecord) name:@"TOUCHRECORD" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchRecord_jp) name:@"TOUCHRECORD_JP" object:nil];
    
    _messageQueue = dispatch_queue_create("easemob.com", NULL);
    _isScrollToBottom = YES;
    
    [self UserNoreadMessages];

    [self setupBarButtonItem];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.slimeView];
    [self.view addSubview:self.chatToolBar];
//    [self bottomThreeBtn];
    
    //将self注册为chatToolBar的moreView的代理
    if ([self.chatToolBar.moreView isKindOfClass:[DXChatBarMoreView class]]) {
        [(DXChatBarMoreView *)self.chatToolBar.moreView setDelegate:self];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self.view addGestureRecognizer:tap];
    //通过会话管理者获取已收发消息
    [self loadMoreMessages];

    EMConversation *em = [[EMConversation alloc]init];
    
    [em markAllMessagesAsRead:YES];
    
    [self SendMessage:@"私秘为您服务\n你好" to:baseData.imUsername from:_chatter];//给自己发
    
    
    //讯飞
    //创建语音听写的对象
    self.iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    self.iflyRecognizerView.hidden = YES;
    
}
- (void)UserNoreadMessages
{
    ISLoginManager *manger = [[ISLoginManager alloc]init];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:manger.telephone forKey:@"user_id"];
    
    DownloadManager *_download = [[DownloadManager alloc]init];
    [_download requestWithUrl:[NSString stringWithFormat:@"%@",UNREADMESSAGES] dict:dic view:self.view delegate:self finishedSEL:@selector(ReadMessagesFinish:) isPost:YES failedSEL:@selector(DownloadMessagesFail:)];
    
}
- (void)ReadMessagesFinish:(id)dict
{
    NSLog(@"dict: %@",dict);
    
    UIButton *btn = (UIButton *)[self.navigationController.navigationBar viewWithTag:321];
    
    int data = [[dict objectForKey:@"data"] intValue];
    if (data > 0) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:@"66" forKey:@"UNREADMESSAGES"];
        [user synchronize];
        btn.hidden = NO;
        
    }else {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:@"55" forKey:@"UNREADMESSAGES"];
        [user synchronize];
        btn.hidden = YES;
    }
}
- (void)DownloadMessagesFail:(id)error
{
    NSLog(@"error:%@",error);
}
#pragma warning 1.8主要改动
////创建三个按钮
//- (void)bottomThreeBtn
//{
//    voiceButton=[[UIButton alloc]initWithFrame:FRAME(50, 5, WIDTH-100, 36)];
//    [voiceButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    voiceButton.backgroundColor=[UIColor whiteColor];
//    voiceButton.layer.cornerRadius=8;
//    [voiceButton.layer setMasksToBounds:YES];
//    [voiceButton.layer setCornerRadius:7.0]; //设置矩圆角半径
//    [voiceButton.layer setBorderWidth:1.0];   //边框宽度
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
//    [voiceButton.layer setBorderColor:colorref];//边框颜色
//    
//    [voiceButton addTarget:self action:@selector(startRecordAdiou) forControlEvents:UIControlEventTouchDown];
//    [voiceButton addTarget:self action:@selector(stopRecordAdiou) forControlEvents:UIControlEventTouchUpInside];
//    //    [btn addTarget:self action:@selector(recordButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpInside];
//    [voiceButton addTarget:self action:@selector(touchOutsideRecord) forControlEvents:UIControlEventTouchUpOutside];
//    UILabel *label=[[UILabel alloc]initWithFrame:FRAME(0, 0, voiceButton.frame.size.width, voiceButton.frame.size.height)];
//    label.text=@"按住 说话";
//    label.textAlignment=NSTextAlignmentCenter;
//    [voiceButton addSubview:label];
//    [self.chatToolBar addSubview:voiceButton];
//    UILabel *lable = [[UILabel alloc]initWithFrame:FRAME(20, 100, self.view.width-40, 100)];
//    lable.tag = 700;
//    lable.text = @"嗨~~终于等到你！\r我是你的私人小秘哦，\r有事只管吩咐，按住说话就行!";
//    lable.textColor = HEX_TO_UICOLOR(TEXT_COLOR, 1.0);
//    lable.numberOfLines = 0;
//    lable.textAlignment = NSTextAlignmentCenter;
//    lable.font = [UIFont systemFontOfSize:18];
//    [self.tableView addSubview:lable];
//    
//    UIButton *dian = [[UIButton alloc]initWithFrame:FRAME(SELF_VIEW_WIDTH-30, 12, 5, 5)];
//    dian.tag = 321;
//    dian.hidden = YES;
////    [dian setBackgroundColor:YELLOW_COLOR];
//    [dian setBackgroundImage:[UIImage imageNamed:@"dot_@2x"] forState:UIControlStateNormal];
////    [self.navigationController.navigationBar addSubview:dian];
//    
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString *unRead = [user objectForKey:@"UNREADMESSAGES"];
//    if ([unRead isEqualToString:@"66"]) {
//        dian.hidden = NO;
//    }else{
//        dian.hidden = YES;
//    }
//    [user synchronize];
//
//}
- (void)hideLable
{
    UILabel *lab = (UILabel *) [self.view viewWithTag:700];
    lab.hidden = YES;
}
//隐藏三个按钮
- (void)hideThreeBtn:(BOOL)YESorNO
{
    UIButton *centerBtn = (UIButton *) [self.view viewWithTag:600];
    UIButton *leftBtn = (UIButton *) [self.view viewWithTag:601];
    UIButton *rightBtn = (UIButton *) [self.view viewWithTag:602];
    
    centerBtn.hidden = YESorNO;
    leftBtn.hidden = YESorNO;
    rightBtn.hidden = YESorNO;
    
}
#pragma mark tableviw坐标位置|||||||||\\\\\\\\\\||||||||||
- (void)touchRecord
{
    [self hideThreeBtn:NO];
    
    [self.chatToolBar setHidden:NO];
    
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.chatToolBar.frame.size.height-80);

    if (_isScrollToBottom) {
        voiceButton.hidden=NO;
        [self scrollViewToBottom:YES];
    }
    else{
        voiceButton.hidden=YES;
        _isScrollToBottom = YES;
    }
}
- (void)touchRecord_jp
{
    voiceButton.hidden=YES;
}

- (void)leftBtn
{
    self.chatToolBar.hidden = NO;
//    [self.chatToolBar willShowBottomView:nil];
//    self.chatToolBar.height = 46;
    [self hideThreeBtn:YES];
}
- (void)rightBtnAction
{
    ListTableViewController *table = [[ListTableViewController alloc]init];
    [self presentViewController:table animated:YES completion:nil];
}
- (void)startRecordAdiou
{
//    [self.chatToolBar recordButtonTouchDown];
//    DXMessageToolBar *a = [[DXMessageToolBar alloc]init];
//    [a recordButtonTouchDown];
}
- (void)stopRecordAdiou
{
//    [self.chatToolBar recordButtonTouchUpInside];
//    DXMessageToolBar *a = [[DXMessageToolBar alloc]init];
//    [a recordButtonTouchUpInside];
}
- (void)touchOutsideRecord
{
//    [self.chatToolBar recordButtonTouchUpOutside];
}
//自动回复
- (void)SendMessage:(NSString *)message to:(NSString *)to from:(NSString *)from
{
    return;
    
#pragma mark 透传消息
    //透传消息
    EMChatCommand *cmdChat = [[EMChatCommand alloc] init];
    cmdChat.cmd = @"弹出窗口";
    EMCommandMessageBody *body = [[EMCommandMessageBody alloc] initWithChatObject:cmdChat];
    // 生成message

    EMMessage *message1 = [[EMMessage alloc] initWithReceiver:to bodies:@[body]];
    //    message.messageType = eMessageTypeChat;
    message1.from = from;
    message1.ext = @{@"title":@"什么玩意？"};
    
    [self didReceiveCmdMessage:message1];
    
    return;
    
    //文字消息
    EMMessage *jiqiMesssage = [ChatSendHelper sendTextMessageWithString:message toUsername:to isChatGroup:NO requireEncryption:NO ext:nil];
    
    jiqiMesssage.from = from;
//    jiqiMesssage.ext = @{@"title":@"什么玩意？"};
    
//    [self addMessage:jiqiMesssage];
    
    [self didReceiveMessage:jiqiMesssage];
    
}
- (void)setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:FRAME(0, 0, 60, 40)];
    //[backButton setImage:[UIImage imageNamed:@"title_left_back"] forState:UIControlStateNormal];
    UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(0, (40-20)/2,10, 20)];
    img.image = [UIImage imageNamed:@"title_left_back"];
    [backButton addSubview:img];
    //backButton.backgroundColor=[UIColor redColor];
    //[backButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    if (_isChatGroup) {
//        UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
//        [detailButton setImage:[UIImage imageNamed:@"group_detail"] forState:UIControlStateNormal];
//        [detailButton addTarget:self action:@selector(showRoomContact:) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailButton];
    }
    else{
//        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//        [clearButton setImage:[UIImage imageNamed:@"index-cellphone1"] forState:UIControlStateNormal];
//        [clearButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
//        [clearButton addTarget:self action:@selector(removeAllMessages:) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    voiceId=0;
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
    
    if (_isScrollToBottom) {
        [self scrollViewToBottom:YES];
    }
    else{
        _isScrollToBottom = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 设置当前conversation的所有message为已读
    [_conversation markAllMessagesAsRead:YES];
    [[EaseMob sharedInstance].deviceManager disableProximitySensor];
    
    //讯飞
    //终止识别
    [_iflyRecognizerView cancel];
    [_iflyRecognizerView setDelegate:nil];
    
    [super viewWillDisappear:animated];
    
}

- (void)dealloc
{
//    _tableView.delegate = nil;
//    _tableView.dataSource = nil;
//    _tableView = nil;
    
    _slimeView.delegate = nil;
    _slimeView = nil;
    
    _chatToolBar.delegate = nil;
    _chatToolBar = nil;
    
    [[EaseMob sharedInstance].chatManager stopPlayingAudio];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#pragma warning 以下第一行代码必须写，将self从ChatManager的代理中移除
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[[EaseMob sharedInstance] deviceManager] removeDelegate:self];
}

- (void)back
{
    //判断当前会话是否为空，若符合则删除该会话
    EMMessage *message = [_conversation latestMessage];
    if (message == nil) {
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:_conversation.chatter deleteMessages:NO];
    }
    LoginViewController *log = [[LoginViewController alloc]init];
    log.popOrNo = 1;
    [self.navigationController popViewControllerAnimated:YES];
//    MineViewController *mine = [[MineViewController alloc]init];
//    [self.navigationController pushViewController:mine animated:YES];
    
}

#pragma mark - helper
- (NSURL *)convert2Mp4:(NSURL *)movUrl {
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        mp4Url = [movUrl copy];
        mp4Url = [mp4Url URLByDeletingPathExtension];
        mp4Url = [mp4Url URLByAppendingPathExtension:@"mp4"];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    
    return mp4Url;
}

#pragma mark - getter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (SRRefreshView *)slimeView
{
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return _slimeView;
}
#pragma mark   tableView初始化方法$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.chatToolBar.frame.size.height-130) style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = .5;
        [_tableView addGestureRecognizer:lpgr];
    }
    
    return _tableView;
}

- (DXMessageToolBar *)chatToolBar
{
    if (_chatToolBar == nil) {
        _chatToolBar = [[DXMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [DXMessageToolBar defaultHeight], self.view.frame.size.width, [DXMessageToolBar defaultHeight])];
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.backgroundColor = [UIColor whiteColor];
        _chatToolBar.delegate = self;
        
        ChatMoreType type = _isChatGroup == YES ? ChatMoreTypeGroupChat : ChatMoreTypeChat;
        _chatToolBar.moreView = [[DXChatBarMoreView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), _chatToolBar.frame.size.width, 0) typw:type];
        _chatToolBar.moreView.backgroundColor = [UIColor whiteColor];
        _chatToolBar.moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
//        _chatToolBar.height = 120;
//        _chatToolBar.hidden = YES;
    }
    
    return _chatToolBar;
}

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

- (MessageReadManager *)messageReadManager
{
    if (_messageReadManager == nil) {
        _messageReadManager = [MessageReadManager defaultManager];
    }
    
    return _messageReadManager;
}

- (NSDate *)chatTagDate
{
    if (_chatTagDate == nil) {
        _chatTagDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:0];
    }

    return _chatTagDate;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"self.dataSource.count   %lu",(unsigned long)self.dataSource.count);
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSLog(@"dataSource :%@",self.dataSource);
    
    if (indexPath.row < [self.dataSource count]) {
        id obj = [self.dataSource objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[NSString class]]) {
            EMChatTimeCell *timeCell = (EMChatTimeCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageCellTime"];
            if (timeCell == nil) {
                timeCell = [[EMChatTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCellTime"];
                timeCell.backgroundColor = [UIColor clearColor];
                timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            timeCell.textLabel.text = (NSString *)obj;
            
            return timeCell;
        }
        else{
            /*
            
            NSLog(@"model.body:%@",model.messageBody);
            NSDictionary *dic = [self dictionaryWithJsonString:[NSString stringWithFormat:@"%@",model.messageBody]];
            NSString *type = dic[@"type"];
            NSLog(@"type:%@",type);
            */
            
            MessageModel *model = (MessageModel *)obj;
            NSString *cellIdentifier = [EMChatViewCell cellIdentifierForMessageModel:model];
            EMChatViewCell *cell = (EMChatViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            cell.headImageView.image=[UIImage imageNamed:@""];
            if (cell == nil) {
                cell = [[EMChatViewCell alloc] initWithMessageModel:model reuseIdentifier:cellIdentifier];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.messageModel = model;
            
            if (self.dataSource.count != 0) {
                [self hideLable];
            }
            
            return cell;
        }
    }
    
    return nil;
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = [self.dataSource objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        return 20;
    }
    else{
        return [EMChatViewCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:(MessageModel *)obj];
        
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_slimeView) {
        [_slimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_slimeView) {
        [_slimeView scrollViewDidEndDraging];
    }
}

#pragma mark - slimeRefresh delegate
//加载更多
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self loadMoreMessages];
    [_slimeView endRefresh];
}

#pragma mark - GestureRecognizer
// 点击背景隐藏
-(void)keyBoardHidden
{
    [self.chatToolBar endEditing:YES];
//    [self.chatToolBar resignFirstResponder];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
	if (recognizer.state == UIGestureRecognizerStateBegan && [self.dataSource count] > 0) {
        CGPoint location = [recognizer locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:location];
        id object = [self.dataSource objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[MessageModel class]]) {
            EMChatViewCell *cell = (EMChatViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell becomeFirstResponder];
            _longPressIndexPath = indexPath;
            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.messageModel.type];
        }
    }
}

- (void)reloadData{
    self.dataSource = [[self formatMessages:self.messages] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - UIResponder actions
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    MessageModel *model = [userInfo objectForKey:KMESSAGEKEY];
    if ([eventName isEqualToString:kRouterEventTextURLTapEventName]) {
        [self chatTextCellUrlPressed:[userInfo objectForKey:@"url"]];
    }
    else if ([eventName isEqualToString:kRouterEventAudioBubbleTapEventName]) {
        [self chatAudioCellBubblePressed:model];
    }
    else if ([eventName isEqualToString:kRouterEventImageBubbleTapEventName]){
        [self chatImageCellBubblePressed:model];
    }
    else if ([eventName isEqualToString:kRouterEventLocationBubbleTapEventName]){
        [self chatLocationCellBubblePressed:model];
    }
    else if([eventName isEqualToString:kResendButtonTapEventName]){
        EMChatViewCell *resendCell = [userInfo objectForKey:kShouldResendCell];
        MessageModel *messageModel = resendCell.messageModel;
        messageModel.status = eMessageDeliveryState_Delivering;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:resendCell];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
        [chatManager asyncResendMessage:messageModel.message progress:nil];
    }else if([eventName isEqualToString:kRouterEventChatCellVideoTapEventName]){
        [self chatVideoCellPressed:model];
    }
}
//链接被点击
- (void)chatTextCellUrlPressed:(NSURL *)url
{
    if (url) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

// 语音的bubble被点击
-(void)chatAudioCellBubblePressed:(MessageModel *)model
{
    id <IEMFileMessageBody> body = [model.message.messageBodies firstObject];
    EMAttachmentDownloadStatus downloadStatus = [body attachmentDownloadStatus];
    if (downloadStatus == EMAttachmentDownloading) {
        [self showHint:NSLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
        return;
    }
    else if (downloadStatus == EMAttachmentDownloadFailure)
    {
        [self showHint:NSLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
        [[EaseMob sharedInstance].chatManager asyncFetchMessage:model.message progress:nil];
        
        return;
    }
    
    // 播放音频
    if (model.type == eMessageBodyType_Voice) {
        __weak ChatViewController *weakSelf = self;
        BOOL isPrepare = [self.messageReadManager prepareMessageAudioModel:model updateViewCompletion:^(MessageModel *prevAudioModel, MessageModel *currentAudioModel) {
            if (prevAudioModel || currentAudioModel) {
                [weakSelf.tableView reloadData];
            }
        }];
        
        if (isPrepare) {
            _isPlayingAudio = YES;
            __weak ChatViewController *weakSelf = self;
            [[[EaseMob sharedInstance] deviceManager] enableProximitySensor];
            [[EaseMob sharedInstance].chatManager asyncPlayAudio:model.chatVoice completion:^(EMError *error) {
                [weakSelf.messageReadManager stopMessageAudioModel];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    
                    weakSelf.isPlayingAudio = NO;
                    [[[EaseMob sharedInstance] deviceManager] disableProximitySensor];
                });
            } onQueue:nil];
        }
        else{
            _isPlayingAudio = NO;
        }
    }
}

// 位置的bubble被点击
-(void)chatLocationCellBubblePressed:(MessageModel *)model
{
    _isScrollToBottom = NO;
    LocationViewController *locationController = [[LocationViewController alloc] initWithLocation:CLLocationCoordinate2DMake(model.latitude, model.longitude)];
    [self.navigationController pushViewController:locationController animated:YES];
}

- (void)chatVideoCellPressed:(MessageModel *)model{
    __weak ChatViewController *weakSelf = self;
    id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
    [weakSelf showHudInView:weakSelf.view hint:NSLocalizedString(@"message.downloadingVideo", @"downloading video...")];
    [chatManager asyncFetchMessage:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
        [weakSelf hideHud];
        if (!error) {
            NSString *localPath = aMessage == nil ? model.localPath : [[aMessage.messageBodies firstObject] localPath];
            if (localPath && localPath.length > 0) {
                [weakSelf playVideoWithVideoPath:localPath];
            }
        }else{
            [weakSelf showHint:NSLocalizedString(@"message.videoFail", @"video for failure!")];
        }
    } onQueue:nil];
}

- (void)playVideoWithVideoPath:(NSString *)videoPath
{
    _isScrollToBottom = NO;
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [moviePlayerController.moviePlayer prepareToPlay];
    moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
}

// 图片的bubble被点击
-(void)chatImageCellBubblePressed:(MessageModel *)model
{
    __weak ChatViewController *weakSelf = self;
    id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
    if ([model.messageBody messageBodyType] == eMessageBodyType_Image) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)model.messageBody;
        if (imageBody.thumbnailDownloadStatus == EMAttachmentDownloadSuccessed) {
            [weakSelf showHudInView:weakSelf.view hint:NSLocalizedString(@"message.downloadingImage", @"downloading a image...")];
            [chatManager asyncFetchMessage:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                [weakSelf hideHud];
                if (!error) {
                    NSString *localPath = aMessage == nil ? model.localPath : [[aMessage.messageBodies firstObject] localPath];
                    if (localPath && localPath.length > 0) {
                        NSURL *url = [NSURL fileURLWithPath:localPath];
                        weakSelf.isScrollToBottom = NO;
                        [weakSelf.messageReadManager showBrowserWithImages:@[url]];
                        return ;
                    }
                }
                [weakSelf showHint:NSLocalizedString(@"message.imageFail", @"image for failure!")];
            } onQueue:nil];
        }else{
            //获取缩略图
            [chatManager asyncFetchMessageThumbnail:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                if (!error) {
                    [weakSelf reloadTableViewDataWithMessage:model.message];
                }else{
                    [weakSelf showHint:NSLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
                }
                
            } onQueue:nil];
        }
    }else if ([model.messageBody messageBodyType] == eMessageBodyType_Video) {
        //获取缩略图
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)model.messageBody;
        if (videoBody.thumbnailDownloadStatus != EMAttachmentDownloadSuccessed) {
            [chatManager asyncFetchMessageThumbnail:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                if (!error) {
                    [weakSelf reloadTableViewDataWithMessage:model.message];
                }else{
                    [weakSelf showHint:NSLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
                }
            } onQueue:nil];
        }
    }
}

#pragma mark - IChatManagerDelegate

-(void)didSendMessage:(EMMessage *)message error:(EMError *)error;
{
    [self reloadTableViewDataWithMessage:message];
//    [self scrollViewToBottom:YES];
}

- (void)reloadTableViewDataWithMessage:(EMMessage *)message{
    __weak ChatViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        if ([weakSelf.conversation.chatter isEqualToString:message.conversationChatter])
        {
            for (int i = 0; i < weakSelf.dataSource.count; i ++) {
                id object = [weakSelf.dataSource objectAtIndex:i];
                if ([object isKindOfClass:[MessageModel class]]) {
                    EMMessage *currMsg = [weakSelf.dataSource objectAtIndex:i];
                    if ([message.messageId isEqualToString:currMsg.messageId]) {
                        MessageModel *cellModel = [MessageModelManager modelWithMessage:message];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.tableView beginUpdates];
                            [weakSelf.dataSource replaceObjectAtIndex:i withObject:cellModel];
                            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                            [weakSelf.tableView endUpdates];
                            
                            
                        });
                        
                        break;
                    }
                }
            }
        }
    });
}

- (void)didMessageAttachmentsStatusChanged:(EMMessage *)message error:(EMError *)error{
    if (!error) {
        id<IEMFileMessageBody>fileBody = (id<IEMFileMessageBody>)[message.messageBodies firstObject];
        if ([fileBody messageBodyType] == eMessageBodyType_Image) {
            EMImageMessageBody *imageBody = (EMImageMessageBody *)fileBody;
            if ([imageBody thumbnailDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }else if([fileBody messageBodyType] == eMessageBodyType_Video){
            EMVideoMessageBody *videoBody = (EMVideoMessageBody *)fileBody;
            if ([videoBody thumbnailDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }else if([fileBody messageBodyType] == eMessageBodyType_Voice){
            if ([fileBody attachmentDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }
        
    }else{
        
    }
}

- (void)didFetchingMessageAttachments:(EMMessage *)message progress:(float)progress{
    NSLog(@"didFetchingMessageAttachment: %f", progress);
}

-(void)didReceiveMessage:(EMMessage *)message
{
    
    //将收到的消息解析出来
    
    NSLog(@"bodies: %@ message: %@",message.messageBodies,message);
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = [self dictionaryWithJsonString:[NSString stringWithFormat:@"%@",message]];
    NSArray *arr = [[NSArray alloc]init];
    arr = [dic objectForKey:@"bodies"];
    
    NSString *str = [arr objectAtIndex:0];
    NSDictionary *dic2 = [[NSDictionary alloc]init];
    dic2 = [self dictionaryWithJsonString:str];
    
    NSString *reviceMessage = [dic2 objectForKey:@"msg"];
    NSLog(@"收到消息为：%@",reviceMessage);
    
    //扩展消息
    NSDictionary *extdic = [[NSDictionary alloc]init];
    extdic = [dic objectForKey:@"ext"];
    NSString *title = [extdic objectForKey:@"title"];
    NSLog(@"扩展消息：%@",title);
    
    if([reviceMessage isEqualToString:@"私秘为您服务"]){
        //        [self.dataSource removeLastObject];
        //        [self.tableView deleteRowsAtIndexPaths:self.dataSource.count-1 withRowAnimation:UITableViewRowAnimationFade];
        
//        [self deleteLastMessage];
//        EMConversation *em = [[EMConversation alloc]init];
//        
//      BOOL a =  [em removeMessage:message];
//        BOOL b = [em removeMessageWithId:@"63177931647615464_14d7a375e33"];

        return;
    }

    
//    NSLog(@"type : %@",[[message.messageBodies objectAtIndex:0] objectForKey:@"type"]);
//    NSLog(@"message: %@",message.messageBodies);//数组里一个字典  字典里 msg对应的消息

    if ([_conversation.chatter isEqualToString:message.conversationChatter]) {
        
        [_messages addObject:message];
        [self addMessage:message];
        
    }
    
    
    
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
#pragma mark 收到透传消息
-(void)didReceiveCmdMessage:(EMMessage *)message
{
    
    //将收到的消息解析出来
    
    NSLog(@"bodies: %@ message: %@",message.messageBodies,message);
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = [self dictionaryWithJsonString:[NSString stringWithFormat:@"%@",message]];
    NSArray *arr = [[NSArray alloc]init];
    arr = [dic objectForKey:@"bodies"];
    
    NSDictionary *dic2 = [[NSDictionary alloc]init];
    dic2 = [self dictionaryWithJsonString:[NSString stringWithFormat:@"%@",[arr objectAtIndex:0]]];
    NSString *cmdAction = dic2[@"action"];
    NSLog(@"cmdAction:%@",cmdAction);
    
    //扩展消息
    NSDictionary *extdic = [[NSDictionary alloc]init];
    extdic = [dic objectForKey:@"ext"];
//    NSString *title = [extdic objectForKey:@"title"];
//    NSLog(@"扩展消息：%@",title);
    
    [self AddOrderViewWith:extdic];
//    if ([_conversation.chatter isEqualToString:message.conversationChatter]) {
//        [self showHint:NSLocalizedString(@"receiveCmd", @"receive cmd message")];
//    }
}
- (void)AddOrderViewWith:(NSDictionary *)dic
{
    chatmodel = [[ChatModel alloc]initWithDictionary:dic];
    
    orderView = [[ChatOrderView alloc]initWithFrame:FRAME(10, 0, SELF_VIEW_WIDTH-20, SELF_VIEW_HEIGHT-20) withModel:chatmodel];
    orderView.delegate = self;
    
    UIView *zhezhao = [[UIView alloc]initWithFrame:FRAME(0, 0, SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT)];
    zhezhao.tag = 989;
    zhezhao.backgroundColor = [UIColor blackColor];
    zhezhao.alpha = 0.5;
    
    [self.view addSubview:zhezhao];
    
    [self.view addSubview:orderView];

}
- (void)PressBtnwithBtnTitle:(NSString *)btnTitle
{
    UIView *view = (UIView *)[self.view viewWithTag:989];
    [view removeFromSuperview];
    orderView.hidden = YES;
    
    if ([btnTitle isEqualToString:@"确认"]) {
        NSLog(@"确认");
        
        SimiOrderDetaileVC *orderViewDetail = [[SimiOrderDetaileVC alloc]init];
        orderViewDetail.orderNo = chatmodel.order_no;
//        orderViewDetail.orderNo = @"613258386779144192";
        [self.navigationController pushViewController:orderViewDetail animated:YES];
        
    }else if([btnTitle isEqualToString:@"确认-支付"])
    {
        NSLog(@"确认-支付");
        SimiOrderDetaileVC *orderViewDetail = [[SimiOrderDetaileVC alloc]init];
                orderViewDetail.orderNo = chatmodel.order_no;
//        orderViewDetail.orderNo = @"613258386779144192";
        [self.navigationController pushViewController:orderViewDetail animated:YES];
        
    }else{
        
        NSLog(@"取消");

    }

}
- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self loadMoreMessages];
}

- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
{
    if (_isChatGroup && [group.groupId isEqualToString:_chatter]) {
        [self.navigationController popToViewController:self animated:NO];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)didInterruptionRecordAudio
{
    [_chatToolBar cancelTouchRecord];
    
    // 设置当前conversation的所有message为已读
    [_conversation markAllMessagesAsRead:YES];
    
    [self stopAudioPlaying];
}

#pragma mark - EMChatBarMoreViewDelegate

- (void)moreViewPhotoAction:(DXChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self keyBoardHidden];
    
    // 弹出照片选择
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}

- (void)moreViewTakePicAction:(DXChatBarMoreView *)moreView
{
    [self keyBoardHidden];
    
#if TARGET_IPHONE_SIMULATOR
    [self showHint:NSLocalizedString(@"message.simulatorNotSupportCamera", @"simulator does not support taking picture")];
#elif TARGET_OS_IPHONE
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
#endif
}

- (void)moreViewLocationAction:(DXChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self keyBoardHidden];
    
    LocationViewController *locationController = [[LocationViewController alloc] initWithNibName:nil bundle:nil];
    locationController.delegate = self;
    [self.navigationController pushViewController:locationController animated:YES];
}

- (void)moreViewVideoAction:(DXChatBarMoreView *)moreView{
    [self keyBoardHidden];
    
#if TARGET_IPHONE_SIMULATOR
    [self showHint:NSLocalizedString(@"message.simulatorNotSupportVideo", @"simulator does not support vidio")];
#elif TARGET_OS_IPHONE
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
#endif
}

- (void)moreViewAudioCallAction:(DXChatBarMoreView *)moreView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"callOutWithChatter" object:self.chatter];
    
//    __weak typeof(self) weakSelf = self;
//    if([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)])
//    {
//        //requestRecordPermission
//        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
//            NSLog(@"granted = %d",granted);
//            if(granted)
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"callOutWithChatter" object:weakSelf.chatter];
//                });
//            }
//        }];
//    }
}

#pragma mark - LocationViewDelegate

-(void)sendLocationLatitude:(double)latitude longitude:(double)longitude andAddress:(NSString *)address
{
    EMMessage *locationMessage = [ChatSendHelper sendLocationLatitude:latitude longitude:longitude address:address toUsername:_conversation.chatter isChatGroup:_isChatGroup requireEncryption:NO ext:nil];
    [self addMessage:locationMessage];
}

#pragma mark - DXMessageToolBarDelegate键盘弹出＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView{
    [_menuController setMenuItems:nil];
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.tableView.frame;
        rect.origin.y = 0;
        rect.size.height = self.view.frame.size.height - toHeight;
        self.tableView.frame = rect;
    }];
    [self scrollViewToBottom:YES];
}

- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        [self sendTextMessage:text];
    }
}

/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction:(UIView *)recordView
{

    if ([self canRecord]) {
        DXRecordView *tmpView = (DXRecordView *)recordView;
        tmpView.center = self.view.center;
        [self.view addSubview:tmpView];
        [self.view bringSubviewToFront:recordView];
        
        NSError *error = nil;
        [[EaseMob sharedInstance].chatManager startRecordingAudioWithError:&error];
        if (error) {
            NSLog(NSLocalizedString(@"message.startRecordFail", @"failure to start recording"));
        }
    }
    
    //讯飞
    if ([self canRecord]){
        
        voice = @"";
        [_iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        
        //设置结果数据格式，可设置为json，xml，plain，默认为json。
        [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
        _iflyRecognizerView.delegate = self;
        
        [_iflyRecognizerView start];
        
        NSLog(@"start listenning...");
    }

}
/**
 *  讯飞
 */

/** 识别结果回调方法
 @param resultArray 结果列表
 @param isLast YES 表示最后一个，NO表示后面还有结果
 */
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    
    NSLog(@"result识别结果是！！！！！＝＝＝＝＝＝＝＝＝ : %@",result);
    if (result != nil && ![result isEqualToString:@""]) {
        voice = result;
        
    }

}

/** 识别结束回调方法
 @param error 识别错误
 */
- (void)onError:(IFlySpeechError *)error
{
    NSLog(@"errorCode:%d",[error errorCode]);
}
/*
 * @ 语义理解
 */
-(void) understandHandler:(NSString *)text
{
    
    NSString *text2;
    if(text != nil){
        text2 = [NSString stringWithFormat:@"%@ 设置闹钟",text];
    }else{
        text2 = nil;
    }
    
    //启动文本语义搜索
    [underStand understandText:text2 withCompletionHandler:^(NSString* restult, IFlySpeechError* error)
     {
         NSLog(@"result is : %@",restult);
         
         //语义抽取
         if(restult != nil){
             NSData *jsonData = [restult dataUsingEncoding:NSUTF8StringEncoding];
             NSError *err;
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
             NSString *date = [[[[dic objectForKey:@"semantic"] objectForKey:@"slots"] objectForKey:@"datetime"] objectForKey:@"date"];
             NSString *time = [[[[dic objectForKey:@"semantic"] objectForKey:@"slots"] objectForKey:@"datetime"] objectForKey:@"time"];
             NSString *title = [[[dic objectForKey:@"semantic"] objectForKey:@"slots"] objectForKey:@"content"];
             
             NSInteger todayDate = [self compareDate:date];//-1：大于当前日期   0：当天   1:小于当前日期
             NSInteger hour = [self getHour]; //现在是几点
             NSInteger minute = [self getMinute]; //现在是几分钟
             NSInteger xiadanHour = [[time substringToIndex:2] integerValue]; //他下的几点的单子
             xiadanHour = (xiadanHour == 24)? 0 : xiadanHour;
             NSInteger xiadanMinute = [[time substringWithRange:NSMakeRange(3, 2)] integerValue]; //他下的是几分钟的单子
//             NSRange range666 = [@"保洁做饭洗衣家电清洗擦玻璃管道疏通新剧开荒" rangeOfString:title];
             NSRange rang = [title rangeOfString:@"保洁"];
             NSRange range1 = [title rangeOfString:@"做饭"];
             NSRange range2 = [title rangeOfString:@"擦玻璃"];
             NSRange range3 = [title rangeOfString:@"管道疏通"];
             NSRange range4 = [title rangeOfString:@"新居开荒"];
//             NSInteger zuizaoHour = hour - 4;
//             NSRange range = [@"保洁做饭洗衣家电清洗擦玻璃管道疏通新居开荒" rangeOfString:title];
             if(date != nil && time != nil){
              
                 BOOL thirty = YES;
                 thirty = [self CompareThirtyDateWithDate:date];
                 if (thirty == NO) {
                     if (rang.location != NSNotFound ||range1.location != NSNotFound ||range2.location != NSNotFound ||range3.location != NSNotFound ||range4.location != NSNotFound ) {
                         [self SendMessage:@"时间太久了" to:baseData.imUsername from:_chatter];
                         return ;
                     }
                     
                 }
                 
                 if (xiadanMinute <= 30 && xiadanMinute > 0 ) {
                     time = [NSString stringWithFormat:@"%ld:30",(long)xiadanHour];
                 }else if (xiadanMinute >30){
                     //                 xiadanHour = [[time substringToIndex:2] integerValue]+1;
                     time = [NSString stringWithFormat:@"%li:00",xiadanHour+1];
                     
                 }
                 
                 if (todayDate == 1) {
                     [self SendMessage:@"换个时间试试" to:baseData.imUsername from:_chatter];
                     return ;
                     
                 }
                 if (todayDate == 0 ) {
                     
                     
                     NSLog(@"%li",(long)xiadanHour);
                     if (hour >= 0 && hour < 8) {  //大于0点小于8点 只能下12点到晚上20点的单子
                         if(xiadanHour < 12||xiadanHour > 20){
                             [self SendMessage:@"换个时间试试" to:baseData.imUsername from:_chatter];
                             return;
                         }
                     }
                     
                     if (hour >= 8 && hour < 16) {  //需要判断分钟
                         
                         if (xiadanHour < hour+4 && xiadanHour <=20) {
                             
                             [self SendMessage:@"换个时间试试" to:baseData.imUsername from:_chatter];
                             return;
                         }
                         if (xiadanHour == hour+4) {
                             if (xiadanMinute < minute) {
                                 [self SendMessage:@"换个时间试试" to:baseData.imUsername from:_chatter];
                                 return;
                             }
                         }
                         if (xiadanHour == 20) {
                             if (xiadanMinute != 0) {
                                 [self SendMessage:@"换个时间试试" to:baseData.imUsername from:_chatter];
                                 return;
                             }
                         }
                     }
                     if (hour >= 16) {
                         [self SendMessage:@"换个时间试试" to:baseData.imUsername from:_chatter];
                         return;
                     }
                 }
                 if([date isEqualToString:[self tomorrow]]){
                     NSLog(@"明天");
                     if(hour >= 18){
                         if (xiadanHour < 12) {
                             [self SendMessage:@"换个时间试试" to:baseData.imUsername from:_chatter];
                             return;
                         }
                     }
                 }

             }
             
             
             if (rang.location != NSNotFound && date != nil && time != nil){
                 BaojieViewController *baojie = [[BaojieViewController alloc]init];
                 baojie.baojieModel = _baojie;
                 baojie.yuyinDate = date;
                 baojie.yuyinTime = time;
                 [self.navigationController pushViewController:baojie animated:YES];
                 return ;
             }
             
             if (range1.location != NSNotFound && date != nil && time != nil){
                 ZuoFanViewController *zuofan = [[ZuoFanViewController alloc]init];
                 zuofan.model = _zuofan;
                 zuofan.yuyinDate = date;
                 zuofan.yuyinTime = time;
                 [self.navigationController pushViewController:zuofan animated:YES];
                 return;
             }
             
             if (range2.location != NSNotFound && date != nil && time != nil){
                 CaBoliViewController *caboli = [[CaBoliViewController alloc]init];
                 caboli.bolimodel = _caboli;
                 caboli.yuyinDate = date;
                 caboli.yuyinTime = time;
                 [self.navigationController pushViewController:caboli animated:YES];
                 return;
             }
             
             if (range3.location != NSNotFound && date != nil && time != nil){
                 GuanDaoViewController *guandao = [[GuanDaoViewController alloc]init];
                 guandao.model = _guandao;
                 guandao.yuyinDate = date;
                 guandao.yuyinTime = time;
                 [self.navigationController pushViewController:guandao animated:YES];
                 return;
             }
             
             if (range4.location != NSNotFound && date != nil && time != nil){
                 XinjuViewController *xinju = [[XinjuViewController alloc]init];
                 xinju.model = _xinju;
                 xinju.yuyinDate = date;
                 xinju.yuyinTime = time;
                 [self.navigationController pushViewController:xinju animated:YES];
                 return;
             }

         }

         [underStand cancel];
         
         NSLog(@"转义完成");

         NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(zhiennghuifu:) object:text];
         [thread start];
         }];

}
/************
 *判断下单时间*
************/
#pragma 判断日期
- (NSInteger )compareDate:(NSString *)str
{
    NSDate *nowDates = [NSDate date];
    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [formatter setTimeZone:timeZone];
    NSString *loctime = [formatter stringFromDate:nowDates];
    NSLog(@"loctime:%@",loctime);
    NSDate *firstDate = [self stringToDate:loctime];
    
    NSDate *secondDate = [self stringToDate:str];
    
    NSComparisonResult result = [firstDate compare:secondDate];
    
    NSLog(@"result: %ld",(long)result);//-1：大于当前日期   0：当天   1:小于当前日期

    return result;
    
}
- (NSDate *) stringToDate:string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:string];
    
    return date;
}
#pragma 获取小时
- (NSInteger )getHour
{
    // 获得本地时间指定时区
    NSDate *nowDates = [NSDate date];
    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [formatter setTimeZone:timeZone];
    NSString *loctime = [formatter stringFromDate:nowDates];
    NSLog(@"loctime:%@",loctime);
    NSDate *firstDate = [self stringToHour:loctime];
    
    NSInteger f = [[formatter stringFromDate:firstDate] intValue];
    NSLog(@"%ld",(long)f);
    
    return f;
}
- (NSDate *) stringToHour:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:string];
    
    return date;
}
#pragma 获取分钟
- (NSInteger )getMinute
{
    // 获得本地时间指定时区
    NSDate *nowDates = [NSDate date];
    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [formatter setTimeZone:timeZone];
    NSString *loctime = [formatter stringFromDate:nowDates];
    NSLog(@"loctime:%@",loctime);

    NSInteger f = [[loctime substringWithRange:NSMakeRange(3, 2)]integerValue];
    NSLog(@"%ld",(long)f);
    
    return f;
}
#pragma 明天  

-  (NSString *)tomorrow
{
    //获取时间
    

    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    

        NSTimeInterval  interval = 24*60*60*(1+0);
        
        NSDate *d = [[NSDate alloc] initWithTimeIntervalSinceNow:+interval];
        
        NSString *  mingtian = [dateformatter stringFromDate:d];

    return mingtian;
    
}
#pragma mark 获取30天后的日期
-  (BOOL )CompareThirtyDateWithDate:(NSString *)xiandandate
{

    

    //30天的日期

    NSTimeInterval  interval = 24*60*60*(30+0);
        
    NSDate *d = [[NSDate alloc] initWithTimeIntervalSinceNow:+interval];
        
    NSDate *a = [self stringToDate:xiandandate];
    
    NSComparisonResult result = [d compare:a];
    
    if (result == 1) { //d > a
        return YES;
    }else if (result == 0){
        return YES;  // d = a
    }else{
        return NO;  // d < a
    }
        
    
    
}
- (void)zhiennghuifu:(NSString *)str
{
    IFlyTextUnderstander *zhineng = [[IFlyTextUnderstander alloc] init];
    [zhineng understandText:str withCompletionHandler:^(NSString* restult, IFlySpeechError* error)
     {
    if (restult != nil) {
        
        NSData *jsonData = [restult dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        NSLog(@"dic//// :%@",dic);
        NSString *answer = [[dic objectForKey:@"answer"] objectForKey:@"text"];
        if (answer != nil) {
            [self SendMessage:answer to:baseData.imUsername from:_chatter];  //给自己发
        }else{
            [self SendMessage:@"没理解您得意思呦" to:baseData.imUsername from:_chatter];   //给自己发
        }

        
        }
        if (error!=nil && error.errorCode!=0) {
             
             NSString* errorText = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
             
             NSLog(@"%@",errorText);
    }
}];
}
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 *  讯飞end
 */


/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction:(UIView *)recordView
{
    [[EaseMob sharedInstance].chatManager asyncCancelRecordingAudioWithCompletion:nil onQueue:nil];
}

/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction:(UIView *)recordView
{
    [[EaseMob sharedInstance].chatManager
     asyncStopRecordingAudioWithCompletion:^(EMChatVoice *aChatVoice, NSError *error){
         if (!error) {
             [self sendAudioMessage:aChatVoice];
             NSLog(@"aChatVoice.displayName: %@",aChatVoice.displayName);
           
             NSLog(@"aChatVoice.path: %@",aChatVoice.localPath);
             
             //是否智能聊天
             int senior = baseData.is_senior;
             if (senior == 0) {
                 //讯飞
                 //终止识别
                 [_iflyRecognizerView cancel];
                 [_iflyRecognizerView setDelegate:nil];
                 if (voice!= nil|| ![voice isEqualToString:@""]) {
                     //
                     //                 NSRange range = [@"保洁做饭洗衣家电清洗擦玻璃管道疏通新剧开荒" rangeOfString:voice];
                     //                 if (range.location != NSNotFound){
                     [self understandHandler:voice];
                     //                 }
                     //                 else{
                     //                     [self zhiennghuifu:voice];
                     //                 }
                }
             }

             
         }else{
             if (error.code == EMErrorAudioRecordNotStarted) {
                 [self showHint:error.domain yOffset:-40];
             } else {
//                 [self showHint:error.domain];
                 [self showHint:@"录音时间太短了"];
             }
         }
         
     } onQueue:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        [picker dismissViewControllerAnimated:YES completion:nil];
        // video url:
        // file:///private/var/mobile/Applications/B3CDD0B2-2F19-432B-9CFA-158700F4DE8F/tmp/capture-T0x16e39100.tmp.9R8weF/capturedvideo.mp4
        // we will convert it to mp4 format
        NSURL *mp4 = [self convert2Mp4:videoURL];
        NSFileManager *fileman = [NSFileManager defaultManager];
        if ([fileman fileExistsAtPath:videoURL.path]) {
            NSError *error = nil;
            [fileman removeItemAtURL:videoURL error:&error];
            if (error) {
                NSLog(@"failed to remove file, error:%@.", error);
            }
        }
        EMChatVideo *chatVideo = [[EMChatVideo alloc] initWithFile:[mp4 relativePath] displayName:@"video.mp4"];
        [self sendVideoMessage:chatVideo];
        
    }else{
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self sendImageMessage:orgImage];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MenuItem actions

- (void)copyMenuAction:(id)sender
{
    // todo by du. 复制
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (_longPressIndexPath.row > 0) {
        MessageModel *model = [self.dataSource objectAtIndex:_longPressIndexPath.row];
        pasteboard.string = model.content;
    }
    
    _longPressIndexPath = nil;
}
//删除最后一条消息
- (void)deleteLastMessage
{
    if(self.dataSource.count > 0)
    {
        NSLog(@"%@",self.dataSource);
        MessageModel *model = [self.dataSource objectAtIndex:self.dataSource.count-1];
        //NSMutableArray *messages = [NSMutableArray arrayWithObjects:model, nil];
        [_conversation removeMessage:model.message];
        
//        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:_longPressIndexPath, nil];;
//        if (_longPressIndexPath.row - 1 >= 0) {
//            id nextMessage = nil;
//            id prevMessage = [self.dataSource objectAtIndex:(_longPressIndexPath.row - 1)];
//            if (_longPressIndexPath.row + 1 < [self.dataSource count]) {
//                nextMessage = [self.dataSource objectAtIndex:(_longPressIndexPath.row + 1)];
//            }
//            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
//                [messages addObject:prevMessage];
//                [indexPaths addObject:[NSIndexPath indexPathForRow:(_longPressIndexPath.row - 1) inSection:0]];
//            }
//        }
    
//        [self.dataSource removeObjectsInArray:messages];
//        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (void)deleteMenuAction:(id)sender
{
    if (_longPressIndexPath && _longPressIndexPath.row > 0) {
        MessageModel *model = [self.dataSource objectAtIndex:_longPressIndexPath.row];
        NSLog(@"%ld",(long)_longPressIndexPath.row);
        NSMutableArray *messages = [NSMutableArray arrayWithObjects:model, nil];
        [_conversation removeMessage:model.message];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:_longPressIndexPath, nil];;
        if (_longPressIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataSource objectAtIndex:(_longPressIndexPath.row - 1)];
            if (_longPressIndexPath.row + 1 < [self.dataSource count]) {
                nextMessage = [self.dataSource objectAtIndex:(_longPressIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [messages addObject:prevMessage];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(_longPressIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataSource removeObjectsInArray:messages];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    
    _longPressIndexPath = nil;
}

#pragma mark - private

- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    return bCanRecord;
}

- (void)stopAudioPlaying
{
    //停止音频播放及播放动画
    [[EaseMob sharedInstance].chatManager stopPlayingAudio];
    MessageModel *playingModel = [self.messageReadManager stopMessageAudioModel];
    
    NSIndexPath *indexPath = nil;
    if (playingModel) {
        indexPath = [NSIndexPath indexPathForRow:[self.dataSource indexOfObject:playingModel] inSection:0];
    }
    
    if (indexPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        });
    }
}

- (void)loadMoreMessages
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(_messageQueue, ^{
        long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
        
        NSArray *messages = [weakSelf.conversation loadNumbersOfMessages:([weakSelf.messages count] + KPageCount) before:timestamp];
        if ([messages count] > 0) {
            weakSelf.messages = [messages mutableCopy];
            
            NSInteger currentCount = [weakSelf.dataSource count];
            weakSelf.dataSource = [[weakSelf formatMessages:messages] mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataSource count]  - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            });
        }
    });
}

- (NSArray *)formatMessages:(NSArray *)messagesArray
{
    NSMutableArray *formatArray = [[NSMutableArray alloc] init];
    if ([messagesArray count] > 0) {
        for (EMMessage *message in messagesArray) {
            NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
            NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
            if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
                [formatArray addObject:[createDate formattedTime]];
                self.chatTagDate = createDate;
            }
            
            MessageModel *model = [MessageModelManager modelWithMessage:message];
            if (model) {
                [formatArray addObject:model];
            }
        }
    }
    
    return formatArray;
}

-(NSMutableArray *)formatMessage:(EMMessage *)message
{
    [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:0.5];
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
    NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
    if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
        [ret addObject:[createDate formattedTime]];
        self.chatTagDate = createDate;
    }
    
    MessageModel *model = [MessageModelManager modelWithMessage:message];//model里content对应接受的消息
    if (model) {
        [ret addObject:model];
    }
    [UIView commitAnimations];
    return ret;
}

-(void)addMessage:(EMMessage *)message
{
    __weak ChatViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSArray *messages = [weakSelf formatMessage:message];
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < messages.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.dataSource.count+i inSection:0];
            [indexPaths addObject:indexPath];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView beginUpdates];
            [weakSelf.dataSource addObjectsFromArray:messages];
            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.tableView endUpdates];
            
            [weakSelf.tableView scrollToRowAtIndexPath:[indexPaths lastObject] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
        });
    });
    [self scrollViewToBottom:YES];
}
#pragma mark  这里是发送消息后向上移动的地方＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

- (void)scrollViewToBottom:(BOOL)animated
{

    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        [UIView beginAnimations: @"Animation" context:nil];
        [UIView setAnimationDuration:0.5];
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:NO];
        
        [UIView commitAnimations];
    }
}

- (void)showRoomContact:(id)sender
{
    [self.view endEditing:YES];
    if (_isChatGroup) {
        ChatGroupDetailViewController *detailController = [[ChatGroupDetailViewController alloc] initWithGroupId:_chatter];
        [self.navigationController pushViewController:detailController animated:YES];
    }
}

- (void)removeAllMessages:(id)sender
{
    //
    
    
//    return;
    
    
    //
    
    UIButton *btn = (UIButton *) [self.navigationController.navigationBar viewWithTag:321];
    btn.hidden = YES;
    
    ISLoginManager *manager = [[ISLoginManager alloc]init];
    NSString *url = [NSString stringWithFormat:@"http://123.57.173.36/simi-wwz/wx-news-list.html?user_id=%@&page=1",manager.telephone];
    ImgWebViewController *img = [[ImgWebViewController alloc]init];
    img.imgurl =url;
    img.title = @"消息列表";
    [self.navigationController pushViewController:img animated:YES];
    //
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"55" forKey:@"UNREADMESSAGES"];
    [user synchronize];
    
    return;
    
    if (_dataSource.count == 0) {
        [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        if (_isChatGroup && [groupId isEqualToString:_conversation.chatter]) {
            [_conversation removeAllMessages];
            [_dataSource removeAllObjects];
            [_tableView reloadData];
            [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        }
    }
    else{
        __weak typeof(self) weakSelf = self;
        [WCAlertView showAlertWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                message:NSLocalizedString(@"sureToDelete", @"please make sure to delete")
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 [weakSelf.conversation removeAllMessages];
                 [weakSelf.dataSource removeAllObjects];
                 [weakSelf.tableView reloadData];
             }
         } cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
    }
}

- (void)showMenuViewController:(UIView *)showInView andIndexPath:(NSIndexPath *)indexPath messageType:(MessageBodyType)messageType
{
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    
    if (messageType == eMessageBodyType_Text) {
        [_menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    }
    else{
        [_menuController setMenuItems:@[_deleteMenuItem]];
    }
    
    [_menuController setTargetRect:showInView.frame inView:showInView.superview];
    [_menuController setMenuVisible:YES animated:YES];
}

- (void)exitGroup
{
//    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)insertCallMessage:(NSNotification *)notification
{
    id object = notification.object;
    if (object) {
        EMMessage *message = (EMMessage *)object;
        [self didReceiveMessage:message];
    }
}

- (void)applicationDidEnterBackground
{
    [_chatToolBar cancelTouchRecord];
    
    // 设置当前conversation的所有message为已读
    [_conversation markAllMessagesAsRead:YES];
}

#pragma mark - send message

-(void)sendTextMessage:(NSString *)textMessage
{
    EMMessage *tempMessage = [ChatSendHelper sendTextMessageWithString:textMessage toUsername:_conversation.chatter isChatGroup:_isChatGroup requireEncryption:NO ext:nil];
    [self addMessage:tempMessage];
    

    //是否智能聊天
    int senior = baseData.is_senior;
    if (senior == 0) {
        [self understandHandler:textMessage];
    }

    EMConversation *em = [[EMConversation alloc]init];
    
    [em markAllMessagesAsRead:YES];
}

-(void)sendImageMessage:(UIImage *)imageMessage
{
    EMMessage *tempMessage = [ChatSendHelper sendImageMessageWithImage:imageMessage toUsername:_conversation.chatter isChatGroup:_isChatGroup requireEncryption:NO ext:nil];
    [self addMessage:tempMessage];
}

-(void)sendAudioMessage:(EMChatVoice *)voice
{
    EMMessage *tempMessage = [ChatSendHelper sendVoice:voice toUsername:_conversation.chatter isChatGroup:_isChatGroup requireEncryption:NO ext:nil];
    [self addMessage:tempMessage];
}

-(void)sendVideoMessage:(EMChatVideo *)video
{
    EMMessage *tempMessage = [ChatSendHelper sendVideo:video toUsername:_conversation.chatter isChatGroup:_isChatGroup requireEncryption:NO ext:nil];
    [self addMessage:tempMessage];
}

#pragma mark - EMDeviceManagerProximitySensorDelegate

- (void)proximitySensorChanged:(BOOL)isCloseToUser{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if (isCloseToUser)//黑屏
    {
        // 使用耳机播放
        [[EaseMob sharedInstance].deviceManager switchAudioOutputDevice:eAudioOutputDevice_earphone];
    } else {
        // 使用扬声器播放
        [[EaseMob sharedInstance].deviceManager switchAudioOutputDevice:eAudioOutputDevice_speaker];
        if (!_isPlayingAudio) {
            [[[EaseMob sharedInstance] deviceManager] disableProximitySensor];
        }
    }
}

@end
