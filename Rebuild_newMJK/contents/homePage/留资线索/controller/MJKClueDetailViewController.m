//
//  MJKClueDetailViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/8/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "MJKClueDetailViewController.h"
#import "CommonCallViewController.h"
#import "MJKHistoryFlowViewController.h"
#import "CGCAlertDateView.h"
#import "CustomerFollowAddEditViewController.h"
#import "CustomerDetailViewController.h"
//cell
#import "MJKClueDetailTableViewCell.h"
#import "MJKClueMemoInDetailTableViewCell.h"
//model
#import "MJKClueDetailModel.h"
#import "NSString+Extern.h"

#import "MJKProductShowModel.h"


#import "AddOrEditlCustomerViewController.h"
#import "MJKClueListViewController.h"

#import "MJKClueTabViewController.h"

#import "BrokerCustomVC.h"

#import "PotentailCustomerListDetailModel.h"

#import "BrokerCustomVC.h"

#import "MJKAddressTableViewCell.h"
#import "MJKCustomerAddressTableViewCell.h"

#import "AddCustomerProductTableViewCell.h"

@interface MJKClueDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate,AddOrEditlCustomerViewControllerDelegate,CustomerFollowAddEditViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) MJKClueDetailModel *clueDetailModel;
@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *textField;
/** productArray*/
@property (nonatomic, strong) NSMutableArray *productArray;

@end

@implementation MJKClueDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"名单处理";
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"查看线索";
    //操作记录按钮
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
//    [button setBackgroundImage:[UIImage imageNamed:@"23-顶右button.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(clickTopButton:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];;
//    self.navigationItem.rightBarButtonItem = barButton;
	[self initUI];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	if (self.backViewBlock) {
		self.backViewBlock(@"detailView");
	}
}

#pragma mark - initUI
- (void)initUI {
    [self.view addSubview:self.tableView];
	UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
	self.scrollView = scrollView;
//    [self.view addSubview:scrollView];
//    [scrollView addSubview:self.tableView];
	[self getClueDetailDatas];
    [self getProduct];
	scrollView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight + 44);
//    CGRect frame = self.tableView.frame;
//    frame.size.height += 44;
//    self.tableView.frame = frame;
}
//操作按钮

