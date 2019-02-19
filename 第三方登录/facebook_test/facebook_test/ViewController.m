//
//  ViewController.m
//  facebook_test
//
//  Created by 柴智权 on 2017/12/18.
//  Copyright © 2017年 xiongze. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //系统提供按钮
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.center = self.view.center;
//    loginButton.readPermissions = @[@"public_profile", @"email"];
//    [self.view addSubview:loginButton];
    
    //登录成功我们可以通过监听FBSDKAccessTokenDidChangeNotification来获取信息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_updateContent:)
                                                 name:FBSDKAccessTokenDidChangeNotification
                                               object:nil];
}

- (IBAction)login:(id)sender {
    FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
    if (token.tokenString.length > 0) {
        [self autoLoginWithToken:token];
    }else
        [self newLogin];
}
- (void)autoLoginWithToken:(FBSDKAccessToken *)token{
    //自动登录逻辑
}
- (void)newLogin{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc]init];
    [login logInWithReadPermissions:@[@"public_profile"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error) {
                                    NSLog(@"process error");
                                }else if (result.isCancelled){
                                    NSLog(@"cancelled");
                                }else{
                                    NSLog(@"logged in");
                                    
                                    FBSDKGraphRequest *fbr = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, gender, picture.type(normal), email,link"}];
                                    [fbr startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                        NSDictionary *userInfo = (NSDictionary *)result;
                                        NSLog(@"userinfo:%@",userInfo);//ID、名称、头像URL、主页URL、性别、
                                    }];
                                }
    }];
}

- (IBAction)logout:(id)sender {
    if ([FBSDKAccessToken currentAccessToken].appID.length > 0) {
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [FBSDKProfile setCurrentProfile:nil];
    }
}

- (void)_updateContent:(NSNotification *)notification {
    NSString *string = [NSString stringWithFormat:@"appid = %@,userID = %@",[FBSDKAccessToken currentAccessToken].appID,[FBSDKAccessToken currentAccessToken].userID];
    NSLog(@"%@",string);
}


@end
