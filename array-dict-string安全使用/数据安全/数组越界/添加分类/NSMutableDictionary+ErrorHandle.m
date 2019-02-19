//
//  NSMutableDictionary+ErrorHandle.m
//  VeryFitPlus
//
//  Created by xiongze on 2018/6/29.
//  Copyright © 2018年 aiju_huangjing1. All rights reserved.
//

#import "NSMutableDictionary+ErrorHandle.h"
#import "NSObject+SwizzleMethod.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (ErrorHandle)

+(void)load{
    [super load];
    //无论怎样 都要保证方法只交换一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //交换NSMutableArray中的方法
        [objc_getClass("__NSDictionaryM") SystemSelector:@selector(setObject:forKey:) swizzledSelector:@selector(z_setObject:forKey:) error:nil];
    });
}

- (void)z_setObject:(id)anObject forKey:(id <NSCopying>)aKey{
    if (anObject) {
        [self z_setObject:anObject forKey:aKey];
    }else
        [self z_setObject:@"" forKey:aKey];
}

@end
