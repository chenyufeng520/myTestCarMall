//
//  ValidObject.m
//  CarLife
//
//  Created by 聂康  on 16/5/24.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ValidObject.h"

@implementation ValidObject

+ (BOOL)objectIsValid:(id)object{
    if([NSNull null] != object && nil != object && [object isKindOfClass:[NSString class]] && ((NSString*)object).length > 0){
        return YES;
    }else if([NSNull null] != object && nil != object && [object isKindOfClass:[NSArray class]] && [(NSArray*)object count] > 0){
        return YES;
    }else if([NSNull null] != object && nil != object && [object isKindOfClass:[NSMutableArray class]] && [(NSMutableArray*)object count] > 0){
        return YES;
    }else if([NSNull null] != object && nil != object && [object isKindOfClass:[NSDictionary class]]){
        return YES;
    }else if([NSNull null] != object && nil != object && [object isKindOfClass:[NSMutableDictionary class]]){
        return YES;
    }else if ([NSNull null] != object && nil != object && [object isKindOfClass:[NSNumber class]]) {
        return YES;
    } else {
        return NO;
    }
}

@end
