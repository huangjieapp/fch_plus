//
//  OrderDetailViewController.m
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "OrderDetailViewController.h"//订单报价

#import "MJKOrderFullViewController.h"
#import "DocumentSignViewController.h"

#import "MJKMortgageViewController.h"
#import "MJKQualityAssuranceViewController.h"
#import "MJKRegistrationViewController.h"
#import "MJKInsuranceViewController.h"
#import "MJKHighQualityViewController.h"

#import "MJKQuestionnaireViewController.h"
#import "MJKCarSourceHomeViewController.h"

#import "MJKOrderPlanViewController.h"
#import "MJKShowOrderPlanViewController.h"

#import "CGCOrderDetailModel.h"//数据模型
#import "CGCNewAddAppointmentVC.h"//邀约到店

#import "MJKCarSourceStatusView.h"

#import "CGCOrderdetailHead.h"
#import "CGCOrderDetailScanlifeCell.h"
#import "CGCOrderDetailNormalCell.h"//控制器的cell和view
#import "CGCOrderDetailOtherCell.h"
#import "CGCOrderDetialFooter.h"
#import "CGCOrderDetailBottomView.h"
#import "CGCMoreActionView.h"
#import "MJKSatisfactionView.h"
#import "MJKAdditionalTrackTableViewCell.h"




#import "WXApi.h"//第三方
#import "CommonCallViewController.h"
#import "SendMessageViewController.h"

#import "AddHelperViewController.h"//设计师
#import "MJKMarketViewController.h"//重新指派


#import "CustomerDetailInfoModel.h"
#import "MJKAdditionalTrackModel.h"

//#import "CommonCallViewController.h"//打电话页面
#import "MJKOrderAddOrEditViewController.h"//编辑跳转页面
#import "CGCAlertDateView.h"

#import "CGCTemplateVC.h"

#import "PotentailCustomerListViewController.h"

#import "KSPhotoBrowser.h"

#import "CustomerDetailViewController.h"

#import "CustomerDetailBottomToolView.h"//输入框
#import "MJKOrderMoneyListModel.h"
#import "CGCLogCell.h"//轨迹cell
#import "HistoryDetailView.h"
#import "MJKOrderImageCollectionViewCell.h"
#import "MJKAlbumView.h"//图片预览

#import "MJKUploadMemoView.h"//备注
#import "addDealViewController.h"//新增收款
#import "ServiceTaskAddViewController.h"
#import "CGCAlertDateView.h"
#import "MJKOrderFllowViewController.h"//订单跟进
#import "MJKHistoryFlowViewController.h"
#import "MJKSingleBackView.h"
#import "MJKChangeOrderStatusView.h"//变更状态
#import "ShowHelpViewController.h"//协助
#import "NewUserSession.h"

#import "ServiceTaskDetailModel.h"
#import "CGCAppointmentModel.h"
#import "CGCAppiontDetailVC.h"
#import "MJKCarSourceHomeModel.h"

#import "ServiceTaskPerformViewController.h"
#import "ServiceTaskTrueDetailViewController.h"

#import "MJKShowSendView.h"
#import "CGCOrderListVC.h"
#import "MJKMessagePushNotiViewController.h"

#import "MJKNewAddDealViewController.h"//收款详情
#import "MJKBatchToTaskViewController.h"

#import "WXApi.h"
#import "MJKChooseEmployeesViewController.h"

#import "MJKAttachmentViewController.h"
#import <MessageUI/MessageUI.h>


typedef enum {
    kShareTool_WeiXinFriends = 0, // 微信好友
    kShareTool_WeiXinCircleFriends, // 微信朋友圈
} ShareToolType;
#define  ROWNUMBER 6
#define  BOTTOMHIGHT 50
@interface OrderDetailViewController ()
<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CustomerDetailBottomToolViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, MJKAlbumViewDelegate, MFMessageComposeViewControllerDelegate>{

     NSString *C_PHONE;
    NSString *is_BH;//拨号
    NSString *is_SJ;//手机
    NSString *is_DH;//电话
    UIAlertController *actionsheetcall;
	
}

@property (nonatomic,copy) NSString * start_time;

@property (nonatomic,strong) UIButton * pickerBtn;

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UITableView * leftTableView;
@property (nonatomic,strong) UITableView * rightTableView;

@property (nonatomic,strong) CGCOrderDetailModel * detailModel;

@property (nonatomic,strong) CGCAlertDateView * alertDateView;

@property (nonatomic,strong) CGCOrderdetailHead * tableHead;

@property (nonatomic,strong) CGCOrderDetialFooter * tableFoot;

@property (nonatomic, strong) MJKCarSourceStatusView *carStatusView;


@property (nonatomic, copy) NSString *desStr;

@property (nonatomic,strong) MJKChangeOrderStatusView * statusView;

/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *typeButtonArray;
/** <#注释#>*/
@property (nonatomic, strong) UILabel *detailLabel;

/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *leftTableDataArray;

//订单编号
@property(nonatomic,strong)NSString*C_VOUCHERID;
@property(nonatomic,strong)CustomerDetailBottomToolView*toolView;//输入框
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *selectTypeView;//选择类型
@property (nonatomic, strong) UIButton *selectPerButton;//上一个button
@property (nonatomic, strong) NSString *typeName;
//@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger pagen;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MJKUploadMemoView *memoView;

@property (nonatomic, assign) BOOL isMoney;
@property (nonatomic, strong) NSString *changeStatus;

/** <#注释#>*/
@property(nonatomic,strong) NSString *A04200_C_ID;
//@property (nonatomic, assign) BOOL haveData;
/** <#备注#>*/
@property (nonatomic, assign) NSInteger toolMainViewHeight;
/** 已评价*/
@property (nonatomic, strong) NSString *satisfaction_flag;

/** <#注释#>*/
@property (nonatomic, strong) NSArray *urlList;
/** 直接上传需要先本地保存一下*/
@property (nonatomic, strong) NSMutableArray *urlArray;
/** <#注释#>*/
@property (nonatomic, strong) UIScrollView *scrollView;
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *additionalTrackArray;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableHead];
	[self.view addSubview:self.selectTypeView];
    self.typeName = @"订单详情";
    self.detailLabel.hidden = NO;
    self.tableView.hidden = YES;
	self.view.backgroundColor = [UIColor whiteColor];
//    [self getDetailVales];
//	[self HttpGetDataList];
	
    
    NSUserDefaults *userdefalut=[NSUserDefaults standardUserDefaults];
    is_BH=[userdefalut objectForKey:@"IS_BH"];
    is_SJ=[userdefalut objectForKey:@"IS_SJ"];
    is_DH=[userdefalut objectForKey:@"IS_DH"];
    //导航相关
    [self createNav];
    [self initCollectionView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.tableView.frame];
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.detailLabel];
	
    [self.view addSubview:self.toolView];
    [self setRefresh];
    [self setMortgageRefresh];
    [self getDetailVales];
    
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    //因为tableview的数据刷新时会置前，下单返回会重新刷数据所以下单返回不需要刷新
    if ([self.changeStatus isEqualToString:@"返回"]) {
        return;
    }
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isRefresh"] isEqualToString:@"yes"]) {
        [self getDetailVales];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isRefresh"];
    }
    
//    [self.tableView.mj_header beginRefreshing];
}

- (void)initCollectionView {
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	// 1.设置列间距
	layout.minimumInteritemSpacing = 5;
	// 2.设置行间距
	layout.minimumLineSpacing = 5;
	
	_collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + 150 + 30, KScreenWidth, KScreenHeight - NavStatusHeight - 150 - 30 - 50 - WD_TabBarHeight) collectionViewLayout:layout];
	_collectionView.dataSource = self;
	_collectionView.delegate = self;
	_collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.hidden = YES;
	[self.view addSubview:_collectionView];
	[_collectionView registerNib:[UINib nibWithNibName:@"MJKOrderImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"imageCell"];
	
}

- (void)setRefresh {
	DBSelf(weakSelf);
	if ([self.typeName isEqualToString:@"所有附件"]) {
		self.pagen = 20;
	} else {
		self.pagen = 10;
	}
	self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
		if ([weakSelf.typeName isEqualToString:@"所有附件"]) {
			weakSelf.pagen = 20;
		} else {
			weakSelf.pagen = 10;
		}
		[weakSelf HttpGetDataList];
		
	}];
	
	self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		self.pagen += 10;
		[weakSelf HttpGetDataList];
//		[self getDetailVales];
	}];
//    [self.tableView.mj_header beginRefreshing];
}

- (void)setMortgageRefresh {
    DBSelf(weakSelf);
        self.pagen = 20;
    
    self.rightTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
      
        [weakSelf getMortgageInfo];
        
    }];
    
    self.rightTableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pagen += 10;
        [weakSelf getMortgageInfo];
//        [self getDetailVales];
    }];
//    [self.tableView.mj_header beginRefreshing];
}

#pragma mark --- createNav（创建导航）
- (void)createNav{
//    if ([self.isEdit isEqualToString:@"A42000_C_STATUS_0002"]){
    self.title=@"订单详情";
//    }else if ([self.isEdit isEqualToString:@"A42000_C_STATUS_0000"]){
//        self.title=@"订金处理";
//    }else{
//        self.title=@"订单详情";
//    }
}


- (void)eidtShow{

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame =CGRectMake(0, 0, 50, 50);
    [rightBtn addTarget: self action: @selector(showHistory) forControlEvents: UIControlEventTouchUpInside];
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:16.0];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [rightBtn setTitleNormal:@"编辑" forState:UIControlStateNormal];
    [rightBtn setImage:@"23-顶右button"];
    
    UIBarButtonItem* rightitem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
		
        self.navigationItem.rightBarButtonItem=rightitem;

}


