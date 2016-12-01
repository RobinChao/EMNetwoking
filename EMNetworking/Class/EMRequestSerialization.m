//
//  EMRequestSerialization.m
//  EMNetworking
//
//  Created by 苏亮 on 2016/12/1.
//  Copyright © 2016年 Emir. All rights reserved.
//

#import "EMRequestSerialization.h"

@interface EMRequestSerialization ()

@property (strong, nonatomic) id value;
@property (strong, nonatomic) id key;

@end

/** 声明两个查找函数 参考AFNetworking */
FOUNDATION_EXPORT NSArray * em_query_string_from_dict(NSDictionary *dictionary);
FOUNDATION_EXPORT NSArray * em_query_string_from_key_and_value(NSString *key, id value);

@implementation EMRequestSerialization

- (instancetype)initWithKey:(id)key value:(id)value {
    
    if (self = [super init]) {
        self.key = key;
        self.value = value;
    }
    
    return self;
}

+ (NSString *)serializationFormByParameters:(NSDictionary *)parameters {
    
    NSMutableArray *mutableArr = [NSMutableArray array];
    for (EMRequestSerialization *serialization in em_query_string_from_dict(parameters)) {
        
        [mutableArr addObject:[serialization URLEncodedStringValue]];
    }
    
    return [mutableArr componentsJoinedByString:@"&"];
}

NSArray *em_query_string_from_dict(NSDictionary *dictionary) {
    return em_query_string_from_key_and_value(nil, dictionary);
}

//递归处理parameters
NSArray * em_query_string_from_key_and_value(NSString *key, id value) {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = value;
        for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            id nestedValue = dictionary[nestedKey];
            if (nestedValue) {
                [mutableQueryStringComponents addObjectsFromArray:em_query_string_from_key_and_value((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
            }
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = value;
        for (id nestedValue in array) {
            [mutableQueryStringComponents addObjectsFromArray:em_query_string_from_key_and_value([NSString stringWithFormat:@"%@[]", key], nestedValue)];
        }
    } else if ([value isKindOfClass:[NSSet class]]) {
        NSSet *set = value;
        for (id obj in [set sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            [mutableQueryStringComponents addObjectsFromArray:em_query_string_from_key_and_value(key, obj)];
        }
    } else {
        [mutableQueryStringComponents addObject:[[EMRequestSerialization alloc] initWithKey:key value:value]];
    }
    
    return mutableQueryStringComponents;
}

static NSString * em_transform_string_from_string(NSString *string) {
    static NSString * const kLYCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kLYCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kLYCharactersGeneralDelimitersToEncode stringByAppendingString:kLYCharactersSubDelimitersToEncode]];
    
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < string.length) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wgnu"
        NSUInteger length = MIN(string.length - index, batchSize);
#pragma GCC diagnostic pop
        NSRange range = NSMakeRange(index, length);
        
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    
    return escaped;
}

- (NSString *)URLEncodedStringValue {
    if (!self.value || [self.value isEqual:[NSNull null]]) {
        return em_transform_string_from_string([self.key description]);
    } else {
        return [NSString stringWithFormat:@"%@=%@", em_transform_string_from_string([self.key description]), em_transform_string_from_string([self.value description])];
    }
}
@end
