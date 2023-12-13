//
//  MJKShowOrderPlanViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/25.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKShowOrderPlanViewController.h"

#import "CGCNewAppointTextCell.h"

#import "MJKShowOrderPlanModel.h"

#import "CGCOrderDetialFooter.h"

#import "KSPhotoItem.h"
#import "KSPhotoBrowser.h"
#import "MJKPhotoView.h"

@interface MJKShowOrderPlanViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** MJKShowOrderPlanModel*/
@property (nonatomic, strong) MJKShowOrderPlanModel *planModel;
/** CGCOrderDetialFooter*/
@property (nonatomic, strong) CGCOrderDetialFooter *tableFoot;
/** (MJKPhotoView *)tableFootPhoto*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;

@end

@implementation MJKShowOrderPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self initUI];
}

- (void)initUI {
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	self.title = @"查看";
	[self.view addSubview:self.tableView];
	[self httpGetOrderTrajectoryData];
}

//MARK:-UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		if (indexPath.row == 2) {
			CGCNewAppointTextCell *cell = [CGCNewAppointTextCell cellWithTableView:tableView];
			cell.topTitleLabel.text = @"备注";
			cell.topTitleLabel.font = [UIFont systemFontOfSize:14.f];
			cell.textView.editable = NO;
			cell.textView.text = self.planModel.X_PLANNEDREMARK;
			return cell;
		} else {
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
			if (!cell) {
				cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
			}
			cell.textLabel.font = [UIFont systemFontOfSize:14.f];
			cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
			if (indexPath.row == 0) {
				cell.textLabel.text = @"计划完成时间";
				cell.detailTextLabel.text = self.planModel.D_PLANNED_TIME;
			} else if (indexPath.row == 1) {
				cell.textLabel.text = @"负责人";
				cell.detailTextLabel.text = self.planModel.C_RESPONSIBLE_ROLENAME;
			}
			
			return cell;
		}
	} else {
		if (indexPath.row == 2) {
			CGCNewAppointTextCell *cell = [CGCNewAppointTextCell cellWithTableView:tableView];
			cell.topTitleLabel.text = @"备注";
			cell.topTitleLabel.font = [UIFont systemFontOfSize:14.f];
			cell.textView.editable = NO;
			cell.textView.text = self.planModel.X_REMARK;
			return cell;
		} else {
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"completeCell"];
			if (!cell) {
				cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"completeCell"];
			}
			cell.textLabel.font = [UIFont systemFontOfSize:14.f];
			cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
			if (indexPath.row == 0) {
				cell.textLabel.text = @"实际完成时间";
				cell.detailTextLabel.text = self.planModel.D_ACTUAL_TIME;
			} else if (indexPath.row == 1) {
				cell.textLabel.text = @"完成人";
				cell.detailTextLabel.text = self.planModel.C_COMPLETE_ROLENAME;
			}
			
			return cell;
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 2) {
		return 120;
	} else {
		return 44;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
	bgView.backgroundColor = kBackgroundColor;
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 30)];
	if (section == 0) {
		label.text = @"计划信息";
	} else {
		label.text = @"完成信息";
	}
	label.textColor = [UIColor darkGrayColor];
	label.font = [UIFont systemFontOfSize:14.f];
	[bgView addSubview:label];
	return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	if (section == 0) {
		return nil;
	} else {
		return self.tableFootPhoto;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section == 0) {
		return .1;
	} else {
		return 150;
	}
}

//MARK:-http
- (void)httpGetOrderTrajectoryData {
	DBSelf(weakSelf);
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47300WebService-getBeanById"];
	
	NSMutableDictionary *dic=[NSMutableDictionary new];
	dic[@"C_ID"] = self.c_id;
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		if ([data[@"code"] integerValue]==200) {
			weakSelf.planModel = [MJKShowOrderPlanModel mj_objectWithKeyValues:data];
			
			weakSelf.tableFootPhoto.imageURLArray = weakSelf.planModel.urlList;
			
//			if (self.planModel.urlList.count == 1) {
//				weakSelf.tableFoot.firstImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.planModel.urlList[0]]]] ;
//			}
//			if (self.planModel.urlList.count == 2) {
//					weakSelf.tableFoot.firstImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.planModel.urlList[0]]]] ;
//					weakSelf.tableFoot.secondImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.planModel.urlList[1]]]] ;
//				}
//			if (self.planModel.urlList.count == 3) {
//				weakSelf.tableFoot.firstImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.planModel.urlList[0]]]] ;
//				weakSelf.tableFoot.secondImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.planModel.urlList[1]]]] ;
//				weakSelf.tableFoot.thirdImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.planModel.urlList[2]]]] ;
//			}
			
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (MJKPhotoView *)tableFootPhoto {
	DBSelf(weakSelf);
	if (!_tableFootPhoto) {
		_tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
		_tableFootPhoto.isEdit = NO;
		_tableFootPhoto.rootVC = self;
//		_tableFootPhoto.backUrlArray = ^(NSArray *arr) {
//			weakSelf.urlList = arr;
//		};
	}
	return _tableFootPhoto;
}

- (CGCOrderDetialFooter *)tableFoot{
	
	if (_tableFoot==nil) {
		
		_tableFoot=[[[NSBundle mainBundle] loadNibNamed:@"CGCOrderDetialFooter" owner:self options:0] lastObject];
		_tableFoot.isDetail = YES;
		
		DBSelf(weakSelf);
		_tableFoot.clickFirstBlock = ^(UIImage *image) {
			if (image) {
				
				[weakSelf showBigImage:image withBtn:weakSelf.tableFoot.firstPicBtn];
				return ;
			}
//			[weakSelf picBtnClick:weakSelf.tableFoot.firstPicBtn];
			
		};
		_tableFoot.clickSecondBlock = ^(UIImage *image) {
			if (image) {
				
				[weakSelf showBigImage:image withBtn:weakSelf.tableFoot.secondPicBtn];
				return ;
			}
//			[weakSelf picBtnClick:weakSelf.tableFoot.secondPicBtn];
		};
		_tableFoot.clickThirdBlock = ^(UIImage *image) {
			if (image) {
				
				[weakSelf showBigImage:image withBtn:weakSelf.tableFoot.thirdPicBtn];
				return ;
			}
//			[weakSelf picBtnClick:weakSelf.tableFoot.thirdPicBtn];
		};
		
		
		
		
		
	}
	return _tableFoot;
}

- (void)showBigImage:(UIImage *)image withBtn:(UIButton *)btn{
	
	KSPhotoItem * item=[KSPhotoItem itemWithSourceView:btn.imageView image:image];
	KSPhotoBrowser * browser=[KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
	
	
	[browser showFromViewController:self];
}

//MARK:-set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - WD_TabBarHeight - SafeAreaBottomHeight) style:UITableViewStyleGrouped];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
	}
	return _tableView;
}

@end