#pragma mark --- tableViewDateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return self.leftTableDataArray.count;
    } else if (tableView == self.rightTableView) {
        return self.additionalTrackArray.count;
    } else {
        return self.dataArray.count;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBSelf(weakSelf);
    if (tableView == self.tableView) {
        MJKOrderMoneyListModel *model;
        if (self.dataArray.count > 0) {
            model = self.dataArray[indexPath.row];
        }
        
        
        
        CGCLogCell *cell = [CGCLogCell cellWithTableView:tableView];
        cell.showDetailViewButton.hidden = YES;
        
        //因为需要默认分割线对其所以，当有数据是则havedata为yes然后适配
    //    if (self.haveData != YES) {
    //        cell.dateWidthLayout.constant = KScreenWidth / 4 - 18;
    //    }
        cell.statusRightLayout.constant = KScreenWidth / 4;
        [cell reloadOrderCellWithModel:model andType:self.typeName andRow:indexPath.row];
        cell.morePlanButtonActionBlock = ^{
            MJKBatchToTaskViewController *vc = [[MJKBatchToTaskViewController alloc]init];
            vc.orderId = model.C_A42000_C_ID;
            vc.orderModel = self.detailModel;
            if (model.D_PLANNED_TIME.length > 0) {
                vc.remarkStr = model.X_PLANNEDREMARK;
            } else {
                vc.remarkStr = model.C_NAME;
            }
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        cell.planButtonActionBlock = ^{
            if (model.C_A01200_C_ID.length > 0) {
                ServiceTaskAddViewController *taskVC = [[ServiceTaskAddViewController alloc] init];
                taskVC.title = @"任务编辑";
                taskVC.vcStr = @"orderHidden";
                taskVC.C_ID =model.C_A01200_C_ID;
                [weakSelf.navigationController pushViewController:taskVC animated:YES];
            } else {
                MJKOrderPlanViewController *vc = [[MJKOrderPlanViewController alloc]init];
                vc.vcName = @"计划";
                vc.detailModel = weakSelf.detailModel;
                vc.trajectoryID = model.C_ID;
                vc.moneyModel = model;
                vc.rootVC = self;
                if (model.D_PLANNED_TIME.length > 0) {
                    vc.remarkStr = model.X_PLANNEDREMARK;
                } else {
                    vc.remarkStr = model.C_NAME;
                }
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
        cell.completeButtonActionBlock = ^{
            if (model.C_A01200_C_ID.length > 0) {
                ServiceTaskPerformViewController *vc = [[ServiceTaskPerformViewController alloc]init];
                vc.title = @"任务执行";
                vc.trajectoryType = @"order";
                vc.vcName = @"订单";
                vc.C_ID = model.C_A01200_C_ID;
                vc.moneyModel = model;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else {
                MJKOrderPlanViewController *vc = [[MJKOrderPlanViewController alloc]init];
                vc.vcName = @"完成";
                vc.trajectoryID = model.C_ID;
                vc.detailModel = weakSelf.detailModel;
                if (model.D_ACTUAL_TIME.length > 0) {
                    vc.remarkStr = model.X_PLANNEDREMARK;
                } else {
                    vc.remarkStr = model.C_NAME;
                }
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
        
        cell.showDetailButtonActionBlock = ^{
            MJKShowOrderPlanViewController *vc = [[MJKShowOrderPlanViewController alloc]init];
            vc.c_id = model.C_ID;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        cell.detailButtonClickBlock = ^{
            NSString *timeStr = @"";
            NSString *remarkStr = @"";
            
            if ([self.typeName isEqualToString:@"订单节点"]) {
                timeStr = model.D_LASTUPDATE_TIME;
                remarkStr = model.X_REMARK;
            } else if ([self.typeName isEqualToString:@"收款记录"]) {
                timeStr = [NSString stringWithFormat:@"%@ %@",model.D_CREATE_DATE,model.D_CREATE_TIME];
                remarkStr = [NSString stringWithFormat:@"金额:%@\n类型:%@",model.AMOUNT,model.C_TYPE_DD_NAME];
            } else if ([self.typeName isEqualToString:@"订单动态"]) {
                timeStr = model.D_FOLLOW_TIME;
                remarkStr = model.CONTENT;
            } else if ([self.typeName isEqualToString:@"所有附件"]) {
                
            }
            HistoryDetailView *detailView = [[HistoryDetailView alloc]initWithFrame:weakSelf.view.frame andTimeAndRemark:@[timeStr, remarkStr]];
            [[UIApplication sharedApplication].keyWindow addSubview:detailView];
        };
    //    cell.datelab.font = [UIFont systemFontOfSize:12.f];
        cell.memoViewBlock = ^{
            MJKUploadMemoView *memoView = [[MJKUploadMemoView alloc]initWithFrame:weakSelf.view.frame andTitle:@"状态备注及附件" andSendMassage:NO andRootVC:weakSelf];
            weakSelf.memoView = memoView;
    //		memoView.rootVC = weakSelf;
            memoView.c_id = model.C_ID;
            memoView.remark = model.X_REMARK;
            memoView.tag = 1000;
            if (model.urlList.count > 0) {
                NSMutableArray *arr = [NSMutableArray array];
                memoView.imageUrlArr = model.urlList;
            }
            
            memoView.messageButtonBloack = ^(UIButton *sender) {
                [weakSelf messageBtnClick:sender];
            };
            
            memoView.commitButtonBloack = ^(NSArray *imageArr, NSString *remarkText) {
                [weakSelf HttpUpdataOrder:model.C_ID andImageUrl:imageArr andRemark:remarkText];
            };
    //		memoView.commitButtonBloack = ^{
    //			[weakSelf.tableView.mj_header beginRefreshing];
    //
    //		};
    //		[[UIApplication sharedApplication].keyWindow addSubview:memoView];
            
            [weakSelf.view addSubview:memoView];

        };
        
        if (self.dataArray.count > 0) {
            if (self.dataArray.count == 1) {//如果arr只有一个那么都要显示
                cell.topImage.hidden = cell.iconImg.hidden = NO;
            } else {
                if (indexPath.row == 0) {
                    cell.topImage.hidden = NO;
                    cell.iconImg.hidden = YES;
                } else if (indexPath.row == self.dataArray.count - 1) {
                    cell.topImage.hidden = YES;
                    cell.iconImg.hidden = NO;
                } else {
                    cell.topImage.hidden = cell.iconImg.hidden = YES;
                }
            }
            
        }
        return cell;
    } else if (tableView == self.leftTableView) {
        NSDictionary *dic = self.leftTableDataArray[indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = dic[@"name"];
        cell.textLabel.font = [UIFont systemFontOfSize:14.f];
        
        return cell;
    } else if (tableView == self.rightTableView) {
        MJKAdditionalTrackModel *model = self.additionalTrackArray[indexPath.row];
//        MJKAdditionalTrackTableViewCell *cell = [MJKAdditionalTrackTableViewCell cellWithTableView:tableView];
//        cell.model = model;
        CGCLogCell *cell = [CGCLogCell cellWithTableView:tableView];
        cell.showDetailViewButton.hidden = YES;
        cell.additionalModel = model;
        return cell;
    }
    return [UITableViewCell new];
}

#pragma mark --- tableViewDelegate 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        return 44;
    } else if (tableView == self.rightTableView) {
        MJKAdditionalTrackModel *model = self.additionalTrackArray[indexPath.row];
        CGFloat height = [model.X_REMARK boundingRectWithSize:CGSizeMake(KScreenWidth - 118 - 88, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
        return 22 + height;
    } else {
    
        if ([self.typeName isEqualToString:@"订单动态"]) {
            MJKOrderMoneyListModel *model;
            if (self.dataArray.count > 0) {
                model = self.dataArray[indexPath.row];
            }
            CGFloat height = [model.CONTENT boundingRectWithSize:CGSizeMake(KScreenWidth - 140, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
            if (height + 20 > 80) {
                return height + 20;
            }
        }
        
        return 80;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        NSDictionary *dic = self.leftTableDataArray[indexPath.row];
        self.C_TYPE_DD_ID = dic[@"code"];
        [self.rightTableView.mj_header beginRefreshing];
    } else if (tableView == self.rightTableView) {
        MJKAdditionalTrackModel *model = self.additionalTrackArray[indexPath.row];
        if ([model.C_TYPE_DD_ID isEqualToString:@"A85600_C_TYPE_0000"]) {
            MJKMortgageViewController *vc= [[MJKMortgageViewController alloc]init];
            vc.C_ID = model.C_OBJECTID;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([model.C_TYPE_DD_ID isEqualToString:@"A85600_C_TYPE_0001"]) {
            MJKInsuranceViewController *vc = [[MJKInsuranceViewController alloc]init];
            vc.C_ID = model.C_OBJECTID;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([model.C_TYPE_DD_ID isEqualToString:@"A85600_C_TYPE_0002"]) {
            MJKQualityAssuranceViewController *vc= [[MJKQualityAssuranceViewController alloc]init];
            vc.C_ID = model.C_OBJECTID;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([model.C_TYPE_DD_ID isEqualToString:@"A85600_C_TYPE_0003"]) {
            MJKHighQualityViewController *vc= [[MJKHighQualityViewController alloc]init];
            vc.C_ID = model.C_OBJECTID;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([model.C_TYPE_DD_ID isEqualToString:@"A85600_C_TYPE_0004"]) {
            MJKRegistrationViewController *vc= [[MJKRegistrationViewController alloc]init];
            vc.C_ID = model.C_OBJECTID;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([model.C_TYPE_DD_ID isEqualToString:@"A85600_C_TYPE_0005"]) {
            MJKQuestionnaireViewController *vc = [[MJKQuestionnaireViewController alloc]init];
            vc.vcName = @"面访问卷";
            vc.detailModel = self.detailModel;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([model.C_TYPE_DD_ID isEqualToString:@"A85600_C_TYPE_0006"]) {
            MJKQuestionnaireViewController *vc = [[MJKQuestionnaireViewController alloc]init];
            vc.vcName = @"销售满意度";
            vc.detailModel = self.detailModel;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (([model.C_TYPE_DD_ID isEqualToString:@"A85600_C_TYPE_0007"])) {
            MJKOrderFllowViewController *vc = [[MJKOrderFllowViewController alloc]init];
            vc.detailModel = self.detailModel;
            vc.objectID = model.C_OBJECTID;
            vc.orderID = self.orderId;
//            if (indexPath.row == 0) {
//                vc.canEdit = YES;
//                vc.isDetail = @"编辑";
//            } else {
                vc.canEdit = NO;
                vc.isDetail = @"详情";
//            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
	MJKOrderMoneyListModel *model = self.dataArray[indexPath.row];
	if ([self.typeName isEqualToString:@"订单动态"]) {
		if ([model.C_TYPE_DD_ID isEqualToString:@"A41600_C_TYPE_0008"]) {
            if ([model.C_RWSTATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0004"]) {
                ServiceTaskTrueDetailViewController *vc = [[ServiceTaskTrueDetailViewController alloc]init];
                vc.title = @"任务详情";
                vc.C_ID = model.C_A01200_C_ID;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                ServiceTaskPerformViewController *vc = [[ServiceTaskPerformViewController alloc]init];
                vc.title = @"任务执行";
                vc.vcName = @"订单";
                vc.C_ID = model.C_A01200_C_ID;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
		} else if ([model.C_TYPE_DD_ID isEqualToString:@"A41600_C_TYPE_0000"]) {
			CGCAppiontDetailVC *vc=[[CGCAppiontDetailVC alloc] init];
			vc.C_ID = model.C_ID;
            vc.rootVC = self;
			[self.navigationController pushViewController:vc animated:YES];
		}
		else {
			MJKOrderFllowViewController *vc = [[MJKOrderFllowViewController alloc]init];
			vc.detailModel = self.detailModel;
			vc.objectID = model.C_ID;
			vc.orderID = self.orderId;
			if (indexPath.row == 0) {
				vc.canEdit = YES;
				vc.isDetail = @"编辑";
			} else {
				vc.canEdit = NO;
				vc.isDetail = @"详情";
			}
			[self.navigationController pushViewController:vc animated:YES];
		}
	} else if ([self.typeName isEqualToString:@"收款记录"]) {
        MJKNewAddDealViewController *vc = [[MJKNewAddDealViewController alloc]init];
        vc.model = model;
        vc.orderDetailModel = self.detailModel;
        [self.navigationController pushViewController:vc animated:YES];
//        addDealViewController *vc = [[addDealViewController alloc]init];
//        vc.vcName = @"收款/退款详情";
//        vc.C_ORDER_ID = self.orderId;
//        vc.model = model;
//        vc.orderDetailModel = self.detailModel;
//        [self.navigationController pushViewController:vc animated:YES];
	}
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - UICollectionViewDataSource
#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.dataArray.count;
	
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identify = @"imageCell";
	MJKOrderImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
	[cell.imageView sd_setImageWithURL:self.dataArray[indexPath.row]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
	
	return cell;
}



#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return  CGSizeMake((KScreenWidth / 4) - 7.5,(KScreenWidth / 4) - 5);
}



#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
	return UIEdgeInsetsMake(5, 5,  0, 5);//（上、左、下、右）
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	//图片预览
	MJKOrderImageCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//	KSPhotoItem * item=[KSPhotoItem itemWithSourceView:cell.imageView imageUrl:[NSURL URLWithString:self.dataArray[indexPath.row]]];
	NSMutableArray *items = @[].mutableCopy;
    
	for (int i = 0; i < self.dataArray.count; i++) {
		// Get the large image url
//		NSString *url = [self.dataArray[i] stringByReplacingOccurrencesOfString:@"bmiddle" withString:@"large"];
		NSString *url =self.dataArray[i];
		KSPhotoItem *item = [KSPhotoItem itemWithSourceView:cell.imageView imageUrl:[NSURL URLWithString:url]];
		[items addObject:item];
	}
	KSPhotoBrowser * browser=[KSPhotoBrowser browserWithPhotoItems:items selectedIndex:indexPath.row];
	
	
	[browser showFromViewController:self];
	
//	MJKAlbumView *albumView = [[MJKAlbumView alloc]initWithFrame:self.view.frame];
//	[[UIApplication sharedApplication].keyWindow addSubview:albumView];
//	albumView.row = indexPath.row;
//	albumView.delegate = self;
//	[albumView reloadData];
	
}

// 要先设置表头大小
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
    return size;
}

// 创建一个继承collectionReusableView的类,用法类比tableViewcell
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // 头部视图
        // 代码初始化表头
         [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView"];
        UICollectionReusableView *tempHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView" forIndexPath:indexPath];
        tempHeaderView.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 80, 10, 60, 30)];
//        [button setBackgroundImage:[UIImage imageNamed:@"icon-加号"] forState:UIControlStateNormal];
        [button setTitleNormal:@"添加图片"];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button setTitleColor:[UIColor blackColor]];
        [button addTarget:self action:@selector(addAttachment)];
        [tempHeaderView addSubview:button];
        reusableView = tempHeaderView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        // 底部视图
    }
    return reusableView;
}

#pragma mark -- 上传图片相关
- (void)addAttachment {
    MJKAttachmentViewController *vc = [[MJKAttachmentViewController alloc]init];
    vc.detailModel = self.detailModel;
    [self.navigationController pushViewController:vc animated:YES];
}
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (!image) {
            image=[info objectForKey:UIImagePickerControllerEditedImage];
        }
        //设置image的尺寸
        //        CGSize imagesize = image.size;
        //        imagesize.height =500;
        //        imagesize.width =500;
        //        //对图片大小进行压缩--
        //        image = [self imageWithImage:image scaledToSize:imagesize];
        NSData *imageData = UIImageJPEGRepresentation(image,0.5);
        image= [UIImage imageWithData:imageData];
        
        
        [self uppicAction:imageData];
        
    }else{
        UIImage * image=[info objectForKey:UIImagePickerControllerEditedImage];
        if (!image) {
            image=[info objectForKey:UIImagePickerControllerOriginalImage];
        }
        //设置image的尺寸
        //        CGSize imagesize = image.size;
        //        imagesize.height =626;
        //        imagesize.width =413;
        //        //对图片大小进行压缩--
        //        image = [self imageWithImage:image scaledToSize:imagesize];
        NSData *imageData = UIImageJPEGRepresentation(image,0.5);
        image= [UIImage imageWithData:imageData];
        
        
        
        [self uppicAction:imageData];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)uppicAction:(NSData *)data{
    
    DBSelf(weakSelf);
    
    //    NSData *data=[NSData dataWithContentsOfFile:self.patchUrl];
    NSString *urlStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:data compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue] == 200) {
            NSString * imgUrl = [data objectForKey:@"url"];//回传
//            [self setPicBtn:imgUrl];
            [weakSelf.urlArray addObject:imgUrl];
            [weakSelf httpUploadImage:weakSelf.urlArray];
            
        } else {
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
}

- (void)httpUploadImage:(NSArray *)urlArr{
    DBSelf(weakSelf);
    NSMutableDictionary *dic=[DBObjectTools getAddressDicWithAction:@"A42000WebService-upload"];
    
    NSMutableDictionary *dic1=[NSMutableDictionary dictionary];
    dic1[@"C_ID"] = self.detailModel.C_ID;
    dic1[@"urlList"] = urlArr;
    [dic setObject:dic1 forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dic withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
//            [weakSelf getDetailVales];
            [weakSelf.tableView.mj_header beginRefreshing];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
    
    
}

- (void)getMortgageInfo {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"pageNum"] = @"1";
    contentDic[@"pageSize"] = @(self.pagen);
//    contentDic[@"C_TYPE_DD_ID"] = self.C_TYPE_DD_ID;
    contentDic[@"C_A42000_C_ID"] = self.detailModel.C_ID;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEMD856LIST parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            weakSelf.additionalTrackArray = [MJKAdditionalTrackModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
            [weakSelf.rightTableView reloadData];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
        [weakSelf.rightTableView.mj_header endRefreshing];
        [weakSelf.rightTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - MJKAlbumViewDelegate
- (NSInteger)numberOfImageCount {
	return self.dataArray.count;
}

- (NSArray *)imageDataArrayWithIndexPath {
	return self.dataArray;
}

/************************     ***************************/
- (void)showHistory {
	
//    DBSelf(weakSelf);
//    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//
//    UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"订单编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if (![[NewUserSession instance].appcode containsObject:@"APP005_0012"]) {
//            [JRToast showWithText:@"账号无权限"];
//            return ;
//        }
//        [weakSelf editBtn];
//
//    }];
//    UIAlertAction *historyAction = [UIAlertAction actionWithTitle:@"操作记录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MJKHistoryFlowViewController *vc = [[MJKHistoryFlowViewController alloc]init];
        vc.VCName = @"订单";
        vc.C_A41500_C_ID = self.detailModel.C_ID;
        [self.navigationController pushViewController:vc animated:YES];
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [alertC addAction:cancelAction];
//    [alertC addAction:editAction];
//    [alertC addAction:historyAction];
//
//    [self presentViewController:alertC animated:YES completion:nil];
}


#pragma mark --- touch导航右边编辑按钮点击事件

- (void)editBtn {//编辑按钮点击事件
    DBSelf(weakSelf);
    
    MJKOrderAddOrEditViewController *vc = [[MJKOrderAddOrEditViewController alloc]init];
    vc.C_ID = self.detailModel.C_ID;
    vc.Type = orderTypeEdit;
    [self.navigationController pushViewController:vc animated:YES];
	

}

#pragma mark -- 提示弹层点击取消
- (void)alertCanelClick:(UIButton *)btn{

    [self.alertDateView removeFromSuperview];

}

#pragma mark -- 提示弹层点击选择延期或者交付时间
- (void)alertSelClick:(UIButton *)btn{
    
    [self datePickerAndMethod];
}



- (void)toCustomerView{
    
    CustomerDetailViewController * vc=[[CustomerDetailViewController alloc] init];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VCName"];
    vc.mainModel=[[PotentailCustomerListDetailModel alloc] init];
    vc.mainModel.C_A41500_C_ID=self.detailModel.C_A41500_C_ID;
    vc.mainModel.C_STATUS_DD_ID=self.detailModel.C_STATUS_DD_ID;
    
    if (vc.mainModel.C_A41500_C_ID.length==0||vc.mainModel.C_STATUS_DD_ID.length==0) {
        return ;
    }
    [self.navigationController pushViewController:vc animated:NO];
}



/************************   网络请求    ***************************/
#pragma mark --- request  订单详情

-(void)getDetailVales{
    
    
    
   
    NSMutableDictionary *dic=[NSMutableDictionary new];
    if (self.orderId.length==0) {
        [JRToast showWithText:@"订单不存在"];
    }
    self.orderId?[dic setObject:self.orderId forKey:@"C_ID"]:0;
    [self.urlArray removeAllObjects];
    
    DBSelf(weakSelf);
    
    
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a420/info", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200)  {
            NSDictionary*dict=[data[@"data"] copy];

            weakSelf.C_VOUCHERID=data[@"C_VOUCHERID"];
            if ([weakSelf.typeName isEqualToString:@"所有附件"]) {
                NSArray *urlList = data[@"urlList"];
                if ([urlList count] > 0) {
                    [weakSelf.urlArray addObjectsFromArray:data[@"urlList"]];
                }
            }


            weakSelf.detailModel=[CGCOrderDetailModel yy_modelWithDictionary:dict];

            
            weakSelf.detailLabel.text = weakSelf.detailModel.detailStr;
            CGFloat height = [weakSelf.detailModel.detailStr boundingRectWithSize:CGSizeMake(weakSelf.scrollView.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f]} context:nil].size.height;
            CGRect labelFrame = weakSelf.detailLabel.frame;
            labelFrame = CGRectMake(0, 10, weakSelf.scrollView.frame.size.width - 20, height);
            weakSelf.detailLabel.frame = labelFrame;
            weakSelf.scrollView.contentSize = CGSizeMake(weakSelf.scrollView.size.width, height);

            C_PHONE=weakSelf.detailModel.C_PHONE;
//            [self.tableView reloadData];
            [weakSelf reloadHeadWithFoot:weakSelf.detailModel];
            weakSelf.isEdit=weakSelf.detailModel.C_STATUS_DD_ID;
            if ([weakSelf.isEdit isEqualToString:@"A42000_C_STATUS_0003"]){
                [weakSelf.toolView removeFromSuperview];
            } else if ([weakSelf.isEdit isEqualToString:@"A42000_C_STATUS_0001"]){
//                weakSelf.toolView.delegate = nil;
            }
                //else{
                weakSelf.title=@"订单详情";
//            }
            [weakSelf eidtShow];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];

    

}




- (void)HttpUpdataOrder:(NSString *)c_id andImageUrl:(NSArray *)urlStr andRemark:(NSString *)remark{
	NSMutableDictionary*Updict = [DBObjectTools getAddressDicWithAction:@"A47300WebService-update"];
	
	NSMutableDictionary * dict=[NSMutableDictionary dictionary];
	dict[@"C_ID"] = c_id;
	if (remark.length > 0) {
		dict[@"X_REMARK"] = remark;
	}
	if (urlStr.count > 0) {
		dict[@"urlList"] = urlStr;
	}
	
	
	[Updict setObject:dict forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:Updict withtype:@"1"];
	DBSelf(weakSelf);
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			//			if (weakSelf. commitButtonBloack) {
			//				weakSelf.commitButtonBloack();
			//			}
			[weakSelf.tableView.mj_header beginRefreshing];
//			[weakSelf removeFromSuperview];
			[weakSelf.memoView removeFromSuperview];
			
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
	}];
	
	
	
}

#pragma mark--- 刷新tableView数据

- (void)reloadHeadWithFoot:(CGCOrderDetailModel *)model{

    if (model.C_HEADIMGURL.length > 0) {
        self.tableHead.headImg.hidden = NO;
        self.tableHead.iconName.hidden = YES;
        [self.tableHead.headImg sd_setImageWithURL:[NSURL URLWithString:model.C_HEADIMGURL]];
    } else {
        self.tableHead.headImg.hidden = YES;
        self.tableHead.iconName.hidden = NO;
        if (model.C_BUYNAME.length > 0) {
            self.tableHead.iconName.text = [model.C_BUYNAME substringToIndex:1];
        } else {
            self.tableHead.iconName.text = model.C_BUYNAME;
        }
    }
    if ([model.C_SEX_DD_NAME isEqualToString:@"男"]) {
        self.tableHead.sexImg.image=[UIImage imageNamed:@"iv_man"];
    }else if ([model.C_SEX_DD_NAME isEqualToString:@"女"]){
        self.tableHead.sexImg.image=[UIImage imageNamed:@"iv_women"];
    }else{
        self.tableHead.sexImg.hidden=YES;
    }
    
    self.tableHead.nameLab.text = model.C_BUYNAME;
    
    self.tableHead.workLab.text = [NSString stringWithFormat:@"%@ %@", model.C_STATUS_DD_NAME, model.C_OWNER_ROLENAME];
    self.tableHead.orderTimeLab.text = [NSString stringWithFormat:@"%@-%@", model.C_A49600_C_NAME, model.B_GUIDEPRICE];
    self.tableHead.payTime.text = [NSString stringWithFormat:@"%@-%@", model.C_SPD, model.D_START_TIME];
}


/************************     ***************************/
#pragma mark --- set

- (UILabel *)detailLabel {
    //CGRectMake(20, NavStatusHeight + 150 + 30, KScreenWidth - 40, KScreenHeight-BOTTOMHIGHT - NavStatusHeight - WD_TabBarHeight - 150 - 30 - SafeAreaBottomHeight)
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.font = [UIFont systemFontOfSize:16.f];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UITableView *)tableView{


    if (_tableView==nil) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, NavStatusHeight + 150 + 30, KScreenWidth, KScreenHeight-BOTTOMHIGHT - NavStatusHeight - WD_TabBarHeight - 150 - 30 - SafeAreaBottomHeight) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=CGCTABBGColor;
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.tableHeaderView=self.tableHead;
//        _tableView.tableFooterView=self.tableFoot;
    }
    return _tableView;
}

- (UITableView *)rightTableView{


    if (_rightTableView==nil) {
        _rightTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, NavStatusHeight + 150 + 30, KScreenWidth, KScreenHeight-BOTTOMHIGHT - NavStatusHeight - WD_TabBarHeight - 150 - 30 - SafeAreaBottomHeight) style:UITableViewStylePlain];
        _rightTableView.delegate=self;
        _rightTableView.dataSource=self;
        _rightTableView.backgroundColor=CGCTABBGColor;
        
        if ([_rightTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_rightTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_rightTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_rightTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        _rightTableView.hidden = YES;
//        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.tableHeaderView=self.tableHead;
//        _tableView.tableFooterView=self.tableFoot;
    }
    return _rightTableView;
}

- (UITableView *)leftTableView{


    if (_leftTableView==nil) {
        _leftTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, NavStatusHeight + 150 + 30, 80, KScreenHeight-BOTTOMHIGHT - NavStatusHeight - WD_TabBarHeight - 150 - 30 - SafeAreaBottomHeight) style:UITableViewStylePlain];
        _leftTableView.delegate=self;
        _leftTableView.dataSource=self;
        _leftTableView.backgroundColor=CGCTABBGColor;
        
        if ([_leftTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_leftTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_leftTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_leftTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        _leftTableView.hidden = YES;
//        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.tableHeaderView=self.tableHead;
//        _tableView.tableFooterView=self.tableFoot;
    }
    return _leftTableView;
}

- (CGCOrderdetailHead *)tableHead{

    if (_tableHead==nil) {
        _tableHead=[[[NSBundle mainBundle] loadNibNamed:@"CGCOrderdetailHead" owner:self options:0] lastObject];
        _tableHead.frame = CGRectMake(0, NavStatusHeight, KScreenWidth, 150);
        [_tableHead.telBtn addTarget:self action:@selector(selectTelephone:) forControlEvents:UIControlEventTouchUpInside];
        [_tableHead.mesBtn addTarget:self action:@selector(messageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_tableHead.weixinBtn addTarget:self action:@selector(weixinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_tableHead.cardButton addTarget:self action:@selector(cardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_tableHead.editButton addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_tableHead.changeBtn addTarget:self action:@selector(toCustomerView)];
        
    }
    return _tableHead;
    
}

- (UIView *)selectTypeView {
	if (!_selectTypeView) {
		_selectTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableHead.frame), KScreenWidth, 30)];
		for (int i = 0; i < 4; i++) {
			UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * KScreenWidth/4, 0, KScreenWidth/4, 30)];
			[button setTitle:@[@"订单详情",@"订单动态",@"收款记录", @"所有附件"][i] forState:UIControlStateNormal];
			button.titleLabel.font = [UIFont systemFontOfSize:14.f];
			[button addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
			if (i == 0) {
				[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
				self.selectPerButton = button;
			} else {
				[button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
			}
			[_selectTypeView addSubview:button];
            [self.typeButtonArray addObject:button];
			//分割线
			if (i != 3) {
				UIView *view = [[UIView alloc]initWithFrame:CGRectMake(button.frame.origin.x + button.frame.size.width, 0, 1, 30)];
				view.backgroundColor = [UIColor grayColor];
				[_selectTypeView addSubview:view];
			}
			
		}
		UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, _selectTypeView.frame.size.height - 2, _selectTypeView.frame.size.width / 4, 2)];
		[_selectTypeView addSubview:bgView];
		bgView.tag = 1090;
		bgView.backgroundColor = DBColor(255,195,0);
		
	}
	return  _selectTypeView;
}

- (CGCOrderDetialFooter *)tableFoot{
    
    if (_tableFoot==nil) {
        
        _tableFoot=[[[NSBundle mainBundle] loadNibNamed:@"CGCOrderDetialFooter" owner:self options:0] lastObject];
        
        _tableFoot.titleNameLab.text=@"订单附图";
         _tableFoot.firstPicBtn.tag=111;
        [_tableFoot.firstPicBtn setImage:nil];
         _tableFoot.secondPicBtn.tag=222;
        [_tableFoot.secondPicBtn setImage:nil];
         _tableFoot.thirdPicBtn.tag=333;
        [_tableFoot.thirdPicBtn setImage:nil];
		
        [_tableFoot.firstPicBtn addTarget:self action:@selector(picBtnClick:)];
        [_tableFoot.secondPicBtn addTarget:self action:@selector(picBtnClick:)];
        [_tableFoot.thirdPicBtn addTarget:self action:@selector(picBtnClick:)];
    }
    return _tableFoot;
}




- (void)picBtnClick:(UIButton *)btn
{
  NSArray * imgArray=  [self.detailModel.X_PICURL componentsSeparatedByString:@","];
    if (btn.tag==111) {
        if (imgArray.count>0&&[[imgArray firstObject] length]>0) {
            [self showBigImage:[imgArray firstObject] withBtn:btn];
            
        }
    }
    if (btn.tag==222) {
        if (imgArray.count>1&&[imgArray[1] length]>0) {
             [self showBigImage:imgArray[1] withBtn:btn];
        }
    }
    if (btn.tag==333) {
        if (imgArray.count>2&&[imgArray[2] length]>0) {
           [self showBigImage:imgArray[2] withBtn:btn];
        }
    }
    
}


- (void)showBigImage:(NSString *)url withBtn:(UIButton *)btn{
    
    KSPhotoItem * item=[KSPhotoItem itemWithSourceView:btn.imageView imageUrl:[NSURL URLWithString:url]];
    KSPhotoBrowser * browser=[KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
    
    
    [browser showFromViewController:self];
}

/************************     ***************************/
#pragma mark -- 微信
- (void)weixinBtnClick:(UIButton *)btn{
    if (![[NewUserSession instance].appcode containsObject:@"APP005_0031"]) {
        [JRToast showWithText:@"账号无权限"];
        return;
    }
	DBSelf(weakSelf);
    
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *wechat = [UIAlertAction actionWithTitle:@"复制微信号跳转" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = weakSelf.detailModel.C_WECHAT;
        [weakSelf openWechat];
    }];
    
    UIAlertAction *phone = [UIAlertAction actionWithTitle:@"复制手机号跳转" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = weakSelf.detailModel.C_PHONE;
        [weakSelf openWechat];
    }];
    
    UIAlertAction *message = [UIAlertAction actionWithTitle:@"发送消息模版" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf httpPostGetCustomerDetailInfo:^(CustomerDetailInfoModel *model) {
            CGCTemplateVC * tvc=[[CGCTemplateVC alloc]init];
            tvc.templateType=CGCTemplateWeiXin;
            //        tvc.customIDArr = [@[weakSelf.detailModel.C_A41500_C_ID] mutableCopy];
            tvc.titStr=weakSelf.detailModel.C_BUYNAME;
            tvc.cusDetailModel = model;
            
            tvc.customIDArr=[NSMutableArray arrayWithObject:weakSelf.detailModel.C_ID];
            [weakSelf.navigationController pushViewController:tvc animated:YES];
        }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    if (weakSelf.detailModel.C_WECHAT.length > 0) {
        [ac addAction:wechat];
    }
    
    if (weakSelf.detailModel.C_PHONE.length > 0) {
        [ac addAction:phone];
    }
    
    [ac addAction:message];
    [ac addAction:cancel];
    
    [weakSelf presentViewController:ac animated:YES completion:nil];
    
	
    
	

    
}

-(void)openWechat{
    NSURL * url = [NSURL URLWithString:@"weixin://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    //先判断是否能打开该url
//    if (canOpen)
//    {   //打开微信
        [[UIApplication sharedApplication] openURL:url];
//    }else {
//        [JRToast showWithText:@"您的设备未安装微信APP"];
//    }
}

- (void)cardBtnClick:(UIButton *)btn{
//    if (![[NewUserSession instance].appcode containsObject:@"APP005_0031"]) {
//        [JRToast showWithText:@"账号无权限"];
//        return;
//    }
//    [self HTTPCardData];
    if (self.detailModel.C_ADDRESS.length <= 0) {
        [JRToast showWithText:@"暂无客户地址"];
        return;
    }
    MJKMapNavigationViewController *alertVC = [MJKMapNavigationViewController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alertVC.C_ADDRESS = self.detailModel.C_ADDRESS;
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)editBtnClick:(UIButton *)btn{
    if (![[NewUserSession instance].appcode containsObject:@"crm:a420:update"]) {
        [JRToast showWithText:@"账号无权限"];
        return;
    }
    [self editBtn];
}

#pragma mark短信
- (void)messageBtnClick:(UIButton *)btn {
    if (![[NewUserSession instance].appcode containsObject:@"APP005_0030"]) {
        [JRToast showWithText:@"账号无权限"];
        return;
    }
    DBSelf(weakSelf);
//	[self httpPostGetCustomerDetailInfo:^(CustomerDetailInfoModel *model) {
//		CGCTemplateVC * tvc=[[CGCTemplateVC alloc]init];
//		tvc.customIDArr = [@[weakSelf.detailModel.C_ID] mutableCopy];
////		tvc.customPhoneArr = [@[weakSelf.detailModel.C_PHONE] mutableCopy];
//		tvc.templateType=CGCTemplateMessage;
//		tvc.titStr=weakSelf.detailModel.C_BUYNAME;
//		tvc.cusDetailModel = model;
//		tvc.customPhoneArr=[NSMutableArray arrayWithObject:weakSelf.detailModel.C_PHONE];
//		[weakSelf.navigationController pushViewController:tvc animated:YES];
//	}];
    MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
    // 设置短信内容
//    vc.body = @"吃饭了没？";
    // 设置收件人列表
    vc.recipients = @[weakSelf.detailModel.C_PHONE];
    // 设置代理
    vc.messageComposeDelegate = self;
    // 显示控制器
    [self presentViewController:vc animated:YES completion:nil];

	

}


#pragma  mark --- 拨打电话

//电话
- (void)telephoneCall:(NSInteger)index{
//    if (![[NewUserSession instance].appcode containsObject:@"APP005_0029"]) {
//        [JRToast showWithText:@"账号无权限"];
//        return;
//    }
    if (C_PHONE.length > 0) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:C_PHONE]]];
    } else {
       [JRToast showWithText:@"无电话号码"];
   }
}

- (void)whbcallBack:(NSInteger)index {
//    if (![[NewUserSession instance].appcode containsObject:@"APP005_0029"]) {
//        [JRToast showWithText:@"账号无权限"];
//        return;
//    }
    if (C_PHONE.length > 0) {
    [DBObjectTools whbCallWithC_OBJECT_ID:self.detailModel.C_ID andC_CALL_PHONE:self.detailModel.C_PHONE andC_NAME:self.detailModel.C_BUYNAME andC_OBJECTTYPE_DD_ID:@"A83100_C_OBJECTTYPE_0007" andCompleteBlock:nil];
    } else {
       [JRToast showWithText:@"无电话号码"];
   }
}

-(void)httpPostGetCustomerDetailInfo:(void(^)(CustomerDetailInfoModel *model))dataBlock{
	NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
	
	if (self.detailModel.C_A41500_C_ID.length > 0) {
		contentDict[@"C_ID"] = self.detailModel.C_A41500_C_ID;
	}
	
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/a415/info", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			
			CustomerDetailInfoModel *detailInfoModel=[CustomerDetailInfoModel yy_modelWithDictionary:data[@"data"]];
			if (dataBlock) {
				dataBlock(detailInfoModel);
			}
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
		
		
	}];
	
	
	
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
        
        //新增跟进
        MJKOrderFllowViewController *vc = [[MJKOrderFllowViewController alloc]init];
        vc.canEdit = YES;
        vc.detailModel = self.detailModel;
        vc.followText = nil;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }];
    [alertV addAction:cancelAction];
    [alertV addAction:trueAction];
    
    [self presentViewController:alertV animated:YES completion:nil];
}
//座机
- (void)landLineCall:(NSInteger)index{
    
    NSString *buttonTitle = @"用座机拨打";
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=buttonTitle;
    myView.nameStr=C_PHONE;
    myView.callStr=C_PHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
}
//回呼
- (void)callBack:(NSInteger)index{
    
    NSString *buttonTitle = @"回呼到手机";
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=buttonTitle;
    myView.callStr=C_PHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
}




#pragma mark -- 时间控件
- (void)datePickerAndMethod
{
    
    
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=self.view.bounds;
    [btn addTarget:self action:@selector(dissmissPicker) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor=CGCBGCOLOR;
    self.pickerBtn=btn;
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-200, KScreenWidth, 200)];
    view.backgroundColor=[UIColor whiteColor];
    
    UIButton * doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame=CGRectMake(KScreenWidth-60, 0, 60, 40);
    [doneBtn addTarget:self action:@selector(dissmissPicker) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setTitleNormal:@"完成"];
    [doneBtn setTitleColor:[UIColor blackColor]];
    [view addSubview:doneBtn];
    
    UIButton * canelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    canelBtn.frame=CGRectMake(0, 0, 60, 40);
    [canelBtn addTarget:self action:@selector(dissmissPicker) forControlEvents:UIControlEventTouchUpInside];
    [canelBtn setTitleNormal:@"取消"];
    [canelBtn setTitleColor:[UIColor blackColor]];
    [view addSubview:canelBtn];
    
    UIDatePicker *Picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, 160)];
    Picker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_cn"];
    if (@available(iOS 13.4, *)) {
        Picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    } else {
        // Fallback on earlier versions
    }
    Picker.datePickerMode = UIDatePickerModeDateAndTime;
    Picker.tag=100;
    
    NSDate *Date = [NSDate date];
    NSDateFormatter *birthformatter = [[NSDateFormatter alloc] init];
    birthformatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    birthformatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    
    self.detailModel.D_START_TIME=[birthformatter stringFromDate:Date];
    [Picker setDate:Date animated:YES];
    [Picker addTarget:self action:@selector(showDate:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:Picker];
    [self.pickerBtn addSubview:view];
    [self.view addSubview:self.pickerBtn];
}
- (void)showDate:(UIDatePicker *)datePicker
{
    if (datePicker.tag==100) {
        
        NSDate *date = datePicker.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *outputString = [formatter stringFromDate:date];
        self.detailModel.D_START_TIME=outputString;
        self.start_time=outputString;
    }
    
    
}

- (void)dissmissPicker{
    
    
    self.alertDateView.textfield.text= self.start_time;
    [self.pickerBtn removeFromSuperview];
}

- (void)selectBackType:(NSString *)typeName {
    for (UIButton *button in self.typeButtonArray) {
        if ([button.titleLabel.text isEqualToString:typeName]) {
            UIView *bgView = [self.selectTypeView viewWithTag:1090];
            CGRect frame = bgView.frame;
            frame.origin.x = button.frame.origin.x;
            bgView.frame = frame;
            [self.selectPerButton setTitleColor:[UIColor grayColor]];
            [button setTitleColor:[UIColor blackColor]];
            
            
            self.selectPerButton = button;
        }
    }
}

- (void)saveCarSourceSdData:(NSString *)orderId andC_A82300_C_ID:(NSString *)C_A82300_C_ID andC_CYSTATUS_DD_ID:(NSString *)C_CYSTATUS_DD_ID {
    @weakify(self);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_A42000_C_ID"] = orderId;
    contentDic[@"C_A82300_C_ID"] = C_A82300_C_ID;
    contentDic[@"C_CYSTATUS_DD_ID"] = C_CYSTATUS_DD_ID;
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a823/cysd", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        @strongify(self);
        if ([data[@"code"] intValue] == 200) {
            MyLog(@"%@", data);
            [self.carStatusView removeFromSuperview];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController*)controller didFinishWithResult:(MessageComposeResult)result
{
    // 关闭短信界面
    [controller dismissViewControllerAnimated:YES completion:nil];
    if(result == MessageComposeResultCancelled) {
        [JRToast showWithText:@"取消发送"];
//        NSLog(@"取消发送");
    } else if(result == MessageComposeResultSent) {
        [JRToast showWithText:@"已经发出"];
//        NSLog(@"已经发出");
    } else {
        [JRToast showWithText:@"发送失败"];
//        NSLog(@"发送失败");
    }
}

#pragma mark - 输入框
-(CustomerDetailBottomToolView *)toolView{
//    NSArray *statusArr = @[@"订金", @"方案", @"已签约", @"已下单", @"已到货", @"安装", @"已交付"];
//    NSArray *statusNameArr = @[@"订金", @"方案", @"签约", @"下单", @"到货", @"安装", @"交付"];
    NSArray *statusArr = @[@"待确认",@"已交付"];
    NSArray *statusNameArr = @[@"库存确认",@"交付"];
	DBSelf(weakSelf);
	if (!_toolView) {
		CGFloat moreLineHeight = [[NewUserSession instance].C_APPTYPE_DD_ID isEqualToString:@"A40300_C_APPTYPE_0000"] ? 0 : 70;
		_toolView=[[CustomerDetailBottomToolView alloc]initWithFrame:CGRectMake(0, KScreenHeight-50-SafeAreaBottomHeight, KScreenWidth, 50+70+moreLineHeight) andIsMoreLines:YES];
		
		_toolView.delegate=self;
	//框框字适应
		__block CustomerDetailBottomToolView *toolView = _toolView;
		_toolView.textChangeBlock = ^(NSString *str) {
			CGSize size = [str boundingRectWithSize:CGSizeMake(KScreenWidth - 115, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
			toolView.toolTextViewHeightLayout.constant = size.height + 20;
			toolView.toolMainViewHeightLayout.constant = size.height + 32;
			//			CGRect rect = self.ToolMainView.frame;
			NSInteger tempHeight = size.height;
			CGRect toolrect = toolView.frame;
			if (weakSelf.toolMainViewHeight != tempHeight && weakSelf.toolMainViewHeight != 0) {
				
				//				rect.origin.y = rect.origin.y - self.toolMainViewHeightLayout.constant;
				toolrect.origin.y = toolrect.origin.y - (tempHeight - weakSelf.toolMainViewHeight);
				toolrect.size.height =  toolrect.size.height + (tempHeight - weakSelf.toolMainViewHeight);
			}
			weakSelf.toolMainViewHeight = size.height;
			//	self.ToolTextField.frame = toolrect;
			
			toolView.frame = toolrect;
		};
		weakSelf.toolView.followBlock = ^(NSString *text) {
			MyLog(@"%@",text);
			//新增跟进
			MJKOrderFllowViewController *vc = [[MJKOrderFllowViewController alloc]init];
			vc.canEdit = YES;
			vc.detailModel = self.detailModel;
			vc.followText = text;
			vc.backSubmitBlock = ^{
				_toolView.ToolTextField.text = @"";
                weakSelf.typeName = @"订单动态";
                [weakSelf selectBackType:weakSelf.typeName];
               
			};
			[weakSelf.navigationController pushViewController:vc animated:YES];
			
		};
		
		
		
		weakSelf.toolView.endRecordBlock = ^(NSString *recordStr) {
			MyLog(@"%@",recordStr);
			weakSelf.toolView.ToolTextField.text=recordStr;
			
			MJKOrderFllowViewController *vc = [[MJKOrderFllowViewController alloc]init];
			vc.canEdit = YES;
			vc.detailModel = self.detailModel;
			vc.followText = recordStr;
			vc.backSubmitBlock = ^{
				_toolView.ToolTextField.text = @"";
                weakSelf.typeName = @"订单动态";
                [weakSelf selectBackType:weakSelf.typeName];
			};
			[weakSelf.navigationController pushViewController:vc animated:YES];
			
		};
		
		
		
		
		weakSelf.toolView.clickChooseButtonBlock = ^(NSInteger index, NSString *title) {
            if ([title isEqualToString:@"文件签署"]) {
                DocumentSignViewController *vc = [DocumentSignViewController new];
                vc.C_ID = self.detailModel.C_ID;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else if ([title isEqualToString:@"车源关联"]) {
                MJKCarSourceHomeViewController *vc = [MJKCarSourceHomeViewController new];
                vc.VCName = @"车源";
                vc.chooseOrderBlock = ^(MJKCarSourceHomeSubModel * _Nonnull carModel) {
                    __block NSString *C_A82300_C_ID = @"";
                    __block NSString *C_CYSTATUS_DD_ID = @"";
                    MJKCarSourceStatusView *view = [[MJKCarSourceStatusView alloc]initWithFrame:self.view.bounds];;
                    weakSelf.carStatusView = view;
                    view.chooseBlock = ^(NSString * _Nonnull str, NSString * _Nonnull postValue) {
                        C_A82300_C_ID = carModel.C_ID;
                        C_CYSTATUS_DD_ID = postValue;
                    };
                    
                    [[view.trueButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                        [weakSelf saveCarSourceSdData:weakSelf.detailModel.C_ID andC_A82300_C_ID:C_A82300_C_ID andC_CYSTATUS_DD_ID:C_CYSTATUS_DD_ID];
                    }];
                    [[UIApplication sharedApplication].windows[0] addSubview:view];
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
			DBSelf(weakSelf);
			MyLog(@"%lu",index);
            
			
			if ([title isEqualToString:@"收款/退款"]) {
				if (![[NewUserSession instance].appcode containsObject:@"crm:a420:stk"]) {
					[JRToast showWithText:@"账号无权限"];
					return ;
				}
				//新增收款
				addDealViewController *vc = [[addDealViewController alloc]init];
				vc.vcName = @"收款/退款";
				vc.C_ORDER_ID = self.orderId;
                vc.orderDetailModel = weakSelf.detailModel;
                vc.reloadBlock = ^{
                    weakSelf.typeName = @"收款记录";
                    [weakSelf selectBackType:weakSelf.typeName];
                };
				//                    vc.A04200_C_ID = self.A04200_C_ID;
				[self.navigationController pushViewController:vc animated:YES];
			}
			
			if ([title isEqualToString:@"变更状态"]) {
                if (![[NewUserSession instance].appcode containsObject:@"crm:a420:ztbg"]) {
                    [JRToast showWithText:@"账号无权限"];
                    return ;
                }
                //变更状态
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                //交付
                UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"已出库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if ([weakSelf.detailModel.C_STATUS_DD_NAME isEqualToString:@"退单"]) {
                        [JRToast showWithText:@"已退单"];
                        return ;
                    }
                    if ([weakSelf.detailModel.C_STATUS_DD_ID isEqualToString:@"A42000_C_STATUS_0013"]) {//已交付
                        [JRToast showWithText:@"已是已出库状态"];
                        return ;
                    }
                    
                    if (weakSelf.detailModel.C_A82300_C_ID.length <=0) {
                        [JRToast showWithText:@"请先绑定车源信息"];
                        return;
                    }
//
                    MJKOrderFullViewController *fvc = [[MJKOrderFullViewController alloc]init];
                    fvc.Type = FullTypeOut;
                    fvc.omodel = weakSelf.detailModel;
                    [weakSelf.navigationController pushViewController:fvc animated:YES];
                    

                }];
                //交付
                UIAlertAction *actionQK = [UIAlertAction actionWithTitle:@"已全款" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if ([weakSelf.detailModel.C_STATUS_DD_NAME isEqualToString:@"退单"]) {
                        [JRToast showWithText:@"已退单"];
                        return ;
                    }
                    if ([weakSelf.detailModel.C_STATUS_DD_ID isEqualToString:@"A42000_C_STATUS_0001"]) {//已全款
                        [JRToast showWithText:@"已是已全款状态"];
                        return ;
                    }
                    if ([weakSelf.detailModel.C_STATUS_DD_ID isEqualToString:@"A42000_C_STATUS_0013"]) {//已交付
                        [JRToast showWithText:@"已是已出库状态,不能变更为已全款"];
                        return ;
                    }
                    
//
                    MJKOrderFullViewController *fvc = [[MJKOrderFullViewController alloc]init];
                    fvc.Type = FullTypeFull;
                    fvc.omodel = weakSelf.detailModel;
                    [weakSelf.navigationController pushViewController:fvc animated:YES];

                }];
                //退单
                UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"退单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf canelClick:weakSelf.detailModel];

                }];
                
                
                if ([[NewUserSession instance].appcode containsObject:@"APP005_0019"]) {
                    [alertVC addAction:actionQK];
                }
                
                    [alertVC addAction:action4];
                if ([[NewUserSession instance].appcode containsObject:@"APP005_0020"]) {
                    [alertVC addAction:action5];
                }
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertVC addAction:cancelAction];
                [self presentViewController:alertVC animated:YES completion:nil];
                
            }
			if ([title isEqualToString:@"预约到店"]) {
				if (![[NewUserSession instance].appcode containsObject:@"crm:a416_yuyue:add"]) {
					[JRToast showWithText:@"账号无权限"];
					return;
				}
				CGCAppointmentModel*postModel=[[CGCAppointmentModel alloc]init];
				postModel.C_A41500_C_NAME=weakSelf.detailModel.C_BUYNAME;
				postModel.C_A41500_C_ID=weakSelf.detailModel.C_A41500_C_ID;
				postModel.C_PHONE=weakSelf.detailModel.C_PHONE;
				postModel.C_SEX_DD_ID=weakSelf.detailModel.C_SEX_DD_ID;
				postModel.C_SEX_DD_NAME=weakSelf.detailModel.C_SEX_DD_NAME;
				
				
				CGCNewAddAppointmentVC *vc=[[CGCNewAddAppointmentVC alloc] init];
				vc.amodel=postModel;
                vc.rootVC = self;
				vc.C_A42000_C_ID = weakSelf.detailModel.C_ID;
                vc.rloadBlock = ^{
                    weakSelf.typeName = @"订单动态";
                    [weakSelf selectBackType:weakSelf.typeName];
                };
				[weakSelf.navigationController pushViewController:vc animated:YES];
			}
            
            if ([title isEqualToString:@"附加产值"]) {
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"按揭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    MJKMortgageViewController *vc= [[MJKMortgageViewController alloc]init];
                    vc.C_A42000_C_ID = self.detailModel.C_ID;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"保险" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    MJKInsuranceViewController *vc = [[MJKInsuranceViewController alloc]init];
                    vc.rootVC = @"新增";
                    vc.C_A42000_C_ID = self.detailModel.C_ID;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }];
                
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"质保" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    MJKQualityAssuranceViewController *vc= [[MJKQualityAssuranceViewController alloc]init];
                    vc.C_A42000_C_ID = self.detailModel.C_ID;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }];
                
                UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"精品" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    MJKHighQualityViewController *vc= [[MJKHighQualityViewController alloc]init];
                    vc.rootVC = @"新增";
                    vc.C_A42000_C_ID = self.detailModel.C_ID;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }];
                
                UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"上牌" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    MJKRegistrationViewController *vc= [[MJKRegistrationViewController alloc]init];
                    vc.C_A42000_C_ID = self.detailModel.C_ID;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }];
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                if ([[NewUserSession instance].appcode containsObject:@"crm:a420:aj"]) {
                    [ac addAction:action];
                }
                if ([[NewUserSession instance].appcode containsObject:@"crm:a420:bx"]) {
                    [ac addAction:action1];
                }
                if ([[NewUserSession instance].appcode containsObject:@"crm:a420:zb"]) {
                    [ac addAction:action2];
                }
                if ([[NewUserSession instance].appcode containsObject:@"crm:a420:jp"]) {
                    [ac addAction:action3];
                }
                if ([[NewUserSession instance].appcode containsObject:@"crm:a420:sp"]) {
                    [ac addAction:action4];
                }
                [ac addAction:cancel];
                
                ac.modalPresentationStyle = 0;
                [self presentViewController:ac animated:YES completion:nil];
            }
            
            if ([title isEqualToString:@"面访问卷"]) {
                if (![[NewUserSession instance].appcode containsObject:@"crm:a420:mfwj"]) {
                    [JRToast showWithText:@"账号无权限"];
                    return;
                }
                MJKQuestionnaireViewController *vc = [[MJKQuestionnaireViewController alloc]init];
                vc.vcName = @"面访问卷";
                vc.detailModel = weakSelf.detailModel;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
			
			
			if ([title isEqualToString:@"重新指派"]) {
				if (![[NewUserSession instance].appcode containsObject:@"crm:a420:zp"]) {
					[JRToast showWithText:@"账号无权限"];
					return ;
				}
				MJKChooseEmployeesViewController*vc=[[MJKChooseEmployeesViewController alloc]init];
                if ([[NewUserSession instance].appcode containsObject:@"crm:a420:kdzp"]) {
                    vc.isAllEmployees = @"是";
                }
                vc.noticeStr = @"无提示";
                vc.employeesType  = @"我和我的下级";
                vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
					[weakSelf HTTPUpdataAssWithID:weakSelf.detailModel.C_ID andUserID:model.user_id];
				};
				
				
				
				
				[weakSelf.navigationController pushViewController:vc animated:YES];
			}
			if ([title isEqualToString:@"满意度"]) {
                if (![[NewUserSession instance].appcode containsObject:@"crm:a420:xsmyd"]) {
                    [JRToast showWithText:@"账号无权限"];
                    return;
                }
                MJKQuestionnaireViewController *vc = [[MJKQuestionnaireViewController alloc]init];
                vc.vcName = @"销售满意度";
                vc.detailModel = weakSelf.detailModel;
                [weakSelf.navigationController pushViewController:vc animated:YES];
//                if (weakSelf.detailModel.satisfaction_flag.boolValue == YES) {
//                    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
//                    launchMiniProgramReq.userName = [NewUserSession instance].C_GID;  //拉起的小程序的username
//                    launchMiniProgramReq.path = [NSString stringWithFormat:@"/pages/evaluateList/evaluateList?objectid=%@",weakSelf.detailModel.C_OBJECTID] ;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
//                    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
//                    [WXApi sendReq:launchMiniProgramReq];
//
//                } else {
//                    WXMiniProgramObject *object = [WXMiniProgramObject object];
//                    object.webpageUrl = @"http://www.qq.com";
//                    object.userName = [NewUserSession instance].C_GID;
//                    NSString *str = [NSString stringWithFormat:@"/pages/evaluate/evaluate?scene=%@",weakSelf.detailModel.C_OBJECTID];
//                    object.path = str;
//                    UIImage *image = [UIImage imageNamed:@"支付功能_03"];
//                    object.hdImageData = UIImagePNGRepresentation(image);
//                    object.withShareTicket = NO;
//                    object.miniProgramType = WXMiniProgramTypeRelease;
//                    WXMediaMessage *message = [WXMediaMessage message];
//                    message.title = @"满意度评价";
//                    //                message.description = @"小程序描述";
//                    message.thumbData = nil;  //兼容旧版本节点的图片，小于32KB，新版本优先
//                    //使用WXMiniProgramObject的hdImageData属性
//                    message.mediaObject = object;
//
//                    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
//                    req.bText = NO;
//                    req.message = message;
//                    req.scene = WXSceneSession;  //目前只支持会话
//                    [WXApi sendReq:req];
//
//
//                }
                
//                MJKSatisfactionView *sView = [[MJKSatisfactionView alloc]initWithFrame:weakSelf.view.frame];
//                sView.C_OBJECTID = self.detailModel.C_OBJECTID;
//                sView.satisfaction_flag = self.detailModel.satisfaction_flag;
//                [[UIApplication sharedApplication].keyWindow addSubview:sView];
			}
		};
		
		
	}
	
	//	if ([self.detailInfoModel.C_STAR_DD_ID isEqualToString:@"A41500_C_STAR_0000"]) {
	//		_toolView.isStar=YES;
	//	}else{
	//		_toolView.isStar=NO;
	//	}
	
	
	
	
	return _toolView;
	
}

