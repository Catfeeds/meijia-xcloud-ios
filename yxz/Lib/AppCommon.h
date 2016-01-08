//
//  AppCommon.h
//  simi
//
//  Created by mazhongchao on 14-10-30.
//  Copyright (c) 2014年 zhirunjia. All rights reserved.
//

#ifndef simi_AppCommon_h
#define simi_AppCommon_h

//#define NAV_COLOR 0xFF6535
#define NAV_FONT_COLOR 0xFFFFFF
#define INDEX_FONF_COLOR 0xC5C5C5
#define TAB_FONT_COLOR 0xCCCCCC
#define BAC_VIEW_COLOR 0xF5F5F5

#define NAV_HEIGHT 64
#define SELF_VIEW_HEIGHT self.view.bounds.size.height
#define SELF_VIEW_WIDTH  self.view.bounds.size.width

//系统相关
#define SYSTEM_VERSION  [[[UIDevice currentDevice]systemVersion] floatValue]
#define HEIGHT_TYPE     [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0 ? 20 : 0
#define IS_IOS_7        [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0 ? YES : NO

//判断是否iPhone5
#define IS_iPhone5      ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)

//application deledate
#define APPLIACTION     ((AppDelegate *)([[UIApplication sharedApplication] delegate]))

//布局相关
#define FRAME(x,y,w,h)  CGRectMake(x,y,w,h)

//颜色转换
#define DEFAULT_COLOR          [UIColor clearColor]
#define COLOR_VAULE(rgb)       [UIColor colorWithRed:rgb/255.0 green:rgb/255.0 blue:rgb/255.0 alpha:1.0]//颜色值
#define COLOR_VAULES(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]//颜色值
#define HEX_TO_UICOLOR(hex,a)  [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:a]
#define YELLOW_COLOR           [UIColor colorWithRed:244.0/255.0 green:113.0/255.0 blue:31.0/255.0 alpha:1.0]  //橘黄色

//调试信息打印
#define DEBUG 1
#if (DEBUG == 1)
#	define XLOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#	define XLOGDATASTR(data) XLOG(@"%@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease])
#	define XLOGRECT(rect) XLOG(@"rect[%d, %d, %d, %d]", (int)rect.origin.x, (int)rect.origin.y, (int)rect.size.width, (int)rect.size.height)
#	define XLOGH(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#elif (DEBUG != 0)
#	define XLOG(fmt, ...) {}
#	define XLOGDATASTR(data) {}
#	define XLOGRECT(rect) {}
#	define XLOGH(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define XLOG(fmt, ...) {}
#	define XLOGDATASTR(data) {}
#	define XLOGRECT(rect) {}
#	define XLOGH(fmt, ...) {}
#endif

#ifdef DEBUG_LOG
#define DLog( s, ... ) NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

#endif
