//
//  ViewController.m
//  WaveAnimation
//
//  Created by Dustin on 17/4/1.
//  Copyright © 2017年 PicVision. All rights reserved.
//

#import "ViewController.h"
#import "WaveView.h"

@interface ViewController (){
    WaveView *waveView;
}
@property (nonatomic, assign) NSInteger progressNum;//%比值
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    waveView = [[WaveView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, (self.view.frame.size.height-self.view.frame.size.width/2)/2, self.view.frame.size.width/2, self.view.frame.size.width/2)];
    waveView.layer.cornerRadius = self.view.frame.size.width/4;
    [self.view addSubview:waveView];
    
    _progressNum = 0;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _progressNum = _progressNum + 1;
    waveView.progressNum = _progressNum;
    
}



@end
