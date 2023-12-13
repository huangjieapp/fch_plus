//
//  DetailWebviewViewController.m
//  Mcr_2
//
//  Created by bipi on 2017/5/27.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import "DetailWebviewViewController.h"

@interface DetailWebviewViewController ()<WKUIDelegate, WKNavigationDelegate,MBProgressHUDDelegate>
{
    
    MBProgressHUD *mbprogress;
    NSString* webViewUrl;
}

@end

@implementation DetailWebviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    mbprogress= [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:mbprogress];
    mbprogress.delegate = self;
    mbprogress.color=[UIColor whiteColor];
    
    
    
    
}

- (void)loadString:(NSString *)str
{
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:webViewUrl]];
    [self.WebView loadRequest:request];
    [self.WebView setUserInteractionEnabled:YES];
    self.WebView.UIDelegate=self;
    self.WebView.navigationDelegate=self;
}

-(void)createWebView{
    
    //    webViewUrl = [webViewUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:webViewUrl]];
    [self.WebView loadRequest:request];
    [self.WebView setUserInteractionEnabled:YES];
    self.WebView.UIDelegate=self;
    self.WebView.navigationDelegate=self;
}
#pragma mark开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    [mbprogress show:YES];
    
    
}

#pragma mark加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [mbprogress hide:YES];
//    self.title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [mbprogress hide:YES];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
