//
//  ViewController.m
//  ShoppingDetailsDemo
//
//  Created by edz on 2017/3/7.
//  Copyright © 2017年 chushenruhua. All rights reserved.
//

#import "ViewController.h"
#import "MJDIYHeader.h"
#import "MJDIYAutoFooter.h"
#import "MJDIYHeader.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScaleSize [UIScreen mainScreen].bounds.size.width/414

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _insideViewHeight.constant = (ScreenHeight-64)*2;
    _tableViewHeight.constant = ScreenHeight-64;
    _parameterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _parameterTableView.tableFooterView = [UITableView new];
    
    _headerView.frame = CGRectMake(0, 0, ScreenWidth, 200*ScaleSize);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UITableView new];
    _tableView.tableHeaderView = _headerView;

    MJDIYAutoFooter *footer = [MJDIYAutoFooter footerWithRefreshingBlock:^{
        [UIView animateWithDuration:0.20 animations:^{
            _scrollView.contentOffset = CGPointMake(0, ScreenHeight-64);
        }];
        [_tableView.mj_footer endRefreshing];
    }];
    footer.triggerAutomaticallyRefreshPercent = 1.0;
    footer.automaticallyRefresh = NO;
    self.tableView.mj_footer = footer;
    
    MJDIYHeader *header = [MJDIYHeader headerWithRefreshingBlock:^{
        [UIView animateWithDuration:0.25 animations:^{
            _scrollView.contentOffset = CGPointMake(0, 0);
        }];
        [_parameterTableView.mj_header endRefreshing];
    }];
    _parameterTableView.mj_header = header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
