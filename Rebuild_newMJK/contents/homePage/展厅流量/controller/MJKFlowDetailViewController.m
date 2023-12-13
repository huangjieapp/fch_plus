//
//  MJKFlowDetailViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/11.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKFlowDetailViewController.h"
#import "MJKMarketViewController.h"
#import "CGCAlertDateView.h"
#import "MJKFlowListViewController.h"
#import "MJKHistoryFlowViewController.h"
#import "CustomerFollowAddEditViewController.h"
#import "MJKShopArriveViewController.h"
//新增潜客
#import "AddOrEditlCustomerViewController.h"
#import "KSPhotoBrowser.h"


#import "MJKFlowDetailTableViewCell.h"
#import "MJKClueMemoInDetailTableViewCell.h"

#import "MJKFlowDetailModel.h"
#import "MJKFlowNoFlie.h"
#import "CGCCustomModel.h"

@interface MJKFlowDetailViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate,AddOrEditlCustomerViewControllerDelegate> {
	BOOL isAddNew;
}
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) MJKFlowDetailModel *detailModel;
@end

@implementation MJKFlowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"流量处理";
	//右上角图标
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
	[button setBackgroundImage:[UIImage imageNamed:@"23-顶右button.png"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(clickTopButton:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];;
	self.navigationItem.rightBarButtonItem = barButton;
    if (@available(iOS 11.0,*)) {
        self.tableview.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
	self.view.backgroundColor = [UIColor whiteColor];
	[self HTTPGetDetailFlowDatas];
}



- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	//无操作按钮返回不刷新
	if ([self.detailModel.C_STATUS_DD_ID isEqualToString:@"A41400_C_STATUS_0002"]) {
		if (self.backViewBlock) {
			self.backViewBlock(@"flowDetailVC");
		}
	} else {
		if (self.backViewBlock) {
			self.backViewBlock(@"flowDetailChangeVC");
		}
	}
	
}

- (void)initUI {
	UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
	scrollView.delegate = self;
	[self.view addSubview:scrollView];
    if (@available(iOS 11.0,*)) {
        scrollView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    
	CGRect oldFrame = self.tableview.frame;
	CGFloat height = 7*44+21;
	if (self.detailModel.headpic_content.count > 0) {
		if (self.detailModel.headpic_content.count > 3) {
			height += 90 * 2;
		}
		height += 90;
	}
	oldFrame = CGRectMake(0, NavStatusHeight, KScreenWidth, height);
	self.tableview.frame = oldFrame;
	[scrollView addSubview:self.tableview];
    NSArray *buttonTitleArray = [NSArray arrayWithObjects:@"未留档", @"新客户", @"客户到店", @"预约到店", @"重新指派", nil];
	for (int i = 0; i < buttonTitleArray.count; i++) {
		UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.tableview.frame) + 10 + i * 50 + 15, KScreenWidth - 40, 40)];
		button.layer.cornerRadius = 5.0f;
		[button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
		[button setBackgroundColor:DBColor(246, 184, 11)];
		button.tag = 300 + i;
		[button addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:button];
	}
	scrollView.contentSize = CGSizeMake(KScreenWidth, self.tableview.frame.size.height + 350 );//tableview的高度加上四个button的高度
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//	DBSelf(weakSelf);
	if (indexPath.row == 7) {
		MJKClueMemoInDetailTableViewCell *cell = [MJKClueMemoInDetailTableViewCell cellWithTableView:tableView];
		cell.titleLabel.text = @"到店备注";
		cell.memoTextView.text = self.detailModel.X_REMARK;
		cell.memoTextView.editable = NO;
//		cell.backTextViewBlock = ^(NSString *str) {
//			weakSelf.detailModel.X_REMARK = str;
//		};
		return cell;
	} else {
		MJKFlowDetailTableViewCell *cell = [MJKFlowDetailTableViewCell cellWithTableView:tableView];
		[cell updateCell:@[@"到店人数", @"到店方式", @"到店时间", @"来源渠道", @"渠道细分",@"逗留时间",@"随行人员"] andModel:self.detailModel andRow:indexPath.row];
		
		return cell;
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    int maxCols = 3;
	if (self.detailModel.headpic_content.count > 0) {
        if (self.detailModel.headpic_content.count <= maxCols) {
            return 90;
        } else {
            return 90 * 2;
        }
	} else {
		return .1;
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 7) {
		return 44 + 65;
	} else if (indexPath.row == 6) {
		CGSize size = [self.detailModel.C_ATTENDANT boundingRectWithSize:CGSizeMake(KScreenWidth - 130, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
		if (size.height + 10 > 44) {
			return size.height + 10;
		} else {
			return 44;
		}
	} else {
		return 44;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    MJKFlowDetailModel *detailModel;
    
//    UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
//    UIImageView*imageV=[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth/2-20, 5, 40, 40)];
//    if (self.detailModel.headpic_content.count>0) {
//        [imageV sd_setImageWithURL:[NSURL URLWithString:self.detailModel.headpic_content[0][@"C_HEADPIC"]] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//
//        }];
//    }
//
//
//    [BGView addSubview:imageV];
//
//    return BGView;
    
    UIView *BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 70)];
    BGView.backgroundColor = [UIColor whiteColor];
    int maxCols = 3;
    CGFloat width = 60;
    CGFloat height = 75;
    if (self.detailModel.headpic_content.count < maxCols) {
        maxCols = self.detailModel.headpic_content.count;
    }
    CGFloat maginX = (KScreenWidth - maxCols * width) / (maxCols + 1);
    
    for (int i = 0; i < self.detailModel.headpic_content.count; i++) {
        int row = i / maxCols;
        int col = i % maxCols;
        
        UIImageView *imageView = [[UIImageView alloc]init];
        [BGView addSubview:imageView];
        imageView.layer.cornerRadius = 5.0f;
        imageView.layer.masksToBounds = YES;
        imageView.frame = CGRectMake(col * width + (maginX * col) + maginX,  row * height + (10 * row) + 10, width, height);
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.detailModel.headpic_content[i][@"C_HEADPIC"]] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        imageView.userInteractionEnabled=YES;
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scaleImageV:)];
        imageView.tag = i;
        [imageView addGestureRecognizer:tap];
    }
