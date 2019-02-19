//
//  ViewController.m
//  Runtime
//
//  Created by 马德茂 on 16/5/12.
//  Copyright © 2016年 马德茂. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] init];
    NSLog(@"********所有变量/值:\n%@", [self getAllIvar:label]);
    NSLog(@"********所有属性:\n%@", [self getAllProperty:label]);
    
    [self getAllClassName];
    
}

//获得所有变量
- (NSArray *)getAllIvar:(id)object
{
    NSMutableArray *array = [NSMutableArray array];
    
    unsigned int count;
    Ivar *ivars = class_copyIvarList([object class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *keyChar = ivar_getName(ivar);
        NSString *keyStr = [NSString stringWithCString:keyChar encoding:NSUTF8StringEncoding];
        @try {
            id valueStr = [object valueForKey:keyStr];
            NSDictionary *dic = nil;
            if (valueStr) {
                dic = @{keyStr : valueStr};
            } else {
                dic = @{keyStr : @"值为nil"};
            }
            [array addObject:dic];
        }
        @catch (NSException *exception) {}
    }
    return [array copy];
}

//获得所有属性
- (NSArray *)getAllProperty:(id)object
{
    NSMutableArray *array = [NSMutableArray array];
    
    unsigned int count;
    objc_property_t *propertys = class_copyPropertyList([object class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertys[i];
        const char *nameChar = property_getName(property);
        NSString *nameStr = [NSString stringWithCString:nameChar encoding:NSUTF8StringEncoding];
        [array addObject:nameStr];
    }
    return [array copy];
}

//获取类名
-(void)getAllClassName{
    
    //先获取类名
    NSString *className = NSStringFromClass([UILabel class]);
    const char *cClassName = [className UTF8String];
    
    id theClass = objc_getClass(cClassName);
    unsigned int outCount;
    Method *m =  class_copyMethodList(theClass,&outCount);
    
    NSLog(@"%d",outCount);
    for (int i = 0; i<outCount; i++) {
        SEL a = method_getName(*(m+i));
        NSString *sn = NSStringFromSelector(a);
        NSLog(@"%@",sn);
    }
    
//    SEL s = @selector(centralManager:didConnectPeripheral:);
//    [ble performSelector:s withObject:nil withObject:nil];
    
}

@end
