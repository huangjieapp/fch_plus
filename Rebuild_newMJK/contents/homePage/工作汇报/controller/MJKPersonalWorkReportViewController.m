//
//  MJKPersonalWorkReportViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/5.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKPersonalWorkReportViewController.h"
#import "MJKAddWorkReporeViewController.h"
#import "MJKCommentsViewController.h"

#import "MJKWorkReportDetailModel.h"
#import "MJKWorkReportDetailSubModel.h"
#import "MJKVacationModel.h"
#import "MJKVacationContentModel.h"

#import "MJKYesterdayWorkReportCell.h"
#import "MJKTodayWorkReportCell.h"
#import "CGCOrderDetialFooter.h"
#import "MJKPhotoView.h"
#import "MJKWorkReportEmployeeView.h"
#import "MJKWorkReportRemarkCell.h"

#import "KSPhotoItem.h"
#import "KSPhotoBrowser.h"

@interface MJKPersonalWorkReportViewController ()<UITableViewDataSource, UITableViewDelegate>
/** model*/
@property (nonatomic, strong) MJKWorkReportListModel *dataModel;
/** 明细*/
@property (nonatomic, strong) NSString *detailStr;
/** 选择哪一行*/
@property (nonatomic, assign) NSInteger selectRow;
/** 图片*/
@property (nonatomic, strong) CGCOrderDetialFooter *footerImageView;
/** 日历*/
@property (nonatomic, strong) MJKWorkReportEmployeeView *employeeView;
/** 无汇报是的view*/
@property (nonatomic, strong) UIView *noDataView;
/** 选择的时间*/
@property (nonatomic, strong) NSString *selectDateStr;
/** <#备注#>*/
@property (nonatomic, strong) NSString *monthDateStr;
/** (MJKPhotoView *)tableFootPhoto*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;

/** MJKWorkReportDetailSubModel *contents*/
@property (nonatomic, strong) MJKWorkReportDetailSubModel *contents;

@end

@implementation MJKPersonalWorkReportViewController
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self getOwnerReportList:self.selectDateStr.length > 0 ? self.selectDateStr : self.createTime];
}


