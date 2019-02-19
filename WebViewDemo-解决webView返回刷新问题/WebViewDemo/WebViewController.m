//
//  WebViewController.m
//  WebViewDemo
//
//  Created by 吴昕 on 3/24/16.
//  Copyright © 2016 ChinaNetCenter. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>

@end

@implementation WebViewController
{
    BOOL _pageCacheDisable;
}
@synthesize webview;
@synthesize reloadButton;
@synthesize gobackButton;
@synthesize goforwardButton;

- (void)viewDidLoad {
    
    _pageCacheDisable = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.webview.delegate = self;
    self.webview.scalesPageToFit = YES;
    
    self.webview.mediaPlaybackRequiresUserAction = YES;
    self.webview.allowsInlineMediaPlayback = NO;
    self.webview.backgroundColor = [UIColor redColor];
    
    NSString *tt = @"https://m.taobao.com";
    NSString *s = @"http://apitest.dongha.cn:8080/prd/veryfitplus/instructions.html?code=1&productId=572&model=0";
    [self.webview loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:s]]];
    if (_pageCacheDisable) {
        id webView = [self.webview valueForKeyPath:@"_internal.browserView._webView"];
        id preferences = [webView valueForKey:@"preferences"];
        [preferences performSelector:@selector(_postCacheModelChangedNotification)];
        //_postCacheModelChangedNotification 构建版本审核不通过
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) onGoBack:(UIButton*)button {
    [self.webview goBack];
}

-(IBAction) onGoForward:(UIButton*)button {
    [self.webview goForward];
}

-(IBAction) onLoad:(UIButton*)button {
//    [self.webview loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.toutiao.com"]]];
    [self.webview loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://m.taobao.com"]]];  
}

-(IBAction) onReload:(UIButton *)button {
    [self.webview reload];
}


//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    NSLog(@"shouldStartLoadWithRequest -- >  %@", request.URL.absoluteString);
//    return YES;
//}
//
//- (void)webViewDidStartLoad:(UIWebView *)webView {
//    NSLog(@"webViewDidStartLoad -- >");
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSLog(@"shouldStartLoadWithRequest -- >");
//}

@end
