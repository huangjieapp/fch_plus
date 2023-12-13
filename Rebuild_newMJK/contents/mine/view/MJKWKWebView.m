//
//  MJKWKWebView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/16.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKWKWebView.h"

@implementation MJKWKWebView

- (instancetype)initWithCoder:(NSCoder *)coder {
	//以下代码适配大小
//	NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
//
//	WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//	WKUserContentController *wkUController = [[WKUserContentController alloc] init];
//	[wkUController addUserScript:wkUScript];
//
//	WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
//	wkWebConfig.userContentController = wkUController;
	
//	_webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:wkWebConfig];
	
	
	CGRect frame = [[UIScreen mainScreen] bounds];
	WKWebViewConfiguration *myConfiguration = [WKWebViewConfiguration new];
	self = [super initWithFrame:frame configuration:myConfiguration];
	
	self.translatesAutoresizingMaskIntoConstraints = NO;
	
	return self;
}

@end