-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	
}




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
	self.title = @"工作汇报";
	self.view.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.tableView];
	//第一次进入时确定本月有几天是有汇报的
	[self httpWorkReportIsRecordWithDate:self.createTime];
	[self httpDetailVacation];
	//	[self noDataViewLabel];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataModel.C_ID.length > 0) {
        return 3;
    }
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
    } else if (section == 2) {
        if (self.dataModel.content.count > 0) {
            if (self.dataModel.X_MRPLAN.length > 0) {
                return self.dataModel.content.count+1;
            } else {
                return self.dataModel.content.count;
            }
        } else {
            return 1;
        }
    } else {
		
		if (self.dataModel.content.count > 0) {
			if (self.dataModel.X_REMARK.length > 0) {
				return self.dataModel.content.count+1;
			} else {
				return self.dataModel.content.count;
			}
		} else {
			return 1;
		}
		
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	//	DBSelf(weakSelf);
	if (indexPath.section == 0 && indexPath.row == 0) {
		MJKYesterdayWorkReportCell *cell = [MJKYesterdayWorkReportCell cellWithTableView:tableView];
        if (self.dataModel.C_ID.length <= 0) {
            cell.noReportView.hidden = NO;
        } else {
            cell.noReportView.hidden = YES;
        }
		cell.yesterdayWorkLabel.text = self.dataModel.X_ZRPLAN;
		return cell;
	} else if (indexPath.section == 1) {
		if (indexPath.row == self.dataModel.content.count) {
			MJKWorkReportRemarkCell *cell = [MJKWorkReportRemarkCell cellWithTableView:tableView];
			//			cell.remarkLabel.text = [NSString stringWithFormat:@"备注:%@",self.listModel.X_REMARK];
			CGSize mrSize = [[NSString stringWithFormat:@"今日备注:\n%@",self.dataModel.X_REMARK] boundingRectWithSize:CGSizeMake(KScreenWidth - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
			UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, mrSize.width, mrSize.height + 5)];
			label.textColor = [UIColor blackColor];
			label.text = [NSString stringWithFormat:@"今日备注:\n%@",self.dataModel.X_REMARK] ;
			label.font = [UIFont systemFontOfSize:14.f];
			label.numberOfLines = 0;
			//			label.backgroundColor = [UIColor redColor];
			if (self.dataModel.X_REMARK.length > 0) {
				[cell.contentView addSubview:label];
			} else {
				[label removeFromSuperview];
			}
			
			return cell;
		}
		MJKTodayWorkReportCell *cell = [MJKTodayWorkReportCell cellWithTableView:tableView];
		if (self.dataModel.content.count > 0) {
			MJKWorkReportDetailModel *subModel = self.dataModel.content[indexPath.row];
			cell.model = subModel;
		} else {
			cell.todayWorkLabel.text = @"";
		}
		if (indexPath.row == self.selectRow) {
			CGSize size = [self.detailStr boundingRectWithSize:CGSizeMake(KScreenWidth - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size;
			UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(cell.todayWorkLabel.frame) + 5, KScreenWidth - 20, size.height)];
			label.textColor = [UIColor darkGrayColor];
			label.text = self.detailStr;
			label.font = [UIFont systemFontOfSize:12.f];
			label.numberOfLines = 0;
			if (self.detailStr.length > 0) {
				[cell.contentView addSubview:label];
			} else {
				[label removeFromSuperview];
			}
		}
		return cell;
		
    } else{
        if (indexPath.row == self.dataModel.content.count) {
            MJKWorkReportRemarkCell *cell = [MJKWorkReportRemarkCell cellWithTableView:tableView];
            //            cell.remarkLabel.text = [NSString stringWithFormat:@"备注:%@",self.listModel.X_REMARK];
            CGSize mrSize = [[NSString stringWithFormat:@"计划备注:\n%@",self.dataModel.X_MRPLAN] boundingRectWithSize:CGSizeMake(KScreenWidth - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, mrSize.width, mrSize.height + 5)];
            label.textColor = [UIColor blackColor];
            label.text = [NSString stringWithFormat:@"计划备注:\n%@",self.dataModel.X_MRPLAN] ;
            label.font = [UIFont systemFontOfSize:14.f];
            label.numberOfLines = 0;
            //            label.backgroundColor = [UIColor redColor];
            if (self.dataModel.X_REMARK.length > 0) {
                [cell.contentView addSubview:label];
            } else {
                [label removeFromSuperview];
            }
            
            return cell;
        }
        MJKTodayWorkReportCell *cell = [MJKTodayWorkReportCell cellWithTableView:tableView];
        if (self.dataModel.content.count > 0) {
            MJKWorkReportDetailModel *subModel = self.dataModel.content[indexPath.row];
//            cell.model = subModel;
            cell.monthLabel.hidden = cell.completeLabel.hidden = NO;
            cell.todayWorkLabel.text = subModel.C_TYPE_DD_NAME;
            cell.monthLabel.text = [NSString stringWithFormat:@"%@%@",subModel.I_TARGETNUMBER,subModel.UNIT];
            cell.completeLabel.text = [NSString stringWithFormat:@"%@%@",subModel.B_TOTAL_BY,subModel.UNIT];
            cell.countLabel.text = [NSString stringWithFormat:@"%@%@",subModel.B_TOTAL_JH_MR,subModel.UNIT];
        } else {
            cell.todayWorkLabel.text = @"";
        }
//        if (indexPath.row == self.selectRow) {
//            CGSize size = [self.detailStr boundingRectWithSize:CGSizeMake(KScreenWidth - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size;
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(cell.todayWorkLabel.frame) + 5, KScreenWidth - 20, size.height)];
//            label.textColor = [UIColor darkGrayColor];
//            label.text = self.detailStr;
//            label.font = [UIFont systemFontOfSize:12.f];
//            label.numberOfLines = 0;
//            if (self.detailStr.length > 0) {
//                [cell.contentView addSubview:label];
//            } else {
//                [label removeFromSuperview];
//            }
//        }
        return cell;
        
    }
    /*{
		//明日计划
		if (self.dataModel.X_MRPLANDETAILED.length > 0) {
			//			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mrcell"];
			//			if (!cell) {
			//				cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"mrcell"];
			//			}
			//			cell.textLabel.numberOfLines = 0;
			//			cell.textLabel.font = [UIFont systemFontOfSize:12.f];
			//			cell.textLabel.text = [NSString stringWithFormat:@"%@\n备注:\n%@",self.dataModel.X_MRPLANDETAILED > 0 ? self.dataModel.X_MRPLANDETAILED : @"", self.dataModel.X_MRPLAN > 0 ? self.dataModel.X_REMARK : @""];
			//			return cell;
			
			MJKYesterdayWorkReportCell *cell = [MJKYesterdayWorkReportCell cellWithTableView:tableView];
			cell.yesterdayWorkLabel.text =  [NSString stringWithFormat:@"%@\n计划备注:\n%@",self.dataModel.X_MRPLANDETAILED > 0 ? self.dataModel.X_MRPLANDETAILED : @"", self.dataModel.X_MRPLAN > 0 ? self.dataModel.X_MRPLAN : @""];
			return cell;
		} else {
			MJKYesterdayWorkReportCell *cell = [MJKYesterdayWorkReportCell cellWithTableView:tableView];
			cell.yesterdayWorkLabel.text =  [NSString stringWithFormat:@"计划备注:\n%@",self.dataModel.X_MRPLAN> 0 ? self.dataModel.X_MRPLAN : @""];
			return cell;
		}
		
	}*/
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
		if (indexPath.row == self.dataModel.content.count) {
			return;
		}
		//detailModel.isSelected == yes是选中状态
		//如果点击的不是当前cell,则上一行取消点击状态
		if (indexPath.row != self.selectRow) {
			MJKWorkReportDetailModel *detailModel = self.dataModel.content[self.selectRow];
			detailModel.selected = NO;
		}
		self.selectRow = indexPath.row;
		MJKWorkReportDetailModel *detailModel = self.dataModel.content[indexPath.row];
		
		//选中展开
		detailModel.selected = !detailModel.isSelected;
		if (detailModel.isSelected == YES) {
			[self httpWorkReportDetailWithC_TYPE_DD_ID:detailModel.C_TYPE_DD_ID andX_OBJECTIDS:detailModel.X_OBJECTIDS];
			
		} else {
			self.dataModel.selected = NO;
			self.detailStr = @"";
			[self.tableView reloadData];
		}
		
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	DBSelf(weakSelf);
	if (section == 0) {
		if (self.employeeView) {
			self.employeeView.model = self.dataModel;
			//			self.employeeView.dateBlock = ^(NSString *dateStr) {
			//				[weakSelf httpWorkReportIsRecordWithDate:dateStr];
			//			};
			return self.employeeView;
		}
		MJKWorkReportEmployeeView *employeeView = [[NSBundle mainBundle]loadNibNamed:@"MJKWorkReportEmployeeView" owner:nil options:nil].lastObject;
		self.employeeView = employeeView;
        employeeView.vcName = @"个人动态日报";
		
		employeeView.createTime = self.createTime;
		employeeView.dateBlock = ^(NSString *dateStr) {
			//已有汇报接口
			weakSelf.monthDateStr = dateStr;
			[weakSelf httpWorkReportIsRecordWithDate:dateStr];
			[weakSelf httpDetailVacation];
            [weakSelf getOwnerReportList:dateStr];
		};
		employeeView.didSelectDateBlock = ^(NSString *dateStr) {
			//选择的时间请求新数据
			weakSelf.selectDateStr = dateStr;
			[weakSelf getOwnerReportList:dateStr];
		};
		//编辑
		employeeView.editBlock = ^{
			MJKAddWorkReporeViewController *vc = [[MJKAddWorkReporeViewController alloc]init];
			vc.editStr = @"编辑";
			vc.createTime = self.selectDateStr.length > 0 ? self.selectDateStr : self.createTime;
			vc.USERID = self.USERID;
			[weakSelf.navigationController pushViewController:vc animated:YES];
		};
		
		return employeeView;
	} else {
		UIView *bgView = [[UIView alloc]initWithFrame:tableView.tableHeaderView.frame];
		bgView.backgroundColor = kBackgroundColor;
		
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 20)];
		label.textColor = [UIColor blackColor];
		label.font = [UIFont systemFontOfSize:14.f];
		label.text = @[@"今日完成",@"明日计划"][section - 1];
		[bgView addSubview:label];
        if (section == 1) {
            UILabel *jhLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth - 80, 0, 80, 20)];
            jhLabel.textColor = [UIColor blackColor];
            jhLabel.font = [UIFont systemFontOfSize:14.f];
            jhLabel.text = @"计划完成";
            [bgView addSubview:jhLabel];
            
        } else {
            for (int i = 0; i < 3; i++) {
                UILabel *jhLabel = [[UILabel alloc]initWithFrame:CGRectMake((i * ((KScreenWidth - 120) / 3)) + 120, 0, (KScreenWidth - 120) / 3, 20)];
                jhLabel.textColor = [UIColor blackColor];
                jhLabel.font = [UIFont systemFontOfSize:14.f];
                jhLabel.textAlignment = NSTextAlignmentCenter;
                jhLabel.text = @[@"月目标",@"已完成",@"计划"][i];
                [bgView addSubview:jhLabel];
            }
        }
		return bgView;
	}
	
	
	
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	DBSelf(weakSelf);
	if (section==2) {
		UIView *bgView = [[UIView alloc]initWithFrame:self.tableView.tableFooterView.frame];
		UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.dataModel.urlList.count > 0 ? 150 : 0)];
		self.tableFootPhoto.imageURLArray = self.dataModel.urlList;
		/*CGCOrderDetialFooter*footer=[[NSBundle mainBundle]loadNibNamed:@"CGCOrderDetialFooter" owner:nil options:nil].firstObject;
		 footer.titleNameLab.textColor = [UIColor blackColor];
		 footer.isWork = YES;//汇报
		 footer.beforeImageArray=self.dataModel.urlList;
		 footer.frame=CGRectMake(0, 0, KScreenWidth, 150);
		 self.footerImageView=footer;
		 footer.deleteOneButton.hidden = footer.deleteSecondButton.hidden = footer.deleteThirdButton.hidden = YES;
		 footer.clickFirstBlock = ^(UIImage*image){
		 if (image) {
		 //有图片那就放大
		 MyLog(@"放大");
		 
		 KSPhotoItem *item = [KSPhotoItem itemWithSourceView:weakSelf.footerImageView.firstPicBtn.imageView image:image];
		 KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
		 //                browser.delegate = self;
		 //                browser.dismissalStyle = _dismissalStyle;
		 //                browser.backgroundStyle = _backgroundStyle;
		 //                browser.loadingStyle = _loadingStyle;
		 //                browser.pageindicatorStyle = _pageindicatorStyle;
		 //                browser.bounces = _bounces;
		 [browser showFromViewController:weakSelf];
		 
		 
		 
		 
		 }
		 
		 };
		 
		 footer.clickSecondBlock = ^(UIImage*image){
		 if (image) {
		 //有图片那就放大
		 MyLog(@"放大");
		 KSPhotoItem *item = [KSPhotoItem itemWithSourceView:weakSelf.footerImageView.secondPicBtn.imageView image:image];
		 KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
		 [browser showFromViewController:weakSelf];
		 
		 
		 }
		 };
		 
		 footer.clickThirdBlock = ^(UIImage*image){
		 if (image) {
		 //有图片那就放大
		 MyLog(@"放大");
		 KSPhotoItem *item = [KSPhotoItem itemWithSourceView:weakSelf.footerImageView.thirdPicBtn.imageView image:image];
		 KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
		 [browser showFromViewController:weakSelf];
		 
		 
		 }
		 
		 };*/
		[footView addSubview:self.tableFootPhoto];
		
		UIView *praiseView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(footView.frame), KScreenWidth, 50)];
		praiseView.backgroundColor = [UIColor whiteColor];
		NSInteger marginX0 = (((praiseView.frame.size.width / 2) - 25) / 2) - 10;
		NSInteger marginX1 = (praiseView.frame.size.width / 2) + (((praiseView.frame.size.width / 2) - 25) / 2) - 10;
		for (int i = 0; i < 2; i++) {
			UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i == 0 ? marginX0 : marginX1, (praiseView.frame.size.height - 25) / 2, 25, 25)];
			imageView.image = [UIImage imageNamed:@[@"评论", [self.dataModel.fabulous_flag boolValue] ? @"点赞图标-黄色" : @"点赞图标"][i]];
			UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, 100, 50)];
			label.textAlignment = NSTextAlignmentLeft;
			label.font = [UIFont systemFontOfSize:14.f];
			label.text = @[self.dataModel.comments.length > 0 ? self.dataModel.comments : @"0", self.dataModel.fabulous.length > 0 ? self.dataModel.fabulous : @"0"][i];
			UIButton *praiseButton = [[UIButton alloc]initWithFrame:CGRectMake(i * (KScreenWidth / 2), 0, KScreenWidth / 2, praiseView.frame.size.height)];
			//			[praiseButton setImage:[UIImage imageNamed:@[@"评论", [self.listModel.fabulous_flag boolValue] ? @"点赞图标-黄色" : @"点赞图标"][i]] forState:UIControlStateNormal];
			//			[praiseButton setTitleNormal:@[self.listModel.comments, self.listModel.fabulous][i] forState:UIControlStateNormal];
			//			[praiseButton setTitleColor:@[[UIColor blackColor], [self.listModel.fabulous_flag boolValue] ? KNaviColor : [UIColor blackColor]][i] forState:UIControlStateNormal];
			//			praiseButton.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 15, 25);
			//			praiseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 5, 0);
			[praiseButton addTarget:self action:@selector(praiseCommentsAction:)];
			praiseButton.tag = i + 100;
			[praiseView addSubview:imageView];
			[praiseView addSubview:label];
			[praiseView addSubview:praiseButton];
		}
		
		
		if (self.dataModel.urlList.count > 0) {
			[bgView addSubview:footView];
		}
		if (self.dataModel.C_ID.length > 0) {
			[bgView addSubview:praiseView];
		}
		return bgView;
	}else{
		return nil;
	}
}

