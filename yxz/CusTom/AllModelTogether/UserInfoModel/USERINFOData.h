//
//  USERINFOData.h
//
//  Created by 中杰 赵 on 14/12/23
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface USERINFOData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double restMoney;
@property (nonatomic, strong) NSString *seniorRange;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, assign) double userId;
@property (nonatomic, assign) double score;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *gender;//性别







+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
