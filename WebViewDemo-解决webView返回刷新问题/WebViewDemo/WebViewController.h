//
//  WebViewController.h
//  WebViewDemo
//
//  Created by 吴昕 on 3/24/16.
//  Copyright © 2016 ChinaNetCenter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
{
    
}

@property (nonatomic, weak) IBOutlet UIWebView* webview;
@property (nonatomic, weak) IBOutlet UIButton* gobackButton;
@property (nonatomic, weak) IBOutlet UIButton* goforwardButton;
@property (nonatomic, weak) IBOutlet UIButton* loadButton;
@property (nonatomic, weak) IBOutlet UIButton* reloadButton;

-(IBAction) onGoBack:(UIButton*)button;
-(IBAction) onGoForward:(UIButton*)button;
-(IBAction) onReload:(UIButton*)button;
-(IBAction) onLoad:(UIButton*)button;

@end

