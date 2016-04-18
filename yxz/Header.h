//
//  Header.h
//  simi
//
//  Created by 赵中杰 on 14/11/25.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#ifndef simi_Header_h
#define simi_Header_h


#import "SIMPLEBaseClass.h"
#import "PartnerConfig.h"


// 屏幕宽度
#define _WIDTH                             self.view.frame.size.width

// 屏幕高度
#define _HEIGHT                            self.view.frame.size.height

#define _CELL_WIDTH                        self.frame.size.width

//  字体
#define MYFONT(a)                          [UIFont systemFontOfSize:a]

//  粗体
#define MYBOLD(a)                          [UIFont boldSystemFontOfSize:a]

//  图片名字
#define IMAGE_NAMED(a)                     [UIImage imageNamed:a]


#define PRINTLOG //注释不打印 NSLog
#ifdef  PRINTLOG

#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif


#define CHOICE_BACK_VIEW_COLOR 0xDADADA


////////////////*************************************//////////////////
////////////////*************接口相关*****************//////////////////

#define SERVER_DRESS                     @"http://123.57.173.36/"                        //服务器地址
#define GET_YANZHENGMA                   @"simi/app/user/get_sms_token.json"              //获取验证码
#define LOGIN_API                        @"simi/app/user/login.json"                      //登录接口
#define Third_LOG                        @"simi/app/user/login-3rd.json"                  //第三方登陆
#define USER_INFO                        @"simi/app/user/get_userinfo.json"               //用户信息接口
#define USERINFO_EDIT                    @"simi/app/user/post_userinfo.json"              //用户信息修改

#define ORDER_LIST                       @"simi/app/order/get_list.json"                  //订单列表
#define ORDER_DETAIL                     @"simi/app/order/get_detail.json"                //订单详情
#define CANCEL_ORDER                     @"simi/app/order/post_order_cancel.json"         //取消订单
#define DISCUSS_ORDER                    @"simi/app/order/post_rate.json"                 //订单评价
#define ORDER_SURE                       @"simi/app/order/post_confirm.json"              //订单确认

#define BASE_API                         @"simi/app/dict/get_base_datas.json"             //首页基础数据
#define MY_JIFEN_MINGXI                  @"simi/app/user/get_score.json"                  //我的积分明细
#define DELETE_ADDRESS                   @"simi/app/user/post_del_addrs.json"             //地址删除接口
#define ADDRESS_ADDCHANGE                @"simi/app/user/post_addrs.json"                 //地址添加修改
                                         
#define MY_DRESSLIST                     @"simi/app/user/get_addrs.json"                  //常用地址
#define USERINFO_API                     @"simi/app/user/get_userinfo.json"               //账号信息
#define ORDER_PAY                        @"simi/app/order/post_pay.json"                  //订单支付
#define ORDER_TIJIAO                     @"simi/app/order/post_add.json"                  //提交订单
#define MY_DRESSLIST                     @"simi/app/user/get_addrs.json"                  //常用地址
#define JIFEN_MINGXI                     @"simi/app/user/get_score.json"                  //积分明晰
#define MY_DRESSLIST                     @"simi/app/user/get_addrs.json"                  //常用地址
#define JIFEN_MINGXI                     @"simi/app/user/get_score.json"                  //积分明晰
#define JIFEN_DUIHUAN                    @"simi/app/user/post_score_exchange.json"        //积分兑换

