//
//  RepeatViewController.m
//  WebViewDemo
//
//  Created by wuxin on 4/20/16.
//  Copyright © 2016 ChinaNetCenter. All rights reserved.
//

#import "RepeatViewController.h"

@interface RepeatViewController () <UIPickerViewDelegate,
                                    UIPickerViewDataSource,
                                    NSURLSessionDownloadDelegate>

@end

@implementation RepeatViewController
{
    NSArray* _urls;
    NSInteger _repeat;
    NSInteger _urlIndex;
    NSInteger _selectedRow;
    NSInteger _totalRecvBytes;
    NSURLSessionConfiguration*  _sessionConfig;
    NSURLSession*               _session;
    NSURLRequest*               _request;
    NSURLSessionDataTask*       _task;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _urls = @[@"http://www.baidu.com",
              @"http://b.hiphotos.baidu.com/image/pic/item/d788d43f8794a4c224a6a42b0cf41bd5ad6e392c.jpg",
              @"http://c.hiphotos.baidu.com/image/pic/item/203fb80e7bec54e7a488c31abb389b504fc26a4a.jpg",
              @"http://c.hiphotos.baidu.com/image/pic/item/32fa828ba61ea8d3af341f0e950a304e251f58a1.jpg",
              @"http://a.hiphotos.baidu.com/image/pic/item/03087bf40ad162d9f285772914dfa9ec8a13cd9f.jpg",
              @"http://a.hiphotos.baidu.com/image/pic/item/4a36acaf2edda3cc146c802d02e93901213f9236.jpg"
              ];
    
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    _urlIndex = 0;
    _selectedRow = 0;
    _repeat = 100;
    _textField.text = @"100";
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"";
    [self initSession];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) onButton:(UIButton*)button {
    NSInteger count = [self.textField.text integerValue];
    _urlIndex = 0;
    _repeat = count <= 0 ? 100 : count;
    _totalRecvBytes = 0;
    _label.text = @"";

    [self start];
}

#pragma mark - UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _urls.count + 1;
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return kScreenWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 24;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2, 44)];
    if (row < _urls.count) {
        label.text = _urls[row];
    } else {
        label.text = @"循环全部链接";
    }
    label.textAlignment = NSTextAlignmentCenter;

    label.font = UIDefaultFont(15);
    
    label.textColor = UIColorFromHex(0x333333);
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _selectedRow = row;
}


- (void) initSession {
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    _sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    _sessionConfig.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    _sessionConfig.allowsCellularAccess = YES;
    _sessionConfig.URLCache = nil;
    _session = [NSURLSession sessionWithConfiguration:_sessionConfig delegate:self delegateQueue:queue];

}

- (NSURLRequest *)request
{
    //创建请求
    NSURL *url = nil;
    if (_selectedRow >= _urls.count) {
        url = [NSURL URLWithString:_urls[_urlIndex % _urls.count]];
        _urlIndex = (_urlIndex + 1) % _urls.count;
    } else {
        url = [NSURL URLWithString:_urls[_selectedRow]];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:30];
    return request;
}

-(void)start {
    _task = [_session dataTaskWithRequest:[self request]];
    [_task resume];
}

- (void)cancel {
    if (_task) {
        [_task cancel];
        _task = nil;
    }
}

#pragma mark NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
            willCacheResponse:(NSCachedURLResponse *)proposedResponse
            completionHandler:(void (^)(NSCachedURLResponse * __nullable cachedResponse))completionHandler {
    
    NSLog(@"willCacheResponse: %@",proposedResponse);
    if (completionHandler) {
        completionHandler(proposedResponse);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
            didReceiveResponse:(NSURLResponse *)response
            completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    _totalRecvBytes += data.length;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    NSLog(@"fail  -> error(%@)\n", error);
    if (!error && task.state == NSURLSessionTaskStateCompleted) {
        // 下载一个文件结束
        NSString* text = nil;
        _repeat -= 1;
        [self cancel];
        if (_repeat > 0) {
            [self start];
            if (_totalRecvBytes > 1024 * 1024 * 1024) {
                text = [NSString stringWithFormat:@"接收到%0.2lf GB", _totalRecvBytes * 1.0 / (1024*1024*1024)];
            } else if (_totalRecvBytes > 1024 * 1024) {
                text = [NSString stringWithFormat:@"接收到%0.2lf MB", _totalRecvBytes * 1.0 / (1024*1024)];
            } else if (_totalRecvBytes > 1024) {
                text = [NSString stringWithFormat:@"接收到%0.2lf KB", _totalRecvBytes * 1.0 / (1024)];
            } else {
                text = [NSString stringWithFormat:@"接收到%d Bytes", _totalRecvBytes];
            }
        } else {
            NSLog(@"test end....\n");
            text = @"测试结束！";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _label.text = text;
        });
        NSLog(@"session download task complete....");
    } else if (error.code != NSURLErrorCancelled || task.state == NSURLSessionTaskStateCanceling) {
        
    }
}


@end
