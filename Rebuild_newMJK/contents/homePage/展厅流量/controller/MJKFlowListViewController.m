//
//  MJKFlowListViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/6.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKFlowListViewController.h"
#import "MJKVoiceCViewController.h"
#import "MJKMarketViewController.h"
#import "MJKAddFlowViewController.h"
#import "MJKFlowDetailViewController.h"
#import "CommonCallViewController.h"
#import "CGCAlertDateView.h"
#import "DBNavigationController.h"
#import "MJKFlowMeterViewController.h"
#import "MJKFlowMeterConductViewController.h"
//查看详情
#import "CustomerDetailViewController.h"
//跟进潜客
#import "CustomerFollowAddEditViewController.h"
//新增潜客
#import "AddOrEditlCustomerViewController.h"

#import "MJKFlowListTableViewCell.h"

#import "CGCNavSearchTextView.h"//textfield筛选框
#import "CFDropDownMenuView.h"
#import "CGCCustomDateView.h"
#import "MJKAssignedView.h"

#import "MJKClueListViewModel.h"
#import "MJKFlowListModel.h"
#import "MJKFlowListFirstSubModel.h"
#import "MJKFlowListSecondSubModel.h"
#import "MJKFunnelChooseModel.h"
#import "MJKFlowNoFlie.h"
#import "FMDBManager.h"
#import "NSString+Extern.h"
#import "CGCCustomModel.h"
#import <objc/message.h>

#import "MJKShopArriveViewController.h"
#import "CGCMoreCollection.h"

#import "MJKManagerModuleViewController.h"//应用中心
#import "MJKFlowProcessViewController.h"
#import "MJKFlowMeterSubSecondModel.h"
#import "MJKChooseEmployeesViewController.h"

#define FlowCell @"flowCell"

@interface MJKFlowListViewController ()<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate, DBNavigationControllerDelegate, AddOrEditlCustomerViewControllerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) CGCNavSearchTextView *titleView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJKClueListViewModel *clueListModel;

@property (nonatomic, strong) NSMutableArray *saleCodeArr;//销售顾问code
@property (nonatomic, strong) NSMutableArray *statusNameArr;//状态
@property (nonatomic, strong) NSMutableArray *statusCodeArr;//状态code
@property (nonatomic, strong) NSMutableArray *shopTimeArr;//到店时间
@property (nonatomic, strong) NSMutableArray *shopTimeCodeArr;//到店时间code
@property (nonatomic, strong) NSString *shopTimesCode;
@property (nonatomic, strong) NSMutableArray *marketArr;//市场活动
@property (nonatomic, strong) NSMutableArray *marketCodeArr;//市场活动code
@property (nonatomic, strong) NSString *marketCode;       //
@property (nonatomic, strong) NSString *arraiveShopCode;
@property (nonatomic, strong) NSString *proceTimeCode;
@property (nonatomic, strong) NSString *START_TIME;
@property (nonatomic, strong) NSString *END_TIME;
@property (nonatomic, strong) NSString *DEAL_START_TIME;
@property (nonatomic, strong) NSString *DEAL_END_TIME;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) MJKFlowListModel *flowListModel;
@property (nonatomic, strong) NSMutableArray *saveFunnelAllDatas;

@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger pagen;

@property (nonatomic, assign) BOOL isShop;//是否到店
@property (nonatomic, assign) BOOL isAgain;//是否重新指派
@property (nonatomic, assign) BOOL isAllSelect; //是否全选

@property (nonatomic, strong) MJKAssignedView *assignView;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) MJKFlowListSecondSubModel *model;
@property (nonatomic, strong) NSString *backView;
@property (nonatomic, strong) UIButton *countButton;
/** 来源渠道*/
@property (nonatomic, strong) NSString *fromStr;


@property(nonatomic,copy)void(^localBlock)();
@end

