//
//  MJKHomePageTodoCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/25.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKHomePageTodoCell.h"
#import "MJKHomePageTodoCollectionCell.h"
#import "MJKHomePageCompleteCollectionCell.h"

#import "NextCountModel.h"
#import "subDicNextCountModel.h"

//待办
#import "PotentailCustomerListViewController.h"
#import "MJKFlowListViewController.h"
#import "MJKClueListViewController.h"
#import "CGCAppointmentListVC.h"
#import "CGCOrderListVC.h"
#import "AssistViewController.h"
#import "ServiceTaskViewController.h"
//完成目标
#import "MJKTheTargetViewController.h"

#import "MJKFlowMeterViewController.h"//人脸识别
#import "CGCBrokerCenterVC.h"//粉丝互动
#import "MJKNewTaskListViewController.h"

@interface MJKFlowLayout : UICollectionViewFlowLayout

@end

@implementation MJKFlowLayout
- (void)awakeFromNib {
	[super awakeFromNib];
	self.itemSize=CGSizeMake(KScreenWidth / 4, KScreenWidth / 4);
	self.minimumInteritemSpacing=1;
	self.minimumLineSpacing=1;
	self.sectionInset=UIEdgeInsetsMake(0, -3, 0, 0);
	self.scrollDirection=UICollectionViewScrollDirectionVertical;
}

@end

@interface MJKHomePageTodoCell ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation MJKHomePageTodoCell

