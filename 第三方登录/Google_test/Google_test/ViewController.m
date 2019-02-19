//
//  ViewController.m
//  Google_test
//
//  Created by 柴智权 on 2017/12/18.
//  Copyright © 2017年 xiongze. All rights reserved.
//

#import "ViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>

@interface ViewController ()<GIDSignInDelegate,GIDSignInUIDelegate>

//google 自带登录按钮
@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    signIn.shouldFetchBasicProfile = YES;
    signIn.delegate = self;
    signIn.uiDelegate = self;
}

//自己创建按钮登录
- (IBAction)signin:(id)sender {
    [[GIDSignIn sharedInstance] signIn];
}
- (IBAction)signout:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
}

#pragma mark - GIDSignInDelegate

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error) {
        NSString *text = [NSString stringWithFormat:@"Status: Authentication error: %@", error];
        NSLog(@"%@",text);
    }else
        [self reportAuthStatus];
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    NSString *text;
    if (error) {
        text = [NSString stringWithFormat:@"Status: Failed to disconnect: %@", error];
    } else {
        text = [NSString stringWithFormat:@"Status: Disconnected"];
    }
    NSLog(@"%@",text);

    [self reportAuthStatus];
}

- (void)reportAuthStatus {
    GIDGoogleUser *googleUser = [[GIDSignIn sharedInstance] currentUser];
    NSString *text;
    if (googleUser.authentication) {
        text = @"Status: Authenticated";
    } else {
        // To authenticate, use Google+ sign-in button.
        text = @"Status: Not authenticated";
    }
    NSLog(@"%@",text);
}

// Implement these methods only if the GIDSignInUIDelegate is not a subclass of UIViewController.

// Stop the UIActivityIndicatorView animation that was started when the user pressed the Sign In button
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    NSLog(@"%@",error);
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
