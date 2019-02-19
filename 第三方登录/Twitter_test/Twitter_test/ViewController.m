//
//  ViewController.m
//  Twitter_test
//
//  Created by 柴智权 on 2017/12/18.
//  Copyright © 2017年 xiongze. All rights reserved.
//

#import "ViewController.h"
#import <TwitterKit/TwitterKit.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
    NSString *userID = store.session.userID;
    if (userID.length > 0) {
        NSLog(@"用户已经登录了");
    }
}
- (IBAction)loginTwitter:(id)sender {
//    自定义按钮事件
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            [self loadTwitterUserWithID:session.userID];
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}
- (IBAction)logoutTwitter:(id)sender {
    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
    NSString *userID = store.session.userID;
    [store logOutUserID:userID];
}

//获取Twitter用户信息
- (void)loadTwitterUserWithID:(NSString *)userId{
    TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
    [client loadUserWithID:userId completion:^(TWTRUser * _Nullable user, NSError * _Nullable error) {
        if (user) {
            //user 包含用户ID、昵称、登录名、用户头像url
            NSLog(@"头像url:%@",user.profileImageURL);
        }else{
            NSLog(@"error:%@",error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
