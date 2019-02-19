//
//  ViewController.m
//  VeryFitPlus
//
//  Created by xiongze on 2018/4/25.
//  Copyright © 2018年 aiju_huangjing1. All rights reserved.
//

#import "ViewController.h"
#import "NSArray+ErrorHandle.h"
#import "NSMutableArray+ErrorHandle.h"


@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *type = nil;
    self.array = [NSArray arrayWithObjects:@"语文", @"数学", @"英语", nil];
    [self.dataSource addObjectVerify:type];
    [self.dataSource addObjectVerify:@"语文"];
    [self.dataSource addObjectVerify:@"数学"];
    [self.dataSource addObjectVerify:@"英语"];
    [self.dataSource insertObjectVerify:type atIndex:10];
    [self.dataSource insertObjectVerify:@"物理" atIndex:2];
    
    for (int i = 0; i<10; i++) {
        NSLog(@"%@",_array[i]);
    }
        
}
/**
 *  dataSource
 */
- (NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
