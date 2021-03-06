//
//  UMComPrivateMessage.h
//  UMCommunity
//
//  Created by umeng on 15/12/1.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UMComManagedObject.h"

@class UMComPrivateLetter, UMComUser;

NS_ASSUME_NONNULL_BEGIN

@interface UMComPrivateMessage : UMComManagedObject

// Insert code here to declare functionality of your managed object subclass

/**
 通过聊天记录id获取到本地 UMComPrivateMessage 对象的方法，如果本地没有， 则会新建一个
 
 @param message_id 聊天记录id
 
 */
+ (UMComPrivateMessage *)objectWithObjectId:(NSString *)message_id;

@end

NS_ASSUME_NONNULL_END

#import "UMComPrivateMessage+CoreDataProperties.h"
