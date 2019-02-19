//
//  ViewController.m
//  DOSigninFW
//
//  Created by 柴智权 on 2017/12/20.
//  Copyright © 2017年 xiongze. All rights reserved.
//

#import "ViewController.h"
#import "DOSigninManagerV2.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)googleSignin:(id)sender {
    DOSigninManagerV2 *signinManager = [DOSigninManagerV2 shareSigninManager];
    signinManager.signinType = DOSigninGoogle;
    [signinManager googleLognin];
    signinManager.signinBlack = ^(NSDictionary *infoDict) {
        NSLog(@"%@",infoDict);
    };
}
- (IBAction)googleSignout:(id)sender {
    DOSigninManagerV2 *signinManager = [DOSigninManagerV2 shareSigninManager];
    [signinManager googleLognout];
}
- (IBAction)facebookSignin:(id)sender {
    DOSigninManagerV2 *signinManager = [DOSigninManagerV2 shareSigninManager];
    signinManager.signinType = DOSigninFacebook;
    [signinManager facebookLognin];
    signinManager.signinBlack = ^(NSDictionary *infoDict) {
        NSLog(@"%@",infoDict);
    };
}
- (IBAction)facebookSignout:(id)sender {
    DOSigninManagerV2 *signinManager = [DOSigninManagerV2 shareSigninManager];
    [signinManager facebookLognout];
}

- (IBAction)twitterSignin:(id)sender {
    DOSigninManagerV2 *signinManager = [DOSigninManagerV2 shareSigninManager];
    signinManager.signinType = DOSigninTwitter;
    [signinManager twitterLognin];
    signinManager.signinBlack = ^(NSDictionary *infoDict) {
        NSLog(@"%@",infoDict);
    };
}
- (IBAction)switterSignput:(id)sender {
    DOSigninManagerV2 *signinManager = [DOSigninManagerV2 shareSigninManager];
    [signinManager twitterLognout];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
