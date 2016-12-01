//
//  EMHTTPSessionManager.h
//  EMNetworking
//
//  Created by 苏亮 on 2016/12/1.
//  Copyright © 2016年 Emir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMHTTPSessionManager : NSObject

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url parameters:(id)parameters;
- (void)dealTaskSuccess:(void (^)(NSData *data, NSURLResponse *response))success failure:(void (^)(NSError *error))failure;

@end
