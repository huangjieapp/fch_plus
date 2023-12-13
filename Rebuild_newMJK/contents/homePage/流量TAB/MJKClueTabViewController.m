//
//  MJKClueTabViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/15.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKClueTabViewController.h"

#import "MJKTabView.h"

#import "MJKFlowMeterViewController.h"//人脸
#import "MJKClueListViewController.h"//线索流量
#import "MJKFlowListViewController.h"//门店流量

@interface MJKClueTabViewController ()
/** <#备注#>*/
@property (nonatomic, strong) UIViewController *subVC;
/** <#注释#> */
@property (nonatomic, strong) MJKTabView *tabView;
@end

@implementation MJKClueTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0,*)) {
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }else{
        if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
            NSArray *list=self.navigationController.navigationBar.subviews;
            for (id obj in list) {
                if ([obj isKindOfClass:[UIImageView class]]) {
                    UIImageView *imageView=(UIImageView *)obj;
                    NSArray *list2=imageView.subviews;
                    for (id obj2 in list2) {
                        if ([obj2 isKindOfClass:[UIImageView class]]) {
                            //将分割线 移除
                            UIImageView *imageView2=(UIImageView *)obj2;
                            imageView2.hidden=YES;
                        }
                    }
                }
            }
        }
        
    }
    
	[self initUI];//默认为人脸
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [KUSERDEFAULT setObject:@"流量" forKey:@"tabSelect"];
    [self initNavi];
}

- (void)allVC:(NSArray *)titleArray {
    if (titleArray.count <= 0) {
        return;
    }
    NSString *str = titleArray[0];
    self.navigationItem.title = str;
    if ([str isEqualToString:@"人脸"]) {
        MJKFlowMeterViewController *meterVC = [[MJKFlowMeterViewController alloc]init];
        meterVC.isTab = YES;
        [self addChildViewController:meterVC];
        [self.view addSubview:meterVC.view];
        self.subVC = meterVC;
        meterVC.superVC = self;
        if ([[NewUserSession instance].appcode containsObject:@"APP010_0002"]) {
            self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        } else {
            self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        }
    } else if ([str isEqualToString:@"到店"]) {
        MJKFlowListViewController * flowVC=[[MJKFlowListViewController alloc] init];
        flowVC.isTab = YES;
        flowVC.superVC = self;
        [self addChildViewController:flowVC];
        [self.view addSubview:flowVC.view];
        self.subVC = flowVC;
        if ([[NewUserSession instance].appcode containsObject:@"APP002_0002"]) {
            self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        } else {
            self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        }
    } else if ([str isEqualToString:@"线索来电"]) {
        MJKClueListViewController *mjkClueVC = [[MJKClueListViewController alloc]init];
        mjkClueVC.isTab = YES;
        [self addChildViewController:mjkClueVC];
        [self.view addSubview:mjkClueVC.view];
        self.subVC = mjkClueVC;
        if ([[NewUserSession instance].appcode containsObject:@"APP001_0002"]) {
            self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        } else {
            self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        }
    } else {
        MJKClueListViewController *mjkClueVC = [[MJKClueListViewController alloc]init];
        mjkClueVC.isTab = YES;
        mjkClueVC.I_SFSY = @"1";
        [self addChildViewController:mjkClueVC];
        [self.view addSubview:mjkClueVC.view];
        self.subVC = mjkClueVC;
//        if ([[NewUserSession instance].appcode containsObject:@"APP001_0002"]) {
//            self.navigationItem.rightBarButtonItem.customView.hidden = NO;
//        } else {
            self.navigationItem.rightBarButtonItem.customView.hidden = YES;
//        }
    }
}

