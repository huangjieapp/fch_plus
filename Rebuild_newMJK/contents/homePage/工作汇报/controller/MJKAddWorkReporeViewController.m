//
//  MJKAddWorkReporeViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/5.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKAddWorkReporeViewController.h"

#import "MJKWorkReportListModel.h"
#import "MJKWorkReportDetailModel.h"
#import "MJKWorkReportDetailSubModel.h"

#import "MJKTodayWorkReportCell.h"
#import "MJKYesterdayWorkReportCell.h"
#import "CGCNewAppointTextCell.h"
#import "CGCOrderDetialFooter.h"
#import "MJKPhotoView.h"
#import "MJKMRRemarkCell.h"
#import "MJKAddMRPlanCell.h"

#import "KSPhotoItem.h"
#import "KSPhotoBrowser.h"
#import "iflyMSC/IFlyMSC.h"
#import "ISRDataHelper.h"
#import "MJKAddMRModel.h"


#define RemarkCell    @"CGCNewAppointTextCell"
#define mrCell    @"MRCGCNewAppointTextCell"

@interface MJKAddWorkReporeViewController ()<UITableViewDataSource, UITableViewDelegate,IFlySpeechRecognizerDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/**  model*/
@property (nonatomic, strong) MJKWorkReportListModel *dataModel;
/** 图片*/
@property (nonatomic, strong) CGCOrderDetialFooter *footerImageView;
@property(nonatomic,strong)NSMutableArray*saveFooterUrlArray;//编辑界面  保存的底部的图片
@property(nonatomic,assign)NSInteger selectedImage;  //点击的是哪个 图片按钮    11 22 33 还有其他   0
@property(nonatomic,strong)NSMutableDictionary*saveFooterImageDataDic; //保存 3张图片的data   11  22  33  key
/** 选中哪一行*/
@property (nonatomic, assign) NSInteger selectRow;
/** 详细信息*/
@property (nonatomic, strong) NSString *detailStr;
/** 提交按钮*/
@property (nonatomic, strong) UIButton *commitButton;
#pragma mark 语音
//不带界面的识别对象
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
/** <#备注#>*/
@property (nonatomic, assign) BOOL isNORecord;
/** 录音数组*/
@property (nonatomic, strong) NSMutableArray *recordArray;
/** 语音背景*/
@property (nonatomic, strong) UIView *voiceView;
/** 语音背景*/
@property (nonatomic, strong) UIView *voiceImagge;
/** 备注长按*/
@property (nonatomic, strong) UILongPressGestureRecognizer *remarkLongGR;
/** 明日计划长按*/
@property (nonatomic, strong) UILongPressGestureRecognizer *mrLongGR;
/** 备注*/
@property (nonatomic, strong) NSString *remarkStr;
/** 明日计划*/
@property (nonatomic, strong) NSString *mrStr;
/** <#备注#>*/
@property (nonatomic, copy) void(^recordBlock)(NSString *str);
/** (MJKPhotoView *)tableFootPhoto*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;
/** image url array*/
@property (nonatomic, strong) NSArray *imageUrlArray;
/** is add mr plan*/
@property (nonatomic, assign) BOOL isMRPlan;

/** <#注释#>*/
@property (nonatomic, strong) NSString *indexStr;
@property (nonatomic, strong) NSIndexPath *indexPath;
/** <#注释#>*/
@property (nonatomic, strong) NSString *A48600C_id;

/** <#注释#>*/
@property (nonatomic, strong) UILabel *detailLabel;

/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *btNormalArray;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *btArray;
@end

@implementation MJKAddWorkReporeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    self.btArray = [NSMutableArray array];
    self.btNormalArray = [NewUserSession instance].configData.btListMapRb;
    for (NSDictionary *dic in self.btNormalArray) {
        [self.btArray addObject:dic[@"CODE"]];
    }
}

