//
//  DOSigninManagerV2.m
//  AllSignin
//
//  Created by 柴智权 on 2017/12/19.
//  Copyright © 2017年 xiongze. All rights reserved.
//

#import "DOSigninManagerV2.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <TwitterKit/TwitterKit.h>

@interface DOSigninManagerV2 ()<GIDSignInDelegate,GIDSignInUIDelegate>

@end

static DOSigninManagerV2 *_signinManager;

@implementation DOSigninManagerV2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_signinManager == nil) {
            _signinManager = [super allocWithZone:zone];
            
            //google
            GIDSignIn *signIn = [GIDSignIn sharedInstance];
            signIn.shouldFetchBasicProfile = YES;
            signIn.delegate = _signinManager;
            signIn.uiDelegate = _signinManager;
            
            //facebook
            //登录成功我们可以通过监听FBSDKAccessTokenDidChangeNotification来获取信息
//            [[NSNotificationCenter defaultCenter] addObserver:self
//                                                     selector:@selector(_updateContent:)
//                                                         name:FBSDKAccessTokenDidChangeNotification
//                                                       object:nil];
            
        }
    });
    return _signinManager;
}
+ (instancetype)shareSigninManager{
    return [[self alloc] init];
}

- (void)googleLognin{
    [[GIDSignIn sharedInstance] signIn];
}
- (void)googleLognout{
    [[GIDSignIn sharedInstance] signOut];
}

- (void)facebookLognin{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc]init];
    [login logInWithReadPermissions:@[@"public_profile"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                DOSigninManagerV2 *signinManager = [DOSigninManagerV2 shareSigninManager];
                                if (error) {
                                    NSLog(@"process error");
                                    signinManager.signinBlack(@{@"LOG":@"process error"});

                                }else if (result.isCancelled){
                                    NSLog(@"cancelled");
                                    signinManager.signinBlack(@{@"LOG":@"cancelled"});

                                }else{
                                    NSLog(@"logged in");
                                    FBSDKGraphRequest *fbr = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, gender, picture.type(normal), email,link"}];
                                    [fbr startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                        NSDictionary *userInfo = (NSDictionary *)result;//ID、名称、头像URL、主页URL、性别
                                        NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
                                        [mDict setObject:userInfo[@"id"] forKey:@"userID"];
                                        [mDict setObject:userInfo[@"gender"] forKey:@"gender"];
                                        [mDict setObject:userInfo[@"name"] forKey:@"name"];
                                        [mDict setObject:userInfo[@"picture"][@"data"][@"url"] forKey:@"imageURL"];
                                        signinManager.signinBlack(mDict);
                                    }];
                                }
                            }];
}
- (void)facebookLognout{
    if ([FBSDKAccessToken currentAccessToken].appID.length > 0) {
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [FBSDKProfile setCurrentProfile:nil];
    }
}

- (void)twitterLognin{
    
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
            [client loadUserWithID:client.userID completion:^(TWTRUser * _Nullable user, NSError * _Nullable error) {
                DOSigninManagerV2 *signinManager = [DOSigninManagerV2 shareSigninManager];
                if (user) {
                    //user 包含用户ID、昵称、登录名、用户头像url
                    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
                    [mDict setObject:user.userID forKey:@"userID"];
                    [mDict setObject:user.name forKey:@"name"];
                    [mDict setObject:user.profileImageURL forKey:@"imageURL"];
                    signinManager.signinBlack(mDict);
                }else{
                    signinManager.signinBlack(@{@"LOG":[error localizedDescription]});
                }
            }];;
        } else {
            DOSigninManagerV2 *signinManager = [DOSigninManagerV2 shareSigninManager];
            signinManager.signinBlack(@{@"LOG":[error localizedDescription]});
        }
    }];
}
- (void)twitterLognout{
    
    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
    NSString *userID = store.session.userID;
    [store logOutUserID:userID];
}

#pragma mark - google GIDSignInDelegate

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    DOSigninManagerV2 *signinManager = [DOSigninManagerV2 shareSigninManager];
    if (error) {
        NSString *text = [NSString stringWithFormat:@"Status: Authentication error: %@", error];
        signinManager.signinBlack(@{@"LOG":text});

    }else{
        GIDGoogleUser *googleUser = [[GIDSignIn sharedInstance] currentUser];
        if (googleUser.authentication) {
            if (signinManager.signinBlack) {
                NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
                [mDict setObject:googleUser.userID forKey:@"userID"];
                [mDict setObject:googleUser.profile.email forKey:@"email"];
                [mDict setObject:googleUser.profile.name forKey:@"name"];
                [mDict setObject:[googleUser.profile imageURLWithDimension:200] forKey:@"imageURL"];
                signinManager.signinBlack(mDict);
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