//    UIImageView *imageView = [[UIImageView alloc]init];
//    [BGView addSubview:imageView];
//    imageView.layer.cornerRadius = 5.0f;
//    imageView.layer.masksToBounds = YES;
//    imageView.frame = CGRectMake((BGView.frame.size.width - 50) / 2, (BGView.frame.size.height - 65) / 2, 50, 65);
    
//    if (self.detailModel.headpic_content.count > 0) {
//        [imageView sd_setImageWithURL:[NSURL URLWithString:self.detailModel.headpic_content[0][@"C_HEADPIC"]] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//
//        }];
//    }
//
    
	if (self.detailModel.headpic_content.count > 0) {
		 return BGView;
	} else {
		return nil;
	}
	
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self.view endEditing:YES];
}

#pragma mark - 点击事件
-(void)scaleImageV:(UITapGestureRecognizer*)tap{
    UIImageView*imageV=(UIImageView*)tap.view;
    NSMutableArray *items = @[].mutableCopy;
    for (int i = 0; i < self.detailModel.headpic_content.count; i++) {
        NSString *url =self.detailModel.headpic_content[i][@"C_HEADPIC"];
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageV imageUrl:[NSURL URLWithString:url]];
        [items addObject:item];
    }
    KSPhotoBrowser * browser=[KSPhotoBrowser browserWithPhotoItems:items selectedIndex:imageV.tag];
    
//    if (imageV.image) {
//        //放大图片
//        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageV image:imageV.image];
//        KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
        [browser showFromViewController:self];
//
//    }

    
}

