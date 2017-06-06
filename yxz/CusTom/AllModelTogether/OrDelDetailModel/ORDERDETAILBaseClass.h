//
//  ORDERDETAILBaseClass.h
//
//  Created by 中杰 赵 on 14/12/20
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORDERDETAILData;

@interface ORDERDETAILBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double status;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) ORDERDETAILData *data;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