- (MJKPhotoView *)tableFootPhoto {
	DBSelf(weakSelf);
	if (!_tableFootPhoto) {
		_tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
		_tableFootPhoto.isEdit = NO;
		_tableFootPhoto.isCamera = NO;
		_tableFootPhoto.rootVC = self;
		//		_tableFootPhoto.backUrlArray = ^(NSArray *arr) {
		//			weakSelf.urlList = arr;
		//		};
	}
	return _tableFootPhoto;
}

#pragma 点在评论按钮
- (void)praiseCommentsAction:(UIButton *)sender {
	if (sender.tag - 100 == 0) {
		NSLog(@"评论");
		MJKCommentsViewController *vc = [[MJKCommentsViewController alloc]init];
		vc.C_OBJECTID = self.dataModel.C_ID;
		vc.typeStr = @"评论";
		[self.navigationController pushViewController:vc animated:YES];
	} else {
		NSLog(@"点赞");
		self.view.userInteractionEnabled = NO;
		if ([self.dataModel.fabulous_flag boolValue] == YES) {
			[self httpCancelPraiseAction:self.dataModel.C_ID];
		} else {
			[self httpPraiseAction:self.dataModel.C_ID];
		}
	}
}

#pragma mark 点赞
- (void)httpPraiseAction:(NSString *)C_OBJECT_ID {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A46500WebService-insertFabulous"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"C_OBJECT_ID"] = C_OBJECT_ID;
	dic[@"C_ID"] = [DBObjectTools getWorkReportA61200];
	[dict setObject:dic forKey:@"content"];
	DBSelf(weakSelf);
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf getOwnerReportList:self.selectDateStr.length > 0 ? self.selectDateStr : self.createTime];
			[JRToast showWithText:@"点赞成功"];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		weakSelf.view.userInteractionEnabled = YES;
		
		//		[weakSelf.tableView.mj_header endRefreshing];
		//		[seweakSelflf.tableView.mj_footer endRefreshing];
	}];
}

