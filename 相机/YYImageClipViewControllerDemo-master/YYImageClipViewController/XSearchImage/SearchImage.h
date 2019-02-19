//
//  SearchImage.h
//  VeryFitPlus
//
//  Created by xiongze on 2018/5/10.
//  Copyright © 2018年 aiju_huangjing1. All rights reserved.
//  选择图片类

#import <UIKit/UIKit.h>

@interface SearchImage : UIView

///是否编辑
@property(nonatomic) BOOL allowsEditing;

///0拍照 1选择
- (void)searchImageWith:(NSInteger)index;

///图片回调
@property (copy, nonatomic) void (^SearchImageBlock) (UIImage *sImage);

@end