@implementation MJKFlowListViewController
//tab页点新增
- (void)setIsAdd:(BOOL)isAdd {
	_isAdd = isAdd;
	if (isAdd == YES) {
		[self clickAddNew:nil];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
//	if ([self.backView isEqualToString:@"flowDetailVC"]) {
//		return;
//	}
//	self.pages = 1;
	//刷新列表
//	[self HTTPGetSalesListDatas];
	NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"isBack"];
	if ([str isEqualToString:@"yes"]) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//			[self HTTPGetSalesListDatas];
			[self.tableView.mj_header beginRefreshing];
		});
	}
	[[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"isBack"];
	
//	if ([self.VCName isEqualToString:@"返回首页"]) {
//		DBNavigationController *tfNavi = (DBNavigationController *)self.navigationController;
//		tfNavi.dbDelegate = self;
		
		UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
		[button setImage:[UIImage imageNamed:@"btn-返回.png"] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(backBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
		self.navigationItem.leftBarButtonItem = item;
	
//	}
	self.navigationController.interactivePopGestureRecognizer.delegate = self;
	
	id target = self.navigationController.interactivePopGestureRecognizer.delegate;
	
	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:@selector(handleNavigationTransition:)];
	pan.delegate = self;
	[self.view addGestureRecognizer:pan];
	self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    unsigned int count = 0;
    Method *memberFuncs = class_copyMethodList([self.navigationController class], &count);
    for (int i = 0; i < count; i++)
    {
        SEL address = method_getName(memberFuncs[i]);
        NSLog(@"member method : %@",NSStringFromSelector(address));
//        NSString *methodName = [NSString stringWithCString:sel_getName(interactivePopGestureRecognizer) encoding:NSUTF8StringEncoding];
//        NSLog(@"member method : %@",methodName);
    }
	
}

#pragma mark tapGestureRecgnizerdelegate 解决手势冲突
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    if ([touch.view isKindOfClass:[UITableView class]]){
//        return NO;
//    }
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
//    return YES;
//}
//解决边缘返回和tableview的手势冲突
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    // 根据具体控制器对象决定是否开启全屏右滑返回
    //    for (UIViewController *viewController in self.blackList) {
    //        if ([self topViewController] == viewController) {
    //            return NO;
    //        }
    //    }
    
    
    
    
    
    // 解决右滑和UITableView左滑删除的冲突
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    return self.childViewControllers.count == 1 ? NO : YES;
}

- (void)handleNavigationTransition:(UIPanGestureRecognizer *)panGR {
	if ([self.VCName isEqualToString:@"返回首页"]) {
		for (UIViewController * vc in self.navigationController.viewControllers) {//MJKManagerModuleViewController
			if ([vc isKindOfClass:[MJKManagerModuleViewController class]]) {
				[self.navigationController popToViewController:vc animated:YES];
			}
		}
	} else {
		[self.navigationController popViewControllerAnimated:YES];
	}
}




- (void)backBarButtonClick {
	if ([self.VCName isEqualToString:@"返回首页"]) {
		for (UIViewController * vc in self.navigationController.viewControllers) {
			if ([vc isKindOfClass:[MJKManagerModuleViewController class]]) {
				[self.navigationController popToViewController:vc animated:YES];
			}
		}
	} else {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"有效进店";
	self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
	[self initUI];
	[self.tableView registerNib:[UINib nibWithNibName:@"MJKFlowListTableViewCell" bundle:nil] forCellReuseIdentifier:FlowCell];
	self.pagen = 20;
}

- (void)initUI {
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
	[button setBackgroundImage:[UIImage imageNamed:@"流量.png"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(clickAddNew:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];;
	self.navigationItem.rightBarButtonItem = barButton;
	
	[self.view addSubview:self.tableView];
	//来源渠道
	[self fromMarket];
	//渠道细分
	[self HTTPGetMarketActionDatas];
	[self HTTPGetSalesListDatas];
	
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.flowListModel.content.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	MJKFlowListFirstSubModel *model = self.flowListModel.content[section];
	return model.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKFlowListTableViewCell *cell = [MJKFlowListTableViewCell cellWithTableView:tableView];
	MJKFlowListFirstSubModel *model = self.flowListModel.content[indexPath.section];
	cell.isAgain = self.isAgain;
	cell.selectArray = self.selectArray;
	cell.rootViewController = self;
	cell.model = model.content[indexPath.row];
	if (indexPath.row == model.content.count - 1) {
		cell.sepLabelLayout.constant = 0;
	}
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view = [[UIView alloc]initWithFrame:self.tableView.tableHeaderView.frame];
	view.backgroundColor = DBColor(247,247,247);
	UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
	timeLabel.textColor = DBColor(153,153,153);
	MJKFlowListFirstSubModel *model = self.flowListModel.content[section];
	timeLabel.text = model.total;
	timeLabel.font = [UIFont systemFontOfSize:14.0f];
	CGSize size = [timeLabel.text sizeWithFont:timeLabel.font constrainedToSize:CGSizeMake(1000.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
	timeLabel.frame = CGRectMake(16, 3, size.width, size.height);
	[view addSubview:timeLabel];
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 84;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 21;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKFlowListFirstSubModel *firstSubModel = self.flowListModel.content[indexPath.section];
	MJKFlowListSecondSubModel *model = firstSubModel.content[indexPath.row];
	if ([model.C_STATUS_DD_ID isEqualToString:@"A41400_C_STATUS_0002"]) {//A41400_C_STATUS_0002 - 自然到店未留档
		return NO;
	}
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKFlowListFirstSubModel *firstSubModel = self.flowListModel.content[indexPath.section];
	MJKFlowListSecondSubModel *model = firstSubModel.content[indexPath.row];
	self.model = model;
	DBSelf(weakSelf);
    UITableViewRowAction *followAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"跟进客户" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (![[NewUserSession instance].appcode containsObject:@"APP004_0005"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        CustomerFollowAddEditViewController *followVC = [[CustomerFollowAddEditViewController alloc]init];
        CustomerDetailInfoModel *followModel = [[CustomerDetailInfoModel alloc]init];
        followModel.C_NAME = model.C_A41500_C_NAME;
        followModel.C_ID = model.C_A41500_C_ID;
        followModel.C_LEVEL_DD_NAME = model.C_LEVEL_DD_NAME;
        followModel.C_LEVEL_DD_ID = model.C_LEVEL_DD_ID;
        followVC.infoModel = followModel;
        [weakSelf.navigationController pushViewController:followVC animated:YES];
    }];
    followAction.backgroundColor = DBColor(50,151,234);
    
    UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"更多操作" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf clickMoreButton:model];
    }];
    moreAction.backgroundColor = DBColor(50,151,234);
    
    
    UITableViewRowAction *showAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"查看客户" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (![[NewUserSession instance].appcode containsObject:@"APP004_0025"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        CustomerDetailViewController *detailVC = [[CustomerDetailViewController alloc]init];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"VCName"];
        PotentailCustomerListDetailModel *detailModel = [[PotentailCustomerListDetailModel alloc]init];
        detailModel.C_A41500_C_ID = model.C_A41500_C_ID;
        detailVC.mainModel = detailModel;
        [self.navigationController pushViewController:detailVC animated:YES];
    }];
    showAction.backgroundColor = DBColor(153,153,153);
    
    UITableViewRowAction *noAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"未留档" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        DBSelf(weakSelf);
        NSMutableArray*failChooseArray=[NSMutableArray array];
        for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A42600_C_REXMARK_TYPE"] ) {
            [failChooseArray addObject:model.C_NAME];
        }
        CGCAlertDateView *alertDateView = [[CGCAlertDateView alloc]initWithFrame:self.view.frame withSelClick:^{
            //弹出选择就默认第一个
        } withSureClick:^(NSString *title, NSString *dateStr) {
            NSLog(@"%@",title);
            if ([title isEqualToString:@"其他原因"]) {
                model.C_REMARK_TYPE_DD_ID = @"A42600_C_REXMARK_TYPE_0002";
            } else if ([title isEqualToString:@"已购买其他产品"]) {
                model.C_REMARK_TYPE_DD_ID = @"A42600_C_REXMARK_TYPE_0001";
            } else {
                model.C_REMARK_TYPE_DD_ID = @"A42600_C_REXMARK_TYPE_0000";
            }
            [MJKFlowNoFlie HTTPUpdateFlowWithC_ID:model.C_ID andRemark:dateStr andShopType:model.C_REMARK_TYPE_DD_ID andBlock:^{
                [weakSelf HTTPGetFlowListDatas];
            }];
            //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                    [weakSelf HTTPGetFlowListDatas];
            //                });
        } withHight:195.0 withText:@"请填写未留档原因" withDatas:failChooseArray];
        alertDateView.textfield.placeholder = @"选择原因类型";
        alertDateView.remarkText.placeholder = @"请输入备注";
        [self.view addSubview:alertDateView];
    }];
    noAction.backgroundColor = DBColor(153,153,153);
    
    
	
    UITableViewRowAction *newCustomerAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"新客户" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //新增潜客
        DBSelf(weakSelf);
        AddOrEditlCustomerViewController *addVC = [[AddOrEditlCustomerViewController alloc]init];
        addVC.vcName = @"门店";
        addVC.Type = customerTypeExhibition;
        addVC.exhibitionMarketAction = model.C_A41200_C_NAME;
        addVC.exhibitionMarketActionID = model.C_A41200_C_ID;
        addVC.exhibitionC_A41400_C_ID = model.C_ID;
        addVC.exhibitionSourceAction = model.C_SOURCE_DD_NAME;
        addVC.exhibitionSourceActionID = model.C_SOURCE_DD_ID;
        addVC.delegate = self;
        //            [addVC setCompleteComitBlock:^(NSString *C_A41500_C_ID){
        //                [weakSelf HTTPCustomConnect:model.C_ID andType:@"1" andC_A41500_C_ID:C_A41500_C_ID];
        //            }];
        [weakSelf.navigationController pushViewController:addVC animated:YES];
    }];
    newCustomerAction.backgroundColor = DBColor(255,195,0);
    
    UITableViewRowAction *phoneAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"电话" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        if (![[NewUserSession instance].appcode containsObject:@"APP002_0008"]) {
//            [JRToast showWithText:@"账号无权限"];
//            return;
//        }
        if (model.C_PHONE.length == 11) {
            [self selectTelephone:indexPath.row];
        } else {
            [JRToast showWithText:@"电话号不合法"];
        }
    }];
    phoneAction.backgroundColor = DBColor(255,195,0);
    
    UITableViewRowAction *isAssAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"重新指派" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (![[NewUserSession instance].appcode containsObject:@"crm:a414:zp"]) {
            [JRToast showWithText:@"账号无权限"];
            return ;
        }
        model.selected = YES;
        MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
        if ([[NewUserSession instance].appcode containsObject:@"APP010_0015"]) {
            vc.isAllEmployees = @"是";
        }
        vc.noticeStr = @"无提示";
        vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull subModel) {
            [weakSelf HTTPCustomConnect:model.C_ID andUserID:subModel.user_id andSuccessBlock:^{
                [weakSelf HTTPGetFlowListDatas];
            }];
        };
        
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    isAssAction.backgroundColor = KNaviColor;
    
    if ([model.C_STATUS_DD_NAME isEqualToString:@"未处理"]) {
        return @[isAssAction];
    } else {
        return @[followAction, showAction, phoneAction];
    }
}

