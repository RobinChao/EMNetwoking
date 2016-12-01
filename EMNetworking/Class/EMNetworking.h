//
//  EMNetworking.h
//  EMNetworking
//
//  Created by 苏亮 on 2016/12/1.
//  Copyright © 2016年 Emir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMNetworking : NSObject



/**
 普通get， post请求

 @param method 请求方式
 @param url 请求url
 @param parameters 请求参数
 @param success 成功 callback
 @param error 失败 callback
 */
+ (void)requestWithMethod:(NSString *)method url:(NSString *)url parameters:(id)parameters
                  success:(void (^)(NSData *data, NSURLResponse *response))success
                  failure:(void (^)(NSError *error))error;

@end
