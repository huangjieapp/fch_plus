//
//  MJKCustomerTabViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/21.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKCustomerTabViewController.h"

#import "MJKTabView.h"

#import "PotentailCustomerListViewController.h"//客户
#import "AssistViewController.h"//协助
#import "CGCBrokerCenterVC.h"//会员

#import "CGCNavSearchTextView.h"
#import "VoiceView.h"

@interface MJKCustomerTabViewController ()

@property (nonatomic, strong) UIViewController *subVC;
/** CGCNavSearchTextView*/
@property (nonatomic, strong) CGCNavSearchTextView *CurrentTitleView;
/** MJKTabView *tabView*/
@property (nonatomic, strong) MJKTabView *tabView;
/** VoiceView*/
@property (nonatomic, strong) VoiceView *vv;
@end

@implementation MJKCustomerTabViewController

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
    
    
	[self initUI];//默认为第一个我的
	
	[self createSearchTitleView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [KUSERDEFAULT setObject:@"客户" forKey:@"tabSelect"];
    [self initNavi];
}

- (UIBarButtonItem *)createFirstBarItem {
	UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 44)];
    [addButton setImage:[UIImage imageNamed:@"icon_customer_add"] forState:UIControlStateNormal];
	[addButton addTarget:self action:@selector(addData:)];
	return [[UIBarButtonItem alloc]initWithCustomView:addButton];
}

- (UIBarButtonItem *)createSecondBarItem {
	UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 44)];
	[searchButton setImage:@"搜索按钮"];
	[searchButton addTarget:self action:@selector(searchbuttonAction:)];
	return [[UIBarButtonItem alloc]initWithCustomView:searchButton];
}

- (void)allVC:(NSArray *)titleArray {
    if (titleArray.count <=0) {
        return;
    }
    NSString *str = titleArray[0];
    self.navigationItem.title = str;
    if ([str isEqualToString:@"潜客"]) {
        PotentailCustomerListViewController * vc=[[PotentailCustomerListViewController alloc] init];
        vc.isTab = YES;
        vc.isListOrSea = @"list";
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        self.subVC = vc;
        if ([[NewUserSession instance].appcode containsObject:@"APP004_0002"]) {
            self.navigationItem.rightBarButtonItems = @[[self createFirstBarItem], [self createSecondBarItem]];
        } else {
            self.navigationItem.rightBarButtonItem = [self createSecondBarItem];
        }
    } else if ([str isEqualToString:@"协助"]) {
        AssistViewController *vc = [[AssistViewController alloc]init];
        vc.isTab = YES;
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        self.subVC = vc;
        self.navigationItem.rightBarButtonItems = @[[self createSecondBarItem]];
        
    } else if ([str isEqualToString:@"粉丝"]) {
        CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
        vc.type = BrokerCenterMembers;
        vc.isTab = YES;
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        self.subVC = vc;
        if ([[NewUserSession instance].appcode containsObject:@"APP015_0014"]) {
            self.navigationItem.rightBarButtonItems = @[[self createFirstBarItem], [self createSecondBarItem]];
        } else {
            self.navigationItem.rightBarButtonItems = @[[self createSecondBarItem]];
        }
    } else if ([str isEqualToString:@"公海"]) {
        PotentailCustomerListViewController * vc=[[PotentailCustomerListViewController alloc] init];
        vc.isTab = YES;
        vc.isListOrSea = @"sea";
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        self.subVC = vc;
        self.navigationItem.rightBarButtonItems = @[[self createSecondBarItem]];
    } else {
        PotentailCustomerListViewController * vc=[[PotentailCustomerListViewController alloc] init];
        vc.isTab = YES;
        vc.isListOrSea = @"list";
        vc.I_SFSY = @"1";
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        self.subVC = vc;
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
//        if ([[NewUserSession instance].appcode containsObject:@"APP004_0002"]) {
//            self.navigationItem.rightBarButtonItems = @[[self createFirstBarItem], [self createSecondBarItem]];
//        } else {
//            self.navigationItem.rightBarButtonItem = [self createSecondBarItem];
//        }
    }
}