#pragma - 接口数据请求
- (void)getClueDetailDatas {
    DBSelf(weakSelf);
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a413/info", HTTP_IP] parameters:@{@"C_ID" :self.clueListMainSecondModel.C_ID} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.clueDetailModel = [MJKClueDetailModel yy_modelWithDictionary:data[@"data"]];
            weakSelf.modelArray = [NSArray arrayWithArray:[MJKClueDetailModel arrayWithModel:weakSelf.clueDetailModel]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = self.titleArray[indexPath.row];
    if ([str isEqualToString:@"意向产品"]) {
        DBSelf(weakSelf);
        AddCustomerProductTableViewCell *cell = [AddCustomerProductTableViewCell cellWithTableView:tableView];
        cell.topTitleLabel.text = @"产品详情";
        cell.topTitltLabelLeftLayout.constant = 10;
        cell.scanfButton.hidden = YES;
        cell.textView.editable = NO;
        
        
        //        if ([self.orderModel.C_STATUS_DD_ID isEqualToString:@"A42000_C_STATUS_0001"] || [self.orderModel.C_STATUS_DD_ID isEqualToString:@"A42000_C_STATUS_0003"]) {
        //            cell.textView.editable = NO;
        //        }
        //        if (self.orderModel.X_INTENTIONREMARK.length > 0) {
        //            cell.textViewStr = self.orderModel.X_INTENTIONREMARK;
        //        } else if (self.X_INTENTIONREMARK.length > 0) {
        //            cell.textViewStr = self.X_INTENTIONREMARK;
        //        }
        if (self.clueDetailModel.C_PURPOSE.length > 0) {
            cell.textViewStr = self.clueDetailModel.C_PURPOSE;
        }
        
        
        cell.rootVC = self;
        if (self.productArray.count > 0) {
            cell.productArray = self.productArray;
        } else {
            cell.productArray = @[];
        }
        
        
        
        return cell;
    } else if ([str isEqualToString:@"客户地址"]) {
        if ([NewUserSession instance].configData.IS_KHXQDZ.boolValue == NO) {
            MJKAddressTableViewCell *cell = [MJKAddressTableViewCell cellWithTableView:tableView];
            cell.textView.editable = NO;
            cell.titleLabel.text=@"客户地址";
            if (self.clueDetailModel.C_ADDRESS.length > 0) {
                cell.textView.alpha = 1.f;
            }
            if (self.clueDetailModel.C_A48200_C_ID.length > 0) {
                cell.textView.text = [NSString stringWithFormat:@"%@ %@",self.clueDetailModel.C_A48200_C_NAME,self.clueDetailModel.C_ADDRESS];
            } else {
                if (self.clueDetailModel.C_ADDRESS.length > 0) {
                    
                    cell.textView.text = self.clueDetailModel.C_ADDRESS;
                } else {
                    cell.textField.hidden = YES;
                }
            }
            cell.sepLabel.hidden = NO;
            if (self.clueDetailModel.C_A48200_C_ID.length > 0 || self.clueDetailModel.C_ADDRESS.length > 0) {
                cell.chooseAreaLayout.constant = 40;
                cell.chooseAreaButton.hidden = NO;
                [cell.chooseAreaButton addTarget:self action:@selector(navAction:)];
            }
            return cell;
        } else {
            
            MJKCustomerAddressTableViewCell *cell = [MJKCustomerAddressTableViewCell cellWithTableView:tableView];
            cell.inputAddressTextView.editable = NO;
            if (self.clueDetailModel.C_ADDRESS.length > 0) {
                cell.inputAddressTextView.text = self.clueDetailModel.C_ADDRESS;;
            } else {
                cell.inputAddressTextView.text = @" ";
            }
            if (self.clueDetailModel.C_A48200_C_NAME.length > 0) {
                cell.chooseAddressLabel.text = self.clueDetailModel.C_A48200_C_NAME;
            }
            if (self.clueDetailModel.C_ADDRESS.length > 0 || self.clueDetailModel.C_A48200_C_ID.length > 0) {
                NSString *str = [NSString stringWithFormat:@"%@ %@",self.clueDetailModel.C_A48200_C_NAME, self.clueDetailModel.C_ADDRESS];
                if (str.length > 0) {
                    cell.tfRightLayout.constant = 30;
                    cell.navImage.hidden = NO;
                    [cell.navImage addTarget:self action:@selector(navAction:)];
                }
            }
            
            
            cell.centerSepLayout.constant = 16;
            cell.bottomSepLabel.hidden = NO;
           
            return cell;
        }
    } else {
	MJKClueDetailTableViewCell *cell = [[NSBundle mainBundle]loadNibNamed:@"MJKClueDetailTableViewCell" owner:nil options:nil].firstObject;
    cell.titleLabel.text=@"";
	if (self.modelArray.count > 0) {
		cell.clueDetailModel = self.clueDetailModel;
		[cell updateCellWithDatas:self.modelArray[indexPath.row] andTitle:self.titleArray[indexPath.row] andRow:indexPath.row];
		if (indexPath.row == self.modelArray.count - 1) {
			MJKClueMemoInDetailTableViewCell *memoCell = [MJKClueMemoInDetailTableViewCell cellWithTableView:tableView];//[[NSBundle mainBundle]loadNibNamed:@"MJKClueMemoInDetailTableViewCell" owner:nil options:nil].firstObject;
            memoCell.titleLabel.text = @"备注";
			memoCell.memoTextView.editable = NO;
//            if ([self.clueDetailModel.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0000"]) {//无意向
//                memoCell.memoTextView.text = @"";
//            } else {
                memoCell.memoTextView.text = self.clueDetailModel.X_REMARK;
//            }
			
			return memoCell;
		}
	}
	return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = self.titleArray[indexPath.row];
    if ([str isEqualToString:@"意向产品"]) {
        if (self.productArray.count > 0) {
            if (44 * self.productArray.count + 30 + 40 > 220) {
                return 220;
            } else {
                return 44 * self.productArray.count + 30 + 40;
            }
        }
        return 120;
    }
	if (indexPath.row == self.modelArray.count - 1) {
//		self.clueDetailModel.X_REMARK
		CGSize size = [self.clueDetailModel.X_REMARK boundingRectWithSize:CGSizeMake(tableView.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f ]} context:nil].size;
		
		return 44 + 86;
    }else if (indexPath.row == 4) {
        if ([NewUserSession instance].configData.IS_KHXQDZ.boolValue == NO) {
            CGSize size = [self.clueDetailModel.C_ADDRESS boundingRectWithSize:CGSizeMake(160, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f ]} context:nil].size;
            if (size.height > 44) {
                return size.height + 14;
            } else {
                return 44;
            }
            
        }else {
            NSString *str = [NSString stringWithFormat:@"%@",self.clueDetailModel.C_ADDRESS];
            NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:14.f ]};
            CGSize size = [str boundingRectWithSize:CGSizeMake(KScreenWidth-115, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
            //        if (([NewUserSession instance].IS_KHXQDZ.boolValue == YES)) {
            if (size.height + 44 + 20 > 88) {
                return size.height + 44 + 20;
            } else {
                return 88;
            }
        }
        
    }  else {
		return 44;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.row == 1) {
		if ([self.clueDetailModel.C_STATUS_DD_NAME isEqualToString:@"再下发"] || [self.clueDetailModel.C_STATUS_DD_NAME isEqualToString:@"有意向"]) {
			CustomerDetailViewController *detailVC = [[CustomerDetailViewController alloc]init];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VCName"];
			PotentailCustomerListDetailModel *detailModel = [[PotentailCustomerListDetailModel alloc]init];
			detailModel.C_A41500_C_ID =self.clueDetailModel.C_A41500_C_ID;
			detailVC.mainModel = detailModel;
			[self.navigationController pushViewController:detailVC animated:YES];
		} else {
			[JRToast showWithText:@"还没有该客户"];
		}
		
	}
	if (indexPath.row == 2) {
		if (![[NewUserSession instance].appcode containsObject:@"APP001_0009"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
		if (self.clueDetailModel.C_PHONE.length == 11) {
//			[self selectTelephone:indexPath.row];
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.clueDetailModel.C_PHONE]]];
		} else {
			[JRToast showWithText:@"暂无电话号码"];
		}
	}
    
    if (indexPath.row == 11) {//介绍人
        if (self.clueDetailModel.C_A47700_C_ID.length > 0) {
            if (![[NewUserSession instance].appcode containsObject:@"APP015_0012"]) {
                [JRToast showWithText:@"账号无权限"];
                return;
            }
            BrokerCustomVC *vc = [[BrokerCustomVC alloc]init];
            PotentailCustomerListDetailModel *model = [[PotentailCustomerListDetailModel alloc]init];
            model.C_A41500_C_ID = self.clueDetailModel.C_A47700_C_ID;
            model.C_ID = self.clueDetailModel.C_A47700_C_ID;
            vc.mainModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}





- (void)getProduct {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47100WebService-getList"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"TYPE"] = @"2" ;
    if (self.clueListMainSecondModel.C_ID.length > 0) {
        dic[@"C_A41300_C_ID"] = self.clueListMainSecondModel.C_ID;
    }
    
    [dict setObject:dic forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    DBSelf(weakSelf);
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        
        if ([data[@"code"] integerValue]==200) {
            weakSelf.productArray = [NSMutableArray array];
            NSArray *arr = data[@"content"];
            for (int i = 0; i < arr.count; i++) {
                NSDictionary *productDic = arr[i];
                MJKProductShowModel *model = [[MJKProductShowModel alloc]init];
                model.C_ID = productDic[@"C_A41900_C_ID"];
                model.B_HDJ = productDic[@"B_PRICE"];
                model.number = [productDic[@"I_NUMBER"] integerValue];
                model.X_REMARK = productDic[@"X_REMARK"];
                model.X_FMPICURL = productDic[@"X_FMPICURL"];
                model.C_NAME = productDic[@"C_A41900_C_NAME"];
                model.C_ID_ID = productDic[@"C_ID"];
                [weakSelf.productArray addObject:model];
            }
            NSInteger index = [weakSelf.titleArray indexOfObject:@"意向产品"];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

#pragma mark - 点击事件
- (void)navAction:(UIButton *)sender {
    if (self.clueDetailModel.C_ADDRESS.length > 0 || self.clueDetailModel.C_A48200_C_ID.length > 0) {
        NSString *str = [NSString stringWithFormat:@"%@ %@",self.clueDetailModel.C_A48200_C_NAME, self.clueDetailModel.C_ADDRESS];
        
        MJKMapNavigationViewController *alertVC = [MJKMapNavigationViewController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        alertVC.C_ADDRESS = str;
        [self presentViewController:alertVC animated:YES completion:nil];
    } else {
        [JRToast showWithText:@"暂无客户地址"];
        return;
    }
    
}

- (void)clickTopButton:(UIButton *)sender {
	MJKHistoryFlowViewController *historyVC = [[MJKHistoryFlowViewController alloc]init];
	historyVC.VCName = @"线索";
	historyVC.C_A41500_C_ID = self.clueDetailModel.C_ID;
	[self.navigationController pushViewController:historyVC animated:YES];
}

#pragma mark - 重写方法
//电话
- (void)telephoneCall:(NSInteger)index{
    if (self.clueDetailModel.C_PHONE.length > 0) {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.clueDetailModel.C_PHONE]]];
    } else {
       [JRToast showWithText:@"无电话号码"];
   }
	
}
- (void)whbcallBack:(NSInteger)index {
    if (self.clueDetailModel.C_PHONE.length > 0) {
    [DBObjectTools whbCallWithC_OBJECT_ID:self.clueDetailModel.C_ID andC_CALL_PHONE:self.clueDetailModel.C_PHONE andC_NAME:self.clueDetailModel.C_NAME andC_OBJECTTYPE_DD_ID:@"A83100_C_OBJECTTYPE_0000" andCompleteBlock:nil];
    } else {
       [JRToast showWithText:@"无电话号码"];
   }
}
//座机
- (void)landLineCall:(NSInteger)index{
	
	CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
	myView.typeStr=@"用座机拨打";
	myView.nameStr=@"请接听座机来电，随后将其自动呼叫对方";
	myView.callStr=self.clueDetailModel.C_PHONE;
	[self.navigationController pushViewController:myView animated:YES];
	
}
//回呼
- (void)callBack:(NSInteger)index{
	CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
	myView.typeStr=@"回呼到手机";
	myView.nameStr=@"请接听手机来电，随后将其自动呼叫对方";
	myView.callStr=self.clueDetailModel.C_PHONE;
	[self.navigationController pushViewController:myView animated:YES];
	
}

#pragma set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, KScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight) style:UITableViewStylePlain];
		_tableView.dataSource = self;
		_tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
//        _tableView.scrollEnabled = NO;
	}
	return _tableView;
}

- (NSArray *)titleArray {
	if (!_titleArray) {
		_titleArray = [NSArray arrayWithObjects:@"类型",@"客户姓名", @"手机号码",@"客户微信",@"客户地址", @"意向产品", @"性别",@"意图标签", @"导入标识", @"来源渠道", @"渠道细分",@"介绍人",@"业务",@"前负责人",@"所属人",@"创建人", @"创建时间", @"备注", nil];
	}
	return _titleArray;
}


#pragma mark  -- funcation


@end