#pragma mark  --delegate
-(void)DelegateForCompleteAddCustomerShowAlertVCToFollow:(CustomerDetailInfoModel *)newModel{
	DBSelf(weakSelf);
	[weakSelf HTTPCustomConnect:self.model.C_ID andType:@"1" andC_A41500_C_ID:newModel.C_A41500_C_ID];
		UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否为新客户添加跟进" preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
			for (UIViewController *controller in weakSelf.navigationController.viewControllers) {
				if ([controller isKindOfClass:[MJKFlowListViewController class]]) {
					[weakSelf.navigationController popToViewController:controller animated:YES];
				}
			}
		}];
		UIAlertAction*sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [DBObjectTools httpPostGetCustomerDetailInfoWithC_ID:newModel.C_A41500_C_ID andCompleteBlock:^(CustomerDetailInfoModel *customerDetailModel) {
                
                CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
                vc.Type=CustomerFollowUpAdd;
                customerDetailModel.C_A41500_C_ID=customerDetailModel.C_ID;
                vc.infoModel=customerDetailModel;
                vc.vcSuper=self;
                vc.followText=nil;
                [self.navigationController pushViewController:vc animated:YES];
            }];
			
			
		}];
		[alertVC addAction:cancel];
		[alertVC addAction:sure];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:alertVC animated:YES completion:nil];
    });
    
		
	
	
	
	
	
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKFlowListFirstSubModel *firstSubModel = self.flowListModel.content[indexPath.section];
	MJKFlowListSecondSubModel *model = firstSubModel.content[indexPath.row];
	if ([model.C_STATUS_DD_ID isEqualToString:@"A41400_C_STATUS_0003"] || [model.C_STATUS_DD_ID isEqualToString:@"A41400_C_STATUS_0004"] || [model.C_STATUS_DD_ID isEqualToString:@"A41400_C_STATUS_0007"]) {
		if (![[NewUserSession instance].appcode containsObject:@"APP004_0025"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
			//查看潜客
		CustomerDetailViewController *detailVC = [[CustomerDetailViewController alloc]init];
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VCName"];
		PotentailCustomerListDetailModel *detailModel = [[PotentailCustomerListDetailModel alloc]init];
		detailModel.C_A41500_C_ID = model.C_A41500_C_ID;
		detailVC.mainModel = detailModel;
		[self.navigationController pushViewController:detailVC animated:YES];
		
		return;
    } else if ([model.C_STATUS_DD_ID isEqualToString:@"A41400_C_STATUS_0001"]) {
        //APP002_0014
        if (![[NewUserSession instance].appcode containsObject:@"APP002_0014"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        NSDictionary *dic = [model mj_keyValues];
        MJKFlowMeterSubSecondModel *subSecondModel = [MJKFlowMeterSubSecondModel mj_objectWithKeyValues:dic];
        MJKFlowProcessViewController *vc = [[MJKFlowProcessViewController alloc]init];
        vc.model = subSecondModel;
        vc.superVC = self.superVC;
        vc.type = MJKFlowProcessOneImage;
        vc.vcName = @"到店";
        vc.typeName = @"有效流量";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
//        MJKFlowDetailViewController *detailVc = [[MJKFlowDetailViewController alloc]init];
//        detailVc.C_ID = model.C_ID;
//        detailVc.clueListModel = self.clueListModel;
//        detailVc.clueSourceName = model.C_CLUESOURCE_DD_NAME;
//        DBSelf(weakSelf);
//        [detailVc setBackViewBlock:^(NSString *str){
//            weakSelf.backView = str;
//        }];
//        detailVc.superVC = self;
//        [self.navigationController pushViewController:detailVc animated:YES];
        if (![[NewUserSession instance].appcode containsObject:@"APP002_0014"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        NSDictionary *dic = [model mj_keyValues];
        MJKFlowMeterSubSecondModel *subSecondModel = [MJKFlowMeterSubSecondModel mj_objectWithKeyValues:dic];
        MJKFlowProcessViewController *vc = [[MJKFlowProcessViewController alloc]init];
        vc.model = subSecondModel;
        vc.type = MJKFlowProcessOneImage;
        vc.typeName = @"有效流量";
        vc.vcName = @"详情";
        vc.clueName = @"已处理流量详情";
//        vc.vcName = @"到店";
        
        [self.navigationController pushViewController:vc animated:YES];
	}
	
}


- (void)addChooseView {
	[self.view addSubview:self.countButton];
	CFDropDownMenuView *menuView = [[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth - 40, 40)];
	[self.view addSubview:menuView];
	NSMutableArray *saleArr = [NSMutableArray array];
	[saleArr addObject:@"全部"];
	[saleArr addObject:@"我的"];
	self.saleCodeArr = [NSMutableArray array];
	[self.saleCodeArr addObject:@""];
	NSString * user_id=[NewUserSession instance].user.u051Id;
	[self.saleCodeArr addObject:user_id];
	NSArray *arr = self.clueListModel.data;
	for (MJKClueListSubModel *clueListSubModel in arr) {
		[saleArr addObject:clueListSubModel.nickName];
		[self.saleCodeArr addObject:clueListSubModel.u051Id];
	}
    if (_statusCode.length <= 0) {
        _statusCode = @"";
    }
    _shopTimesCode = _marketCode = _arraiveShopCode = _proceTimeCode = _phoneNumber = @"";
	menuView.dataSourceArr = [@[saleArr, [self getStatus], self.shopTimeArr, self.shopTimeArr]mutableCopy];
	menuView.defaulTitleArray = @[@"员工", @"状态", @"到店时间", @"处理时间"];
	menuView.startY=CGRectGetMaxY(menuView.frame);
	DBSelf(weakSelf);
	menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
		weakSelf.pagen = 20;
		weakSelf.pages = 1;
		[weakSelf selectScreenDatas:selectedSection.integerValue andRow:selectedRow.integerValue andTitle:title];
	};
	
	//得到筛选的所有数据
	[self getFunnelValue];
	
	//这个是筛选的view
	FunnelShowView*funnelView=[FunnelShowView funnelShowView];
	//延迟 传入参数
	//	self.localBlock = ^{
	funnelView.allDatas=weakSelf.saveFunnelAllDatas;
	
	//	};
	
	//c_id 是999 的时候  是选择时间
	funnelView.viewCustomTimeBlock = ^(NSInteger selectedSession){
		MyLog(@"自定义时间");
		weakSelf.isShop = NO;
		[weakSelf showTimeAlertVC];
	};
	
	funnelView.resetBlock = ^{
		self.DEAL_START_TIME = @"";
		self.DEAL_END_TIME = @"";
        [weakSelf.tableView.mj_header beginRefreshing];
	};
	
	//    回调
	funnelView.sureBlock = ^(NSMutableArray *array){
		weakSelf.pagen = 20;
		weakSelf.pages = 1;
		if (array.count <= 0) {
			weakSelf.marketCode = weakSelf.arraiveShopCode = @"";
		}
		NSMutableArray <NSString *>*backArray = [NSMutableArray array];
		for (int i = 0; i < array.count; i++) {
			[backArray addObject:array[i][@"index"]];
		}
		for (int j = 0; j < backArray.count; j++) {
			MJKFunnelChooseModel *model = array[j][@"model"];
			if (([backArray[j] isEqualToString:@"0"] )) {
				weakSelf.fromStr = model.c_id;
			} else if ([backArray[j] isEqualToString:@"1"] ) {
				weakSelf.marketCode = model.c_id;
				
			} else {
				
				weakSelf.arraiveShopCode = model.c_id;
			}
		}
		//吊接口  加上上面的筛选
//		[weakSelf HTTPGetFlowListDatas];
		[weakSelf.tableView.mj_header beginRefreshing];
	};
	[[UIApplication sharedApplication].keyWindow addSubview:funnelView];
	
	//这个是漏斗按钮
	CFRightButton*funnelButton=[[CFRightButton alloc]initWithFrame:CGRectMake( KScreenWidth-40,NavStatusHeight, 40, 40)];
	[self.view addSubview:funnelButton];
	funnelButton.clickFunnelBlock = ^(BOOL isSelected) {
		[menuView hide];
		//显示 左边的view
		[funnelView show];
	};
	//分割线
//	UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, 104, KScreenWidth - self.countButton.frame.size.width, 1)];
//	sepView.backgroundColor = DBColor(213, 213, 218);
//	[self.view addSubview:sepView];
}

-(void)setUpRefresh{
	self.pages = 1;
	DBSelf(weakSelf);
	self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
		weakSelf.pages = 1;
		weakSelf.pagen = 20;
		[weakSelf HTTPGetFlowListDatas];
		
	}];
	[self.tableView.mj_header beginRefreshing];
	self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		weakSelf.pagen += 20;
		[weakSelf HTTPGetFlowListDatas];
	}];
}

