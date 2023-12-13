//
//  MJKShareFolderTabViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/14.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKShareFolderTabViewController.h"
#import "MJKShareFolderViewController.h"
#import "MJKSharePresonalFolderViewController.h"
#import "MJKAddNewPresonalFolderViewController.h"

#import "MJKTabView.h"



@interface MJKShareFolderTabViewController ()
/** \*/
@property (nonatomic, strong) MJKShareFolderViewController *publicVC;
/** <#注释#>*/
@property (nonatomic, strong) MJKSharePresonalFolderViewController *presonalVC;
/** <#注释#>*/
@property (nonatomic, strong) NSString *vcName;
@end

@implementation MJKShareFolderTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self configNavi];
}

- (void)initUI {
    self.vcName = @"公司文档";
    MJKShareFolderViewController *publicVC = [[MJKShareFolderViewController alloc]init];
    self.publicVC = publicVC;
    publicVC.vcName = @"公司文档";
    [self addChildViewController:publicVC];
    [self.view addSubview:publicVC.view];
    
    MJKSharePresonalFolderViewController *presonalVC = [[MJKSharePresonalFolderViewController alloc]init];
    self.presonalVC = presonalVC;
    [self addChildViewController:presonalVC];
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:@"btn-返回"];
    [backButton setTitleColor:[UIColor blackColor]];
    [backButton addTarget:self action:@selector(backVCAction)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:28.f];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
}

- (void)backVCAction{
    if ([self.vcName isEqualToString:@"公司文档"]) {
        [self.publicVC backVCAction];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)configNavi {
    DBSelf(weakSelf);
    MJKTabView *tabView = [[MJKTabView alloc]initWithFrame:CGRectMake(0, 7, 3 * 70, 30) andNameItems:@[@"公司文档",@"个人文档"]  withDefaultIndex:0 andIsSaveItem:YES andClickButtonBlock:^(NSString * _Nonnull str) {
        
        if ([str isEqualToString:@"公司文档"]) {
            weakSelf.publicVC.vcName = @"公司文档";
            [weakSelf.presonalVC.view removeFromSuperview];
            [weakSelf.view addSubview:weakSelf.publicVC.view];
        } else {
            [weakSelf.publicVC.view removeFromSuperview];
            [weakSelf.view addSubview:weakSelf.presonalVC.view];
        }
    }];
    self.navigationItem.titleView = tabView;
}
@end
