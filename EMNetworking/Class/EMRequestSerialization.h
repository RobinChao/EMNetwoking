//
//  EMRequestSerialization.h
//  EMNetworking
//
//  Created by 苏亮 on 2016/12/1.
//  Copyright © 2016年 Emir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMRequestSerialization : NSObject

+ (NSString *)serializationFormByParameters:(NSDictionary *)parameters;
@end