#pragma mark - 点击事件
//点击更多操作时
- (void)clickMoreButton:(MJKFlowListSecondSubModel *)model{
    DBSelf(weakSelf);
    CGCMoreCollection *moreCollection = [[CGCMoreCollection alloc]initWithFrame:self.view.bounds withPicArr:@[@"关联现有潜客.png",@"老客户预约.png", @"重新指派.png"] withTitleArr:@[@"客户到店", @"预约到店", @"重新指派"] withTitle:@"更多操作" withSelectIndex:^(NSInteger index, NSString *title) {
        if ([title isEqualToString:@"客户到店"]) {
            MJKCustomerChooseViewController *customListVC = [[MJKCustomerChooseViewController alloc]init];
            customListVC.rootVC = self;
            customListVC.chooseCustomerBlock = ^(CGCCustomModel *model) {
                [weakSelf HTTPCustomConnect:weakSelf.model.C_ID andType:@"3" andC_A41500_C_ID:model.C_A41500_C_ID];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
            [weakSelf.navigationController pushViewController:customListVC animated:YES];
        }
        
        if ([title isEqualToString:@"预约到店"]) {
            MJKShopArriveViewController *arrVC = [[MJKShopArriveViewController alloc]initWithNibName:@"MJKShopArriveViewController" bundle:nil];
            
            arrVC.backC_ID = ^(NSString *C_ID) {
                [weakSelf HTTPCustomConnect:model.C_ID andType:@"6" andC_A41500_C_ID:C_ID];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
            [weakSelf.navigationController pushViewController:arrVC animated:YES];
        }
        
        if ([title isEqualToString:@"重新指派"]) {
            if (![[NewUserSession instance].appcode containsObject:@"crm:a414:zp"]) {
                [JRToast showWithText:@"账号无权限"];
                return ;
            }
            model.selected = YES;
            MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
            if ([[NewUserSession instance].appcode containsObject:@"APP010_0015"]) {
                vc.isAllEmployees = @"是";
            }
            vc.noticeStr = @"无提示";
            vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull subModel) {
                [weakSelf HTTPCustomConnect:model.C_ID andUserID:subModel.user_id andSuccessBlock:^{
                    [weakSelf HTTPGetFlowListDatas];
                }];
			};
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
    [self.view addSubview:moreCollection];
    

}
#pragma mark 重新指派
- (void)HTTPCustomConnect:(NSString *)C_ID andUserID:(NSString *)userID andSuccessBlock:(void(^)(void))completeBlock {
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = C_ID;
    contentDic[@"TYPE"] = @"4";
    contentDic[@"USER_ID"] = userID;
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:contentDic withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a414/operation", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        //        DBSelf(weakSelf);
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if (completeBlock) {
                completeBlock();
            }
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)clickAddNew:(UIButton *)sender {
//    MJKAddFlowViewController *addFlowVC = [[MJKAddFlowViewController alloc]init];
//    addFlowVC.superVC = self;
//    [self.navigationController pushViewController:addFlowVC animated:YES];
    
    if (![[NewUserSession instance].appcode containsObject:@"crm:a414:add"]) {
        [JRToast showWithText:@"账号无权限"];
        return;
    }
    
    MJKFlowProcessViewController *vc = [[MJKFlowProcessViewController alloc]init];
    vc.type = MJKFlowProcessOneImage;
    vc.superVC = self.superVC;
    vc.clueName = @"新增";
    vc.vcName = @"到店";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 重写方法
//电话
- (void)telephoneCall:(NSInteger)index{
    if (self.model.C_PHONE.length > 0) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString: [NSString stringWithFormat:@"tel://%@",self.model.C_PHONE ]]];
    }else {
        [JRToast showWithText:@"无电话号码"];
    }
	
}

- (void)whbcallBack:(NSInteger)index {
    if (self.model.C_PHONE.length > 0) {
        [DBObjectTools whbCallWithC_OBJECT_ID:self.model.C_ID andC_CALL_PHONE:self.model.C_PHONE andC_NAME:self.model.C_A41500_C_NAME andC_OBJECTTYPE_DD_ID:[self.model.C_STATUS_DD_ID isEqualToString:@"A41400_C_STATUS_0003"] ? @"A83100_C_OBJECTTYPE_0001" : @"A83100_C_OBJECTTYPE_0006" andCompleteBlock:nil];
    } else {
       [JRToast showWithText:@"无电话号码"];
   }
}

- (void)closePhone {
    [self alertViewFollow];
    
}

- (void)alertViewFollow {
    DBSelf(weakSelf);
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"是否新增跟进" message:nil  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CustomerDetailInfoModel*infoModel=[[CustomerDetailInfoModel alloc]init];
        infoModel.C_ID=weakSelf.model.C_A41500_C_ID;
        infoModel.C_HEADIMGURL=weakSelf.model.C_HEADIMGURL;
        infoModel.C_NAME=weakSelf.model.C_A41500_C_NAME;
        infoModel.C_LEVEL_DD_NAME=weakSelf.model.C_LEVEL_DD_NAME;
        infoModel.C_LEVEL_DD_ID=weakSelf.model.C_LEVEL_DD_ID;
        infoModel.C_STAGE_DD_ID = weakSelf.model.C_STAGE_DD_ID;
        infoModel.C_STAGE_DD_NAME = weakSelf.model.C_STAGE_DD_NAME;
        
        
        CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
        vc.Type=CustomerFollowUpAdd;
        vc.infoModel=infoModel;
        vc.vcSuper=weakSelf;
        vc.followText=nil;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [alertV addAction:cancelAction];
    [alertV addAction:trueAction];
    
    [self presentViewController:alertV animated:YES completion:nil];
}

//座机
- (void)landLineCall:(NSInteger)index{
	
	CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
	myView.typeStr=@"用座机拨打";
	myView.nameStr=@"请接听座机来电，随后将其自动呼叫对方";
	myView.callStr=self.model.C_PHONE;
	[self.navigationController pushViewController:myView animated:YES];
	
}
//回呼
- (void)callBack:(NSInteger)index{
	CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
	myView.typeStr=@"回呼到手机";
	myView.nameStr=@"请接听手机来电，随后将其自动呼叫对方";
	myView.callStr=self.model.C_PHONE;
	[self.navigationController pushViewController:myView animated:YES];
	
}



#pragma mark - 数据请求
//销售顾问
- (void)HTTPGetSalesListDatas {
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list",HTTP_IP] parameters:@{@"C_LOCCODE" : [NewUserSession instance].user.C_LOCCODE} compliation:^(id data, NSError *error) {
	
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.clueListModel = [MJKClueListViewModel yy_modelWithDictionary:data];
//			[weakSelf HTTPGetMarketActionDatas];
			[weakSelf addChooseView];
			[weakSelf setUpRefresh];
//			[weakSelf HTTPGetFlowListDatas];
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}

//得到市场活动的数据
-(void)HTTPGetMarketActionDatas{
	NSMutableArray*saveMarketArray=[NSMutableArray array];
	MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
	model.name=@"全部";
	model.c_id=@"";
	[saveMarketArray addObject:model];
//	self.marketArr = [NSMutableArray array];
//	[self.marketArr addObject:@"全部"];
//	self.marketCodeArr = [NSMutableArray array];
//	[self.marketCodeArr addObject:@""];
	
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a412/list", HTTP_IP] parameters:@{@"C_TYPE_DD_ID":@"A41200_C_TYPE_0000"} compliation:^(id data, NSError *error) {
		DBSelf(weakSelf);
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			NSArray*array=data[@"data"][@"list"];
			for (NSDictionary*dict in array) {
//				[weakSelf.marketArr addObject:dict[@"C_NAME"]];
//				[weakSelf.marketCodeArr addObject:dict[@"C_ID"]];
				MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
				model.name=dict[@"C_NAME"];
				model.c_id=dict[@"C_ID"];
				
				[saveMarketArray addObject:model];
			}
			NSDictionary*dic=@{@"title":@"渠道细分",@"content":saveMarketArray};
			[weakSelf.saveFunnelAllDatas addObject:dic];
		} else {
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}

- (void)fromMarket {
	NSString*customerSourceStr=@"来源渠道";
	NSMutableArray*customerSourceArr=[NSMutableArray array];
	MJKFunnelChooseModel*customerSourceModel=[[MJKFunnelChooseModel alloc]init];
	customerSourceModel.name=@"全部";
	customerSourceModel.c_id=@"";
	[customerSourceArr addObject:customerSourceModel];
	for (MJKDataDicModel*model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41300_C_CLUESOURCE"]) {
		MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
		funnelModel.name=model.C_NAME;
		funnelModel.c_id=model.C_VOUCHERID;
		[customerSourceArr addObject:funnelModel];
	}
	NSDictionary*customerSourceDic=@{@"title":customerSourceStr,@"content":customerSourceArr};
	[self.saveFunnelAllDatas addObject:customerSourceDic];
}

- (void)HTTPGetFlowListDatas {
    
    NSString *nowTime =  [DBTools getTimeFomatFromCurrentTimeStampWithYMD];
    NSString *oneDayTime =  [DBTools getTimeFomatFromTimeStampOnlyYMDAddDay:1 andNowTime:nowTime];
    NSString *threeDayTime =  [DBTools getTimeFomatFromTimeStampOnlyYMDAddDay:2 andNowTime:oneDayTime];
    NSString *beforeOneDayTime =  [DBTools getBeforeTimeFomatFromTimeStampOnlyYMDAddDay:1 andNowTime:nowTime];
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	if (self.timerType==flowListTimeTypeToday) {
        [dict setObject:@"A41400_C_STATUS_0001" forKey:@"C_STATUS_DD_ID"];
        [dict setObject:[nowTime stringByAppendingString:@" 00:00:00"] forKey:@"ARRIVAL_START_TIME"];
        [dict setObject:[nowTime stringByAppendingString:@" 23:59:59"] forKey:@"ARRIVAL_END_TIME"];
	}else if (self.timerType==flowListTimeTypeOverDay){
        [dict setObject:@"A41400_C_STATUS_0001" forKey:@"C_STATUS_DD_ID"];
        [dict setObject:@"2000-01-01 00:00:00" forKey:@"ARRIVAL_START_TIME"];
        [dict setObject:[beforeOneDayTime stringByAppendingString:@" 23:59:59"] forKey:@"ARRIVAL_END_TIME"];
	}
    if (self.CREATE_TIME_TYPE.length > 0) {
        dict[@"CREATE_TIME_TYPE"] = self.CREATE_TIME_TYPE;
        [dict setObject:@"0" forKey:@"TYPE"];
    }
	[dict setObject:[NSString stringWithFormat:@"%ld", self.pages] forKey:@"pageNum"];
	[dict setObject:[NSString stringWithFormat:@"%ld", self.pagen] forKey:@"pageSize"];
	[dict setObject:@"0" forKey:@"TYPE"];
    if (self.saleCode.length > 0) {
        [dict setObject:self.saleCode forKey:@"USER_ID"];
    }

    if (self.statusCode.length > 0 ) {
        [dict setObject:self.statusCode forKey:@"C_STATUS_DD_ID"];
    }
	[dict setObject:self.marketCode.length > 0 ? self.marketCode : @"" forKey:@"C_A41200_C_ID"];
	if (self.START_TIME.length > 0 || self.END_TIME.length > 0) {
		[dict setObject:self.START_TIME.length > 0 ? self.START_TIME : @"" forKey:@"ARRIVAL_START_TIME"];
		[dict setObject:self.END_TIME.length > 0 ? self.END_TIME : @"" forKey:@"ARRIVAL_END_TIME"];
	} else {
		[dict setObject:self.shopTimesCode forKey:@"ARRIVAL_TIME_TYPE"];
	}
	if (self.fromStr.length > 0) {
		dict[@"C_SOURCE_DD_ID"] = self.fromStr;
	}
	[dict setObject:self.arraiveShopCode forKey:@"C_SOURCETYPE"];
	if (self.DEAL_START_TIME.length > 0 && self.DEAL_END_TIME.length > 0) {
		[dict setObject:self.DEAL_START_TIME forKey:@"DEAL_START_TIME"];
		[dict setObject:self.DEAL_END_TIME forKey:@"DEAL_END_TIME"];
	} else {
		[dict setObject:self.proceTimeCode forKey:@"DEAL_TIME_TYPE"];
	}
	[dict setObject:self.phoneNumber forKey:@"SEARCH_NAMEORCONTACT"];
    dict[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a414/list", HTTP_IP] parameters:dict compliation:^(id data, NSError *error) {
        DBSelf(weakSelf);
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.flowListModel = [MJKFlowListModel yy_modelWithDictionary:data[@"data"]];
            weakSelf.selectArray = [NSMutableArray array];
            [self.flowListModel.content enumerateObjectsUsingBlock:^(MJKFlowListFirstSubModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj.content enumerateObjectsUsingBlock:^(MJKFlowListSecondSubModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (weakSelf.isAllSelect == YES) {
                        obj.selected = YES;
                    }
                    [weakSelf.selectArray addObject:obj];
                }];
            }];
            [weakSelf.countButton setTitle:[NSString stringWithFormat:@"总计:%@",weakSelf.flowListModel.countNumber] forState:UIControlStateNormal];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
//	[manager postDataFromNetworkNoHudWithUrl:params parameters:nil compliation:^(id data, NSError *error) {
//		DBSelf(weakSelf);
//		MyLog(@"%@",data);
//		if ([data[@"code"] integerValue]==200) {
//			weakSelf.flowListModel = [MJKFlowListModel yy_modelWithDictionary:data];
//			weakSelf.selectArray = [NSMutableArray array];
//			[self.flowListModel.content enumerateObjectsUsingBlock:^(MJKFlowListFirstSubModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
//				[obj.content enumerateObjectsUsingBlock:^(MJKFlowListSecondSubModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
//					if (weakSelf.isAllSelect == YES) {
//						obj.selected = YES;
//					}
//					[weakSelf.selectArray addObject:obj];
//				}];
//			}];
//			[weakSelf.countButton setTitle:[NSString stringWithFormat:@"总计:%@",weakSelf.flowListModel.countNumber] forState:UIControlStateNormal];
//			[weakSelf.tableView reloadData];
//			[weakSelf.tableView.mj_header endRefreshing];
//			[weakSelf.tableView.mj_footer endRefreshing];
//		} else {
//			[JRToast showWithText:data[@"message"]];
//		}
//	}];
}

//关联客户
- (void)HTTPCustomConnect:(NSString *)C_ID andType:(NSString *)type andC_A41500_C_ID:(NSString *)C_A41500_C_ID {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
	
    dic[@"C_ID"] = C_ID;
    dic[@"TYPE"] = type;
    if (![type isEqualToString:@"6"]) {
        dic[@"C_A41500_C_ID"] = C_A41500_C_ID;
    } else {
        dic[@"C_A41600_C_ID"] = C_A41500_C_ID;
    }
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a414/operation", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
		DBSelf(weakSelf);
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf HTTPGetFlowListDatas];
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}

- (NSMutableArray *)getStatus {
	FMDBManager *manager = [FMDBManager sharedFMDBManager];
	NSArray *statusArray = [NSArray arrayWithArray:[manager queryDatasWithC_TYPECODE:@"A41400_C_STATUS"]];
	self.statusNameArr = [NSMutableArray array];
	[self.statusNameArr addObject:@"全部"];
	self.statusCodeArr = [NSMutableArray array];
	[self.statusCodeArr addObject:@""];
	for (MJKDataDicModel *model in statusArray) {
		[self.statusNameArr addObject:model.C_NAME];
		[self.statusCodeArr addObject:model.C_VOUCHERID];
	}
	[self.statusNameArr removeObject:@"未分配"];
	[self.statusNameArr removeObject:@"已处理"];
	[self.statusCodeArr removeObject:@"A41400_C_STATUS_0006"];
	[self.statusCodeArr removeObject:@"A41400_C_STATUS_0000"];
	return self.statusNameArr;
}

-(void)getFunnelValue {
	[self getArraiveShop];//到店方式
//	[self getRegisterTime];//处理时间
//	[self HTTPGetMarketActionDatas];
}

- (void)getArraiveShop {
	NSMutableArray*arraiveShopArray=[NSMutableArray array];
	MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
	model.name=@"全部";
	model.c_id=@"";
	[arraiveShopArray addObject:model];
	
	NSArray*name=  @[@"自然到店",@"预约到店"];
	NSArray *C_ID = @[@"1", @"2"];
	
	for (int i=0; i<name.count; i++) {
		MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
		model.name=name[i];
		model.c_id=C_ID[i];
		[arraiveShopArray addObject:model];
	}
	NSDictionary*dic=@{@"title":@"到店方式",@"content":arraiveShopArray};
	[self.saveFunnelAllDatas addObject:dic];
}

-(void)getRegisterTime{
	NSMutableArray*saveRegisterTimeArray=[NSMutableArray array];
//	NSArray*name=  @[@"全部",@"今天",@"最近7天",@"最近30天",@"本周",@"本月",@"自定义"];
//	//判断当999 的时候跳警告框选择时间  并接口中带入时间。
//	NSArray*C_ID=@[@"",@"1",@"7",@"30",@"2",@"3",@"999"];
	
	for (int i=0; i<self.shopTimeArr.count; i++) {
		MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
		model.name=self.shopTimeArr[i];
		model.c_id=self.shopTimeCodeArr[i];
		[saveRegisterTimeArray addObject:model];
	}
	NSDictionary*dic=@{@"title":@"处理时间",@"content":saveRegisterTimeArray};
	[self.saveFunnelAllDatas addObject:dic];
	
}

- (void)selectScreenDatas:(NSInteger)section andRow:(NSInteger)row andTitle:(NSString *)title{
	if (section == 0) {
		self.saleCode = self.saleCodeArr[row];
	}
	if (section == 1) {
		self.statusCode = self.statusCodeArr[row];
	}
	if (section == 2) {
		if ([title isEqualToString:@"自定义"]) {
			self.isShop = YES;
			[self showTimeAlertVC];
			return;
		} else {
			self.START_TIME = self.END_TIME = @"";
			self.shopTimesCode = self.shopTimeCodeArr[row];
		}
		
	}
	if (section == 3) {
		if ([title isEqualToString:@"自定义"]) {
			self.isShop = NO;
			[self showTimeAlertVC];
			return;
		} else {
			self.DEAL_START_TIME = self.DEAL_END_TIME = @"";
			self.proceTimeCode = self.shopTimeCodeArr[row];
		}
//		self.marketCode = self.marketCodeArr[row];
	}
//	[self HTTPGetFlowListDatas];
	[self.tableView.mj_header beginRefreshing];
}

-(void)showTimeAlertVC{
	//自定义的选择时间界面。
	DBSelf(weakSelf);
	CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
		
	} withEnd:^{
		
	} withSure:^(NSString *start, NSString *end) {
		weakSelf.pagen = 20;
		weakSelf.pages = 1;
		if (weakSelf.isShop == YES) {
			self.START_TIME = start;
			self.END_TIME = end;
		} else {
			self.DEAL_START_TIME = start;
			self.DEAL_END_TIME = end;
		}
//		[weakSelf HTTPGetFlowListDatas];
		[weakSelf.tableView.mj_header beginRefreshing];
	}];
	[[UIApplication sharedApplication].keyWindow addSubview:dateView];
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		CGRect rect = CGRectZero;
		if (self.isTab == YES) {
			rect = CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight - NavStatusHeight - 40 - WD_TabBarHeight - WD_TabBarHeight);
		} else {
			rect = CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight - NavStatusHeight - 40 - WD_TabBarHeight);
		}
		_tableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.dataSource = self;
		_tableView.delegate = self;
	}
	return _tableView;
}