- (void)initUI {
	
	self.view.backgroundColor = [UIColor whiteColor];
	self.isMRPlan = NO;
	[self.view addSubview:self.commitButton];
	[self.view addSubview:self.tableView];
	[self startIFly];
	[self voiceBgView];
	[self.tableView registerNib:[UINib nibWithNibName:RemarkCell bundle:nil] forCellReuseIdentifier:RemarkCell];
	[self.tableView registerNib:[UINib nibWithNibName:RemarkCell bundle:nil] forCellReuseIdentifier:mrCell];
//	if ([self.editStr isEqualToString:@"编辑"]) {
//
//		[self getOwnerReportList:self.createTime];
//	} else {
	
		[self getOwnerReportList];
//	}
	//每次进入清空tu
	self.saveFooterUrlArray = nil;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0 ) {
		return 1;
	} else if (section == 1) {
		return self.dataModel.content.count + 1;
	} else {
		if (self.isMRPlan == YES) {
			return self.dataModel.content.count + 1;
		} else {
			return 1;
		}
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	if (indexPath.section == 0 && indexPath.row == 0) {
		MJKYesterdayWorkReportCell *cell = [MJKYesterdayWorkReportCell cellWithTableView:tableView];
		cell.yesterdayWorkLabel.text = self.dataModel.X_ZRPLAN;
		return cell;
	} else if (indexPath.section == 1) {
		if (indexPath.row == self.dataModel.content.count) {
			//备注
			CGCNewAppointTextCell*cell=[tableView dequeueReusableCellWithIdentifier:RemarkCell];
//			CGCNewAppointTextCell*cell = [CGCNewAppointTextCell cellWithTableView:tableView];
			cell.tag = indexPath.section;
			cell.topTitleLabel.text=@"今日备注:";
            if ([self.btArray containsObject:@"A47500_C_RBBTSZ_0000"]) {
                cell.mustLabel.hidden = NO;
            }
			cell.topTitleLabel.font = [UIFont systemFontOfSize:14.f];
			cell.titleTopLayout.constant = 0;
			cell.titleLeftLayout.constant = 10;
			if (self.dataModel.X_REMARK&&![self.dataModel.X_REMARK isEqualToString:@""]) {
				cell.beforeText=self.dataModel.X_REMARK;
			}
			
            
            __block CGCNewAppointTextCell *blockCell = cell;
			cell.changeTextBlock = ^(NSString *textStr) {
//                for (NSDictionary *dic in btArry) {
//                    if ([dic[@"CODE"] isEqualToString:@"A47500_C_RBBTSZ_0000"]) {
//                        if (textStr.length >= [dic[@"NUMBER"] integerValue]) {
//                            [JRToast showWithText:[NSString stringWithFormat:@"字数上限%@",dic[@"NUMBER"]]];
//
//                            [blockCell.textView resignFirstResponder];
//                            return ;
//                        }
//                    }
//                }
				weakSelf.dataModel.X_REMARK = textStr;
                
			};
			//屏幕的上移问题
			cell.startInputBlock = ^{

				
				[UIView animateWithDuration:0.25 animations:^{
					CGRect frame = [blockCell.textView convertRect:blockCell.textView.frame toView:nil];
					if (frame.origin.y > 300) {
						CGRect viewFrame = weakSelf.view.frame;
						viewFrame.origin.y = -frame.origin.y + 300;
						weakSelf.view.frame = viewFrame;
					}
					
				}];
			};
			cell.endBlock = ^{
				[UIView animateWithDuration:0.25 animations:^{
					CGRect frame = weakSelf.view.frame;
					frame.origin.y = 0.0;
					weakSelf.view.frame = frame;

				}];
			};
			cell.voiceButton.hidden = NO;
            self.indexPath = indexPath;
			[cell.voiceButton addTarget:self action:@selector(btnLong:)];
//		UILongPressGestureRecognizer*longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(btnLong:)];
//			self.remarkLongGR = longPress;
//			[cell.voiceButton addGestureRecognizer:longPress];
			
			return cell;
		} else {
			MJKWorkReportDetailModel *subModel = self.dataModel.content[indexPath.row];
			MJKTodayWorkReportCell *cell = [MJKTodayWorkReportCell cellWithTableView:tableView];
            cell.widthLayout.constant = KScreenWidth - 150;
			cell.model = subModel;
			if (indexPath.row == self.selectRow) {
				CGSize size = [self.detailStr boundingRectWithSize:CGSizeMake(KScreenWidth - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size;
				UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(cell.todayWorkLabel.frame) + 5, KScreenWidth - 20, size.height)];
				label.textColor = [UIColor darkGrayColor];
                self.detailLabel = label;
				label.text = self.detailStr;
				label.font = [UIFont systemFontOfSize:12.f];
				label.numberOfLines = 0;
					[cell.contentView addSubview:label];
				
            }
			return cell;
		}
	} else {
		if (self.isMRPlan == YES) {
			if (indexPath.row != self.dataModel.content.count) {
                MJKWorkReportDetailModel *subModel = self.dataModel.content[indexPath.row];
//                MJKAddMRModel *subModel = self.dataModel.jrjhmx[indexPath.row];
				MJKAddMRPlanCell *cell = [MJKAddMRPlanCell cellWithTableView:tableView];
				cell.model = subModel;
				return cell;
			}
		}
		//明日计划
		
		MJKMRRemarkCell *cell = [MJKMRRemarkCell cellWithTableView:tableView];
		if (self.dataModel.X_MRPLAN&&![self.dataModel.X_MRPLAN isEqualToString:@""]) {
			cell.textView.text=self.dataModel.X_MRPLAN;
		}
        if ([self.btArray containsObject:@"A47500_C_RBBTSZ_0002"]) {
            cell.mustLabel.hidden = NO;
        }
        
        __block MJKMRRemarkCell *weakCell = cell;
		cell.changeBlock = ^(NSString *str) {
            
			weakSelf.dataModel.X_MRPLAN = str;;
            
		};
		//屏幕的上移问题
		
		__block MJKMRRemarkCell *blockCell = cell;
		cell.beginBlock = ^{
			[UIView animateWithDuration:0.25 animations:^{
				CGRect frame = [blockCell.textView convertRect:blockCell.textView.frame toView:nil];
				if (frame.origin.y > 300) {
					CGRect viewFrame = weakSelf.view.frame;
					viewFrame.origin.y = viewFrame.origin.y - 200 ;
					weakSelf.view.frame = viewFrame;
				}
				
//				CGRect frame = [blockCell.textView convertRect:blockCell.textView.frame toView:nil];
////				CGRect frame = weakSelf.view.frame;
//				//frame.origin.y+
//				frame.origin.y = -240 + weakSelf.tableView.contentOffset.y;
//				weakSelf.view.frame = frame;
			}];
		};
		cell.endBlock = ^{
			[UIView animateWithDuration:0.25 animations:^{
				CGRect frame = weakSelf.view.frame;
				frame.origin.y = 0.0;
				weakSelf.view.frame = frame;
				
			}];
		};
		
		cell.beginLongBlock = ^{
			[weakSelf.view endEditing:YES];
			weakSelf.recordBlock = ^(NSString *str) {
				weakSelf.dataModel.X_MRPLAN = [weakSelf.dataModel.X_MRPLAN stringByAppendingString:str];
//                [weakSelf.tableView reloadData];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
			};

			weakSelf.isNORecord = NO;
			weakSelf.voiceView.hidden = NO;
			weakSelf.voiceImagge.hidden = NO;
			[_iFlySpeechRecognizer startListening];
				
		};
//		cell.endLongBlock = ^{
//			weakSelf.recordBlock = ^(NSString *str) {
//				weakSelf.dataModel.X_MRPLAN = [weakSelf.dataModel.X_MRPLAN stringByAppendingString:str];
//				[weakSelf.tableView reloadData];
//			};
//			weakSelf.isNORecord = YES;
//			weakSelf.voiceView.hidden = YES;
//			weakSelf.voiceImagge.hidden = YES;
//			[_iFlySpeechRecognizer stopListening];
//		};
		
		return cell;
		
		
//		cell.voiceButton.hidden = NO;
//		UILongPressGestureRecognizer*longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(btnLong:)];
//		[cell.voiceButton addGestureRecognizer:longPress];
		
//		self.mrLongGR =longPress;
	}
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 1) {
//        if ([self.title isEqualToString:@"新增汇报"]) {
//            return;
//        }
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
            [self httpWorkReportDetailWithC_TYPE_DD_ID:detailModel.C_TYPE_DD_ID andX_OBJECTIDS:detailModel.X_OBJECTIDS andC_ID:[self.title isEqualToString:@"新增汇报"] ? self.A48600C_id : self.dataModel.C_ID andCompleteBlock:^(NSString *str) {
                
                [self.detailLabel removeFromSuperview];
                if (detailModel.X_REMARK.length > 0) {
                    self.detailStr = [NSString stringWithFormat:@"(%@)\n%@",detailModel.X_REMARK, str];
                } else {
                    if (str.length > 0) {
                        self.detailStr = str;
                    } else {
                        self.detailStr = @"";
                    }
                    
                    if (detailModel.X_REMARK.length <= 0 && str.length <= 0) {
                        self.detailStr = @"";
                    }
                }
//                self.detailStr = [NSString stringWithFormat:@"(%@)\n%@",detailModel.X_REMARK, str];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
		} else {
			self.dataModel.selected = NO;
			self.detailStr = @"";
			[self.tableView reloadData];
		}
		
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *bgView = [[UIView alloc]initWithFrame:tableView.tableHeaderView.frame];
	bgView.backgroundColor = kBackgroundColor;
	
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
	label.textColor = [UIColor blackColor];
	label.font = [UIFont systemFontOfSize:14.f];
	label.text = @[@"原计划备注",@"今日完成",@"明日计划"][section];
    CGSize size = [label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
    label.frame = CGRectMake(10, 0, size.width, 20);
	[bgView addSubview:label];
    if (section == 1) {
        UILabel *tailLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth - 100, 0, 80, 20)];
        tailLabel.text = @"计划完成";
        tailLabel.textColor = [UIColor blackColor];
        tailLabel.font = [UIFont systemFontOfSize:14.f];
        tailLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:tailLabel];
    }
	if (section == 2) {
		UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 40, 0, 20, 20)];
		[button setTitleNormal:@"+"];
		[button setTitleColor:[UIColor darkGrayColor]];
		[button addTarget:self action:@selector(addMRPlanAction:)];
		if (self.isMRPlan != YES) {
			[bgView addSubview:button];
		}
        
        UILabel *mustLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 5, 10, 10)];
        mustLabel.text = @"*";
        mustLabel.textColor = [UIColor redColor];
