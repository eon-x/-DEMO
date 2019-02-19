//
//  WaveView.m
//  WaveAnimation
//
//  Created by Dustin on 17/4/1.
//  Copyright © 2017年 PicVision. All rights reserved.
//

#import "WaveView.h"

@interface WaveView()

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *downLabel;
@property (nonatomic, strong) CADisplayLink *waveDisplaylink;
@property (nonatomic, strong) CAShapeLayer *firstWaveLayer;
@property (nonatomic, strong) CAShapeLayer *secondWaveLayer;
@property (nonatomic, strong) CAShapeLayer *thirdWaveLayer;
@property (nonatomic, strong) CAShapeLayer *firstWaveLayer_label;
@property (nonatomic, strong) CAShapeLayer *secondWaveLayer_label;
@property (nonatomic, strong) CAShapeLayer *thirdWaveLayer_label;

@end

@implementation WaveView
{
    CGFloat waveW ;//水纹周期
    CGFloat currentK; //当前波浪高度Y
    CGFloat waterWaveWidth; //水纹宽度

    CGFloat waveA;//第一个波浪图层的水纹振幅A
    CGFloat waveB;//第二个波浪图层的水纹振幅B
    CGFloat waveC;
    CGFloat offsetXA; //第一个波浪图层的位移A
    CGFloat offsetXB;//第二个波浪图层的位移B
    CGFloat offsetXC;
    CGFloat waveSpeedA;//第一个波浪图层的水纹速度A
    CGFloat waveSpeedB;//第二个波浪图层的水纹速度B
    CGFloat waveSpeedC;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        self.layer.masksToBounds  = YES;
        [self setUp];
    }
    
    return self;
}

-(void)setProgressNum:(NSInteger)progressNum{
    _progressNum = progressNum;
    
    currentK = self.frame.size.height*(1-(_progressNum /100.0));
    
    if (currentK < 0) {
        currentK = 0;
    }
    
    self.topLabel.text = [NSString stringWithFormat:@"%ld %%",_progressNum];
    self.downLabel.text = [NSString stringWithFormat:@"%ld %%",_progressNum];
}

-(UILabel *)downLabel{
    if (!_downLabel) {
        UILabel *label = [[UILabel alloc]initWithFrame:self.bounds];
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:40];
        _downLabel = label;
        [self addSubview:_downLabel];
    }
    return _downLabel;
}

-(UILabel *)topLabel{
    if (!_topLabel) {
        UILabel *label = [[UILabel alloc]initWithFrame:self.bounds];
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:40];
        label.layer.masksToBounds = YES;
        _topLabel = label;
        [self addSubview:_topLabel];
    }
    return _topLabel;
}

-(void)setUp
{
    
    //设置波浪的宽度
    waterWaveWidth = self.frame.size.width;
    //设置周期影响参数，2π/waveW是一个周期
    waveW = 1/30.0;
    //设置波浪纵向位置
    currentK = self.frame.size.height*0.5;//屏幕居中
//    currentK = self.frame.size.height;
    
    //初始化偏移量影响参数，平移的单位为offsetXA/waveW,而不是offsetXA
    offsetXA = 0; offsetXB = 1; offsetXC = 1.5;
    
    //设置波纹流动速度
    waveSpeedA = 0.1; waveSpeedB = 0.15; waveSpeedC = 0.2;

    //设置波纹振幅
    waveA = 10; waveB = 10; waveC = 10;
    
//    _firstWaveLayer_label = [CAShapeLayer layer];
//    _firstWaveLayer_label.fillColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:255/255.0 alpha:0.1].CGColor;
//    [self.layer addSublayer:_firstWaveLayer_label];
//
//    _secondWaveLayer_label = [CAShapeLayer layer];
//    _secondWaveLayer_label.fillColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:255/255.0 alpha:0.3].CGColor;
//    [self.layer addSublayer:_secondWaveLayer_label];
//
//    _thirdWaveLayer_label = [CAShapeLayer layer];
//    _thirdWaveLayer_label.fillColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:255/255.0 alpha:0.5].CGColor;
//    [self.layer addSublayer:_thirdWaveLayer_label];
    
    self.downLabel.text = @"0 %";
    self.topLabel.text = @"0 %";

    _firstWaveLayer = [CAShapeLayer layer];
    _firstWaveLayer.fillColor = [UIColor blueColor].CGColor;
    [self.layer addSublayer:_firstWaveLayer];

    _secondWaveLayer = [CAShapeLayer layer];
    _secondWaveLayer.fillColor = [UIColor greenColor].CGColor;
    [self.layer addSublayer:_secondWaveLayer];

    _thirdWaveLayer = [CAShapeLayer layer];
    _thirdWaveLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:_thirdWaveLayer];
    
    /*
     *启动定时器
     */
    _waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    _waveDisplaylink.frameInterval = 2;//设置定时器刷新的频率
    [_waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];//添加到RunLoop中
}

#pragma mark 实现波纹动画
-(void)getCurrentWave:(CADisplayLink *)displayLink
{
    //实时的位移
    offsetXA += waveSpeedA;
    offsetXB += waveSpeedB;
    offsetXC += waveSpeedC;
    [self setCurrentWaveLayerPath];
}

//重新绘制波浪图层
-(void)setCurrentWaveLayerPath
{
    //创建第一个路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = currentK;
    //将点移动到 x=0,y=currentK的位置
    CGPathMoveToPoint(path, nil, 0, y);
    for (NSInteger x = 0.0f; x<=waterWaveWidth; x++) {
        //正玄波浪公式
        y = waveA * sin(waveW * x+ offsetXA)+currentK;
        //将点连成线
        CGPathAddLineToPoint(path, nil, x, y);
    }
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    _firstWaveLayer.path = path;
    _firstWaveLayer.mask = _topLabel.layer;
    _topLabel.frame = self.bounds;
    _firstWaveLayer_label.path = path;
    
    
    //创建第二个路径
    CGMutablePathRef path1 = CGPathCreateMutable();
    
    //将点移动到 x=offsetXB/waveW=30,y=currentK的位置
    CGPathMoveToPoint(path1, nil, 0, y);
    for (NSInteger x = 0.0f; x<=waterWaveWidth; x++) {
        //正玄波浪公式
        y = waveB * sin(waveW * x+ offsetXB)+currentK;
        //将点连成线
        CGPathAddLineToPoint(path1, nil, x, y);
    }
    CGPathAddLineToPoint(path1, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path1, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path1);
    _secondWaveLayer.path = path1;
//    _secondWaveLayer.mask = _topLabel.layer;
//    _topLabel.frame = self.bounds;
    _secondWaveLayer_label.path = path1;
    
    //创建第三个路径
    CGMutablePathRef path2 = CGPathCreateMutable();
    
    //将点移动到 x=offsetXB/waveW=30,y=currentK的位置
    CGPathMoveToPoint(path2, nil, 0, y);
    for (NSInteger x = 0.0f; x<=waterWaveWidth; x++) {
        //正玄波浪公式
        y = waveC * sin(waveW * x+ offsetXC)+currentK;
        //将点连成线
        CGPathAddLineToPoint(path2, nil, x, y);
    }
    CGPathAddLineToPoint(path2, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path2, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path2);
    _thirdWaveLayer.path = path2;
//    _thirdWaveLayer.mask = _topLabel.layer;
//    _topLabel.frame = self.bounds;
    _thirdWaveLayer_label.path = path2;

    CGPathRelease(path);
    CGPathRelease(path1);
    CGPathRelease(path2);
     
}

#pragma mark 销毁定时器
-(void)dealloc
{
    [_waveDisplaylink invalidate];
}


@end
