//
//  NSArray+ErrorHandle.h
//  VeryFitPlus
//
//  Created by xiongze on 2018/4/25.
//  Copyright © 2018年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ErrorHandle)

/**
 为数组分类添加的方法  可以在应用中直接调用 可以防止数组越界导致的crash

 @param index 传入的取值下标
 @return id类型的数据
 */
- (id)objectAtIndexVerify:(NSUInteger)index;
- (id)objectAtIndexedSubscriptVerify:(NSUInteger)idx;

@end