//        mustLabel.font = [UIFont systemFontOfSize:14.f];
        if ([self.btArray containsObject:@"A47500_C_RBBTSZ_0001"]) {
            [bgView addSubview:mustLabel];
        }
        
        UILabel *targetLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth - 45 - 50, 0, 50, 20)];
        targetLabel.textAlignment = NSTextAlignmentCenter;
        targetLabel.textColor = [UIColor blackColor];
        targetLabel.text = @"目标";
        targetLabel.font = [UIFont systemFontOfSize:14.f];
        if (self.isMRPlan == YES) {
            [bgView addSubview:targetLabel];
        }
        
        UILabel *completeLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth - 135 - 50, 0, 50, 20)];
        completeLabel.textAlignment = NSTextAlignmentCenter;
        completeLabel.textColor = [UIColor blackColor];
        completeLabel.text = @"已完成";
        completeLabel.font = [UIFont systemFontOfSize:14.f];
        if (self.isMRPlan == YES) {
            [bgView addSubview:completeLabel];
        }
        
        UILabel *monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(completeLabel.frame) - 60, 0, 50, 20)];
        monthLabel.textAlignment = NSTextAlignmentCenter;
        monthLabel.textColor = [UIColor blackColor];
        monthLabel.text = @"月目标";
        monthLabel.font = [UIFont systemFontOfSize:14.f];
        if (self.isMRPlan == YES) {
            [bgView addSubview:monthLabel];
        }
		
	}
	return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    DBSelf(weakSelf);
	if (section==2) {
        if (self.dataModel.urlList.count > 0) {
            
            self.tableFootPhoto.imageURLArray = self.dataModel.urlList;
        }
		return self.tableFootPhoto;
		/*if (self.footerImageView) {
			[self.saveFooterUrlArray removeAllObjects];
			[self.saveFooterUrlArray addObjectsFromArray:self.dataModel.urlList];
			self.footerImageView.beforeImageArray=self.saveFooterUrlArray;
			return self.footerImageView;
		}
		CGCOrderDetialFooter*footer=[[NSBundle mainBundle]loadNibNamed:@"CGCOrderDetialFooter" owner:nil options:nil].firstObject;
		footer.beforeImageArray=self.saveFooterUrlArray;
//		footer.isWork = YES;//汇报
		footer.frame=CGRectMake(0, 0, KScreenWidth, 150);
		self.footerImageView=footer;
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
			}else{
				//选择图片
				weakSelf.selectedImage=11;
				[weakSelf TouchAddImage];
				
			}
			
		};
		
		footer.clickSecondBlock = ^(UIImage*image){
			if (image) {
				//有图片那就放大
				MyLog(@"放大");
				KSPhotoItem *item = [KSPhotoItem itemWithSourceView:weakSelf.footerImageView.secondPicBtn.imageView image:image];
				KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
				[browser showFromViewController:weakSelf];
			}else{
				//选择图片
				weakSelf.selectedImage=22;
				[weakSelf TouchAddImage];
				
			}
		};
		
		footer.clickThirdBlock = ^(UIImage*image){
			if (image) {
				//有图片那就放大
				MyLog(@"放大");
				KSPhotoItem *item = [KSPhotoItem itemWithSourceView:weakSelf.footerImageView.thirdPicBtn.imageView image:image];
				KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
				[browser showFromViewController:weakSelf];
				
				
			}else{
				//选择图片
				weakSelf.selectedImage=33;
				[weakSelf TouchAddImage];
				
				
			}
			
		};
		//删除图片
		footer.deleteFirstBlock = ^{
			[weakSelf.saveFooterImageDataDic removeObjectForKey:@"11"];
			if (weakSelf.saveFooterUrlArray.count>=1) {
				
				[self.saveFooterUrlArray removeObjectAtIndex:0];
			}
			
			
		};
		
		footer.deleteSecondBlock = ^{
			[weakSelf.saveFooterImageDataDic removeObjectForKey:@"22"];
			if (weakSelf.saveFooterUrlArray.count>=2) {
				
				[self.saveFooterUrlArray removeObjectAtIndex:1];
			}
			
		};
		
		footer.deleteThirdBlock = ^{
			[weakSelf.saveFooterImageDataDic removeObjectForKey:@"33"];
			if (weakSelf.saveFooterUrlArray.count>=3) {
				[self.saveFooterUrlArray removeObjectAtIndex:2];
			}
			
		};
		return footer;*/
	}else{
		return nil;
	}
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
			return 100;
		} else {
			if (indexPath.row == self.selectRow) {
				if (self.detailStr.length > 0) {
					CGSize size = [self.detailStr boundingRectWithSize:CGSizeMake(KScreenWidth - 100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size;
					if (size.height + 30 > 30) {
						return 30 + size.height;
					}
				}
			}
			return 30;
		}
		
	} else if (indexPath.section == 2) {
		if (self.isMRPlan == YES) {
			if (indexPath.row != self.dataModel.content.count) {
				return 44;
			}
		}
		return 100;
	}
	return 44;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section == 2) {
		return 150;
	}
	return .1f;
}

