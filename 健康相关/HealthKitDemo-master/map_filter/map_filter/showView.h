//
//  showView.h
//  map_filter
//
//  Created by zqwl001 on 16/8/4.
//  Copyright © 2016年 ljw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface showView : UIView
@property (weak, nonatomic) IBOutlet UILabel *existStpNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *addStepNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *btn;
+ (showView *)loadView;
@end
