//
//  DetailWebviewViewController.h
//  Mcr_2
//
//  Created by bipi on 2017/5/27.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import "DBBaseViewController.h"
#import <WebKit/WebKit.h>

@interface DetailWebviewViewController : DBBaseViewController
@property (weak, nonatomic) IBOutlet WKWebView *WebView;
@property(nonatomic,strong)NSString *PassType;

@property(nonatomic,strong)NSString *type;


@end