#pragma mark 重新指派
- (void)HTTPUpdataAssWithID:(NSString *)idStr andUserID:(NSString *)userID {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A42000WebService-assign"];
	
	NSMutableDictionary *dic=[NSMutableDictionary new];
	dic[@"C_ID"] = idStr;
	dic[@"USER_ID"] = userID;
	
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	
	DBSelf(weakSelf);
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		[self.view addSubview:self.tableView];
		if ([data[@"code"] integerValue]==200) {
			[weakSelf getDetailVales];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
	
}

- (void)HTTPCardData {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"UserWebService-qrcodeToCard"];
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    dic[@"C_ID"] = [NewUserSession instance].user.u051Id;
    dic[@"appid"] = [NewUserSession instance].C_APPID;
    dic[@"appsecret"] = [NewUserSession instance].C_APPSECRET;

    
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    DBSelf(weakSelf);
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            MJKCardView *cardView = [[NSBundle mainBundle]loadNibNamed:@"MJKCardView" owner:nil options:nil].firstObject;
            cardView.rootVC = weakSelf;
            cardView.vcName = @"名片";
            [cardView.qrcodeImageView sd_setImageWithURL:[NSURL URLWithString:data[@"qrcode"]]];
            cardView.qrCodeStr = data[@"qrcode"];
            [[UIApplication sharedApplication].keyWindow addSubview:cardView];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
}

