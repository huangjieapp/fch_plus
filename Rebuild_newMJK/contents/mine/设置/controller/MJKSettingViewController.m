//
//  MJKSettingViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKSettingViewController.h"
#import "SHLoginViewController.h"
#import "MJKCustomReturnViewController.h"
#import "MJKMarketSettingViewController.h"
#import "MJKFlowInstrumentViewController.h"
#import "MJKOnlineHallViewController.h"
#import "MJKApproveViewController.h"
#import "MJKOrderNumberViewController.h"
#import "OrderNumberSetViewController.h"
#import "MJKWorkReportSettingViewController.h"

#import "MJKSettingListTableViewCell.h"

#import "MJKResultViewController.h"
#import "MJKPKSetViewController.h"
#import "MJKCheckingViewController.h"//考勤设置
#import "MJKSafeSettingViewController.h"//安全设置
#import "MJKWorkTaskViewController.h"//任务排班设置
#import "MJKRecheckViewController.h"//客户查重设置
#import "MJKSalesPromotionActivityViewController.h"//促销活动设置
#import "MJKCustomerLabelViewController.h"//客户标签设置
#import "MJKPushSetViewController.h"//推送设置
#import "MJKDeviceSetViewController.h"//设备设置
#import "MJKOrderNodeViewController.h"//订单节点设置
#import "MJKPublicMessageViewController.h"//公共消息模板设置
#import "MJKSchedulingViewController.h"//休假排班设置
#import "MJKCustomReturnEditViewController.h"//客户跟进等级设置
#import "MJKRemindHomeViewController.h"//首页提醒显示设置
#import "MJKEmployeesAccountViewController.h"//员工账号设置
#import "MJKCustomaSortViewController.h"//客户列表排序设置
#import "MJKCustomerMandatoryViewController.h"//客户必填项设置
#import "SetManagementViewController.h"//个人应用功能设置
#import "MJKExternalMessagePushViewController.h"//外部消息推送设置
#import "MJKAiParameterViewController.h"//ai外呼参数
#import "MJKProductCategorySettingViewController.h"//产品分类设置
#import "MJKBuldDicSetViewController.h"//楼宇字典
#import "MJKFinancialAuditViewController.h"//订单财务审批设置
#import "MJKNormalEmployeesViewController.h"//订单相关负责人设置
#import "MJKProductInputViewController.h"//产品输入设置
#import "MJKChooseReferencesViewController.h"//介绍人选择设置
#import "MJKDailyTimeViewController.h"//工作圈时间设置
#import "MJKOrderMandatoryViewController.h"//订单必填项设置
#import "MJKOrderInfoOpenViewController.h"//订单信息开放选择设置
#import "MJKNewWorkReportSettingViewController.h"//工作汇报设置
#import "MJKDaliyReportViewController.h"//日报必填项设置
#import "MJKFolderViewController.h"//共享文档设置
#import "MJKPersonalPerformanceTargetViewController.h"//个人业绩目标设置
#import "OnlineExhibtionSettingViewController.h"//在线展厅
#import "MJKRAndPViewController.h"//奖惩制度设置
#import "MJKTaskTypeSettingViewController.h"//任务类型设置
#import "MJKApprovalSetViewController.h"//审批设置
#import "MJKGoodPaperViewController.h"//喜报模板设置
#import "MJKDouDouViewController.h"//脉趣豆对账记录
#import "MJKCompanyInfoViewController.h"//公司信息设置
#import "MJKFaceCheckSetViewController.h"//人脸识别规则设置
#import "MJKHomepageReportShowViewController.h"//首页报表显示设置
@interface MJKSettingViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIButton *exitButton;
@property (nonatomic, strong) NSMutableArray *cellContent;//cell里的图片和文字
@end

