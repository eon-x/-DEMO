//
//  ViewController.m
//  JavaScript
//
//  Created by xiongze on 2018/4/13.
//  Copyright © 2018年 aiju_huangjing1. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
-(void)viewDidAppear:(BOOL)animated{
    
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"rankindex" ofType:@"html"];
//    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]] ;

    NSString * AnswerURLstring = @"http://cnpywm.natappfree.cc/Rank-swiper/rankindex.html";
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:AnswerURLstring]];
    
    [self.webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"VeryFitPlus"] = self;//xiongze ： JS调用OC方法桥梁，JS里面一定要一样
    //OC需要给JS调用的方法，一定要放着@protocol JSObjcDelegate <JSExport>里面

    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

- (void)call{
    NSLog(@"call");
    
    // 之后在回调js的方法Callback把内容传出去
    JSValue *Callback = self.jsContext[@"Callback"];//Callback ： 为JS里面的方法

    //传值给web端
    [Callback callWithArguments:@[@"OC给H5传值回调完成"]];
}


- (void)getCall:(NSString *)callString{
    NSLog(@"Get:%@", callString);
    
    // 成功回调js的方法Callback
//    JSValue *Callback = self.jsContext[@"Callback"];//alerCallback ： 为JS里面的方法
//    [Callback callWithArguments:nil];
    
//    直接添加提示框
//    NSString *str = @"alert('OC添加JS提示成功')";
//    [self.jsContext evaluateScript:str];

}

- (void)clickAddFollowsButton{
    NSLog(@"c---------clickAddFollowsButton");
}

@end