- (void)awakeFromNib {
    [super awakeFromNib];
	self.collectionView.dataSource = self;
	self.collectionView.delegate = self;
	[self.collectionView registerNib:[UINib nibWithNibName:@"MJKHomePageTodoCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
	
	[self.collectionView registerNib:[UINib nibWithNibName:@"MJKHomePageCompleteCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell1"];
}

- (void)setTodoArray:(NSArray *)todoArray {
	_todoArray = todoArray;
	[self.collectionView reloadData];
}

- (void)setJxArray:(NSArray *)jxArray {
	_jxArray = jxArray;
	[self.collectionView reloadData];
}


//MARK:-UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	if ([self.typeStr isEqualToString:@"今日待处理"]) {
		NextCountModel *model = self.todoArray[0];
		return model.content.count;
	} else if ([self.typeStr isEqualToString:@"后三天待办"]) {
		NextCountModel *model = self.todoArray[1];
		return model.content.count;
	} else if ([self.typeStr isEqualToString:@"逾期未处理"]) {
		NextCountModel *model = self.todoArray[2];
		return model.content.count;
	} else {
		return self.jxArray.count;
	}
	
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.typeStr isEqualToString:@"业绩目标"]) {
		MJKHomePageJXModel *model = self.jxArray[indexPath.row];
		MJKHomePageCompleteCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
		cell.jxModel = model;
		return cell;
	} else {
		MJKHomePageTodoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
		NextCountModel *model;
		if ([self.typeStr isEqualToString:@"今日待处理"]) {
			model = self.todoArray[0];
			cell.countLabel.textColor = [UIColor colorWithHexString:@"#16F4C3"];
		} else if ([self.typeStr isEqualToString:@"后三天待办"]) {
			model = self.todoArray[1];
			cell.countLabel.textColor = KNaviColor;
		} else if ([self.typeStr isEqualToString:@"逾期未处理"]) {
			model = self.todoArray[2];
			cell.countLabel.textColor = [UIColor colorWithHexString:@"#FF6CA8"];
		}
		subDicNextCountModel *subModel = model.content[indexPath.row];
		
		cell.backgroundColor = [UIColor whiteColor];
		cell.countLabel.text = subModel.COUNT;
		cell.titleLabel.text = subModel.NAME;
		return cell;
	}
	
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	if ([self.typeStr isEqualToString:@"今日待处理"]) {
		NextCountModel *model = self.todoArray[0];
		subDicNextCountModel *subModel = model.content[indexPath.row];
        if ([subModel.NAME isEqualToString:@"人脸识别"]) {
            MJKFlowMeterViewController *meterVC = [[MJKFlowMeterViewController alloc]init];
            meterVC.CREATE_TIME_TYPE = @"1";
//            meterVC.C_ARRIVAL_DD_ID = @"A46000_C_STATUS_0002";
            [self.rootVC.navigationController pushViewController:meterVC animated:YES];
        } else 
		if ([subModel.NAME isEqualToString:@"客户跟进"]) {
			PotentailCustomerListViewController*vc=[[PotentailCustomerListViewController alloc]init];
            vc.loudou = @"yes";
			vc.timerType=customerListTimeTypeToday;
			[self.rootVC.navigationController pushViewController:vc animated:YES];
			
		}else if ([subModel.NAME isEqualToString:@"门店流量"] || [subModel.NAME isEqualToString:@"展厅流量"]){
			MJKFlowListViewController *vc = [[MJKFlowListViewController alloc]init];
			vc.timerType = flowListTimeTypeToday;
			[self.rootVC.navigationController pushViewController:vc animated:YES];
			
        }else if ([subModel.NAME isEqualToString:@"主动营销"] || [subModel.NAME isEqualToString:@"名单流量"] || [subModel.NAME isEqualToString:@"线索流量"] || [subModel.NAME isEqualToString:@"线索来电"] || [subModel.NAME isEqualToString:@"线索下发"]){
			MJKClueListViewController *vc = [[MJKClueListViewController alloc]init];
			vc.timerType = clueListTimeTypeToday;
            vc.isTab = NO;
			[self.rootVC.navigationController pushViewController:vc animated:YES];
			
		}else if ([subModel.NAME isEqualToString:@"线索跟进"]) {
            MJKClueListViewController *vc = [[MJKClueListViewController alloc]init];
            vc.stateCode = @"A41300_C_STATUS_0002";
            vc.nextTime = @"yqjr";
            vc.isTab = NO;
            [self.rootVC.navigationController pushViewController:vc animated:YES];
            
        }else if ([subModel.NAME isEqualToString:@"预约到店"]){
			
			CGCAppointmentListVC *cvc=[[CGCAppointmentListVC alloc] init];
			cvc.BOOK_TIME_TYPE=@"1";
			cvc.IS_ARRIVE_SHOP=@"1";
			[self.rootVC.navigationController pushViewController:cvc animated:YES];
			
		}else if ([subModel.NAME isEqualToString:@"订单完工"] || [subModel.NAME  isEqualToString:@"交付提醒"]){
			CGCOrderListVC *cvc=[[CGCOrderListVC alloc] init];
            cvc.loudou = @"yes";
			cvc.startTime=@"1";
			cvc.statusID=@"A42000_C_STATUS_0002";
			[self.rootVC.navigationController pushViewController:cvc animated:YES];
			
		}else if ([subModel.NAME isEqualToString:@"粉丝互动"] || [subModel.NAME isEqualToString:@"桩脚互动"]){
			
            CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
            vc.type = BrokerCenterMembers;
            vc.LASTFOLLOW_TIME_TYPE = @"1";
            vc.C_STATUS_DD_ID = @"0";
            [self.rootVC.navigationController pushViewController:vc animated:YES];
			
		} else if ([subModel.NAME isEqualToString:@"订单跟进"] || [subModel.NAME isEqualToString:@"订单回访"] || [subModel.NAME isEqualToString:@"订单关怀"]) {
			CGCOrderListVC *cvc=[[CGCOrderListVC alloc] init];
            cvc.loudou = @"yes";
			cvc.LASTFOLLOW_TIME_TYPE=@"1";
			cvc.statusStr = @"今日";
			[self.rootVC.navigationController pushViewController:cvc animated:YES];
		} else if ([subModel.NAME isEqualToString:@"协助客户"]) {
			AssistViewController *vc = [[AssistViewController alloc]init];
			vc.XZCREATE_TIME_TYPE = @"1";
			vc.TYPE = @"0";
			[self.rootVC.navigationController pushViewController:vc animated:YES];
		} else if ([subModel.NAME isEqualToString:@"任务执行"]) {
			MJKNewTaskListViewController*vc=[[MJKNewTaskListViewController alloc]init];
			vc.status = @"6";
			vc.END_TIME_TYPE = @"1";
            vc.vcName = @"战板";
			[self.rootVC.navigationController pushViewController:vc animated:YES];
		}
	}
	
	
	