@implementation MJKSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableview];
//	[self.view addSubview:self.exitButton];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
	if ([self.title isEqualToString:@"个人设置"]) {
		return 1;
	} else {
		NSDictionary *dic = self.cellContent[0];
		NSArray *arr = dic[@"title"];
		return arr.count;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([self.title isEqualToString:@"个人设置"]) {
		return self.cellContent.count;
	} else {
		NSDictionary *dic = self.cellContent[0];
		
		NSArray *arr = dic[@"content"];
		NSArray *contentArr = arr[section];
		return contentArr.count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKSettingListTableViewCell *cell = [MJKSettingListTableViewCell cellWithTableView:tableView];
	if ([self.title isEqualToString:@"个人设置"]) {
		cell.handImageView.image = [UIImage imageNamed:self.cellContent[indexPath.row][@"image"]];
		cell.titleLabel.text = self.cellContent[indexPath.row][@"title"];
	} else {
		NSDictionary *dic = self.cellContent[0];
		
		NSArray *arr = dic[@"content"];
		NSArray *contentArr = arr[indexPath.section];
		NSDictionary *contentDic = contentArr[indexPath.row];
		cell.handImageView.image = [UIImage imageNamed:contentDic[@"image"]];
		cell.titleLabel.text = contentDic[@"title"];
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if ([self.title isEqualToString:@"个人设置"]) {
		return .1f;
	}
	return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if ([self.title isEqualToString:@"个人设置"]) {
		return nil;
	}
	NSDictionary *dic = self.cellContent[0];
	
	NSArray *arr = dic[@"title"];
	
	UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
	bgView.backgroundColor = kBackgroundColor;
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, KScreenWidth - 20, bgView.frame.size.height)];
	label.text = arr[section];
	label.textColor = [UIColor lightGrayColor];
	label.font = [UIFont systemFontOfSize:14.f];
	[bgView addSubview:label];
	
	return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSArray *codeArr = [NSArray arrayWithArray:[NewUserSession instance].appcode];
	NSDictionary *dic;
	if ([self.title isEqualToString:@"个人设置"]) {
		dic = self.cellContent[indexPath.row];
		
	} else {
		NSDictionary *dic1 = self.cellContent[0];
		
		NSArray *arr = dic1[@"content"];
		NSArray *contentArr = arr[indexPath.section];
		dic = contentArr[indexPath.row];
	}
	if ([dic[@"title"] isEqualToString:@"个人业绩目标设置"]) {
		MJKPersonalPerformanceTargetViewController *customVC = [[MJKPersonalPerformanceTargetViewController alloc]init];
        if (![codeArr containsObject:@"APP008_0003"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
		
		
		[self.navigationController pushViewController:customVC animated:YES];
	} else if ([dic[@"title"] isEqualToString:@"潜客跟进周期设置"]) {
		MJKCustomReturnEditViewController *addVC = [[MJKCustomReturnEditViewController alloc]init];
//		addVC.model = self.customModel;
		addVC.title = dic[@"title"];
		if (![codeArr containsObject:@"APP008_0001"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
		[self.navigationController pushViewController:addVC animated:YES];
	}
	
	else if ([dic[@"title"] isEqualToString:@"渠道细分设置"]) {
		MJKMarketSettingViewController *marketVC = [[MJKMarketSettingViewController alloc]init];
		marketVC.title = dic[@"title"];
		if (![codeArr containsObject:@"APP008_0010"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
		[self.navigationController pushViewController:marketVC animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"人脸识别规则设置"]) {
        MJKFaceCheckSetViewController *flowVC = [[MJKFaceCheckSetViewController alloc]init];//
        if (![codeArr containsObject:@"APP008_0047"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        [self.navigationController pushViewController:flowVC animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"人脸识别设置"]) {
		MJKFlowInstrumentViewController *flowVC = [[MJKFlowInstrumentViewController alloc]initWithNibName:@"MJKFlowInstrumentViewController" bundle:nil];
		flowVC.title = dic[@"title"];
		if (![codeArr containsObject:@"APP008_0004"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
		[self.navigationController pushViewController:flowVC animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"在线展厅设置"]) {
//        MJKOnlineHallViewController
        OnlineExhibtionSettingViewController *flowVC = [[OnlineExhibtionSettingViewController alloc]initWithNibName:@"OnlineExhibtionSettingViewController" bundle:nil];
        flowVC.title = dic[@"title"];
        [self.navigationController pushViewController:flowVC animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"订单编号设置"]) {
		OrderNumberSetViewController*vc=[[OrderNumberSetViewController alloc]init];
		if (![codeArr containsObject:@"APP008_0006"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
		[self.navigationController pushViewController:vc animated:YES];
	} else if ([dic[@"title"] isEqualToString:@"订单关怀周期设置"]) {
		MJKCustomReturnEditViewController *vc = [[MJKCustomReturnEditViewController alloc]init];
//		addVC.model = self.customModel;
		vc.title = dic[@"title"];
		
		//
		if (![codeArr containsObject:@"APP008_0007"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
		[self.navigationController pushViewController:vc animated:YES];
	} else if ([dic[@"title"] isEqualToString:@"绩效得分规则设置"]) {
		MJKResultViewController *customVC = [[MJKResultViewController alloc]init];
		customVC.title = dic[@"title"];
		if (![codeArr containsObject:@"APP008_0008"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
		[self.navigationController pushViewController:customVC animated:YES];
	} else if ([dic[@"title"] isEqualToString:@"绩效分组PK设置"]) {
		if (![codeArr containsObject:@"APP008_0009"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
		MJKPKSetViewController *customVC = [[MJKPKSetViewController alloc]init];
		customVC.title = dic[@"title"];
		
		[self.navigationController pushViewController:customVC animated:YES];
	} else if ([dic[@"title"] isEqualToString:@"个人汇报内容设置"]) {
		if (![codeArr containsObject:@"APP008_0011"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
		MJKWorkReportSettingViewController *vc = [[MJKWorkReportSettingViewController alloc]init];
		vc.vcName = @"汇报";
		[self.navigationController pushViewController:vc animated:YES];
	} else if ([dic[@"title"] isEqualToString:@"公海转流规则设置"]) {
		if (![codeArr containsObject:@"APP008_0012"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
		MJKWorkReportSettingViewController *vc = [[MJKWorkReportSettingViewController alloc]init];
		vc.vcName = @"公海";
		[self.navigationController pushViewController:vc animated:YES];
	} else if ([dic[@"title"] isEqualToString:@"考勤规则设置"]) {
		if (![[NewUserSession instance].appcode containsObject:@"APP008_0014"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
		MJKCheckingViewController *vc = [[MJKCheckingViewController alloc]init];
		[self.navigationController pushViewController:vc animated:YES];
	} else if ([dic[@"title"] isEqualToString:@"安全设置"]) {
		//安全设置 APP008_0015
		if (![[NewUserSession instance].appcode containsObject:@"APP008_0015"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
		MJKSafeSettingViewController *vc = [[MJKSafeSettingViewController alloc]init];
		[self.navigationController pushViewController:vc animated:YES];
	} else if ([dic[@"title"] isEqualToString:@"任务排班公示设置"]) {//任务排班设置
		if (![[NewUserSession instance].appcode containsObject:@"APP008_0018"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
		MJKWorkTaskViewController *vc = [[MJKWorkTaskViewController alloc]initWithNibName:@"MJKWorkTaskViewController" bundle:nil];
		[self.navigationController pushViewController:vc animated:YES];
	} else if ([dic[@"title"] isEqualToString:@"潜客查重设置"]) {
		if (![[NewUserSession instance].appcode containsObject:@"APP008_0017"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
		MJKRecheckViewController *vc = [[MJKRecheckViewController alloc]init];
		[self.navigationController pushViewController:vc animated:YES];
    }  else if ([dic[@"title"] isEqualToString:@"楼盘字典设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0035"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKBuldDicSetViewController *vc = [[MJKBuldDicSetViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"促销活动设置"]) {
		if (![[NewUserSession instance].appcode containsObject:@"APP008_0021"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
		MJKSalesPromotionActivityViewController *vc = [[MJKSalesPromotionActivityViewController alloc]initWithNibName:@"MJKSalesPromotionActivityViewController" bundle:nil];
		[self.navigationController pushViewController:vc animated:YES];
	} else if ([dic[@"title"] isEqualToString:@"潜客标签设置"]) {
		if (![[NewUserSession instance].appcode containsObject:@"APP008_0020"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
		MJKCustomerLabelViewController *vc = [[MJKCustomerLabelViewController alloc]init];
		[self.navigationController pushViewController:vc animated:YES];
		
	} else if ([dic[@"title"] isEqualToString:@"内部消息推送设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0019"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
		MJKPushSetViewController *vc = [[MJKPushSetViewController alloc]init];
		[self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"外部消息推送设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0027"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKExternalMessagePushViewController *vc = [[MJKExternalMessagePushViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([dic[@"title"] isEqualToString:@"屏幕管理设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0022"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
		MJKDeviceSetViewController *vc = [[MJKDeviceSetViewController alloc]init];
		[self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"订单节点设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0024"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
		MJKOrderNodeViewController *vc = [[MJKOrderNodeViewController alloc]init];
		[self.navigationController pushViewController:vc animated:YES];
	} else if ([dic[@"title"] isEqualToString:@"公共消息模板设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0026"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
		MJKPublicMessageViewController *vc = [[MJKPublicMessageViewController alloc]init];
		[self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"喜报模板设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0049"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKGoodPaperViewController *vc = [[MJKGoodPaperViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"休假排班设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0025"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
		//休假排班
		MJKSchedulingViewController *vc = [[MJKSchedulingViewController alloc]init];
		[self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"粉丝互动周期设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0028"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKCustomReturnEditViewController *vc = [[MJKCustomReturnEditViewController alloc]init];
        //        addVC.model = self.customModel;
        vc.title = dic[@"title"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"首页提醒显示设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0029"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKRemindHomeViewController *vc = [[MJKRemindHomeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"员工账号设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0023"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKEmployeesAccountViewController *vc = [[MJKEmployeesAccountViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"潜客列表排序设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0031"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKCustomaSortViewController *vc = [[MJKCustomaSortViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"共享文档设置"]) {
        //APP008_0045
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0045"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKFolderViewController *vc = [[MJKFolderViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }  else if ([dic[@"title"] isEqualToString:@"奖惩制度设置"]) {
        //APP008_0046
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0046"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKRAndPViewController *vc = [[MJKRAndPViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([dic[@"title"] isEqualToString:@"脉趣豆对账记录"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0050"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKDouDouViewController *vc = [[MJKDouDouViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }  else if ([dic[@"title"] isEqualToString:@"首页报表显示设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0051"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKHomepageReportShowViewController *vc = [[MJKHomepageReportShowViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([dic[@"title"] isEqualToString:@"潜客必填项设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0030"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKCustomerMandatoryViewController *vc = [[MJKCustomerMandatoryViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"日报必填项设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0044"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKDaliyReportViewController *vc = [[MJKDaliyReportViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"应用功能管理设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0032"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        SetManagementViewController *vc = [[SetManagementViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"AI外呼参数"]) {
        //APP008_0033
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0033"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKAiParameterViewController *vc = [[MJKAiParameterViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"公司信息设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0048"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKCompanyInfoViewController *vc = [[MJKCompanyInfoViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"产品分类设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0034"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKProductCategorySettingViewController *vc = [[MJKProductCategorySettingViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"任务类型设置"]) {
        
        MJKTaskTypeSettingViewController *vc = [[MJKTaskTypeSettingViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }  else if ([dic[@"title"] isEqualToString:@"审批设置"]) {
        MJKApprovalSetViewController *vc = [[MJKApprovalSetViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"订单财务审核设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0037"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKFinancialAuditViewController *vc = [[MJKFinancialAuditViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"订单相关负责人设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0038"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKNormalEmployeesViewController *vc = [[MJKNormalEmployeesViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"产品输入设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0039"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKProductInputViewController *vc = [[MJKProductInputViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"介绍人选择设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0040"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKChooseReferencesViewController *vc = [[MJKChooseReferencesViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"日报发布时间设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0042"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKDailyTimeViewController *vc = [[MJKDailyTimeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }  else if ([dic[@"title"] isEqualToString:@"订单必填项设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0041"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKOrderMandatoryViewController *vc = [[MJKOrderMandatoryViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"订单信息开放选择设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0043"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKOrderInfoOpenViewController *vc = [[MJKOrderInfoOpenViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dic[@"title"] isEqualToString:@"日报汇报内容设置"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0011"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKNewWorkReportSettingViewController *vc = [[MJKNewWorkReportSettingViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 点击事件
- (void)exitButtonAction:(UIButton *)sender {
	UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"退出账号" message:@"你确实要退出账号？" preferredStyle:UIAlertControllerStyleActionSheet];
	UIAlertAction*action0=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		
	}];
	UIAlertAction*action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		
		[NewUserSession cleanUser];
        
        /*EMError *error = [[EMClient sharedClient] logout:YES];
        if (!error) {
            NSLog(@"退出成功");
        }*/
	}];
	[alertVC addAction:action1];
	[alertVC addAction:action0];
	
	
	[self presentViewController:alertVC animated:YES completion:nil];
    
    
    
}

#pragma mark - set
- (UITableView *)tableview {
	if (!_tableview) {
		_tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
		_tableview.delegate = self;
		_tableview.dataSource = self;
	}
	return _tableview;
}

- (UIButton *)exitButton {
	if (!_exitButton) {
		_exitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, KScreenHeight - 50, KScreenWidth, 50)];
		[_exitButton setBackgroundColor:[UIColor redColor]];
		[_exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
//        _exitButton.layer.cornerRadius = 5.0f;
		[_exitButton addTarget:self action:@selector(exitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	return  _exitButton;
}

- (NSMutableArray *)cellContent {
	if (!_cellContent) {
		
		_cellContent = [NSMutableArray array];
		if ([self.title isEqualToString:@"个人设置"]) {
			[_cellContent addObject:@{@"image" : @"销售业绩目标设置.png" , @"title" : @"个人业绩目标设置"}];
//            [_cellContent addObject:@{@"image" : @"个人汇报内容设置.png" , @"title" : @"个人汇报内容设置"}];
        
			[_cellContent addObject:@{@"image" : @"休假排班图标应用.png" , @"title" : @"休假排班设置"}];
			[_cellContent addObject:@{@"image" : @"首页提醒设置" , @"title" : @"首页提醒显示设置"}];
            
            [_cellContent addObject:@{@"image" : @"排序设置" , @"title" : @"潜客列表排序设置"}];
		} else {
			NSMutableDictionary *titleDic = [NSMutableDictionary dictionary];
			titleDic[@"title"] = @[@"客户管理相关",@"订单管理相关",@"绩效管理相关",@"消息推送相关",@"硬件设备相关",@"账号安全相关"];
			
			
			
		
		
		
//		if ([self.title isEqualToString:@"客户管理相关"]) {
			NSMutableArray *customerArray = [NSMutableArray array];
			//客户相关
			[customerArray addObject:@{@"image" : @"客户回访等级设置.png" , @"title" : @"潜客跟进周期设置"}];
			[customerArray addObject:@{@"image" : @"会员等级回访设置图标" , @"title" : @"粉丝互动周期设置"}];
			[customerArray addObject:@{@"image" : @"市场活动设置.png" , @"title" : @"渠道细分设置"}];
			[customerArray addObject:@{@"image" : @"客户查重设置图标.png" , @"title" : @"潜客查重设置"}];
//            [customerArray addObject:@{@"image" : @"楼盘.png" , @"title" : @"楼盘字典设置"}];
			[customerArray addObject:@{@"image" : @"标签设置图标.png" , @"title" : @"潜客标签设置"}];
			[customerArray addObject:@{@"image" : @"公海设置按钮.png" , @"title" : @"公海转流规则设置"}];
            [customerArray addObject:@{@"image" : @"客户必填项设置.png" , @"title" : @"潜客必填项设置"}];
            [customerArray addObject:@{@"image" : @"介绍人设置.png" , @"title" : @"介绍人选择设置"}];
            [customerArray addObject:@{@"image" : @"任务类型设置.png" , @"title" : @"任务类型设置"}];
            [customerArray addObject:@{@"image" : @"审批设置.png" , @"title" : @"审批设置"}];
//			[_cellContent addObject:@{@"image" : @"客户列表排序设置.png" , @"title" : @"客户列表排序设置"}];
			
			
//			//流量相关
//			NSString *BUYTYPE_0003 = [[NewUserSession instance].buyTypeMap objectForKey:@"A40300_C_BUYTYPE_0003"];
//			if (BUYTYPE_0003.intValue == 1) {//微信营销中的名单流量
//				[_cellContent addObject:@{@"image" : @"销售线索分配设置.png" , @"title" : @"员工名单分配设置"}];
//			} else if ([[NewUserSession instance].hotappList containsObject:@"A40300_X_HOTAPP_0026"]) {
//				[_cellContent addObject:@{@"image" : @"销售线索分配设置.png" , @"title" : @"员工名单分配设置"}];
//			}
			
			
//		} else if ([self.title isEqualToString:@"订单管理相关"]) {
			//订单相关
			NSMutableArray *orderArray = [NSMutableArray array];
			[orderArray addObject:@{@"image" : @"订单编号设置" , @"title" : @"订单编号设置"}];
			[orderArray addObject:@{@"image" : @"促销活动设置图标" , @"title" : @"促销活动设置"}];
			[orderArray addObject:@{@"image" : @"经营品牌设置.png" , @"title" : @"订单关怀周期设置"}];
			[orderArray addObject:@{@"image" : @"订单节点设置图标.png" , @"title" : @"订单节点设置"}];
            [orderArray addObject:@{@"image" : @"产品分类设置.png" , @"title" : @"产品分类设置"}];
            [orderArray addObject:@{@"image" : @"产品输入设置.png" , @"title" : @"产品输入设置"}];
//            [orderArray addObject:@{@"image" : @"订单默认员工设置.png" , @"title" : @"订单相关负责人设置"}];
//            [orderArray addObject:@{@"image" : @"财务订单审核设置.png" , @"title" : @"订单财务审核设置"}];
//            [orderArray addObject:@{@"image" : @"订单必填项设置.png" , @"title" : @"订单必填项设置"}];
//            [orderArray addObject:@{@"image" : @"订单信息开放选择设置.png" , @"title" : @"订单信息开放选择设置"}];
			
//		} else if ([self.title isEqualToString:@"绩效管理相关"]) {
			//绩效相关
			
			NSMutableArray *resultsArray = [NSMutableArray array];
			
			[resultsArray addObject:@{@"image" : @"个人业务积分设置.png" , @"title" : @"绩效得分规则设置"}];
			[resultsArray addObject:@{@"image" : @"组队pk设置.png" , @"title" : @"绩效分组PK设置"}];
			
			[resultsArray addObject:@{@"image" : @"任务排班设置图标.png" , @"title" : @"任务排班公示设置"}];
			[resultsArray addObject:@{@"image" : @"考勤设置图标.png" , @"title" : @"考勤规则设置"}];
            [resultsArray addObject:@{@"image" : @"工作圈日报时间设置.png" , @"title" : @"日报发布时间设置"}];
            [resultsArray addObject:@{@"image" : @"工作汇报设置.png" , @"title" : @"日报汇报内容设置"}];
            [resultsArray addObject:@{@"image" : @"日报必填项设置" , @"title" : @"日报必填项设置"}];
            [resultsArray addObject:@{@"image" : @"奖惩制度设置" , @"title" : @"奖惩制度设置"}];
            
            [resultsArray addObject:@{@"image" : @"脉趣豆对账记录图标.png" , @"title" : @"脉趣豆对账记录"}];
            //首页报表显示设置
            [resultsArray addObject:@{@"image" : @"首页报表显示设置" , @"title" : @"首页报表显示设置"}];

			
//		} else if ([self.title isEqualToString:@"消息推送相关"]) {
			NSMutableArray *messageArray = [NSMutableArray array];
			[messageArray addObject:@{@"image" : @"推送消息设置图标1.png" , @"title" : @"内部消息推送设置"}]; //内部消息推送设置
            [messageArray addObject:@{@"image" : @"客户推送设置图标" , @"title" : @"外部消息推送设置"}];
			[messageArray addObject:@{@"image" : @"公共消息模板设置图标.png" , @"title" : @"公共消息模板设置"}];
            [messageArray addObject:@{@"image" : @"喜报模板设置图标.png" , @"title" : @"喜报模板设置"}];
//		} else if ([self.title isEqualToString:@"硬件设备相关"]) {
			NSMutableArray *deviceArray = [NSMutableArray array];
//            NSString *BUYTYPE_0002 = [NewUserSession instance].buyTypeMap[@"A40300_C_BUYTYPE_0002"];
//            if (BUYTYPE_0002.intValue == 1) {//客流管理中的人脸识别
				[deviceArray addObject:@{@"image" : @"流量仪设置.png" , @"title" : @"人脸识别设置"}];
            [deviceArray addObject:@{@"image" : @"renlianshibie.png" , @"title" : @"人脸识别规则设置"}];
            
//            [deviceArray addObject:@{@"image" : @"在线展厅设置.png" , @"title" : @"在线展厅设置"}];
//            } else if ([[NewUserSession instance].hotappList containsObject:@"A40300_X_HOTAPP_0023"]) {
//                [deviceArray addObject:@{@"image" : @"流量仪设置.png" , @"title" : @"人脸识别设置"}];
//            }
			[deviceArray addObject:@{@"image" : @"设备管理 .png" , @"title" : @"屏幕管理设置"}];
            [deviceArray addObject:@{@"image" : @"AI外呼参数图标.png" , @"title" : @"AI外呼参数"}];
            [deviceArray addObject:@{@"image" : @"公司信息设置图标.png" , @"title" : @"公司信息设置"}];
//		} else {
			//其他相关
			
			NSMutableArray *otherArray = [NSMutableArray array];
			[otherArray addObject:@{@"image" : @"安全设置按钮.png" , @"title" : @"安全设置"}];
            [otherArray addObject:@{@"image" : @"员工账号设置图标.png" , @"title" : @"员工账号设置"}];
            [otherArray addObject:@{@"image" : @"全部应用功能设置" , @"title" : @"应用功能管理设置"}];
            [otherArray addObject:@{@"image" : @"文档" , @"title" : @"共享文档设置"}];
//			[_cellContent addObject:@{@"image" : @"员工账号设置.png" , @"title" : @"员工账号设置"}];
			
//		}
			titleDic[@"content"] = @[customerArray, orderArray, resultsArray, messageArray, deviceArray, otherArray];
			[_cellContent addObject:titleDic];
		}
		
		
	}
	return _cellContent;
}

@end
