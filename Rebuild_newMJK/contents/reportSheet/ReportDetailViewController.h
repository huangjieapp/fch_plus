//
//  ReportDetailViewController.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/11.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <WebKit/WebKit.h>

typedef NS_ENUM(NSInteger,webViewType){
    webViewTypeOrder=0,
    webViewTypeWillCustom,
    webViewTypeOrderProgress,
    webViewTypeCrue,
    
    webViewTypeOrderStatus,
    webViewTypeFollow,
    webViewTypeCustomActive,
    webViewTypeReserveStatus,
    webViewTypeFlowSheet,
    webViewTypeCrueSheet,
    webViewTypePhoneSheet
    
    
};


@interface ReportDetailViewController : UIViewController

@property(nonatomic,assign)NSInteger webType;

@property(nonatomic,strong)WKWebView*webView;

@end
