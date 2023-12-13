
//
//  MJKWorkWorldPresonalViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/28.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKWorkWorldPresonalViewController.h"
#import "MJKPersonalWorkReportViewController.h"
#import "MJKWorkWorldViewController.h"

@interface MJKWorkWorldPresonalViewController ()
/** tabView*/
@property (nonatomic, strong) UIView *selTabView;
/** sepView*/
@property (nonatomic, strong) UIView *sepView;
/** contentView*/
@property (nonatomic, strong) UIView *contentView;
/** <#注释#>*/
@property (nonatomic, strong) MJKPersonalWorkReportViewController *workReportView;
/** <#注释#>*/
@property (nonatomic, strong) MJKWorkWorldViewController *workWorldView;
@end

@implementation MJKWorkWorldPresonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"个人动态";
	self.view.backgroundColor = [UIColor whiteColor];
	[self initUI];
}

- (void)initUI {
	[self.view addSubview:self.selTabView];
    [self.view addSubview:self.contentView];
//    [self.view addSubview:self.tableView];
    
    [self daliyWorkReportView];
    [self dynamicView];
    if ([self.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0000"]) {
        [self.contentView bringSubviewToFront:self.workReportView.view];
    } else {
        [self.contentView bringSubviewToFront:self.workWorldView.view];
    }
}

- (void)daliyWorkReportView {
    MJKPersonalWorkReportViewController *vc = [[MJKPersonalWorkReportViewController alloc]init];
    vc.USERID = self.userid;
    vc.createTime = self.createTime;
    vc.headImage = self.headImage;
    vc.userName = self.userName;
    self.workReportView = vc;
    [self addChildViewController:vc];
    [self.contentView addSubview:vc.view];
    CGRect tableViewFrame = vc.tableView.frame;
    tableViewFrame.origin.y = 0;
    tableViewFrame.size.height = tableViewFrame.size.height - self.selTabView.frame.size.height;
    vc.tableView.frame = tableViewFrame;
}

- (void)dynamicView {
    
    MJKWorkWorldViewController *vc = [[MJKWorkWorldViewController alloc]init];
    vc.C_TYPE_DD_ID = @"0";
    vc.userID = self.userid;
    vc.name = @"个人动态";
    [self addChildViewController:vc];
    self.workWorldView = vc;
    [self.contentView addSubview:vc.view];
    CGRect tableViewFrame = vc.tableView.frame;
    tableViewFrame.origin.y = 0;
    tableViewFrame.size.height = tableViewFrame.size.height - self.selTabView.frame.size.height;
    vc.tableView.frame = tableViewFrame;
}

#pragma - 点击事件
#pragma mark 选择类型
- (void)selectTypeAction:(UIButton *)sender {
	CGRect sepViewFrame = self.sepView.frame;
	sepViewFrame.origin.x = CGRectGetMidX(sender.frame) - 20;
	self.sepView.frame = sepViewFrame;
    if ([sender.titleLabel.text isEqualToString:@"日报"]) {
//        [self.contentView addSubview:self.workReportView.view];
        [self.contentView bringSubviewToFront:self.workReportView.view];
    } else {
        
//        [self.contentView addSubview:self.workWorldView.view];
        [self.contentView bringSubviewToFront:self.workWorldView.view];
    }
}

#pragma mark - set
- (UIView *)selTabView {
	if (!_selTabView) {
		_selTabView = [[UIView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 44)];
		_selTabView.backgroundColor = kBackgroundColor;
		for (int i = 0; i < 2; i++) {
			UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * (KScreenWidth / 2), 0, KScreenWidth / 2, 44)];
			[button setTitleNormal:@[@"日报", @"动态"][i]];
			[button setTitleColor:[UIColor blackColor]];
			button.titleLabel.font = [UIFont systemFontOfSize:14.f];
			[button addTarget:self action:@selector(selectTypeAction:)];
			[_selTabView addSubview:button];
            if ( i == [self.C_TYPE_DD_ID isEqualToString:@"A49000_C_TYPE_0000"] ? 0 : 1) {
				UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(button.frame) - 20, button.frame.size.height - 4, 40, 2)];
				sepView.backgroundColor = KNaviColor;
				[_selTabView addSubview:sepView];
				self.sepView = sepView;
			}
		}
	}
	return _selTabView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.selTabView.frame), KScreenWidth, KScreenHeight - NavStatusHeight - self.selTabView.frame.size.height - WD_TabBarHeight - SafeAreaBottomHeight)];
    }
    return _contentView;
}


@end