- (NSMutableArray *)shopTimeArr {
	if (!_shopTimeArr) {
        
		_shopTimeArr = [NSMutableArray arrayWithObjects:@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义", nil];
	}
	return _shopTimeArr;
}

- (NSMutableArray *)shopTimeCodeArr {
	if (!_shopTimeCodeArr) {
		_shopTimeCodeArr = [NSMutableArray arrayWithObjects:@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999", nil];
	}
	return _shopTimeCodeArr;
}

- (NSMutableArray *)saveFunnelAllDatas {
	if (!_saveFunnelAllDatas) {
		_saveFunnelAllDatas=[NSMutableArray array];
	}
	return _saveFunnelAllDatas;
}


- (MJKAssignedView *)assignView {
	if (!_assignView) {
		_assignView = [[MJKAssignedView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 30, self.view.frame.size.width, 30)];
		_assignView.userInteractionEnabled = YES;
	}
	return _assignView;
}

- (UIButton *)countButton {
	if (!_countButton) {
		_countButton = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 60, NavStatusHeight + 40, 60, 20)];
		[_countButton setBackgroundImage:[UIImage imageNamed:@"all_bg.png"] forState:UIControlStateNormal];
		_countButton.titleLabel.font = [UIFont systemFontOfSize:10.0f];
		[_countButton setTitleColor:DBColor(142, 142, 142) forState:UIControlStateNormal];
		
		
	}
	return _countButton;
}

@end
