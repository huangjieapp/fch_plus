//
//  MJKWorkReportListCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/6/27.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKWorkReportListCell.h"

#import "MJKWorkReportEmployeeView.h"
#import "MJKWorkReportEmployeeCell.h"
#import "MJKYesterdayWorkReportCell.h"
#import "MJKTodayWorkReportCell.h"
#import "CGCOrderDetialFooter.h"
#import "MJKPhotoView.h"
#import "MJKWorkReportRemarkCell.h"

#import "KSPhotoItem.h"
#import "KSPhotoBrowser.h"

#import "MJKWorkReportDetailSubModel.h"

@interface MJKWorkReportListCell ()<UITableViewDataSource, UITableViewDelegate>
/** 列表*/
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong)CGCOrderDetialFooter*footerImageView;
/** 明细*/
@property (nonatomic, strong) NSString *detailStr;
/** 选中的哪一行*/
@property (nonatomic, assign)  NSInteger selectRow;
/** 列表高度*/
@property (nonatomic, assign) NSInteger rowHeight;
/** (MJKPhotoView *)tableFootPhoto*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;

@end

@implementation MJKWorkReportListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setupUI {
	[self.contentView addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//	NSArray *array = self.listModel.content
	if (section == 2) {
		if (self.listModel.X_REMARK.length > 0) {
			return self.listModel.content.count + 1;
		} else {
			return self.listModel.content.count;
		}
	} else {
		return 1;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0 && indexPath.row == 0) {
		MJKWorkReportEmployeeCell *cell = [MJKWorkReportEmployeeCell cellWithTableView:tableView];
		cell.model = self.listModel;
		return cell;
	} else if (indexPath.section == 1 && indexPath.row == 0) {
		MJKYesterdayWorkReportCell *cell = [MJKYesterdayWorkReportCell cellWithTableView:tableView];
		cell.indexPath = indexPath;
		cell.model = self.listModel;
		return cell;
	} else if (indexPath.section == 2) {
		if (indexPath.row == self.listModel.content.count) {
			MJKWorkReportRemarkCell *cell = [MJKWorkReportRemarkCell cellWithTableView:tableView];
//			cell.remarkLabel.text = [NSString stringWithFormat:@"备注:%@",self.listModel.X_REMARK];
			CGSize mrSize = [[NSString stringWithFormat:@"备注:\n%@",self.listModel.X_REMARK] boundingRectWithSize:CGSizeMake(KScreenWidth - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
			UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, mrSize.width, mrSize.height + 5)];
			label.textColor = [UIColor blackColor];
			label.text = [NSString stringWithFormat:@"备注:\n%@",self.listModel.X_REMARK] ;
			label.font = [UIFont systemFontOfSize:14.f];
			label.numberOfLines = 0;
//			label.backgroundColor = [UIColor redColor];
			if (self.listModel.X_REMARK.length > 0) {
				[cell.contentView addSubview:label];
			} else {
				[label removeFromSuperview];
			}
			
			return cell;
		}
		MJKWorkReportDetailModel *detailModel = self.listModel.content[indexPath.row];
		MJKTodayWorkReportCell *cell = [MJKTodayWorkReportCell cellWithTableView:tableView];
		cell.model = detailModel;
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
	} else {
		if (self.listModel.X_MRPLANDETAILED.length > 0) {
			MJKYesterdayWorkReportCell *cell = [MJKYesterdayWorkReportCell cellWithTableView:tableView];
			cell.yesterdayWorkLabel.text = [NSString stringWithFormat:@"%@\n备注:\n%@",self.listModel.X_MRPLANDETAILED, self.listModel.X_MRPLAN];
			return cell;
//			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mrcell"];
//			if (!cell) {
//				cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"mrcell"];
//			}
//			cell.textLabel.numberOfLines = 0;
//			cell.textLabel.font = [UIFont systemFontOfSize:12.f];
//			cell.textLabel.text = [NSString stringWithFormat:@"%@\n备注:\n%@",self.listModel.X_MRPLANDETAILED, self.listModel.X_MRPLAN] ;
//			return cell;
		} else {
			MJKYesterdayWorkReportCell *cell = [MJKYesterdayWorkReportCell cellWithTableView:tableView];
			cell.indexPath = indexPath;
			cell.model = self.listModel;
			return cell;
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		return 60;
	} else if (indexPath.section == 1) {
		
		CGSize zrSize = [self.listModel.X_ZRPLAN boundingRectWithSize:CGSizeMake(KScreenWidth - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
		if (zrSize.height + 22 > 44) {
			return zrSize.height + 22;
		}
	} else if (indexPath.section == 2) {
		if (indexPath.row == self.listModel.content.count) {
			CGSize mrSize = [self.listModel.X_REMARK boundingRectWithSize:CGSizeMake(KScreenWidth - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
			if (mrSize.height + 22 > 30) {
				return mrSize.height + 28;
			} else {
				return 30;
			}
		} else {
			if (indexPath.row == self.selectRow) {
				if (self.detailStr.length > 0) {
					CGSize size = [self.detailStr boundingRectWithSize:CGSizeMake(KScreenWidth - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size;
					if (size.height + 30 > 30) {
						return 30 + size.height;
					}
				}
			}
			return 30;
		}
	} else if (indexPath.section == 3) {
		if (self.listModel.X_MRPLANDETAILED.length > 0) {
			CGSize mrSize = [[NSString stringWithFormat:@"%@\n备注:\n%@",self.listModel.X_MRPLANDETAILED, self.listModel.X_MRPLAN] boundingRectWithSize:CGSizeMake(KScreenWidth - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
			if (mrSize.height + 22 > 44) {
				return mrSize.height + 22;
			}
		} else {
			CGSize mrSize = [[NSString stringWithFormat:@"备注:\n%@", self.listModel.X_MRPLAN] boundingRectWithSize:CGSizeMake(KScreenWidth - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
			if (mrSize.height + 22 > 44) {
				return mrSize.height + 22;
			}
		}
	}
	return 44;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return .1;
	}
	return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section == 3) {
		if (self.listModel.urlList.count > 0) {
			return 200;
		}
		return 50;
	}
	return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view = [[UIView alloc]initWithFrame:self.tableView.tableHeaderView.frame];
	view.backgroundColor = kBackgroundColor;
	if (section == 0) {
//		MJKWorkReportEmployeeView *employeeView = [[NSBundle mainBundle]loadNibNamed:@"MJKWorkReportEmployeeView" owner:nil options:nil].lastObject;
//		[employeeView.headImageView sd_setImageWithURL:[NSURL URLWithString:self.listModel.C_HEADIMGUR] placeholderImage:[UIImage imageNamed:@"用户名"]];
//		NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",self.listModel.USERNAME,self.listModel.D_CREATE_TIME]];
//		[attributedString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} range:NSMakeRange(self.listModel.USERNAME.length + 1, self.listModel.D_CREATE_TIME.length)];
//
//		employeeView.nameLabel.attributedText = attributedString;
//		return employeeView;
		return nil;
	} else {
		
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 20)];
		label.textColor = [UIColor blackColor];
		if (section == 1) {
			label.text = @"今日计划";
		} else if (section == 2) {
			label.text = @"今日完成";
		} else if (section == 3) {
			label.text = @"明日计划";
		}
		label.font = [UIFont systemFontOfSize:14.f];
		[view addSubview:label];
		return view;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	DBSelf(weakSelf);
	if (section == 3) {
		UIView *bgView = [[UIView alloc]initWithFrame:self.tableView.tableFooterView.frame];
		UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.listModel.urlList.count > 0 ? 150 : 0)];
		self.tableFootPhoto.imageURLArray = self.listModel.urlList;
//		CGCOrderDetialFooter*footer=[[NSBundle mainBundle]loadNibNamed:@"CGCOrderDetialFooter" owner:nil options:nil].firstObject;
//		footer.titleNameLab.textColor = [UIColor blackColor];
//		footer.isWork = YES;//汇报
//		footer.beforeImageArray=self.listModel.urlList;
//		footer.frame=CGRectMake(0, 0, KScreenWidth, 150);
//		self.footerImageView=footer;
//		footer.deleteOneButton.hidden = footer.deleteSecondButton.hidden = footer.deleteThirdButton.hidden = YES;
//		footer.clickFirstBlock = ^(UIImage*image){
//			if (image) {
//				//有图片那就放大
//				MyLog(@"放大");
//
//				KSPhotoItem *item = [KSPhotoItem itemWithSourceView:weakSelf.footerImageView.firstPicBtn.imageView image:image];
//				KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
//				//                browser.delegate = self;
//				//                browser.dismissalStyle = _dismissalStyle;
//				//                browser.backgroundStyle = _backgroundStyle;
//				//                browser.loadingStyle = _loadingStyle;
//				//                browser.pageindicatorStyle = _pageindicatorStyle;
//				//                browser.bounces = _bounces;
//				[browser showFromViewController:weakSelf.rootVC];
//
//
//
//
//			}
//
//		};
//
//		footer.clickSecondBlock = ^(UIImage*image){
//			if (image) {
//				//有图片那就放大
//				MyLog(@"放大");
//				KSPhotoItem *item = [KSPhotoItem itemWithSourceView:weakSelf.footerImageView.secondPicBtn.imageView image:image];
//				KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
//				[browser showFromViewController:weakSelf.rootVC];
//
//
//			}
//		};
//
//		footer.clickThirdBlock = ^(UIImage*image){
//			if (image) {
//				//有图片那就放大
//				MyLog(@"放大");
//				KSPhotoItem *item = [KSPhotoItem itemWithSourceView:weakSelf.footerImageView.thirdPicBtn.imageView image:image];
//				KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
//				[browser showFromViewController:weakSelf.rootVC];
//
//
//			}
//
//		};
		[footView addSubview:self.tableFootPhoto];
		
		UIView *praiseView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(footView.frame), KScreenWidth, 50)];
		praiseView.backgroundColor = [UIColor whiteColor];
		NSInteger marginX0 = (((praiseView.frame.size.width / 2) - 25) / 2) - 10;
		NSInteger marginX1 = (praiseView.frame.size.width / 2) + (((praiseView.frame.size.width / 2) - 25) / 2) - 10;
		for (int i = 0; i < 2; i++) {
			UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i == 0 ? marginX0 : marginX1, (praiseView.frame.size.height - 25) / 2, 25, 25)];
			imageView.image = [UIImage imageNamed:@[@"评论", [self.listModel.fabulous_flag boolValue] ? @"点赞图标-黄色" : @"点赞图标"][i]];
			UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, 100, 50)];
			label.textAlignment = NSTextAlignmentLeft;
			label.font = [UIFont systemFontOfSize:14.f];
			label.text = @[self.listModel.comments, self.listModel.fabulous][i];
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
		
		
		if (self.listModel.urlList.count > 0) {
			[bgView addSubview:footView];
		}
		
		[bgView addSubview:praiseView];
		return bgView;
	} else {
		return nil;
	}
}
//static NSInteger selectRow;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		if (self.didSelectPersonalBlock) {
			self.didSelectPersonalBlock();
		}
	}
	if (indexPath.section == 2) {
		if (indexPath.row == self.listModel.content.count) {
			return;
		}
		//detailModel.isSelected == yes是选中状态
		//如果点击的不是当前cell,则上一行取消点击状态
		if (indexPath.row != self.selectRow) {
			MJKWorkReportDetailModel *detailModel = self.listModel.content[self.selectRow];
			detailModel.selected = NO;
		}
		self.selectRow = indexPath.row;
		MJKWorkReportDetailModel *detailModel = self.listModel.content[indexPath.row];
		
		//选中展开
		detailModel.selected = !detailModel.isSelected;
		if (detailModel.isSelected == YES) {
			CGRect tableFrame = self.tableView.frame;
			tableFrame.size.height = self.rowHeight;
			self.tableView.frame = tableFrame;
			[self httpWorkReportDetailWithC_TYPE_DD_ID:detailModel.C_TYPE_DD_ID andX_OBJECTIDS:detailModel.X_OBJECTIDS];
			
		} else {
			self.listModel.selected = NO;
			self.detailStr = @"";
			[self.tableView reloadData];
			
			CGRect tableFrame = self.tableView.frame;
			tableFrame.size.height = self.rowHeight;
			self.tableView.frame = tableFrame;
			if (self.backCellHeightBlock) {
				self.backCellHeightBlock(0);
			}
		}
		
	}
}

- (MJKPhotoView *)tableFootPhoto {
	DBSelf(weakSelf);
	if (!_tableFootPhoto) {
		_tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
		_tableFootPhoto.isEdit = NO;
		_tableFootPhoto.isCamera = NO;
		_tableFootPhoto.rootVC = self.rootVC;
//		_tableFootPhoto.backUrlArray = ^(NSArray *arr) {
//			weakSelf.urlList = arr;
//		};
	}
	return _tableFootPhoto;
}

#pragma mark workReport detail
- (void)httpWorkReportDetailWithC_TYPE_DD_ID:(NSString *)C_TYPE_DD_ID andX_OBJECTIDS:(NSString *)X_OBJECTIDS{
	self.userInteractionEnabled = NO;
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A48600WebService-getObjectList"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"C_TYPE_DD_ID"] = C_TYPE_DD_ID;
	dic[@"X_OBJECTIDS"] = X_OBJECTIDS;
	dic[@"C_ID"] = self.listModel.C_ID;
	[dict setObject:dic forKey:@"content"];
	DBSelf(weakSelf);
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			MJKWorkReportDetailSubModel *contents = [MJKWorkReportDetailSubModel mj_objectWithKeyValues:data];
			NSMutableArray *remarkArray = [NSMutableArray array];
			for (NSDictionary *dic in contents.content) {
				[remarkArray addObject:dic[@"X_REMARK"]];
			}
			weakSelf.detailStr = [remarkArray componentsJoinedByString:@"\n"];
			[weakSelf.tableView reloadData];
			
			CGSize size = [weakSelf.detailStr boundingRectWithSize:CGSizeMake(KScreenWidth - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size;
			
			
			CGRect tableFrame = weakSelf.tableView.frame;
			tableFrame.size.height = tableFrame.size.height + size.height;
			weakSelf.tableView.frame = tableFrame;
			
			self.listModel.selected = YES;
			if (weakSelf.backCellHeightBlock) {
				weakSelf.backCellHeightBlock(size.height);
			}
			weakSelf.userInteractionEnabled = YES;
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

#pragma 点在评论按钮
- (void)praiseCommentsAction:(UIButton *)sender {
	if (sender.tag - 100 == 0) {
		NSLog(@"评论");
		if (self.commentsBlock) {
			self.commentsBlock();
		}
	} else {
		NSLog(@"点赞");
		if (self.praiseBlock) {
			self.praiseBlock([self.listModel.fabulous_flag boolValue]);
		}
	}
}

#pragma mark - set
- (UITableView *)tableView {
	
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenHeight, self.rowHeight) style:UITableViewStylePlain];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.tableFooterView = [[UIView alloc]init];
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.bounces = NO;
		_tableView.scrollEnabled = NO;
	}
	return _tableView;
}

- (void)setListModel:(MJKWorkReportListModel *)listModel {
	_listModel = listModel;
	CGSize mrSize;
	if (self.listModel.X_MRPLANDETAILED.length > 0) {
		mrSize = [[NSString stringWithFormat:@"%@\n备注:\n%@",self.listModel.X_MRPLANDETAILED, self.listModel.X_MRPLAN] boundingRectWithSize:CGSizeMake(KScreenWidth - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
	} else {
		mrSize = [listModel.X_MRPLAN boundingRectWithSize:CGSizeMake(KScreenWidth - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
	}
	CGSize zrSize = [listModel.X_ZRPLAN boundingRectWithSize:CGSizeMake(KScreenWidth - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
	NSInteger mrHeight;
	if (listModel.X_MRPLAN.length > 0 || listModel.X_MRPLANDETAILED.length > 0) {
		mrHeight = mrSize.height + 23;
	} else {
		mrHeight = 44;
	}
	
	NSInteger zrHeight;
	if (listModel.X_ZRPLAN.length > 0) {
		zrHeight = zrSize.height + 23;
	} else {
		zrHeight = 44;
	}
	
	CGSize remarkSize = [[NSString stringWithFormat:@"备注:\n%@",self.listModel.X_REMARK] boundingRectWithSize:CGSizeMake(KScreenWidth - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
	NSInteger remarkHeight;
	if (listModel.X_REMARK.length > 0) {
		remarkHeight = remarkSize.height + 21;
	} else {
		remarkHeight = 0;
	}
	
	NSInteger headerHeight = 22 * 3;
	NSInteger footHight = listModel.urlList.count > 0 ? 200 + 10 : 60;
	NSInteger rowHeight = self.listModel.content.count * 31 + 1 * 44 + zrHeight + mrHeight + remarkHeight + footHight;
	self.rowHeight = headerHeight + rowHeight;
	[self setupUI];
//	[self.tableView reloadData];
}

#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKWorkReportListCell";
	MJKWorkReportListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
//		if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//			[cell setLayoutMargins:UIEdgeInsetsZero];
//		}
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

- (void)dealloc {
	
}

@end