#pragma mark - 设计师
- (void)HttpAddDesignerWithAndOrder:(NSString *)orderID andDesigner:(NSString *)designer {
	NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A42000WebService-operationDesigner"];
	NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
	if (orderID.length > 0) {
		contentDict[@"C_ID"] = orderID;
	}
	
	if (designer.length > 0) {
		contentDict[@"C_DESIGNER_ROLEID"] = designer;
	}
	DBSelf(weakSelf);
	[mainDict setObject:contentDict forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf getDetailVales];
			[JRToast showWithText:data[@"message"]];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
	}];
}


- (void)showAlertDate:(NSString*)title andTimeBlock:(void(^)(NSString *timeStr))backTimeValueBlock {
	CGCAlertDateView *alertDate = [[CGCAlertDateView alloc]initWithFrame:self.view.frame withSelClick:^{
		
	} withSureClick:^(NSString *title, NSString *dateStr) {
		if (backTimeValueBlock) {
			backTimeValueBlock(dateStr);
		}
	} withHight:150 withText:title withDatas:nil];
	[[UIApplication sharedApplication].keyWindow addSubview:alertDate];
}

-(void)delegateShowFirstView{
    self.toolView.backView.hidden = NO;
	DBSelf(weakSelf);
	CGFloat moreLineHeight = [[NewUserSession instance].C_APPTYPE_DD_ID isEqualToString:@"A40300_C_APPTYPE_0000"] ? 0 : 70;
	[UIView animateWithDuration:0.25 animations:^{
		if (weakSelf.toolView.ToolLeftButton.isSelected == NO) {
			CGRect toolFrame = weakSelf.toolView.frame;
			//(0, KScreenHeight-50 - SafeAreaBottomHeight, KScreenWidth, 50+70 + 70)
			toolFrame.origin.y = KScreenHeight-50 - SafeAreaBottomHeight;
			toolFrame.size.height = 50+70 + moreLineHeight;
			weakSelf.toolView.toolMainViewHeightLayout.constant = 50;
			weakSelf.toolView.toolTextViewHeightLayout.constant = 44;
			weakSelf.toolMainViewHeight = 0;
			weakSelf.toolView.ToolTextField.text = @"";
		}
		CGRect rect=weakSelf.toolView.frame;
		rect.origin.y=KScreenHeight-weakSelf.toolView.toolMainViewHeightLayout.constant - SafeAreaBottomHeight;
		weakSelf.toolView.frame=rect;
		
	}];
	
}
-(void)delegateShowChooseView{
    self.toolView.backView.hidden = YES;
	CGFloat moreLineHeight = [[NewUserSession instance].C_APPTYPE_DD_ID isEqualToString:@"A40300_C_APPTYPE_0000"] ? 0 : 70;
	DBSelf(weakSelf);
	[UIView animateWithDuration:0.25 animations:^{
		CGRect rect=weakSelf.toolView.frame;
		rect.origin.y=KScreenHeight-self.toolView.toolMainViewHeightLayout.constant-70-moreLineHeight;
		weakSelf.toolView.frame=rect;
		
	}];
	
}
-(void)delegateShowKeyBoardViewWithY:(CGFloat)keyBoardY{
	DBSelf(weakSelf);
	[UIView animateWithDuration:0.25 animations:^{
		CGRect rect=weakSelf.toolView.frame;
		//        rect.origin.y=KScreenHeight-258-30-50;
		rect.origin.y=keyBoardY-30-self.toolView.toolMainViewHeightLayout.constant;
		weakSelf.toolView.frame=rect;
		
	}];
	
}
#pragma mark 点击选择类型
- (void)selectButtonAction:(UIButton *)sender {
    
	self.typeName = sender.titleLabel.text;
	UIView *bgView = [self.selectTypeView viewWithTag:1090];
	CGRect frame = bgView.frame;
	frame.origin.x = sender.frame.origin.x;
	bgView.frame = frame;
	[self.selectPerButton setTitleColor:[UIColor grayColor]];
	[sender setTitleColor:[UIColor blackColor]];
	
//	[self HttpGetDataList];
	
    
	self.selectPerButton = sender;
    if ([sender.titleLabel.text isEqualToString:@"订单详情"]) {
        self.scrollView.hidden = NO;
        self.tableView.hidden = YES;
        self.collectionView.hidden = YES;
        self.leftTableView.hidden = self.rightTableView.hidden = YES;
        return;
    } else if ([sender.titleLabel.text isEqualToString:@"所有附件"]) {
        self.scrollView.hidden = YES;
        self.tableView.hidden = YES;
        self.collectionView.hidden = NO;
        self.leftTableView.hidden = self.rightTableView.hidden = YES;
    } else if ([sender.titleLabel.text isEqualToString:@"订单动态"]) {
        self.C_TYPE_DD_ID = @"A85600_C_TYPE_0000";
        self.scrollView.hidden = YES;
        self.tableView.hidden = YES;
        self.collectionView.hidden = YES;
        self.leftTableView.hidden = YES;
        self.rightTableView.hidden = NO;
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    } else {
        self.scrollView.hidden = YES;
        self.tableView.hidden = NO;
        self.collectionView.hidden = YES;
        self.leftTableView.hidden = self.rightTableView.hidden = YES;
    }
    if ([sender.titleLabel.text isEqualToString:@"订单动态"]) {
        [self.rightTableView.mj_header beginRefreshing];
    } else {
        [self.tableView.mj_header beginRefreshing];
    }
}