- (MJKPhotoView *)tableFootPhoto {
	DBSelf(weakSelf);
	if (!_tableFootPhoto) {
		_tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
		_tableFootPhoto.isEdit = YES;
        NSArray *btArray = [NewUserSession instance].configData.btListMapRb;
        for (NSDictionary *dic in btArray) {
            if ([dic[@"CODE"] isEqualToString:@"A47500_C_RBBTSZ_0003"]) {
                _tableFootPhoto.mustStr = @"*";
            }
        }
		_tableFootPhoto.isCamera = NO;
		_tableFootPhoto.rootVC = self;
		_tableFootPhoto.backUrlArray = ^(NSArray *arr, NSArray *saveArr) {
			weakSelf.imageUrlArray = arr;
		};
	}
	return _tableFootPhoto;
}

#pragma mark - 长按手势
- (void)btnLong:(UIButton *)sender {
	DBSelf(weakSelf);
	[self.view endEditing:YES];
//	if (sender == self.remarkLongGR) {
    
		self.recordBlock = ^(NSString *str) {
			weakSelf.dataModel.X_REMARK = [weakSelf.dataModel.X_REMARK stringByAppendingString:str];
//            [weakSelf.tableView reloadData];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[weakSelf.indexPath] withRowAnimation:UITableViewRowAnimationNone];
		};
//	} else {
//		self.recordBlock = ^(NSString *str) {
//			weakSelf.dataModel.X_MRPLAN = [weakSelf.dataModel.X_MRPLAN stringByAppendingString:str];
//			[weakSelf.tableView reloadData];
//		};
//	}
	
	self.isNORecord = NO;
	self.voiceView.hidden = NO;
	self.voiceImagge.hidden = NO;
	[_iFlySpeechRecognizer startListening];
//	if (sender.state == UIGestureRecognizerStateBegan) {
//		self.isNORecord = NO;
//		self.voiceView.hidden = NO;
//		self.voiceImagge.hidden = NO;
//		[_iFlySpeechRecognizer startListening];
//	} else if (sender.state == UIGestureRecognizerStateEnded) {
//		self.isNORecord = YES;
//		self.voiceView.hidden = YES;
//		self.voiceImagge.hidden = YES;
//		[_iFlySpeechRecognizer stopListening];
//
//
//	}
}