#define YIJIAN_FANKUI                    @"simi/app/user/post_feedback.json"             //意见反馈
#define REMIND_SAVE                      @"simi/app/user/post_user_remind.json"          //提醒记录保存
#define REMIND_LIST                      @"simi/app/user/get_user_remind.json"           //提醒记录列表
#define REMIND_DELETE                    @"simi/app/user/post_user_remind_del.json"      //提醒删除
#define MINEYOUHUIJUAN                   @"simi/app/user/get_coupons.json"               //我的优惠卷
#define YOUHUIJUAN_DUIHUAN               @"simi/app/user/post_coupon.json"               //优惠卷兑换
#define simi_GOUMAI                      @"simi/app/user/senior_buy.json"                //管家卡购买
#define VIP_CHONGZHI                     @"simi/app/user/card_buy.json"                  //会员充值
#define BUY_simiCARD                     @"simi/app/user/senior_buy.json"                //购买管家卡
#define VIP_LIST                         @"simi/app/dict/get_cards.json"                 //充值列表
#define VIPCHONGZHI_NOTYURL              @"simi/pay/notify_alipay_ordercard.jsp"         //会员充值notyurl
#define simi_NOTYURL                     @"simi/pay/notify_alipay_ordersenior.jsp"       //管家卡回调notyurl
#define ORDEL_NOTYURL                    @"simi/pay/notify_alipay_order.jsp"             //订单支付回调notyurl
#define ORDER_CANCLE                     @"simi/app/order/pre_order_cancel.json"         //订单预取消
#define baidu_bangding                   @"simi/app/user/post_baidu_bind.json"           //百度推送绑定
#define WXPAY_URL                        @"simi/app/order/wx_pre.json"                   //微信预支付接口
#define WXPAY_SUCCESS                    @"simi/app/order/wx_order_query.json"           //查询微信支付是否成功
#define UNREADMESSAGES                   @"simi/app/user/get_new_msg.json"               //查看有没有未读消息
#define CREATE_CARD                      @"simi/app/card/post_card.json"                 //创建卡片接口
#define CARD_LIST                        @"simi/app/card/get_list.json"                  //卡片列表接口
#define CITY_JK                          @"simi/app/city/get_list.json"                  //城市数据接口
#define CARD_DETAILS                     @"simi/app/card/get_detail.json"                //卡片详情接口
#define CARD_PL                          @"simi/app/card/post_comment.json"              //卡片评论接口
#define CARD_PLLB                        @"simi/app/card/get_comment_list.json"          //卡片评论列表接口
#define CARD_DZ                          @"simi/app/card/post_zan.json"                  //卡片点赞接口
#define USER_HYXX                        @"simi/app/user/get_im_last.json"               //好友消息列表接口
#define USER_HYLB                        @"simi/app/user/get_friends.json"               //好友列表接口
#define USER_TJHY                        @"simi/app/user/post_friend.json"               //添加好友接口
#define USER_GRZY                        @"simi/app/user/get_user_index.json"            //用户个人主页接口
#define SEEK_MS                          @"simi/app/sec/get_list.json"                   //秘书列表接口数据
#define SEEK_GMLB                        @"simi/app/dict/get_seniors.json"               //购买秘书基础接口
#define SEEK_ZFB                         @"simi/app/user/senior_buy.json"                     //支付宝
#define SEEK_YHLB                        @"simi/app/sec/get_users.json"                  //秘书获取客户接口
#define SEEK_CLJK                        @"simi/app/card/sec_do.json"                    //秘书处理卡片接口
#define SEEK_MSCL                        @"simi/app/card/sec_do.json"                    //秘书处理卡片流程接口
#define CARD_QXJK                        @"simi/app/card/card_cancel.json"               //卡片取消接口
#define LOGIN_GTJK                       @"simi/app/user/post_push_bind.json"            //个推推送接口
#define LOGIN_TSNZ                       @"simi/app/card/get_reminds.json"               //闹钟列表借口
#define USER_TXSC                        @"simi/app/user/post_user_head_img.json"        //上传头像接口
#define USER_YHTP                        @"simi/app/user/get_user_imgs.json"             //用户获取图片接口
#define SEEK_FWS                         @"simi/app/partner/get_user_list.json"          //服务商-服务商列表接口
#define USER_FWXQ                        @"simi/app/partner/get_user_detail.json"        //服务商-服务人员详情
#define ORDER_FWXD                       @"simi/app/order/post_add.json"                 //订单-服务下单接口
#define ORDER_DDLB                       @"simi/app/order/get_list.json"                 //订单列表接口
#define ORDER_DDHD                       @"simi/pay/notify_alipay_order.jsp"             //订单付款回调url
#define ORDER_DDXQ                       @"simi/app/order/get_detail.json"               //订单详情接口
#define USER_SJBD                        @"simi/app/user/bind_mobile.json"               //手机号绑定接口
#define ORDER_DDZF                       @"simi/app/order/post_pay.json"                 //订单支付接口（订单详情和订单列表支付调用）
#define USER_QRCODE                      @"simi/app/user/get_qrcode.json"                //用户获取自己的二维码接口
#define USER_QRHY                        @"simi/app/user/add_friend.json"                //二维码扫描添加好友接口
#define USER_LNTEGRAL                    @"http://123.57.173.36/simi/app/user/score_shop.json"                //积分积口
#define USER_WALLET                      @"simi/app/user/get_detail_pay.json"                 //用户钱包接口
#define SERVICE_SEARCH                   @"simi/app/partner/search.json"                 //服务商-搜索结果-服务人员列表接口
#define SERVICE_RSLB                     @"simi/app/partner/get_hot_keyword.json"        //服务商-热搜关键字列表接口
#define USER_ENTERPRISE                  @"simi/app/company/get_by_user.json"            //企业-用户所属企业列表
#define ENTERPRISE_STAFF                 @"simi/app/company/get_staffs.json"             //企业-企业员工列表
#define FOUND_CHANNEL                    @"simi/app/op/get_channels.json"                //获取频道列表接口
#define CHANNEL_CARD                     @"simi/app/op/get_ads.json"                     //获取频道内广告信息接口
#define WATER_CELL                       @"simi/app/op/get_appTools.json"                //用户-获得应用列表接口
#define UP_DONGTAI                       @"simi/app/feed/post_feed.json"                 //动态-添加动态接口
#define DYNAMIC_CARD                     @"simi/app/feed/get_list.json"                  //动态-获取动态列表接口
#define DYNAMIC_DETAILS                  @"simi/app/feed/get_detail.json"                //动态-获取动态详情接口
#define DYNAMIC_SHARE                    @"simi/app/feed/post_zan.json"                  //动态-动态点赞接口
#define DYNAMIC_COMMENT                  @"simi/app/feed/post_comment.json"              //动态-动态评论接口
#define DYNAMIC_DELETE                   @"simi/app/feed/del.json"                       //动态-动态删除接口
#define DYNAMIC_COM_CARD                 @"simi/app/feed/get_comment_list.json"          //动态-动态评论列表接口
#define DYNAMIC_COM_DELETE               @"simi/app/feed/del_comment.json"               //动态-动态评论删除接口
#define WAGE_ORCODE                      @"simi/app/company/get_detail.json"             //企业-获取企业详情
#define ATTEND_CHECKIN                   @"simi/app/company/checkin.json"                //企业-员工考勤签到接口
#define ATTEND_DEFAULT                   @"simi/app/company/get_checkins.json"           //企业-获取企业员工班次及考勤记录接口
#define CADR_NEWSLIST                    @"simi/app/user/get_msg.json"                   //用户-消息列表接口
#define SUER_LEAVE_APPLY                 @"simi/app/user/post_leave.json"                //用户-请假接口
#define USER_LEAVE_LIST                  @"simi/app/user/leave_list.json"                //用户-请假列表
#define USER_LEAVE_REVOKE                @"simi/app/user/leave_cancel.json"              //用户-请假撤销接口
#define USER_LEAVE_AUDIT                 @"simi/app/user/leave_pass.json"                //用户-请假审批接口
#define USER_LEAVE_DETAILS               @"simi/app/user/leave_detail.json"              //用户-请假详情接口
#define USER_PLUE_LIST                   @"simi/app/op/get_appIndexList.json"            //导航列表接口
#define USER_HELP                        @"simi/app/op/get_appHelp.json"                 //帮助接口
#define USER_APPLYFRIENDS                @"simi/app/user/get_friend_reqs.json"           //用户-获取好友申请列表
#define USER_CHECK_FRIENDS_LIST          @"simi/app/user/post_friend_req.json"           //用户-好友申请通过或拒绝接口
#define USER_NEWLY_ADDED                 @"simi/app/op/user_app_tools.json"              //新增应用显示配置接口
#define MEETING_ROOM                     @"simi/app/company/get_company_setting.json"    //用户-公司配置信息接口
#define ORDER_ORDER_LIST                 @"simi/app/order/get_list_water.json"           //订单-送水订单列表
#define ORDER_PLACR_AN_ORDER             @"simi/app/order/post_add_water.json"           //订单-送水订单下单接口
#define WATER_GOODS_LIST                 @"simi/app/partner/get_default_service_price_list.json"             //服务商-获取送水商品列表
#define WATER_LIST_SIGN                  @"simi/app/order/post_done_water.json"          //订单-送水订单签收接口
#define WASTE_LIST                       @"simi/app/order/get_list_recycle.json"           //订单-废品回收订单列表接口
#define ADDRESS_USER                     @"simi/app/user/post_trail.json"                //用户-当前地理位置接口
#define WASTE_ORDER                      @"simi/app/order/post_add_recycle.json"           //订单-废品回收订单下单接口
#define WATER_ORDER_DETAILS              @"simi/app/order/get_detail_water.json"         //订单-送水订单详情
#define CLEAN_ORDER_LIST                 @"simi/app/order/get_list_clean.json"           //订单-保洁订单列表
#define CLEAN_ORDER_DETAILE              @"simi/app/order/get_detail_clean.json"         //订单-保洁订单详情
#define CLEAN_ORDER_PLACE                @"simi/app/order/post_add_clean.json"           //订单-保洁订单下单接口
#define LWAGYEBUILDING_ORDER_PLACE       @"simi/app/order/post_add_team.json"            //订单-团建下单接口
#define LWAGYEBUILDING_LIST              @"simi/app/order/get_list_team.json"            //订单-团建订单列表
#define LWAGYEBUILDING_ORDER_DETAILE     @"simi/app/order/get_detail_team.json"          //订单-团建订单详情
#define EXPRESS_ORDER_LIST               @"simi/app/record/get_list_express.json"        //登记-快递登记列表接口
#define EXPRESS_REGISTER                 @"simi/app/record/post_add_express.json"        //登记-快递登记接口
#define EXREESS_REGISER_DETAILE          @"simi/app/record/get_detail_express.jsonn"     //登记-快递登记详情接口
#define USER_DEFAULTCOMPANT              @"simi/app/company/set_default.json"            //企业-用户设置默认企业
#define USER_HELP_CLICK                  @"simi/app/op/post_help.json"                   //帮助-帮助点击记录接口
#define COMPANY_STORAGE_RECORD           @"simi/app/record/get_record_assets.json"       //公司资产登记列表接口（入库纪录）
#define COMPANY_STORAGE_REGISTER         @"simi/app/record/post_asset.json"              //公司资产登记接口（入库登记）
#define COMPANY_ASSETS_BARCODE           @"simi/app/record/barcode.json"                 //条形码获取详细信息接口(资产名称)
#define COMPANY_COLLECT_CATEGORY         @"simi/app/record/get_asset_list.json"          //公司资产列表接口(资产分类列表，领用登记选择)
#define COMPANY_COLLECT_REGISTER         @"simi/app/record/post_asset_use.json"          //公司资产领用记录接口
#define COMPANY_COLLECT_LIST             @"simi/app/record/get_asset_use.json"           //公司资产领用列表接口
#define BASICE_GENERAL_ADVERTISING       @"simi/app/dict/get_ads.json"                   //获取频道内广告信息接口
#define HOMEPAHE_SIGN                    @"simi/app/user/day_sign.json"                  //用户签到接口（首页签到有礼访问接口）
#define USER_DETAILED_LIST               @"simi/app/user/get_score.json"                 //我的积分明细接口
#define APP_BASIC_DATA                   @"simi/app/get_base_datas.json"                 //基础数据接口
#endif