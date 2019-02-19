//
//  ViewController.h
//  JavaScript
//
//  Created by xiongze on 2018/4/13.
//  Copyright © 2018年 aiju_huangjing1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcDelegate <JSExport>

- (void)call;
- (void)getCall:(NSString *)callString;
- (void)clickAddFollowsButton;


@end

@interface ViewController : UIViewController<JSObjcDelegate>

@property (nonatomic, strong) JSContext *jsContext;

@end