#pragma mark 添加明天计划
- (void)addMRPlanAction:(UIButton *)sender {
	self.isMRPlan = YES;
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:2];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView reloadData];
}

#pragma mark - get owner report list
- (void)getOwnerReportList {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A48600WebService-getDetails"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dict setObject:dic forKey:@"content"];
	DBSelf(weakSelf);
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.dataModel = [MJKWorkReportListModel mj_objectWithKeyValues:data];
            weakSelf.imageUrlArray = weakSelf.dataModel.urlList;
			[weakSelf.tableView reloadData];
			if (weakSelf.dataModel.C_ID.length > 0) {
				weakSelf.title = @"更新汇报";
//                if (weakSelf.dataModel.flag == YES) {
					weakSelf.isMRPlan = YES;
//                }
				[weakSelf.tableView reloadData];
				[weakSelf.commitButton setTitleNormal:@"更新"];
			} else {
				weakSelf.title = @"新增汇报";
                weakSelf.A48600C_id = [DBObjectTools getA48600C_id];
				[weakSelf.commitButton setTitleNormal:@"提交"];
			}
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
		[weakSelf.tableView.mj_header endRefreshing];
		[weakSelf.tableView.mj_footer endRefreshing];
	}];
}

#pragma mark workReport detail
- (void)httpWorkReportDetailWithC_TYPE_DD_ID:(NSString *)C_TYPE_DD_ID andX_OBJECTIDS:(NSString *)X_OBJECTIDS andC_ID:(NSString *)C_ID andCompleteBlock:(void(^)(NSString *str))successBlock{
	self.view.userInteractionEnabled = NO;
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A48600WebService-getObjectList"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"C_TYPE_DD_ID"] = C_TYPE_DD_ID;
	dic[@"X_OBJECTIDS"] = X_OBJECTIDS;
	dic[@"C_ID"] = C_ID;
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
			NSString *detailStr = [array componentsJoinedByString:@"\n"];
//            [weakSelf.tableView reloadData];
            if (successBlock) {
                successBlock(detailStr);
            }
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		weakSelf.view.userInteractionEnabled = YES;
	}];
}

