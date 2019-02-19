//
//  DOSigninManagerV2.h
//  AllSignin
//
//  Created by 柴智权 on 2017/12/19.
//  Copyright © 2017年 xiongze. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DOSigninType) {
    DOSigninGoogle,
    DOSigninTwitter,
    DOSigninFacebook
};

@interface DOSigninManagerV2 : UIViewController

+ (instancetype)shareSigninManager;

typedef void(^SigninBlack)(NSDictionary *infoDict);
@property (nonatomic, copy) SigninBlack signinBlack;

@property(nonatomic,assign) DOSigninType signinType;

- (void)googleLognin;
- (void)googleLognout;

- (void)facebookLognin;
- (void)facebookLognout;

- (void)twitterLognin;
- (void)twitterLognout;

@end
