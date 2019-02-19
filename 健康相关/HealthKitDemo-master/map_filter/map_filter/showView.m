//
//  showView.m
//  map_filter
//
//  Created by zqwl001 on 16/8/4.
//  Copyright © 2016年 ljw. All rights reserved.
//

#import "showView.h"

@implementation showView
+ (showView *)loadView{
    
//    Class class = NSClassFromString(@"showView");
    showView *view = [[[NSBundle mainBundle] loadNibNamed:@"showView" owner:nil options:nil] lastObject];
    return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