#pragma 后三天待办任务
	if ([self.typeStr isEqualToString:@"后三天待办"]) {
		NextCountModel *model = self.todoArray[1];
		subDicNextCountModel *subModel = model.content[indexPath.row];
		if ([subModel.NAME isEqualToString:@"客户跟进"]) {
			PotentailCustomerListViewController*vc=[[PotentailCustomerListViewController alloc]init];
            vc.loudou = @"yes";
			vc.timerType=customerListTimeTypeThreeDay;
			[self.rootVC.navigationController pushViewController:vc animated:YES];
			
			
		}else if ([subModel.NAME isEqualToString:@"预约到店"]){
			
			CGCAppointmentListVC *cvc=[[CGCAppointmentListVC alloc] init];
			cvc.BOOK_TIME_TYPE=@"inThreeDays";
			cvc.IS_ARRIVE_SHOP=@"1";
			[self.rootVC.navigationController pushViewController:cvc animated:YES];
			
		}else if ([subModel.NAME isEqualToString:@"订单完工"] || [subModel.NAME  isEqualToString:@"交付提醒"]){
			CGCOrderListVC *cvc=[[CGCOrderListVC alloc] init];
            cvc.loudou = @"yes";
			cvc.startTime=@"inThreeDays";
			cvc.statusID=@"A42000_C_STATUS_0002";
			[self.rootVC.navigationController pushViewController:cvc animated:YES];
			
			
		} else if ([subModel.NAME isEqualToString:@"订单跟进"] || [subModel.NAME isEqualToString:@"订单回访"] || [subModel.NAME isEqualToString:@"订单关怀"]) {
			CGCOrderListVC *cvc=[[CGCOrderListVC alloc] init];
			cvc.LASTFOLLOW_TIME_TYPE=@"inThreeDays";
			cvc.statusStr = @"后三天";
			[self.rootVC.navigationController pushViewController:cvc animated:YES];
		} else if ([subModel.NAME isEqualToString:@"任务执行"]) {
			MJKNewTaskListViewController*vc=[[MJKNewTaskListViewController alloc]init];
			vc.status = @"6";
			vc.END_TIME_TYPE = @"inThreeDays";
            vc.vcName = @"战板";
			[self.rootVC.navigationController pushViewController:vc animated:YES];
        } else if ([subModel.NAME isEqualToString:@"粉丝互动"] || [subModel.NAME isEqualToString:@"桩脚互动"]){
            
            CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
            vc.type = BrokerCenterMembers;
            vc.LASTFOLLOW_TIME_TYPE = @"inThreeDays";
            vc.C_STATUS_DD_ID = @"0";
            [self.rootVC.navigationController pushViewController:vc animated:YES];
            
        }
		
		//ORDER_TIME_TYPE传inThreeDays,STATUS_TYPE传3
	}
	
	