#pragma add workReport http
- (void)httpAddWorkReportDetailWithImageArray:(NSArray *)imageArray{
	self.view.userInteractionEnabled = NO;
	NSString *actionStr ;
	if ([self.editStr isEqualToString:@"编辑"] || self.dataModel.C_ID.length > 0) {
		actionStr = @"A48600WebService-update";
	} else {
		actionStr = @"A48600WebService-insert";
	}
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:actionStr];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	
	
	if ([self.editStr isEqualToString:@"编辑"] || self.dataModel.C_ID.length > 0) {
		dic[@"C_ID"] = self.dataModel.C_ID;
	} else {
        dic[@"C_ID"] = self.A48600C_id;//[DBObjectTools getA48600C_id];
		dic[@"X_ZRPLAN"] = self.dataModel.X_ZRPLAN;
		if (self.isAddWorkWorld == YES) {
			dic[@"IS_WORKCIRCLE"] = @"1";
		}
	}
	dic[@"X_MRPLAN"] = self.dataModel.X_MRPLAN;
	dic[@"urlList"] = imageArray;
	dic[@"X_REMARK"] = self.dataModel.X_REMARK;
	if (self.isMRPlan == YES) {
		NSMutableArray *arr = [NSMutableArray array];
		for (MJKWorkReportDetailModel *model in self.dataModel.content) {
            NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
            contentDic[@"CODE"] = model.C_TYPE_DD_ID;
            contentDic[@"NAME"] = model.C_TYPE_DD_NAME;
            contentDic[@"COUNT"] = model.B_TOTAL_JH_MR;
            [arr addObject:contentDic];
		}
		dic[@"jrjhmx"] = arr;
	}
	
	[dict setObject:dic forKey:@"content"];
	DBSelf(weakSelf);
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    HttpManager*manager=[[HttpManager alloc]init];
//    NSString *urlStr;
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"formal"] isEqualToString:@"YES"]) {
//        urlStr=[NSString stringWithFormat:@"%@",HTTP_NewADDRESS];
//    } else {
//        urlStr=[NSString stringWithFormat:@"%@",HTTP_TestNewADDRESS];
//    }
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [JRToast showWithText:data[@"message"]];
            [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"isRefresh"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        weakSelf.view.userInteractionEnabled = YES;
    }];

    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",@"text/html;charset=utf-8",nil];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];//请求
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];//响应
//    [manager POST:HTTP_ADDRESS parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
    
}

-(NSString*)dictionaryToJson:(NSDictionary *)dic

{
    NSError *error = nil;
    
    NSData * jsonData  =  [NSJSONSerialization dataWithJSONObject: dic options:NSJSONWritingPrettyPrinted error:&error];  //第一步，字典转数据
    
    NSString *jsonString = [[NSString alloc]initWithData: jsonData encoding:NSUTF8StringEncoding];  //第二部，数据转JSON
    
    NSString *outerJson = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];  //第三步，处理JSON，去掉“\”转义
    return outerJson;
    
}

#pragma mark - get owner report list
- (void)getOwnerReportList:(NSString *)createTime {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A48600WebService-getPersonalReportList"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"DATE"] = createTime;
	dic[@"USERID"] = self.USERID;
	[dict setObject:dic forKey:@"content"];
	DBSelf(weakSelf);
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.dataModel = [MJKWorkReportListModel mj_objectWithKeyValues:data];
			weakSelf.title = @"更新汇报";
            if (weakSelf.dataModel.flag == YES) {
				weakSelf.isMRPlan = YES;
            }
			[weakSelf.commitButton setTitleNormal:@"更新"];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
		[weakSelf.tableView.mj_header endRefreshing];
		[weakSelf.tableView.mj_footer endRefreshing];
	}];
}