#pragma mark 取消点赞
- (void)httpCancelPraiseAction:(NSString *)C_OBJECT_ID {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A46500WebService-deleteFabulous"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"C_OBJECT_ID"] = C_OBJECT_ID;
	[dict setObject:dic forKey:@"content"];
	DBSelf(weakSelf);
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf getOwnerReportList:self.selectDateStr.length > 0 ? self.selectDateStr : self.createTime];
			
			[JRToast showWithText:@"点赞取消"];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		weakSelf.view.userInteractionEnabled = YES;
		//		[weakSelf.tableView.mj_header endRefreshing];
		//		[weakSelf.tableView.mj_footer endRefreshing];
	}];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		CGSize zrSize = [self.dataModel.X_ZRPLAN boundingRectWithSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
		if (zrSize.height + 22 > 44) {
			return zrSize.height + 22;
		}
	}
	if (indexPath.section == 1) {
		if (indexPath.row == self.dataModel.content.count) {
			CGSize mrSize = [self.dataModel.X_REMARK boundingRectWithSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
			if (mrSize.height + 22 > 30) {
				return mrSize.height + 30;
			} else {
				return 30;
			}
		} else {
			if (indexPath.row == self.selectRow) {
				if (self.detailStr.length > 0) {
					CGSize size = [self.detailStr boundingRectWithSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size;
					if (size.height + 30 > 30) {
						return 30 + size.height;
					}
				}
			}
			return 30;
		}
		
	}
	if (indexPath.section == 2) {
        if (indexPath.row == self.dataModel.content.count) {
            CGSize mrSize = [self.dataModel.X_MRPLAN boundingRectWithSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
            if (mrSize.height + 22 > 30) {
                return mrSize.height + 30;
            } else {
                return 30;
            }
        } else {
            return 30;
        }
		
	}
	return 44;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return 340 ;
	}
	return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section == 2) {
		if (self.dataModel.urlList.count > 0) {
			return 194;
		} else {
			return 44;
		}
		return .1;
	}
	return .1f;
}