- (void)initNavi {
    DBSelf(weakSelf);
	//点击哪个tab今日哪个vc
    
    NSArray *appjpArr = [NewUserSession instance].appcode;
    NSMutableArray *jpArr = [NSMutableArray array];
    [jpArr addObject:@{@"title" : @"潜客", @"code" : @"crm:a415:list"}];
//    [jpArr addObject:@{@"title" : @"协助", @"code" : @"A40300_X_HOTAPP_0010"}];
//    [jpArr addObject:@{@"title" : @"粉丝", @"code" : @"A40300_X_HOTAPP_0042"}];
    [jpArr addObject:@{@"title" : @"公海", @"code" : @"crm:a415_pond:list"}];
//    [jpArr addObject:@{@"title" : @"私域", @"code" : @"A40300_X_HOTAPP_0052"}];
    
    NSMutableArray *titleArray = [NSMutableArray array];
    for (NSDictionary *dic in jpArr) {
        if ([appjpArr containsObject:dic[@"code"]]) {
            [titleArray addObject:dic[@"title"]];
        }
    }
    
    NSString *str = [KUSERDEFAULT objectForKey:@"customerTabName"];
    if (str.length > 0) {
        if (![titleArray containsObject:str]) {
            [self initUI];
            [KUSERDEFAULT removeObjectForKey:@"customerTabName"];
        }
    }
    
    if ([NewUserSession instance].isApp_jp == YES) {
        self.navigationItem.titleView = nil;
        [self allVC:titleArray];
        [NewUserSession instance].isApp_jp = NO;
    }
    
    if (titleArray.count == 1) {
//        PotentailCustomerListViewController * vc=[[PotentailCustomerListViewController alloc] init];
//        vc.isTab = YES;
//        vc.isListOrSea = @"list";
//        [self addChildViewController:vc];
//        [self.view addSubview:vc.view];
//        self.subVC = vc;
//        self.navigationItem.titleView = self.CurrentTitleView;
//        self.navigationItem.rightBarButtonItem =  [self createFirstBarItem];
        [self allVC:titleArray];
    } else {
        CGRect titleViewFrame = self.navigationItem.titleView.frame;
        titleViewFrame.origin.y = 10;
        self.navigationItem.titleView.frame = titleViewFrame;
        if (self.tabView != nil) {
            return;;
        }
        MJKTabView *tabView = [[MJKTabView alloc]initWithFrame:CGRectMake(0, 7, 3 * 70, 30) andNameItems:titleArray  withDefaultIndex:0 andIsSaveItem:YES andClickButtonBlock:^(NSString * _Nonnull str) {
            weakSelf.tabBarController.tabBar.hidden = NO;
            [weakSelf.subVC.view removeFromSuperview];
            [weakSelf.subVC removeFromParentViewController];
            [KUSERDEFAULT setObject:str forKey:@"customerTabName"];
            if ([str isEqualToString:@"潜客"]) {
                PotentailCustomerListViewController * vc=[[PotentailCustomerListViewController alloc] init];
                vc.isTab = YES;
                vc.isListOrSea = @"list";
                [weakSelf addChildViewController:vc];
                [weakSelf.view addSubview:vc.view];
                weakSelf.subVC = vc;
                if ([[NewUserSession instance].appcode containsObject:@"APP004_0002"]) {
                    weakSelf.navigationItem.rightBarButtonItems = @[[weakSelf createFirstBarItem], [weakSelf createSecondBarItem]];
                } else {
                    weakSelf.navigationItem.rightBarButtonItem = [weakSelf createSecondBarItem];
                }
            } else if ([str isEqualToString:@"协助"]) {
                AssistViewController *vc = [[AssistViewController alloc]init];
                vc.isTab = YES;
                [weakSelf addChildViewController:vc];
                [weakSelf.view addSubview:vc.view];
                weakSelf.subVC = vc;
                weakSelf.navigationItem.rightBarButtonItems = @[[weakSelf createSecondBarItem]];
                
            } else if ([str isEqualToString:@"粉丝"]) {
                CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
                vc.type = BrokerCenterMembers;
                vc.isTab = YES;
                [weakSelf addChildViewController:vc];
                [weakSelf.view addSubview:vc.view];
                weakSelf.subVC = vc;
                if ([[NewUserSession instance].appcode containsObject:@"APP015_0014"]) {
                    self.navigationItem.rightBarButtonItems = @[[self createFirstBarItem], [self createSecondBarItem]];
                } else {
                    self.navigationItem.rightBarButtonItems = @[[self createSecondBarItem]];
                }
            } else if ([str isEqualToString:@"公海"]) {
                PotentailCustomerListViewController * vc=[[PotentailCustomerListViewController alloc] init];
                vc.isTab = YES;
                vc.isListOrSea = @"sea";
                [weakSelf addChildViewController:vc];
                [weakSelf.view addSubview:vc.view];
                weakSelf.subVC = vc;
                weakSelf.navigationItem.rightBarButtonItems = @[[weakSelf createSecondBarItem]];
            } else {
                PotentailCustomerListViewController * vc=[[PotentailCustomerListViewController alloc] init];
                vc.isTab = YES;
                vc.isListOrSea = @"list";
                vc.I_SFSY = @"1";
                [self addChildViewController:vc];
                [self.view addSubview:vc.view];
                self.subVC = vc;
                self.navigationItem.rightBarButtonItem.customView.hidden = YES;
//                if ([[NewUserSession instance].appcode containsObject:@"APP004_0002"]) {
//                    self.navigationItem.rightBarButtonItems = @[[self createFirstBarItem], [self createSecondBarItem]];
//                } else {
//                    self.navigationItem.rightBarButtonItem = [self createSecondBarItem];
//                }
            }
        }];
        
        self.tabView = tabView;
        self.navigationItem.titleView = tabView;
    }
    
	
	
	
	
}

