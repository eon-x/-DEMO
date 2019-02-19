//
//  ViewController.h
//  map_filter
//
//  Created by zqwl001 on 16/8/3.
//  Copyright © 2016年 ljw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef id(^LJWItemMap)(id item);
typedef NSArray *(^LJWArrayMap)(LJWItemMap itemMap);

typedef BOOL(^LJWItemFilter)(id item);
typedef NSArray *(^LJWArrayFilter)(LJWItemFilter itemFilter);
/*
 * 扩展数组高级方法仿 swift 调用
 */
@interface NSArray (LJWExtension)
@property (nonatomic, copy, readonly) LJWArrayMap map;

@property (nonatomic, copy, readonly) LJWArrayFilter filter;
@end

@interface ViewController : UIViewController


@end

