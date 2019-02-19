//
//  ViewController.m
//  VeryFitPlus
//
//  Created by 杨健 on 16/7/8.
//  Copyright © 2016年 杨健. All rights reserved.
//

#import "ViewController.h"
#import "SearchImage.h"

@interface ViewController ()<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _portraitImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
    [_portraitImageView addGestureRecognizer:portraitTap];
    
}

- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    SearchImage *sImage = [[SearchImage alloc]init];
    [self.view addSubview:sImage];
    if (buttonIndex == 0) {
        sImage.allowsEditing = YES;
        [sImage searchImageWith:0];
    } else if (buttonIndex == 1) {
        sImage.allowsEditing = YES;
        [sImage searchImageWith:1];
    }
    sImage.SearchImageBlock = ^(UIImage *sImage) {
        _portraitImageView.image = sImage;
    };
}

@end