- (void)clickButtonAction:(UIButton *)sender {
	if (sender.tag == 300) {
		//未留档		
		DBSelf(weakSelf);
		NSMutableArray*failChooseArray=[NSMutableArray array];
		for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A42600_C_REXMARK_TYPE"] ) {
			[failChooseArray addObject:model.C_NAME];
		}
		CGCAlertDateView *alertDateView = [[CGCAlertDateView alloc]initWithFrame:self.view.frame withSelClick:^{
			
		} withSureClick:^(NSString *title, NSString *dateStr) {
			NSLog(@"%@",title);
			if ([title isEqualToString:@"其他原因"]) {
				weakSelf.detailModel.C_REMARK_TYPE_DD_ID = @"A42600_C_REXMARK_TYPE_0002";
			} else if ([title isEqualToString:@"已购买其他产品"]) {
				weakSelf.detailModel.C_REMARK_TYPE_DD_ID = @"A42600_C_REXMARK_TYPE_0001";
			} else {
				weakSelf.detailModel.C_REMARK_TYPE_DD_ID = @"A42600_C_REXMARK_TYPE_0000";
			}
			[MJKFlowNoFlie HTTPUpdateFlowWithC_ID:self.detailModel.C_ID andRemark:dateStr andShopType:self.detailModel.C_REMARK_TYPE_DD_ID andBlock:^{
				[[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"isBack"];
				[weakSelf.navigationController popViewControllerAnimated:YES];
			}];
//			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//				[[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"isBack"];
//				[weakSelf.navigationController popViewControllerAnimated:YES];
//			});
		} withHight:195.0 withText:@"请填写未留档原因" withDatas:failChooseArray];
		alertDateView.textfield.placeholder = @"选择原因类型";
		alertDateView.remarkText.placeholder = @"请输入备注";
		[self.view addSubview:alertDateView];
	} else if (sender.tag == 301) {
		//新增潜客
        
		isAddNew = YES;
		DBSelf(weakSelf);
		AddOrEditlCustomerViewController *addVC = [[AddOrEditlCustomerViewController alloc]init];
		addVC.Type = customerTypeExhibition;
		addVC.delegate = self;
        addVC.vcName = @"门店";
		addVC.exhibitionMarketAction = self.detailModel.C_A41200_C_NAME;
		addVC.exhibitionMarketActionID = self.detailModel.C_A41200_C_ID;
		addVC.exhibitionSourceAction = self.detailModel.C_SOURCE_DD_NAME;
		addVC.exhibitionSourceActionID = self.detailModel.C_SOURCE_DD_ID;
		addVC.exhibitionC_A41400_C_ID = self.detailModel.C_ID;
		addVC.exhibitionRemark = self.detailModel.X_REMARK;
        if (self.detailModel.headpic_content.count > 0) {
            addVC.portraitAddress =self.detailModel.headpic_content[0][@"C_HEADPIC"];
        }
        
//		[addVC setCompleteComitBlock:^(NSString *C_A41500_C_ID){
//			[weakSelf HTTPCustomConnect:weakSelf.detailModel.C_ID andType:@"1" andC_A41500_C_ID:C_A41500_C_ID];
//		}];
		addVC.superVC = self.superVC;
		[weakSelf.navigationController pushViewController:addVC animated:YES];
	} else if (sender.tag == 302) {
		
		//老客户
		isAddNew = NO;
		DBSelf(weakSelf);
        MJKCustomerChooseViewController *customListVC = [[MJKCustomerChooseViewController alloc]init];
		customListVC.rootVC = self;
		customListVC.chooseCustomerBlock = ^(CGCCustomModel *model) {
			[weakSelf HTTPCustomConnect:self.detailModel.C_ID andType:@"3" andC_A41500_C_ID:model.C_A41500_C_ID];
		};
		[self.navigationController pushViewController:customListVC animated:YES];
		
        
        
		
    } else if (sender.tag == 303) {
        //老客户预约
        
        MJKShopArriveViewController *arrVC = [[MJKShopArriveViewController alloc]initWithNibName:@"MJKShopArriveViewController" bundle:nil];
        DBSelf(weakSelf);
        arrVC.backC_ID = ^(NSString *C_ID) {
            [weakSelf HTTPCustomConnect:self.detailModel.C_ID andType:@"6" andC_A41500_C_ID:C_ID];
            
        };
        [self.navigationController pushViewController:arrVC animated:YES];
        
        
        
    } else {
		//重新指派
		MJKMarketViewController *marketVC = [[MJKMarketViewController alloc]init];
		marketVC.vcName = @"全部员工";
//		marketVC.clueListModel = self.clueListModel;
		marketVC.C_ID = self.detailModel.C_ID;
		marketVC.rootViewController = self;
		[self.navigationController pushViewController:marketVC animated:YES];
	}
}

