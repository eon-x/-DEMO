//
//  ViewController.h
//  ShoppingDetailsDemo
//
//  Created by edz on 2017/3/7.
//  Copyright © 2017年 chushenruhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *insideView;
@property (weak, nonatomic) IBOutlet UIView *twoView;

@property (weak, nonatomic) IBOutlet UITableView *parameterTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *insideViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@end