#pragma mark  -- photo delegate
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
	//    定义一个newPhoto，用来存放我们选择的图片。
	UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
	if (!newPhoto) {
		newPhoto=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
	}
	NSData*data=UIImageJPEGRepresentation(newPhoto, 0.5);
	
	if (self.selectedImage==11){
		//footer 第一张图
		[self.saveFooterImageDataDic setObject:data forKey:@"11"];
		//        [self.self.footerImageView.firstPicBtn setImage:newPhoto forState:UIControlStateNormal];
		self.footerImageView.firstImg=newPhoto;
		if (self.saveFooterUrlArray.count>=1) {
			[self.saveFooterUrlArray removeObjectAtIndex:0];
		}
		
		
	}else if (self.selectedImage==22){
		//footer 第二张图
		[self.saveFooterImageDataDic setObject:data forKey:@"22"];
		//         [self.self.footerImageView.secondPicBtn setImage:newPhoto forState:UIControlStateNormal];
		self.footerImageView.secondImg=newPhoto;
		if (self.saveFooterUrlArray.count>=2) {
			[self.saveFooterUrlArray removeObjectAtIndex:1];
		}
		
		
	}else if (self.selectedImage==33){
		//footer 第三张图
		[self.saveFooterImageDataDic setObject:data forKey:@"33"];
		//         [self.self.footerImageView.thirdPicBtn setImage:newPhoto forState:UIControlStateNormal];
		self.footerImageView.thirdImg=newPhoto;
		if (self.saveFooterUrlArray.count>=3) {
			[self.saveFooterUrlArray removeObjectAtIndex:2];
		}
		
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

//上传多张照片  并完成
-(void)httpPostArrayImage:(NSMutableDictionary*)ImageDic compliete:(void(^)(NSArray*arrayImg))successBlock{
	NSMutableArray*ImageArray=[NSMutableArray array];
	[ImageDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
		[ImageArray addObject:obj];
	}];
	if (ImageArray.count<1) {
		successBlock(nil);
	}else{
		
		NSMutableArray*saveFooterImageAddress=[NSMutableArray array];
		
		for (NSData*imageData in ImageArray) {
			NSString*urlStr=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
			HttpManager*manager=[[HttpManager alloc]init];
			[manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:imageData compliation:^(id data, NSError *error) {
				MyLog(@"%@",data);
				if ([data[@"code"] integerValue]==200) {
					
					NSString*imageStr=data[@"show_url"];
					[saveFooterImageAddress addObject:imageStr];
					
					if (saveFooterImageAddress.count==ImageArray.count) {
						successBlock(saveFooterImageAddress);
					}
				}else{
					[JRToast showWithText:data[@"message"]];
				}
				
			}];
			
		}
	}
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - WD_TabBarHeight - SafeAreaBottomHeight - self.commitButton.frame.size.height - 5) style:UITableViewStyleGrouped];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	}
	return _tableView;
}

