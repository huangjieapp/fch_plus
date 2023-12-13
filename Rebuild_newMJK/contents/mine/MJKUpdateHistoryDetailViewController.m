//
//  MJKUpdateHistoryDetailViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/16.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKUpdateHistoryDetailViewController.h"

#import "MJKWKWebView.h"

@interface MJKUpdateHistoryDetailViewController ()
@property (weak, nonatomic) IBOutlet MJKWKWebView *webView;

@end

@implementation MJKUpdateHistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	NSString *urlStr = [NSString stringWithFormat:@"http://121.40.174.159:8585/MJK2.0/mobile/report/about.jsp?C_ID=%@&C_TYPE_DD_ID=%@&APPTYPE=%@",self.C_ID,self.C_TYPE_DD_ID,self.APPTYPE];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
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
