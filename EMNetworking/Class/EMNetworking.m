//
//  EMNetworking.m
//  EMNetworking
//
//  Created by 苏亮 on 2016/12/1.
//  Copyright © 2016年 Emir. All rights reserved.
//

#import "EMNetworking.h"
#import "EMHTTPSessionManager.h"

@implementation EMNetworking

+ (void)requestWithMethod:(NSString *)method url:(NSString *)url parameters:(id)parameters success:(void (^)(NSData *, NSURLResponse *))success failure:(void (^)(NSError *))error {
    
    EMHTTPSessionManager *manager = [[EMHTTPSessionManager alloc] initWithMethod:method url:url parameters:parameters];
    [manager dealTaskSuccess:success failure:error];
}
@end
