//
//  YKPlayerVideo.h
//  YKPlayerSDK
//
//  Created by SMY on 16/7/6.
//  Copyright © 2016年 SMY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKPlayerDefine.h"

@interface YKPlayerVideo : NSObject {
    
}

@property (nonatomic, strong) NSString *videoId;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) double duration; //秒

- (NSURL *)posterURLWithQuality:(YKPlayerVideoQuality)quality;

- (NSDictionary *)allPosterURL;

- (NSArray *)allSupportQuality;

@end