//点击右上角
- (void)clickTopButton:(UIButton *)sender {
	MJKHistoryFlowViewController *historyVC = [[MJKHistoryFlowViewController alloc]init];
	historyVC.VCName = @"流量";
	historyVC.C_A41500_C_ID = self.detailModel.C_ID;
	[self.navigationController pushViewController:historyVC animated:YES];
}

#pragma mark  --delegate
-(void)DelegateForCompleteAddCustomerShowAlertVCToFollow:(CustomerDetailInfoModel *)newModel{
	DBSelf(weakSelf);
	[self HTTPCustomConnect:self.detailModel.C_ID andType:@"1" andC_A41500_C_ID:newModel.C_A41500_C_ID];
	UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否为新客户添加跟进" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		for (UIViewController *controller in weakSelf.navigationController.viewControllers) {
			if ([controller isKindOfClass:[MJKFlowListViewController class]]) {
				[[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"isBack"];
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
            vc.vcSuper=self.superVC;
            vc.followText=nil;
            [self.navigationController pushViewController:vc animated:YES];
        }];
		
		
	}];
	[alertVC addAction:cancel];
	[alertVC addAction:sure];
	[self presentViewController:alertVC animated:YES completion:nil];
	
	
}

#pragma mark - HTTP request
- (void)HTTPGetDetailFlowDatas {
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a414/info", HTTP_IP] parameters:@{@"C_ID" : self.C_ID} compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.detailModel = [MJKFlowDetailModel yy_modelWithDictionary:data[@"data"]];
			if ([weakSelf.detailModel.C_STATUS_DD_ID isEqualToString:@"A41400_C_STATUS_0001"]) {
				[weakSelf initUI];
			} else if ([weakSelf.detailModel.C_STATUS_DD_ID isEqualToString:@"A41400_C_STATUS_0002"]) {
				[weakSelf.view addSubview:weakSelf.tableview];
			} else {
				[weakSelf.view addSubview:weakSelf.tableview];
			}
			if ([weakSelf.detailModel.C_STATUS_DD_NAME isEqualToString:@"未留档"] || [weakSelf.detailModel.C_STATUS_DD_NAME isEqualToString:@"已关联"] || [weakSelf.detailModel.C_STATUS_DD_NAME isEqualToString:@"已新增"]) {
				weakSelf.title = @"流量详情";
			}
//			[weakSelf.tableview reloadData];
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}

- (void)HTTPCustomConnectDic:(NSDictionary *)dic {
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a414/operation", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        DBSelf(weakSelf);
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if (isAddNew == YES) {
                
            } else {
                for (UIViewController *controller in weakSelf.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[MJKFlowListViewController class]]) {
                        [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"isBack"];
                        [weakSelf.navigationController popToViewController:controller animated:YES];
                    }
                }
            }
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)HTTPCustomConnect:(NSString *)C_ID andType:(NSString *)type andC_A41500_C_ID:(NSString *)C_A41500_C_ID {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"C_ID"] = C_ID;
    dic[@"TYPE"] = type;
    dic[@"USER_ID"] = [NewUserSession instance].user.u051Id;
    if ([type isEqualToString:@"6"]) {
        dic[@"C_A41600_C_ID"] = C_A41500_C_ID;
    } else {
        dic[@"C_A41500_C_ID"] = C_A41500_C_ID;
    }
    
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a414/operation", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
		DBSelf(weakSelf);
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			if (isAddNew == YES) {
				
			} else {
				for (UIViewController *controller in weakSelf.navigationController.viewControllers) {
					if ([controller isKindOfClass:[MJKFlowListViewController class]]) {
						[[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"isBack"];
						[weakSelf.navigationController popToViewController:controller animated:YES];
					}
				}
			}
			
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}

#pragma mark - set
- (UITableView *)tableview {
	if (!_tableview) {
		_tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
		_tableview.dataSource = self;
		_tableview.delegate = self;
		_tableview.bounces = NO;
		_tableview.estimatedSectionFooterHeight = 0;
		_tableview.estimatedSectionHeaderHeight = 0;
	}
	return _tableview;
}


@end