- (void)createSearchTitleView {
	DBSelf(weakSelf);
	self.CurrentTitleView=[[CGCNavSearchTextView alloc] initWithFrame:self.view.bounds withPlaceHolder:@"请输入姓名/手机/地址/微信号" withRecord:^{//点击录音
		self.vv = [[VoiceView alloc]initWithFrame:self.view.frame];
		
		[self.view addSubview:self.vv];
		[weakSelf.vv start];
		weakSelf.vv.recordBlock = ^(NSString *str) {
			_CurrentTitleView.textField.text = str;
			if ([self.subVC isKindOfClass:[PotentailCustomerListViewController class]]) {
				PotentailCustomerListViewController *vc = (PotentailCustomerListViewController *)self.subVC;
				vc.tabSearchStr = str;
			}  else if ([self.subVC isKindOfClass:[CGCBrokerCenterVC class]]) {
				CGCBrokerCenterVC *vc = (CGCBrokerCenterVC *)self.subVC;
				vc.tabSearchStr = str;
			} else if ([self.subVC isKindOfClass:[AssistViewController class]]) {
				AssistViewController *vc = (AssistViewController *)self.subVC;
				vc.tabSearchStr = str;
			}
			
		};
		
	} withText:^{//开始编辑
		MyLog(@"编辑");
		
		
	}withEndText:^(NSString *str) {//结束编辑
		NSLog(@"%@____",str);
		if ([self.subVC isKindOfClass:[PotentailCustomerListViewController class]]) {
			PotentailCustomerListViewController *vc = (PotentailCustomerListViewController *)self.subVC;
			vc.tabSearchStr = str;
		}  else if ([self.subVC isKindOfClass:[CGCBrokerCenterVC class]]) {
			CGCBrokerCenterVC *vc = (CGCBrokerCenterVC *)self.subVC;
			vc.tabSearchStr = str;
		} else if ([self.subVC isKindOfClass:[AssistViewController class]]) {
			AssistViewController *vc = (AssistViewController *)self.subVC;
			vc.tabSearchStr = str;
		}
	}];
}

- (void)initUI {
    
    NSArray *appjpArr = [NewUserSession instance].appcode;
    NSMutableArray *jpArr = [NSMutableArray array];
    [jpArr addObject:@{@"title" : @"潜客", @"code" : @"crm:a415:list"}];
//    [jpArr addObject:@{@"title" : @"协助", @"code" : @"A40300_X_HOTAPP_0010"}];
//    [jpArr addObject:@{@"title" : @"粉丝", @"code" : @"A40300_X_HOTAPP_0042"}];
    [jpArr addObject:@{@"title" : @"公海", @"code" : @"crm:a415_pond:list"}];
//    [jpArr addObject:@{@"title" : @"私域", @"code" : @"A40300_X_HOTAPP_0052"}];
    
    NSMutableArray *titleArray = [NSMutableArray array];
    for (NSDictionary *dic in jpArr) {
        if ([appjpArr containsObject:dic[@"code"]]) {
            [titleArray addObject:dic[@"title"]];
        }
    }
    
//    if (titleArray.count > 1) {
//        self.navigationItem.rightBarButtonItems = @[[self createFirstBarItem], [self createSecondBarItem]];
    [self allVC:titleArray];
//        PotentailCustomerListViewController * vc=[[PotentailCustomerListViewController alloc] init];
//        vc.isTab = YES;
//        vc.isListOrSea = @"list";
//        [self addChildViewController:vc];
//        [self.view addSubview:vc.view];
//        self.subVC = vc;
//    }
    
	
}

#pragma mark - 添加数据
- (void)addData:(UIButton *)sender {
	if ([self.subVC isKindOfClass:[PotentailCustomerListViewController class]]) {
		PotentailCustomerListViewController *vc = (PotentailCustomerListViewController *)self.subVC;
		vc.isAdd = YES;
	}  else if ([self.subVC isKindOfClass:[CGCBrokerCenterVC class]]) {
		CGCBrokerCenterVC *vc = (CGCBrokerCenterVC *)self.subVC;
		vc.isAdd = YES;
	}
}

#pragma mark - 搜索
- (void)searchbuttonAction:(UIButton *)sender {
	sender.selected = !sender.isSelected;
	[sender setImage:sender.isSelected == YES ? @"X图标" : @"搜索按钮"];
	self.navigationItem.titleView=sender.isSelected == YES ? self.CurrentTitleView : self.tabView;
	if (sender.isSelected == NO) {
		self.CurrentTitleView.textField.text = @"";
		if ([self.subVC isKindOfClass:[PotentailCustomerListViewController class]]) {
			PotentailCustomerListViewController *vc = (PotentailCustomerListViewController *)self.subVC;
			vc.tabSearchStr = @"";
		}  else if ([self.subVC isKindOfClass:[CGCBrokerCenterVC class]]) {
			CGCBrokerCenterVC *vc = (CGCBrokerCenterVC *)self.subVC;
			vc.tabSearchStr = @"";
		} else if ([self.subVC isKindOfClass:[AssistViewController class]]) {
			AssistViewController *vc = (AssistViewController *)self.subVC;
			vc.tabSearchStr = @"";
		}
	}
}

@end