#pragma mark 请求数据
- (void)HttpGetDataList {
    if ([self.typeName isEqualToString:@"订单详情"]) {
        return;
    }
    if ([self.typeName isEqualToString:@"订单节点"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP005_0027"]) {
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            [JRToast showWithText:@"账号无权限"];
            [self.view bringSubviewToFront:self.tableView];
            [self.view bringSubviewToFront:self.toolView];
            [self.view bringSubviewToFront:self.memoView];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            return;
        }
    } else if ([self.typeName isEqualToString:@"收款记录"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP005_0025"]) {
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            [JRToast showWithText:@"账号无权限"];
            [self.view bringSubviewToFront:self.tableView];
            [self.view bringSubviewToFront:self.toolView];
            [self.view bringSubviewToFront:self.memoView];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            return;
        }
    } else if ([self.typeName isEqualToString:@"订单动态"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP005_0026"]) {
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            [JRToast showWithText:@"账号无权限"];
            [self.view bringSubviewToFront:self.tableView];
            [self.view bringSubviewToFront:self.toolView];
            [self.view bringSubviewToFront:self.memoView];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            return;
        }
    } else if ([self.typeName isEqualToString:@"所有附件"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP005_0028"]) {
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            [JRToast showWithText:@"账号无权限"];
            [self.view bringSubviewToFront:self.tableView];
            [self.view bringSubviewToFront:self.toolView];
            [self.view bringSubviewToFront:self.memoView];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            return;
        }
    }
    
    self.tableView.userInteractionEnabled = NO;
	self.dataArray = nil;
    
    DBSelf(weakSelf);
    if (self.orderId.length<=0) {
        [JRToast showWithText:@"订单不存在"];
        return;
    }
    if ([self.typeName isEqualToString:@"所有附件"]) {
        NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
        contentDic[@"C_ID"] = self.detailModel.C_ID;
        HttpManager *manager = [[HttpManager alloc]init];
        [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/a420/getAllFileList", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
            if ([data[@"code"] integerValue]==200) {
                [weakSelf.dataArray addObjectsFromArray:data[@"data"]];
                [weakSelf.view bringSubviewToFront:weakSelf.collectionView];
                [weakSelf.view bringSubviewToFront:weakSelf.toolView];
                [weakSelf.view bringSubviewToFront:weakSelf.memoView];
                [weakSelf.collectionView reloadData];
            } else {
                [JRToast showWithText:data[@"msg"]];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    } else if ([self.typeName isEqualToString:@"订单动态"]) {
        
        NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
        contentDic[@"C_A42000_C_ID"] = self.detailModel.C_ID;
        contentDic[@"pageNum"] = @"1";
        contentDic[@"pageSize"] = @(self.pagen);
        HttpManager *manager = [[HttpManager alloc]init];
        [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/a856/list", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
            if ([data[@"code"] integerValue]==200) {
                NSDictionary*dict=[data copy];
                for (NSDictionary * div in dict[@"data"][@"list"]) {
                    MJKOrderMoneyListModel *model = [MJKOrderMoneyListModel yy_modelWithDictionary:div];
                    [weakSelf.dataArray addObject:model];
                }
                [weakSelf.tableView reloadData];
                [weakSelf.view bringSubviewToFront:weakSelf.tableView];
                [weakSelf.view bringSubviewToFront:weakSelf.toolView];
                [weakSelf.view bringSubviewToFront:weakSelf.memoView];
                
            
            
            weakSelf.tableView.userInteractionEnabled = YES;
            } else {
                [JRToast showWithText:data[@"msg"]];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    } else if ([self.typeName isEqualToString:@"收款记录"]) {
        NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
        contentDic[@"C_ORDER_ID"] = self.detailModel.C_ID;
        contentDic[@"pageNum"] = @"1";
        contentDic[@"pageSize"] = @(self.pagen);
        HttpManager *manager = [[HttpManager alloc]init];
        [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a042/list", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
            if ([data[@"code"] integerValue]==200) {
                NSDictionary*dict=[data copy];
                for (NSDictionary * div in dict[@"data"][@"content"]) {
                    MJKOrderMoneyListModel *model = [MJKOrderMoneyListModel yy_modelWithDictionary:div];
                    [weakSelf.dataArray addObject:model];
                }
                [weakSelf.tableView reloadData];
                [weakSelf.view bringSubviewToFront:weakSelf.tableView];
                [weakSelf.view bringSubviewToFront:weakSelf.toolView];
                [weakSelf.view bringSubviewToFront:weakSelf.memoView];
                
            
            
            weakSelf.tableView.userInteractionEnabled = YES;
            } else {
                [JRToast showWithText:data[@"msg"]];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }
    
    

}


#pragma mark 退单
//取消
- (void)canelClick:(CGCOrderDetailModel *)model{
    DBSelf(weakSelf);
    MJKSingleBackView *alertView = [[MJKSingleBackView alloc]initWithFrame:self.view.frame andReasonBlock:^(NSString *type, NSString *timeStr, NSString *Remark) {
        [MJKHttpApproval DefeatGetHttpValuesWithC_VOUCHERID:@"" andX_REMARK:Remark andC_REMARK_TYPE_DD_ID:type andC_OBJECT_ID:model.C_ID andTYPE:@"A42500_C_TYPE_0002" andSuccessBlock:^{
            UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退款" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //新增收款
                addDealViewController *vc = [[addDealViewController alloc]init];
                vc.vcName = @"收款/退款";
                vc.C_ORDER_ID = weakSelf.orderId;
                vc.orderDetailModel = model;
                vc.type = @"退单";
                    //                    vc.A04200_C_ID = self.A04200_C_ID;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                
                
            }];
            
            UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            [alertV addAction:noAction];
            [alertV addAction:yesAction];
            [weakSelf presentViewController:alertV animated:YES completion:nil];
        }];
    }];
    [self.view addSubview:alertView];
    
}



- (void)pushInfoWithC_A41500_C_ID:(NSString *)C_A41500_C_ID andC_ID:(NSString *)C_ID andC_TYPE_DD_ID:(NSString *)C_TYPE_DD_ID {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"UserWebService-getPushMsg"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"C_A41500_C_ID"] = C_A41500_C_ID;
    dic[@"C_OBJECTID"] = C_ID;
    dic[@"C_TYPE_DD_ID"] = C_TYPE_DD_ID;
    
    [dict setObject:dic forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    DBSelf(weakSelf);
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        
        if ([data[@"code"] integerValue]==200) {
            //            weakSelf.dataDic = data[@"content"];
            MJKShowSendView *showView = [[MJKShowSendView alloc]initWithFrame:weakSelf.view.frame andButtonTitleArray:@[@"否",@"是"] andTitle:@"" andMessage:@"是否给客户发送通知消息?"];
            showView.buttonActionBlock = ^(NSString * _Nonnull str) {
                if ([str isEqualToString:@"否"]) {
                    for (UIViewController * vc in self.navigationController.childViewControllers) {
                        if ([vc isKindOfClass:[CGCOrderListVC class]]) {
                            
                            [self.navigationController popToViewController:vc animated:NO];
                        }
                        
                    }
                } else {
                    MJKMessagePushNotiViewController *vc = [[MJKMessagePushNotiViewController alloc]init];
                    vc.dataDic = data[@"content"];
                    
                    vc.C_A41500_C_ID = C_A41500_C_ID;
                    vc.C_TYPE_DD_ID = C_TYPE_DD_ID;
                    vc.C_ID = C_ID;
                    vc.backActionBlock = ^{
//                        for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
//                            if ([vc isKindOfClass:[CGCOrderListVC class]]) {
                                [weakSelf.navigationController popToViewController:self.rootVC animated:YES];
//                            }
//                        }
                    };
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            };
            
            [weakSelf.view addSubview:showView];
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (NSMutableArray *)dataArray {
	if (!_dataArray) {
		_dataArray = [NSMutableArray array];
	}
	return _dataArray;
}

- (NSMutableArray *)typeButtonArray {
    if (!_typeButtonArray) {
        _typeButtonArray = [NSMutableArray array];
    }
    return _typeButtonArray;
}

- (NSMutableArray *)urlArray {
    if (!_urlArray) {
        _urlArray = [NSMutableArray array];
    }
    return _urlArray;
}

- (NSMutableArray *)leftTableDataArray {
    if (!_leftTableDataArray) {
        NSArray *nameArr = @[@"按揭",@"保险",@"质保",@"精品",@"上牌"];
        NSArray *codeArr = @[@"A85600_C_TYPE_0000",@"A85600_C_TYPE_0001",@"A85600_C_TYPE_0002",@"A85600_C_TYPE_0003",@"A85600_C_TYPE_0004"];
        _leftTableDataArray = [NSMutableArray array];
        for (int i = 0; i < codeArr.count; i++) {
            [_leftTableDataArray addObject:@{@"code" : codeArr[i], @"name" : nameArr[i]}];
        }
    }
    return _leftTableDataArray;
}

@end