- (UIButton *)commitButton {
	if (!_commitButton) {
		_commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_commitButton.frame = CGRectMake(10, KScreenHeight - 45 - SafeAreaBottomHeight, KScreenWidth - 20, 40);
//		[_commitButton setTitleNormal:@"提交" forState:UIControlStateNormal];
        _commitButton.layer.cornerRadius = 5.f;
        _commitButton.layer.masksToBounds = YES;
		[_commitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		_commitButton.backgroundColor = KNaviColor;
		[_commitButton addTarget:self action:@selector(commitButtonAction:)];
	}
	return _commitButton;
}
#pragma mark 提交
- (void)commitButtonAction:(UIButton *)sender {
	DBSelf(weakSelf);
//	[self httpPostArrayImage:self.saveFooterImageDataDic compliete:^(NSArray *arrayImg) {
//		if ([self.editStr isEqualToString:@"编辑"] || self.dataModel.C_ID.length > 0) {
//			[self.saveFooterUrlArray removeAllObjects];
//			if (self.saveFooterUrlArray.count > 0) {
//				[self.saveFooterUrlArray addObjectsFromArray:arrayImg];
//			}
//			[self httpAddWorkReportDetailWithImageArray:self.saveFooterUrlArray.count > 0 ? self.saveFooterUrlArray : arrayImg];
//		} else {
    
        if ([self.btArray containsObject:@"A47500_C_RBBTSZ_0000"]) {
            if (self.dataModel.X_REMARK.length <= 0) {
                [JRToast showWithText:@"请输入今日备注"];
                return;
            }
           
        }
    
    for (NSDictionary *dic in self.btNormalArray) {
        if ([dic[@"CODE"] isEqualToString:@"A47500_C_RBBTSZ_0002"]) {
            if (self.dataModel.X_REMARK.length <= [dic[@"NUMBER"] integerValue]) {
                [JRToast showWithText:[NSString stringWithFormat:@"今日备注字数至少%@个",dic[@"NUMBER"]]];
                return ;
            }
        }
    }
    
    //self.isMRPlan
    if ([self.btArray containsObject:@"A47500_C_RBBTSZ_0001"]) {
        if (self.isMRPlan != YES) {
            [JRToast showWithText:@"请选择计划目标"];
            return;
        }
        
    }
    
        if ([self.btArray containsObject:@"A47500_C_RBBTSZ_0002"]) {
            if (self.dataModel.X_MRPLAN.length <= 0) {
                [JRToast showWithText:@"请输入计划备注"];
                return;
            }
            
        }
    
    for (NSDictionary *dic in self.btNormalArray) {
        if ([dic[@"CODE"] isEqualToString:@"A47500_C_RBBTSZ_0002"]) {
            if (self.dataModel.X_MRPLAN.length <= [dic[@"NUMBER"] integerValue]) {
                [JRToast showWithText:[NSString stringWithFormat:@"计划备注字数至少%@个",dic[@"NUMBER"]]];
                return ;
            }
        }
    }
    
    
        
        if ([self.btArray containsObject:@"A47500_C_RBBTSZ_0003"]) {
            if (self.imageUrlArray.count <= 0) {
                [JRToast showWithText:@"请选择图片"];
                return;
            }
            
        }
    
			[self httpAddWorkReportDetailWithImageArray:self.imageUrlArray];
//		}
	
//	}];
}

- (NSMutableDictionary *)saveFooterImageDataDic {
	if (!_saveFooterImageDataDic) {
		_saveFooterImageDataDic = [NSMutableDictionary dictionary];
	}
	return _saveFooterImageDataDic;
}

- (NSMutableArray *)saveFooterUrlArray {
	if (!_saveFooterUrlArray) {
		_saveFooterUrlArray = [NSMutableArray array];
	}
	return _saveFooterUrlArray;
}
#pragma mark - 语音
- (void)startIFly {
	//创建语音识别对象
	_iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
	//设置识别参数
	//设置为听写模式
	[_iFlySpeechRecognizer setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
	//asr_audio_path 是录音文件名，设置value为nil或者为空取消保存，默认保存目录在Library/cache下。
	[_iFlySpeechRecognizer setParameter:@"iat.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
	_iFlySpeechRecognizer.delegate =self;
}

/*
 //需要实现IFlyRecognizerViewDelegate识别协议
 @interface IATViewController : UIViewController<IFlySpeechRecognizerDelegate>
 //不带界面的识别对象
 @property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
 @end
  */
 
 
 //IFlySpeechRecognizerDelegate协议实现
 //识别结果返回代理
 - (void) onResults:(NSArray *) results isLast:(BOOL)isLast{
	 NSLog(@"===========%@",results);
	 NSMutableString *resultString = [[NSMutableString alloc] init];
	 NSDictionary *dic = results[0];
	 for (NSString *key in dic) {
		 [resultString appendFormat:@"%@",key];
	 }
	 NSString * str =  [ISRDataHelper stringFromJson:resultString];
	 NSLog(@"===========%@",str);
	 [self.recordArray addObject:str];
	 if (isLast) {
//		 if (self.isNORecord == YES) {
			 NSString *str1 = [self.recordArray componentsJoinedByString:@""];
			 NSLog(@"++++++++++++%@",str1);
			 if (self.recordBlock) {
				 self.recordBlock(str1);
			 }
			 [self.recordArray removeAllObjects];
		 self.isNORecord = YES;
		 self.voiceView.hidden = YES;
		 self.voiceImagge.hidden = YES;
		 [_iFlySpeechRecognizer stopListening];

//		 }
	 }
 }
 //识别会话结束返回代理
 - (void)onCompleted: (IFlySpeechError *) error{
	 
 }
 //停止录音回调
 - (void) onEndOfSpeech{
//	 if (self.isNORecord == NO) {
//		 [_iFlySpeechRecognizer startListening];
//	 } else {
//		 [_iFlySpeechRecognizer stopListening];
//	 }
 }
 //开始录音回调
 - (void) onBeginOfSpeech{
	 
 }
 //音量回调函数
 - (void) onVolumeChanged: (int)volume{
	 
 }
 //会话取消回调
 - (void) onCancel{
	 
 }

- (void)voiceBgView {
	UIView *voiceView = [[UIView alloc]initWithFrame:self.view.frame];
	self.voiceView = voiceView;
	voiceView.hidden = YES;
	voiceView.backgroundColor = [UIColor blackColor];
	voiceView.alpha = .5f;
	[[UIApplication sharedApplication].keyWindow addSubview:voiceView];
	UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake((KScreenWidth - 100) / 2, (KScreenHeight - 130) / 2, 130, 130)];
	bgView.hidden = YES;
	self.voiceImagge = bgView;
	UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
	imageView.image = [UIImage imageNamed:@"语音搜索大按钮"];
	[bgView addSubview:imageView];
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), 100, 30)];
	label.text = @"我们正在倾听你的对话...";
	label.font = [UIFont systemFontOfSize:14.f];
	label.textColor = [UIColor whiteColor];
	[bgView addSubview:label];
	[[UIApplication sharedApplication].keyWindow addSubview:bgView];
}

- (NSMutableArray *)recordArray {
	if (!_recordArray) {
		_recordArray = [NSMutableArray array];
	}
	return _recordArray;
}


@end
