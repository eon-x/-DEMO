//
//  ViewController.m
//  TwitterDemo
//
//  Created by zpp on 17/7/13.
//  Copyright © 2017年 txtws. All rights reserved.
//

#import "ViewController.h"
#import <TwitterKit/TwitterKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
// Twitter提供的登录按钮
//    TWTRLogInButton* logInButton =  [TWTRLogInButton
//                                     
//                                     buttonWithLogInCompletion:
//                                     
//                                     ^(TWTRSession* session, NSError* error) {
//                                         
//                                         if(session) {
//                                             
//                                             NSLog(@"signed in as %@", [session userName]);
//                                             
//                                         } else{
//                                             
//                                             NSLog(@"error: %@", [error localizedDescription]);
//                                             
//                                         }
//                                         
//                                     }];
//    
//    logInButton.center = self.view.center;
//    
//    [self.view addSubview:logInButton];
    
}

//自定义xib按钮触发事件
- (IBAction)loginAction:(id)sender {
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession * _Nullable session, NSError * _Nullable error) {
        if(session){
            NSLog(@"%@已登录",session.userName);
            [self loadTwitterUserWithID:session.userID];
        }  else  {
            NSLog(@"error:%@",error.localizedDescription);
        }
    }];
    
}

//获取Twitter用户信息
- (void)loadTwitterUserWithID:(NSString *)userId{

    TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
    [client loadUserWithID:userId completion:^(TWTRUser * _Nullable user, NSError * _Nullable error) {
        if (user) {
            NSLog(@"头像url:%@",user.profileImageURL);
        }else{
            NSLog(@"error:%@",error.localizedDescription);
        }
    }];
}

//管理多个用户时需要注销用户
- (void)logoutTwitterUser{
    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
    NSString *userID = store.session.userID;
    [store logOutUserID:userID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
