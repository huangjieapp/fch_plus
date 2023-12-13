//
//  AdvertiseViewController.m
//  zhibo
//
//  Created by 周焕强 on 16/5/17.
//  Copyright © 2016年 zhq. All rights reserved.
//

#import "AdvertiseViewController.h"
#import <WebKit/WebKit.h>

@interface AdvertiseViewController ()

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation AdvertiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = DBGetStringWithKeyFromTable(@"L活动", nil);
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _webView.backgroundColor = [UIColor whiteColor];
    if (!self.adUrl) {
        self.adUrl = @"http://www.baidu.com";
    }
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.adUrl]];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}

- (void)setAdUrl:(NSString *)adUrl
{
    _adUrl = adUrl;
}



@end