- (void)initNavi {
	//点击哪个tab今日哪个vc
    DBSelf(weakSelf);
    NSArray *appjpArr = [NewUserSession instance].appcode;
    NSMutableArray *jpArr = [NSMutableArray array];
    [jpArr addObject:@{@"title" : @"人脸", @"code" : @"crm:a460:list"}];
    [jpArr addObject:@{@"title" : @"到店", @"code" : @"crm:a414:list"}];
    [jpArr addObject:@{@"title" : @"线索来电", @"code" : @"crm:a413:list"}];
//    [jpArr addObject:@{@"title" : @"私域线索", @"code" : @"A40300_X_HOTAPP_0051"}];
    
    NSMutableArray *titleArray = [NSMutableArray array];
    for (NSDictionary *dic in jpArr) {
        if ([appjpArr containsObject:dic[@"code"]]) {
            [titleArray addObject:dic[@"title"]];
        }
    }
//    if ([titleArray containsObject:@"人脸"]) {
//        [titleArray insertObject:@"到店" atIndex:1];
//    } else if ([titleArray containsObject:@"线索"]) {
//        [titleArray insertObject:@"到店" atIndex:0];
//    }
    
    NSString *str = [KUSERDEFAULT objectForKey:@"clueTabName"];
    if (str.length > 0) {
        if (![titleArray containsObject:str]) {
//            [self initUI];
            [KUSERDEFAULT removeObjectForKey:@"clueTabName"];
        }
    }
    
    if (titleArray.count == 1) {
//        self.navigationItem.titleView = nil;
//        self.navigationItem.title = @"到店";
//        MJKFlowListViewController * flowVC=[[MJKFlowListViewController alloc] init];
//        flowVC.isTab = YES;
//        [self addChildViewController:flowVC];
//        [self.view addSubview:flowVC.view];
//        self.subVC = flowVC;
        
//        [KUSERDEFAULT setObject:@"到店" forKey:@"clueTabName"];
        [self allVC:titleArray];
    } else {
        if (self.tabView != nil) {
            return;;
        }
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3 * 70, 44)];
        self.navigationItem.titleView = view;
        MJKTabView *tabView = [[MJKTabView alloc]initWithFrame:CGRectMake(0, 7, 3 * 70, 30) andNameItems:titleArray  withDefaultIndex:0 andIsSaveItem:YES andClickButtonBlock:^(NSString * _Nonnull str) {
            weakSelf.tabBarController.tabBar.hidden = NO;
            [weakSelf.subVC.view removeFromSuperview];
            [weakSelf.subVC removeFromParentViewController];
            [KUSERDEFAULT setObject:str forKey:@"clueTabName"];
            if ([str isEqualToString:@"人脸"]) {
                MJKFlowMeterViewController *meterVC = [[MJKFlowMeterViewController alloc]init];
                meterVC.isTab = YES;
                [weakSelf addChildViewController:meterVC];
                [weakSelf.view addSubview:meterVC.view];
                weakSelf.subVC = meterVC;
                meterVC.superVC = weakSelf;
                if ([[NewUserSession instance].appcode containsObject:@"APP010_0002"]) {
                    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
                } else {
                    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
                }

            } else if ([str isEqualToString:@"到店"]) {
                MJKFlowListViewController * flowVC=[[MJKFlowListViewController alloc] init];
                flowVC.isTab = weakSelf;
                flowVC.superVC = weakSelf;
                [weakSelf addChildViewController:flowVC];
                [weakSelf.view addSubview:flowVC.view];
                self.subVC = flowVC;
                if ([[NewUserSession instance].appcode containsObject:@"APP002_0002"]) {
                    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
                } else {
                    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
                }

            } else if ([str isEqualToString:@"线索来电"]) {
                MJKClueListViewController *mjkClueVC = [[MJKClueListViewController alloc]init];
                mjkClueVC.isTab = YES;
                [weakSelf addChildViewController:mjkClueVC];
                [weakSelf.view addSubview:mjkClueVC.view];
                weakSelf.subVC = mjkClueVC;
                if ([[NewUserSession instance].appcode containsObject:@"APP001_0002"]) {
                    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
                } else {
                    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
                }
            } else {
                MJKClueListViewController *mjkClueVC = [[MJKClueListViewController alloc]init];
                mjkClueVC.isTab = YES;
                mjkClueVC.I_SFSY = @"1";
                [self addChildViewController:mjkClueVC];
                [self.view addSubview:mjkClueVC.view];
                self.subVC = mjkClueVC;
//                if ([[NewUserSession instance].appcode containsObject:@"APP001_0002"]) {
//                    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
//                } else {
                    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
//                }
            }
        }];
        self.tabView = tabView;
        [view addSubview:tabView];
    }
    
	
	
	
}

- (void)initUI {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    //    [button setImage:@"icon_customer_add"];
    [button setTitleNormal:@"+"];
    button.titleLabel.font = [UIFont systemFontOfSize:30.f];
    [button setTitleColor:[UIColor blackColor]];
    [button addTarget:self action:@selector(addData:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    NSArray *appjpArr = [NewUserSession instance].appcode;
    NSMutableArray *jpArr = [NSMutableArray array];
    [jpArr addObject:@{@"title" : @"人脸", @"code" : @"crm:a460:list"}];
    [jpArr addObject:@{@"title" : @"到店", @"code" : @"crm:a414:list"}];
    [jpArr addObject:@{@"title" : @"线索来电", @"code" : @"crm:a413:list"}];
//    [jpArr addObject:@{@"title" : @"私域线索", @"code" : @"A40300_X_HOTAPP_0051"}];
    
    NSMutableArray *titleArray = [NSMutableArray array];
    //    [titleArray addObject:@"意向"];
    for (NSDictionary *dic in jpArr) {
        if ([appjpArr containsObject:dic[@"code"]]) {
            [titleArray addObject:dic[@"title"]];
        }
    }
//    if ([titleArray containsObject:@"人脸"]) {
//        [titleArray insertObject:@"到店" atIndex:1];
//    } else if ([titleArray containsObject:@"线索"]) {
//        [titleArray insertObject:@"到店" atIndex:0];
//    }
    
    [self allVC:titleArray];
    
//    if ([titleArray containsObject:@"人脸"] && titleArray.count > 1) {
//        MJKFlowMeterViewController *vc = [[MJKFlowMeterViewController alloc]init];
//        vc.isTab = YES;
//        vc.superVC = self;
//        [self addChildViewController:vc];
//        [self.view addSubview:vc.view];
//        self.subVC = vc;
//    } else {
//        self.navigationItem.title = @"到店";
//        MJKFlowListViewController * flowVC=[[MJKFlowListViewController alloc] init];
//        flowVC.isTab = YES;
//        flowVC.superVC = self;
//        [self addChildViewController:flowVC];
//        [self.view addSubview:flowVC.view];
//        self.subVC = flowVC;
//    }
	
}

#pragma mark - 添加数据
- (void)addData:(UIButton *)sender {
	if ([self.subVC isKindOfClass:[MJKFlowMeterViewController class]]) {
		MJKFlowMeterViewController *vc = (MJKFlowMeterViewController *)self.subVC;
		vc.isAdd = YES;
	} else if ([self.subVC isKindOfClass:[MJKFlowListViewController class]]) {
		MJKFlowListViewController *vc = (MJKFlowListViewController *)self.subVC;
		vc.isAdd = YES;
	} else {
		MJKClueListViewController *vc = (MJKClueListViewController *)self.subVC;
		vc.isAdd = YES;
	}
}

@end
