//
//  DBWebViewController.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/20.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoticeInfoModel;
@class WKWebView;

@interface DBWebViewController : UIViewController
/** NoticeInfoModel*/
@property (nonatomic, strong) NoticeInfoModel *model;
@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, copy) NSString *urlStr;

@end