#pragma 逾期未处理
	if ([self.typeStr isEqualToString:@"逾期未处理"]) {
        
		NextCountModel *model = self.todoArray[2];
		subDicNextCountModel *subModel = model.content[indexPath.row];
        if ([subModel.NAME isEqualToString:@"人脸识别"]) {
            MJKFlowMeterViewController *meterVC = [[MJKFlowMeterViewController alloc]init];
            meterVC.END_TIME = [DBTools getProjectYesterdayTime];
            meterVC.CREATE_TIME_TYPE = @"0";
            [self.rootVC.navigationController pushViewController:meterVC animated:YES];
        } else
		if ([subModel.NAME isEqualToString:@"客户跟进"]) {
			PotentailCustomerListViewController*vc=[[PotentailCustomerListViewController alloc]init];
             vc.loudou = @"yes";
			vc.timerType=customerListTimeTypeOverDay;
			[self.rootVC.navigationController pushViewController:vc animated:YES];
			
			
			
		}else if ([subModel.NAME isEqualToString:@"门店流量"] || [subModel.NAME isEqualToString:@"展厅流量"]){
			MJKFlowListViewController *vc = [[MJKFlowListViewController alloc]init];
			vc.timerType = flowListTimeTypeOverDay;
			[self.rootVC.navigationController pushViewController:vc animated:YES];
			
        }else if ([subModel.NAME isEqualToString:@"主动营销"] || [subModel.NAME isEqualToString:@"名单流量"] || [subModel.NAME isEqualToString:@"线索流量"] || [subModel.NAME isEqualToString:@"线索来电"]|| [subModel.NAME isEqualToString:@"线索下发"]){
			MJKClueListViewController *vc = [[MJKClueListViewController alloc]init];
			vc.timerType = clueListTimeTypeOverDay;
            vc.isTab = NO;
			[self.rootVC.navigationController pushViewController:vc animated:YES];
			
		}else if ([subModel.NAME isEqualToString:@"预约到店"]){
			
			CGCAppointmentListVC *cvc=[[CGCAppointmentListVC alloc] init];
			cvc.END_BOOK_TIME=[DBTools getProjectYesterdayTime];
			cvc.IS_ARRIVE_SHOP=@"1";
			[self.rootVC.navigationController pushViewController:cvc animated:YES];
			
		}else if ([subModel.NAME isEqualToString:@"订单完工"] || [subModel.NAME  isEqualToString:@"交付提醒"]){
			
			CGCOrderListVC *cvc=[[CGCOrderListVC alloc] init];
            cvc.loudou = @"yes";
//            cvc.endTime=[DBTools getProjectYesterdayTime];
            cvc.startTime = @"yq";
			cvc.statusID=@"inThreeDays";
			[self.rootVC.navigationController pushViewController:cvc animated:YES];
			
        }else if ([subModel.NAME isEqualToString:@"粉丝互动"] || [subModel.NAME isEqualToString:@"桩脚互动"]){
            
            CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
            vc.type = BrokerCenterMembers;
            vc.LASTFOLLOW_END_TIME = [DBTools getProjectYesterdayTime];
            vc.C_STATUS_DD_ID = @"0";
            [self.rootVC.navigationController pushViewController:vc animated:YES];
            
        } else if ([subModel.NAME isEqualToString:@"订单跟进"] || [subModel.NAME isEqualToString:@"订单回访"] ||  [subModel.NAME isEqualToString:@"订单关怀"]) {
			CGCOrderListVC *cvc=[[CGCOrderListVC alloc] init];
            cvc.loudou = @"yes";
			cvc.LASTFOLLOW_END_TIME= [DBTools getProjectYesterdayTime];
			cvc.statusStr = @"逾期";
			[self.rootVC.navigationController pushViewController:cvc animated:YES];
		} else if ([subModel.NAME isEqualToString:@"任务执行"]) {
			MJKNewTaskListViewController*vc=[[MJKNewTaskListViewController alloc]init];
			vc.status = @"6";
			vc.END_END_TIME = [DBTools getProjectYesterdayTime];
            vc.vcName = @"战板";
			[self.rootVC.navigationController pushViewController:vc animated:YES];
		}
		
		
		//ORDER_TIME_TYPE传昨天0点0分0秒,STATUS_TYPE传3
	}
           
	
	if ([self.typeStr isEqualToString:@"业绩目标"]) {
        MJKHomePageJXModel *model = self.jxArray[indexPath.row];
        MJKTheTargetViewController *vc = [[MJKTheTargetViewController alloc]initWithNibName:@"MJKTheTargetViewController" bundle:nil];
        vc.type = model.type;
        vc.titleStr = model.typeName;
        [self.rootVC.navigationController pushViewController:vc animated:YES];
	}
}

+(CGFloat)cellHeightTodoArray:(NSArray *)array {
	
	NSInteger rowCount = array.count / 4;
	NSInteger remainder = array.count % 4;
	CGFloat width = KScreenWidth / 4;
	if (remainder == 0) {
		return rowCount * width;
	} else {
		return (rowCount + 1) * width;
	}
	
}

#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKHomePageTodoCell";
	MJKHomePageTodoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
