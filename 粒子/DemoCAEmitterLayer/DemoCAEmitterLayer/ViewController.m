//
//  ViewController.m
//  DemoCAEmitterLayer
//
//  Created by Chris Hu on 16/6/14.
//  Copyright © 2016年 icetime17. All rights reserved.
//

#import "ViewController.h"
#import "ViewCAEmitter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UIImageView *model = [[UIImageView alloc] initWithFrame:self.view.frame];
    model.image = [UIImage imageNamed:@"model.jpg"];
    [self.view addSubview:model];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"blur.png"];
    [self.view addSubview:bg];
    
    ViewCAEmitter *viewEmitter = [[ViewCAEmitter alloc] initWithFrame:self.view.frame];
    [self.view addSubview:viewEmitter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
