//
//  ALLCITYBaseClass.h
//
//  Created by 中杰 赵 on 14/12/6
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ALLCITYBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double cITYId;
@property (nonatomic, strong) NSString *cITYOpentime;
@property (nonatomic, strong) NSString *cITYName;
@property (nonatomic, assign) double cITYStoreid;
@property (nonatomic, assign) double cId;
@property (nonatomic, strong) NSString *cITYDress;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
