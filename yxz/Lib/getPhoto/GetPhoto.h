//
//  GetPhoto.h
//  simi
//
//  Created by 高鸿鹏 on 15/6/15.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetPhoto : NSObject
+ (UIImage *)getPhotoFromName:(NSString *)name;
+ (UIImage *)fixOrientation:(UIImage *)aImage ;
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
+ (NSData *)getPhotoDataFromName:(NSString *)name;

@end
