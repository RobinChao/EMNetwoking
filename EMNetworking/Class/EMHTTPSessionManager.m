//
//  EMHTTPSessionManager.m
//  EMNetworking
//
//  Created by 苏亮 on 2016/12/1.
//  Copyright © 2016年 Emir. All rights reserved.
//

#import "EMHTTPSessionManager.h"
#import "EMRequestSerialization.h"

@interface EMHTTPSessionManager ()

@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *method;
@property (strong, nonatomic) NSDictionary *parameters;

@property (strong, nonatomic) NSMutableURLRequest *request;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionDataTask *dataTask;


@end

@implementation EMHTTPSessionManager

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url parameters:(id)parameters {
    
    if (self = [super init]) {
        
        self.url = url;
        self.method = method;
        self.parameters = parameters;
        self.request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        self.session = [NSURLSession sharedSession];
    }
    
    return self;
}

- (void)dealTaskSuccess:(void (^)(NSData *, NSURLResponse *))success failure:(void (^)(NSError *))failure {
    [self setRequest];
    [self setBody];
    
    self.dataTask = [self.session dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if (error) {
            failure(error);
        }else {
            if (success) {
                success(data, response);
            }
        }
    }];
    [self.dataTask resume];
}

- (void)setRequest {
    
    if ([self.method isEqual:@"GET"]&&self.parameters.count>0) {
        
        self.request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[self.url stringByAppendingString:@"?"] stringByAppendingString: [EMRequestSerialization serializationFormByParameters:self.parameters]]]];
    }
    self.request.HTTPMethod = self.method;
    
    if (self.parameters.count>0) {
        [self.request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
}

- (void)setBody {
    
    if (self.parameters.count>0&&![self.method isEqual:@"GET"]) {
        
        self.request.HTTPBody = [[EMRequestSerialization serializationFormByParameters:self.parameters] dataUsingEncoding:NSUTF8StringEncoding];
    }
}

@end
