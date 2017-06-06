//
//  SERVICEServiceTypes.h
//
//  Created by 中杰 赵 on 14/11/28
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SERVICEBaojie, SERVICEXiyi, SERVICEZuofan, SERVICECaboli, SERVICEGuandao, SERVICEXinju, SERVICEJiadian;

@interface SERVICEServiceTypes : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) SERVICEBaojie *baojie;
@property (nonatomic, strong) SERVICEXiyi *xiyi;
@property (nonatomic, strong) SERVICEZuofan *zuofan;
@property (nonatomic, strong) SERVICECaboli *caboli;
@property (nonatomic, strong) SERVICEGuandao *guandao;
@property (nonatomic, strong) SERVICEXinju *xinju;
@property (nonatomic, strong) SERVICEJiadian *jiadian;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
