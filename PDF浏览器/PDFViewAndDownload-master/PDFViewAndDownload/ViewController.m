//
//  ViewController.m
//  PDFViewAndDownload
//
//  Created by Dustin on 17/4/6.
//  Copyright © 2017年 PicVision. All rights reserved.
//

#import "ViewController.h"
#import "ScanViewController.h"
#import "DownloadViewController.h"
#import "Masonry.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
}

#pragma mark 创建UI
- (void)creatUI{
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanBtn setBackgroundColor:[UIColor grayColor]];
    [scanBtn setTitle:@"浏览" forState:UIControlStateNormal];
    scanBtn.layer.cornerRadius = 2;
    [scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(jumpToScanVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanBtn];
    
    UIButton *downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downloadBtn.hidden = YES;
    [downloadBtn setBackgroundColor:[UIColor purpleColor]];
    [downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    downloadBtn.layer.cornerRadius = 2;
    [downloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [downloadBtn addTarget:self action:@selector(jumpToDownloadVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downloadBtn];
    
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.width.equalTo(@200);
        make.height.equalTo(@40);
        make.top.offset(200);
    }];
    
    [downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.width.equalTo(@200);
        make.height.equalTo(@40);
        make.top.equalTo(scanBtn.mas_bottom).offset(20);
    }];
    
}

#pragma mark 跳到浏览器控制器
- (void)jumpToScanVC:(UIButton *)sender{
    ScanViewController *scanVC = [[ScanViewController alloc] init];
    [self presentViewController:scanVC animated:YES completion:nil];
}

#pragma amek 跳到下载控制器
- (void)jumpToDownloadVC:(UIButton *)sender{
    DownloadViewController *downloadVC = [[DownloadViewController alloc] init];
    [self presentViewController:downloadVC animated:YES completion:nil];
    
}


@end
