//
//  CGContextDrawPDFReaderController.m
//  PDFViewAndDownload
//
//  Created by Dustin on 17/4/6.
//  Copyright © 2017年 PicVision. All rights reserved.
//

#import "CGContextDrawPDFReaderController.h"
#import "CGContextDrawPDFPageController.h"

@interface CGContextDrawPDFReaderController ()

@end

@implementation CGContextDrawPDFReaderController
@synthesize titleText, fileName;
- (void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.titleText;
    
    if (1) {
        NSURL *url = [NSURL URLWithString:@"http://apitest.dongha.cn:8080/107plus.pdf"];
        CFURLRef refURL = (__bridge_retained CFURLRef)url;//将的到的NSURL转化为CFURLRefrefURL备用
        CGPDFDocumentRef document =CGPDFDocumentCreateWithURL(refURL);//通过CFURLRefrefURL获取文件内容
        CFRelease(refURL);//过河拆桥，释放使用完毕的CFURLRefrefURL，这个东西并不接受自动内存管理，所以要手动释放
        pdfPageModel = [[CGContextDrawPDFPageModel alloc] initWithPDFDocument:document];

    }else{
        CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), (__bridge CFStringRef)self.fileName, NULL, NULL);
        //创建CGPDFDocument对象
        CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
        CFRelease(pdfURL);
        pdfPageModel = [[CGContextDrawPDFPageModel alloc] initWithPDFDocument:pdfDocument];
    }
    
    // UIPageViewControllerSpineLocationMin 单页显示
    NSDictionary *options = [NSDictionary dictionaryWithObject:
                             [NSNumber numberWithInteger: UIPageViewControllerSpineLocationMin]
                                                        forKey: UIPageViewControllerOptionSpineLocationKey];
    //初始化UIPageViewController，UIPageViewControllerTransitionStylePageCurl翻页效果，UIPageViewControllerNavigationOrientationHorizontal水平方向翻页
    pageViewCtrl = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                   navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                 options:options];
    //承载pdf每页内容的控制器
    CGContextDrawPDFPageController *initialViewController = [pdfPageModel viewControllerAtIndex:1];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    //设置UIPageViewController的数据源
    [pageViewCtrl setDataSource:pdfPageModel];
    //设置正反面都有文字
    pageViewCtrl.doubleSided = YES;
    //设置pageViewCtrl的子控制器
    [pageViewCtrl setViewControllers:viewControllers
                           direction:UIPageViewControllerNavigationDirectionReverse
                            animated:NO
                          completion:^(BOOL f){}];
    [self addChildViewController:pageViewCtrl];
    [self.view addSubview:pageViewCtrl.view];
    //当我们向我们的视图控制器容器（就是父视图控制器，它调用addChildViewController方法加入子视图控制器，它就成为了视图控制器的容器）中添加（或者删除）子视图控制器后，必须调用该方法，告诉iOS，已经完成添加（或删除）子控制器的操作。
    [pageViewCtrl didMoveToParentViewController:self];
}

- (void) viewDidUnload {
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
