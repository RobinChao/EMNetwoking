//
//  ViewController.m
//  EMNetworking
//
//  Created by 苏亮 on 2016/12/1.
//  Copyright © 2016年 Emir. All rights reserved.
//

#import "ViewController.h"
#import "EMNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSString *url = @"https://api.github.com/search/users";
    NSDictionary *parameters = @{@"q" : @"language:objective-c",
                                 @"sort" : @"followers",
                                 @"order" : @"desc"};
    
    [EMNetworking requestWithMethod:@"GET" url:url parameters:parameters success:^(NSData *data, NSURLResponse *response) {
        
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"data: %@", str);
        
    } failure:^(NSError *error) {
        NSLog(@"error: %@", error.localizedDescription);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
