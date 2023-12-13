//
//  ViewTheContractViewController.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2023/5/12.
//  Copyright © 2023 脉居客. All rights reserved.
//

#import "ViewTheContractViewController.h"

#import <WebKit/WebKit.h>

#import "WXApi.h"

@interface ViewTheContractViewController ()
/** <#注释#> */
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation ViewTheContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看合同";
    self.view.backgroundColor = [UIColor whiteColor];
    _webView = [WKWebView new];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.htUrl]]];
    @weakify(self);
    UIButton *button = [UIButton new];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    [button setTitle:@"分享" forState:UIControlStateNormal];
    button.titleLabel.font = KNomarlFont;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self share];
    }];
}

- (void)share {
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = self.htUrl;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"合同";
    message.description = @"合同";
    [message setThumbImage:[UIImage imageNamed:@"logo-2"]];
    message.mediaObject = webpageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req completion:nil];
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