- (void)noDataViewLabel {
	UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 320 + NavStatusHeight, KScreenWidth, KScreenHeight - 320 - NavStatusHeight)];
	view.backgroundColor = [UIColor whiteColor];
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
	label.text = @"暂无日报";
	label.textColor = [UIColor darkGrayColor];
	label.font = [UIFont systemFontOfSize:14.f];
	label.textAlignment = NSTextAlignmentCenter;
	[view addSubview:label];
	[self.view addSubview:view];
	self.noDataView = view;
}

#pragma mark - get owner report list
- (void)getOwnerReportList:(NSString *)createTime {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A48600WebService-getPersonalReportList"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"DATE"] = [createTime substringToIndex:10];
	dic[@"USERID"] = self.USERID;
	[dict setObject:dic forKey:@"content"];
	DBSelf(weakSelf);
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.dataModel = [MJKWorkReportListModel mj_objectWithKeyValues:data];
            if (weakSelf.dataModel.C_ID.length <= 0) {
                weakSelf.dataModel.C_HEADIMGURL = weakSelf.headImage;
                weakSelf.dataModel.USERNAME = weakSelf.userName;

            }
//            weakSelf.dataModel.C_HEADIMGURL = weakSelf.listModel.C_HEADIMGURL;
//            weakSelf.dataModel.USERNAME = weakSelf.listModel.USERNAME;
//            weakSelf.dataModel.USERID = weakSelf.listModel.USERID;
            
			//			if (weakSelf.dataModel.C_ID.length > 0) {
			//				weakSelf.noDataView.hidden = YES;
			//			} else {
			//				weakSelf.noDataView.hidden = NO;
			//			}
			
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
		[weakSelf.tableView.mj_header endRefreshing];
		[weakSelf.tableView.mj_footer endRefreshing];
	}];
}

