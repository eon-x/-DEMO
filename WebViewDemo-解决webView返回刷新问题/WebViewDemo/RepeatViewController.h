//
//  RepeatViewController.h
//  WebViewDemo
//
//  Created by wuxin on 4/20/16.
//  Copyright © 2016 ChinaNetCenter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepeatViewController : UIViewController


@property (nonatomic, weak) IBOutlet UIButton* button;
@property (nonatomic, weak) IBOutlet UIPickerView* pickerView;
@property (nonatomic, weak) IBOutlet UITextField* textField;
@property (nonatomic, weak) IBOutlet UILabel* label;
-(IBAction) onButton:(UIButton*)button ;

@end
