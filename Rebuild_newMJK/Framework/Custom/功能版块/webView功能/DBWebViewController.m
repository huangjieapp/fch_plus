//
//  DBWebViewController.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/20.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBWebViewController.h"

#import "NoticeInfoModel.h"

#import <WebKit/WebKit.h>

@interface DBWebViewController ()
/** scrollView*/
@property (nonatomic, strong) UIScrollView *scrollView;
/** <#备注#>*/
@property (nonatomic, assign) CGFloat height;
/** <#备注#>*/
@property (nonatomic, strong) NSMutableArray *imageViewArray;

@end

@implementation DBWebViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
	[self.view addSubview:self.scrollView];
	
	for (int i = 0; i < self.model.urlList.count; i++) {
		NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.urlList[i]]];
		
		UIImage *image = [UIImage imageWithData:data];
		
		UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, i * (KScreenWidth + 100),image.size.width / (image.size.width / KScreenWidth), image.size.height / (image.size.height / KScreenHeight))];
		imageView.image = image;
		[self.scrollView addSubview:imageView];
		[self.imageViewArray addObject:imageView];
		//		[imageView sd_setImageWithURL:[NSURL URLWithString:self.model.urlList[i]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		//			imageView.frame = CGRectMake(0, i * (KScreenWidth + 100), (1 - image.size.width / KScreenWidth) *  image.size.width, (1 - image.size.height / KScreenHeight) * image.size.height);
		//		}];
		//		[imageView sd_setImageWithURL:[NSURL URLWithString:self.model.urlList[i]]];
		self.height = self.height + imageView.frame.size.height;
	}
	
	//	[self.scrollView addSubview:self.webView];
	self.scrollView.contentSize = CGSizeMake(KScreenWidth, self.height + KScreenHeight);
	
	MyLog(@"%@",self.urlStr);
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
	[self.webView loadRequest:request];
	
	
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	//    [self.navigationController.navigationBar setHidden:NO];
	//
	//    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
	[self.navigationController setNavigationBarHidden:NO animated:NO];
}
//
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    [self.navigationController.navigationBar setHidden:NO];
//
//    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
//  [self.navigationController setNavigationBarHidden:NO animated:NO];
//
//}


-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	//    [self.navigationController.navigationBar setHidden:NO];
	
	//     [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
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


#pragma mark  --set
- (WKWebView *)webView
{
	if (_webView == nil){
		UIImageView *imageView = [self.imageViewArray lastObject];
		WKWebView *webView = [[WKWebView alloc] init];
		//        webView.frame = CGRectMake(0, (KScreenWidth + 100) * self.model.urlList.count, KScreenWidth, KScreenHeight);
		
		[self.scrollView addSubview:webView];
		[webView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(imageView.mas_bottom);
			make.width.equalTo(self.view);
			make.height.mas_equalTo(200);
			make.left.mas_equalTo(self.view);
			//            make.center.equalTo(self.view);
		}];
		
		_webView = webView;
		//		_webView.scrollView.bounces = NO;
		//		_webView.scrollView.showsHorizontalScrollIndicator = NO;
		_webView.scrollView.scrollEnabled = NO;
		[_webView sizeToFit];
		//		_webView.scrollView.contentSize = CGSizeMake(KScreenWidth, 100);
	}
	return _webView;
}

- (NSMutableArray *)imageViewArray {
	if (!_imageViewArray) {
		_imageViewArray = [NSMutableArray array];
	}
	return _imageViewArray;
}


@end
