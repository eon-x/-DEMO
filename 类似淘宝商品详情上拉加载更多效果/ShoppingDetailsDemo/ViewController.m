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
        [UIView animateWithDuration:.25 animations:^{
            _scrollView.contentOffset = CGPointMake(0, ScreenHeight-64);
        } completion:^(BOOL finished) {
            [_tableView.mj_footer endRefreshing];
        }];
    }];
    footer.triggerAutomaticallyRefreshPercent = 1.0;
    footer.automaticallyRefresh = NO;
    self.tableView.mj_footer = footer;
    
    MJDIYHeader *header = [MJDIYHeader headerWithRefreshingBlock:^{
        [UIView animateWithDuration:.25 animations:^{
            _scrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            [_parameterTableView.mj_header endRefreshing];
        }];
    }];
    _parameterTableView.mj_header = header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 16;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if (tableView == _parameterTableView) {
        cell.textLabel.text = [NSString stringWithFormat:@"BBBBBBBBBBBBBBBB%ld行",indexPath.row];
    }
    else{
        cell.textLabel.text = [NSString stringWithFormat:@"第AAAAAAAAAAAAAA%ld行",indexPath.row];
    }
    return cell;
}

@end