//MARK: 休假详情
- (void)httpDetailVacation{
	NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:@"A48800WebService-monthDetail"];
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	//	self.selectDateStr.length > 0 ? self.selectDateStr : self.createTime
	
	contentDict[@"DATE"] = [self.monthDateStr.length > 0 ? self.monthDateStr : self.createTime substringToIndex:7];
	contentDict[@"C_U03100_C_ID"] = self.USERID;
	contentDict[@"TYPE"] = @"1";
	contentDict[@"C_STATUS_DD_ID"] = @"A48800_C_STATUS_0005";
	
	
	DBSelf(weakSelf);
	[mtDict setObject:contentDict forKey:@"content"];
	NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			MJKVacationModel *vModel = [MJKVacationModel mj_objectWithKeyValues:data];
			NSMutableArray *arr = [NSMutableArray array];
			for (MJKVacationContentModel *subModel in vModel.content) {
				[arr addObject:subModel.DAYNUMBER];
			}
			weakSelf.employeeView.vcName = @"个人工作汇报";
			weakSelf.employeeView.vacationArr = arr;
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
	}];
}

#pragma mark workReport detail
- (void)httpWorkReportDetailWithC_TYPE_DD_ID:(NSString *)C_TYPE_DD_ID andX_OBJECTIDS:(NSString *)X_OBJECTIDS{
	self.view.userInteractionEnabled = NO;
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A48600WebService-getObjectList"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"C_TYPE_DD_ID"] = C_TYPE_DD_ID;
	dic[@"X_OBJECTIDS"] = X_OBJECTIDS;
//    dic[@"C_ID"] = self.listModel.C_ID;
    dic[@"C_ID"] = self.dataModel.C_ID;
	[dict setObject:dic forKey:@"content"];
	DBSelf(weakSelf);
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			MJKWorkReportDetailSubModel *contents = [MJKWorkReportDetailSubModel mj_objectWithKeyValues:data];
			NSMutableArray *array = [NSMutableArray array];
			for (NSDictionary *dic in contents.content) {
				[array addObject:dic[@"X_REMARK"]];
			}
			weakSelf.detailStr = [array componentsJoinedByString:@"\n"];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		weakSelf.view.userInteractionEnabled = YES;
	}];
}

#pragma get isRecord
- (void)httpWorkReportIsRecordWithDate:(NSString *)dateStr {
	NSString *yearStr;
	NSString *monthStr;
	if (dateStr.length > 0) {
		yearStr = [dateStr substringToIndex:4];
		monthStr = [dateStr substringWithRange:NSMakeRange(5, 2)];
	}
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A48600WebService-isRecord"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"USERID"] = self.USERID;
	dic[@"YEAR"] = yearStr;
	dic[@"MONTH"] = monthStr;
	[dict setObject:dic forKey:@"content"];
	DBSelf(weakSelf);
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.contents = [MJKWorkReportDetailSubModel mj_objectWithKeyValues:data];
			weakSelf.employeeView.dotArray = weakSelf.contents.content;
			
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - WD_TabBarHeight - SafeAreaBottomHeight) style:UITableViewStyleGrouped];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	}
	return _tableView;
}


@end
