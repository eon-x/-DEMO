//
//  TestViewController.m
//  GrainEffect
//
//  Created by xiongze on 2018/8/4.
//  Copyright © 2018年 zhouen. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *start = [[UIButton alloc] initWithFrame:CGRectMake(300, 480, 50, 30)];
    start.backgroundColor = [UIColor grayColor];
    [start setTitle:@"开始" forState:UIControlStateNormal];
    [self.view addSubview:start];
    [start addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)start:(UIButton *)sender{
    CGPoint rect = [sender convertRect: sender.bounds toView:self.view].origin;
    // 配置发射器
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.emitterShape    = kCAEmitterLayerLine;//发射源的形状
    emitterLayer.emitterMode     = kCAEmitterLayerOutline;//发射模式
    emitterLayer.emitterSize     = CGSizeMake(0, 0);//发射源的尺寸大小
    emitterLayer.emitterPosition = CGPointMake(rect.x+22, rect.y+22);
    emitterLayer.renderMode      = kCAEmitterLayerOldestLast;
    [self.view.layer addSublayer:emitterLayer];
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 6; i++) {
        CAEmitterCell *snowflake          = [CAEmitterCell emitterCell];

        //粒子参数的速度乘数因子
        snowflake.name                    = @"sprite";//粒子的名字
        snowflake.birthRate               = 1;//出生率，这个就是代表每秒有多少个对象生成
        snowflake.lifetime                = 3;
        snowflake.velocity                = 1200;//粒子速度
        snowflake.velocityRange           = 150;//粒子的速度浮动范围
        snowflake.yAcceleration           = 1800;//粒子y方向的加速度分量,可以模拟地球上的重力加速度，值越大则每个粒子下落的越快
        snowflake.scale                   = 0.5;//粒子发射器的生成粒子的初始缩放比例
        //snowflake.xAcceleration = 200;
        snowflake.emissionRange           = 0.25*M_PI;//周围发射角度
        //snowflake.emissionLatitude = 200;
        snowflake.emissionLongitude       = -M_PI_2/4;//发射角度
        snowflake.spinRange               = 2*M_PI;//子旋转角度范围

        NSString *imageName = [NSString stringWithFormat:@"vp_challenge_like_%d", arc4random_uniform(19)+1];
        snowflake.contents = (id)[[UIImage imageNamed:imageName] CGImage];
        [mArray addObject:snowflake];
    }
    
    emitterLayer.emitterCells  = mArray;
    
    emitterLayer.beginTime = CACurrentMediaTime();
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        emitterLayer.birthRate = 0;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [emitterLayer removeFromSuperlayer];
                });
    });

}

//添加粒子效果
- (void)addEmitter_:(UIButton *)sender {
    CGRect rect = [sender convertRect: sender.bounds toView:self.view];
    
    CAEmitterLayer *likeLayer = [CAEmitterLayer layer];
    likeLayer.emitterShape = kCAEmitterLayerCuboid;
    likeLayer.emitterMode = kCAEmitterLayerOutline;
    likeLayer.emitterSize = CGSizeMake(0, 0);
    likeLayer.emitterPosition = CGPointMake(rect.origin.x+22, rect.origin.y+22);
    likeLayer.renderMode = kCAEmitterLayerUnordered;
    likeLayer.birthRate = 0;
    [self.view.window.layer addSublayer:likeLayer];
    
    NSMutableArray *cellArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 6; i++) {
        CAEmitterCell *likeCell = [CAEmitterCell emitterCell];
        likeCell.birthRate = 8;
        likeCell.lifetime = 2;
        likeCell.lifetimeRange = 0.3;
        likeCell.velocity = 200;
        likeCell.velocityRange = 150;
        likeCell.yAcceleration = 70;
        likeCell.scale = 0.5;
        likeCell.alphaSpeed = -0.3;
        likeCell.spin = i%2 == 0 ? M_PI/2 : -M_PI/2;
        likeCell.spinRange = M_PI/2;
        likeCell.emissionLongitude = M_PI/arc4random_uniform(5);
        likeCell.emissionRange = M_PI;
        NSString *imageName = [NSString stringWithFormat:@"vp_challenge_like_%d", arc4random_uniform(19)+1];
        likeCell.contents = (__bridge id _Nullable)([[UIImage imageNamed:imageName] CGImage]);
        likeCell.name = [NSString stringWithFormat:@"icon%ld", (long)i];
        [cellArray addObject:likeCell];
    }
    likeLayer.emitterCells = cellArray;
    
    likeLayer.beginTime = CACurrentMediaTime();
    likeLayer.birthRate = 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(300 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        likeLayer.birthRate = 0;
    });
    

}

@end
