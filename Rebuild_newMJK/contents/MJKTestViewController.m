//
//  MJKTestViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/6.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKTestViewController.h"
#import "DBNavigationController.h"
#import "MJKUploadFileViewController.h"

@interface MJKTestViewController ()


@end

@implementation MJKTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MJKUploadFileViewController *vc = [[MJKUploadFileViewController alloc]init];
    vc.fileDic = self.fileDic;
    DBNavigationController *navi = [[DBNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:navi];
    [self.view addSubview:navi.view];
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
