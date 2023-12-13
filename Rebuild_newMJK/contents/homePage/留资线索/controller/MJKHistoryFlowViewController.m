//
//  MJKHistoryFlowViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/28.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKHistoryFlowViewController.h"

#import "CustomerDetailSecondTableViewCell.h"
#import "CGCLogCell.h"
#import "HistoryDetailView.h"

#import "MJKHistoryModel.h"
#import "MJKHistorySubModel.h"

#import "CGCLogModel.h"

#define CELL1       @"CustomerDetailSecondTableViewCell"
@interface MJKHistoryFlowViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJKHistoryModel *historyModel;

@end

@implementation MJKHistoryFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	if ([self.VCName isEqualToString:@"流量"]) {
		self.title = @"流量操作记录";
	} else if ([self.VCName isEqualToString:@"来电"]) {
		self.title = @"来电操作记录";
	} else if ([self.VCName isEqualToString:@"线索"]) {
		self.title = @"名单操作记录";
	} else if ([self.VCName isEqualToString:@"订单"]) {
		self.title = @"订单操作记录";
    } else if ([self.VCName isEqualToString:@"粉丝"]) {
        self.title = @"粉丝操作记录";
    }
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.tableView registerNib:[UINib nibWithNibName:CELL1 bundle:nil] forCellReuseIdentifier:CELL1];
	[self.view addSubview:self.tableView];
	[self HTTPGetHistoryFlowDatas];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.historyModel.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//	CustomerDetailSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL1];
//	MJKHistorySubModel* model = self.historyModel.content[indexPath.row];
//	NSArray *arr = self.historyModel.content;
//	UILabel *timeLabel = [cell valueForKey:@"timeLabel"];
//	timeLabel.font = [UIFont systemFontOfSize:14.0f];
//	timeLabel.textColor = DBColor(60, 60, 60);
//	UILabel *TypeLabel = [cell valueForKey:@"TypeLabel"];
//	TypeLabel.font = [UIFont systemFontOfSize:14.0f];
//	UILabel *remarkLabel = [cell valueForKey:@"remarkLabel"];
//	remarkLabel.font = [UIFont systemFontOfSize:14.0f];
//	timeLabel.textColor = TypeLabel.textColor = remarkLabel.textColor = DBColor(60, 60, 60);
//	if (arr.count > 0) {
//		if (arr.count == 1) {//如果arr只有一个那么都要显示
//			cell.topImage.hidden = cell.bottomImage.hidden = NO;
//		} else {
//			if (indexPath.row == 0) {
//				cell.topImage.hidden = NO;
//				cell.bottomImage.hidden = YES;
//			} else if (indexPath.row == arr.count - 1) {
//				cell.topImage.hidden = YES;
//				cell.bottomImage.hidden = NO;
//			} else {
//				cell.topImage.hidden = cell.bottomImage.hidden = YES;
//			}
//		}
//		
//	}
//	[cell updataHistoryCell:model];
	DBSelf(weakSelf);
	CGCLogModel *model = self.historyModel.content[indexPath.row];
	CGCLogCell *cell = [CGCLogCell cellWithTableView:tableView];
    cell.statusLab.numberOfLines = 3;
	NSArray *arr = self.historyModel.content;
	[cell reloadCellWithModel:model];
    cell.statusRightLayout.constant = 10;
	cell.detailButtonClickBlock = ^{
        NSString *str = model.X_REMARK;
        if (model.X_DETAILS.length > 0) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"\n%@",model.X_DETAILS]];
        }
		HistoryDetailView *detailView = [[HistoryDetailView alloc]initWithFrame:weakSelf.view.frame andTimeAndRemark:@[model.D_CREATE_TIME, str]];
		[[UIApplication sharedApplication].keyWindow addSubview:detailView];
	};
	if (arr.count > 0) {
			if (arr.count == 1) {//如果arr只有一个那么都要显示
				cell.topImage.hidden = cell.iconImg.hidden = NO;
			} else {
				if (indexPath.row == 0) {
					cell.topImage.hidden = NO;
					cell.iconImg.hidden = YES;
				} else if (indexPath.row == arr.count - 1) {
					cell.topImage.hidden = YES;
					cell.iconImg.hidden = NO;
				} else {
					cell.topImage.hidden = cell.iconImg.hidden = YES;
				}
			}
	
		}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGCLogModel *model = self.historyModel.content[indexPath.row];
    CGRect rect = [model.X_REMARK boundingRectWithSize:CGSizeMake(KScreenWidth - 150, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil];
//    if (rect.size.height + 10 > 50) {
//        return rect.size.height + 10;
//    }
	return 60;
}

#pragma mark - HTTP request
- (void)HTTPGetHistoryFlowDatas {
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    if ([self.VCName isEqualToString:@"线索"]) {
        contentDict[@"pageNum"] = @"1";
        contentDict[@"pageSize"] = @(2000);
        contentDict[@"C_A41300_C_ID"] = self.C_A41500_C_ID;
    } else {
        
        contentDict[@"C_OBJECTID"] = self.C_A41500_C_ID;
    }
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:[self.VCName isEqualToString:@"线索"] ? @"%@/api/crm/a426/list" : @"%@/api/crm/a459/list",HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.historyModel = [MJKHistoryModel yy_modelWithDictionary:data[@"data"]];
            weakSelf.historyModel.content = weakSelf.historyModel.list;
			[weakSelf.tableView reloadData];
			if (weakSelf.historyModel.content.count <= 0) {
				UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, (KScreenHeight - 90) / 2, KScreenWidth, 90)];
				label.text = @"暂无操作";
				label.font = [UIFont systemFontOfSize:16.0f];
				label.textColor = [UIColor grayColor];
				label.textAlignment = NSTextAlignmentCenter;
				[weakSelf.view addSubview:label];
			}
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
		
	}];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	return nil;
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.delegate = self;
		_tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
	}
	return _tableView;
}

@end
