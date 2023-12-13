//
//  ReportDetailViewController.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/11.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "ReportDetailViewController.h"


@interface ReportDetailViewController ()<MBProgressHUDDelegate, WKUIDelegate, WKNavigationDelegate>

@property(nonatomic,strong)MBProgressHUD*HUD;

@end

@implementation ReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.HUD=[[MBProgressHUD alloc]initWithView:[UIApplication sharedApplication].delegate.window];
	[[UIApplication sharedApplication].delegate.window addSubview:_HUD];
	self.HUD.delegate=self;
	self.HUD.dimBackground=NO;
	self.HUD.userInteractionEnabled=NO;
	[self.HUD show:NO];
        self.automaticallyAdjustsScrollViewInsets=NO;

    switch (self.webType) {
        case 0:{
            self.title=@"客户报表";
            break;}
        case 1:{
            self.title=@"流量报表";
            break;}
        case 2:{
            self.title=@"交易报表";
            break;}
        case 3:{
            self.title=@"市场报表";
            break;}
        case 4:{
            self.title=@"到店报表";
            break;}
        case 5:{
            self.title=@"绩效榜单";
            break;}
    
        default:
            break;
    }
    
    
    //接口
    [self getDatas];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.HUD show:NO];
    [self.HUD removeFromSuperview];
}


#pragma mark  --datas
-(void)getDatas{
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"RptWebService-getRptUrl"];
	[dict setObject:@{@"TYPE" : [NSString stringWithFormat:@"%ld",self.webType]} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf loadWebView:data[@"URL"]];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
    
    
    
}

- (void)loadWebView:(NSString *)str {
	if (![str hasPrefix:@"http://"]) {
		str = [NSString stringWithFormat:@"http://%@",str];
	}
	NSURL *url = [NSURL URLWithString:str];
	// 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[self.webView loadRequest:request];
}

#pragma mark  --delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    MyLog(@"1");
	
	
    [self.HUD show:YES];
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
     MyLog(@"2");
    [self.HUD show:NO];
    [self.HUD removeFromSuperview];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
     MyLog(@"3");
    [self.HUD show:NO];
    [self.HUD removeFromSuperview];
    
//    [JRToast showWithText:error.localizedDescription];
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

#pragma mark  -- set
-(WKWebView *)webView{
    if (!_webView) {
        WKWebView*webView= [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64)];
        [self.view addSubview:webView];
//        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(self.view);
//            make.height.equalTo(self.view);
//            make.center.equalTo(self.view);
//            
//        }];
        webView.UIDelegate=self;
        webView.navigationDelegate = self;
        _webView=webView;
        
    }
    
    return _webView;
}


@end
