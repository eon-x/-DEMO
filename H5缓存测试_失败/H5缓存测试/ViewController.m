//
//  ViewController.m
//  H5缓存测试
//
//  Created by xiongze on 2018/4/25.
//  Copyright © 2018年 xiongze. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *urlStr = @"http://apitest.dongha.cn:8080/prd/veryfitplus/illustrate.html?code=1&firmwreId=572";
    NSURL *url = [NSURL URLWithString:urlStr];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
//    [_webView loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0]];
    
    /*
     
     看看 AFN 有没有相关功能
     
     NSURLRequestReturnCacheDataDontLoad
     
     https://blog.csdn.net/pjk1129/article/details/50674835
     
     https://www.jianshu.com/p/8a7594df4659
     
     */
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
