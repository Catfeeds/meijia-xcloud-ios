//
//  JIFENData.h
//
//  Created by 中杰 赵 on 14/12/11
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface JIFENData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, assign) double score;
@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, assign) double isConsume;
@property (nonatomic, assign) double userId;
@property (nonatomic, assign) double actionId;
@property (nonatomic, assign) double addTime;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
