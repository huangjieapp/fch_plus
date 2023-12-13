//
//  MJKHomePageTodoCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/25.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKHomePageTodoNewCell.h"
#import "MJKHomePageTodoCollectionCell.h"
#import "MJKHomePageCompleteCollectionCell.h"

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
#import "MJKAfterManageViewController.h"

@interface MJKNewFlowLayout : UICollectionViewFlowLayout

@end

@implementation MJKNewFlowLayout
- (void)awakeFromNib {
	[super awakeFromNib];
	self.itemSize=CGSizeMake(KScreenWidth / 4, KScreenWidth / 4 - 20);
	self.minimumInteritemSpacing=1;
	self.minimumLineSpacing=1;
	self.sectionInset=UIEdgeInsetsMake(0, -3, 0, 0);
	self.scrollDirection=UICollectionViewScrollDirectionVertical;
}

@end

@interface MJKHomePageTodoNewCell ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation MJKHomePageTodoNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
	self.collectionView.dataSource = self;
	self.collectionView.delegate = self;
	[self.collectionView registerNib:[UINib nibWithNibName:@"MJKHomePageTodoCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}

- (void)setTodoArray:(NSArray *)todoArray {
	_todoArray = todoArray;
	[self.collectionView reloadData];
}


//MARK:-UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.todoArray.count;
	
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MJKPendingModel *model = self.todoArray[indexPath.row];
    MJKHomePageTodoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if ([self.typeStr isEqualToString:@"今日待办"]) {
        cell.countLabel.textColor = [UIColor colorWithHexString:@"#16F4C3"];
    } else if ([self.typeStr isEqualToString:@"后三天待办"]) {
        cell.countLabel.textColor = KNaviColor;
    } else if ([self.typeStr isEqualToString:@"逾期未处理"]) {
        cell.countLabel.textColor = [UIColor colorWithHexString:@"#FF6CA8"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.countLabel.text = model.count;
    cell.titleLabel.text = model.name;
    return cell;
	
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *nowTime =  [DBTools getTimeFomatFromCurrentTimeStampWithYMD];
    NSString *oneDayTime =  [DBTools getTimeFomatFromTimeStampOnlyYMDAddDay:1 andNowTime:nowTime];
    NSString *threeDayTime =  [DBTools getTimeFomatFromTimeStampOnlyYMDAddDay:2 andNowTime:oneDayTime];
    NSString *beforeOneDayTime =  [DBTools getBeforeTimeFomatFromTimeStampOnlyYMDAddDay:1 andNowTime:nowTime];
    MJKPendingModel *model = self.todoArray[indexPath.row];
	if ([self.typeStr isEqualToString:@"今日待办"]) {

        if ([model.name isEqualToString:@"人脸识别"]) {
            MJKFlowMeterViewController *meterVC = [[MJKFlowMeterViewController alloc]init];
            meterVC.CREATE_TIME_TYPE = @"1";
//            meterVC.C_ARRIVAL_DD_ID = @"A46000_C_STATUS_0002";
            [self.rootVC.navigationController pushViewController:meterVC animated:YES];
        } else 
		if ([model.name isEqualToString:@"客户跟进"]) {
			PotentailCustomerListViewController*vc=[[PotentailCustomerListViewController alloc]init];
            vc.loudou = @"yes";
//			vc.timerType=customerListTimeTypeToday;
            vc.LASTFOLLOW_START_TIME = [nowTime stringByAppendingString:@" 00:00:00"];
            vc.LASTFOLLOW_END_TIME = [nowTime stringByAppendingString:@" 23:59:59"];
            vc.C_STATUS_DD_ID  = @"1";
			[self.rootVC.navigationController pushViewController:vc animated:YES];
			
		}else if ([model.code isEqualToString:@"A47500_C_SYTXXSSZ_0009"]){//到店客流
			MJKFlowListViewController *vc = [[MJKFlowListViewController alloc]init];
			vc.timerType = flowListTimeTypeToday;
			[self.rootVC.navigationController pushViewController:vc animated:YES];
			
        }else if ([model.code isEqualToString:@"A47500_C_SYTXXSSZ_0001"]){//线索下发
			MJKClueListViewController *vc = [[MJKClueListViewController alloc]init];
            vc.stateCode = @"1";
            vc.LEAD_START_TIME = [nowTime stringByAppendingString:@" 00:00:00"];
            vc.LEAD_END_TIME = [nowTime stringByAppendingString:@" 23:59:59"];
			vc.timerType = clueListTimeTypeToday;
            vc.isTab = NO;
			[self.rootVC.navigationController pushViewController:vc animated:YES];
			
		}else if ([model.name isEqualToString:@"线索跟进"]) {
            MJKClueListViewController *vc = [[MJKClueListViewController alloc]init];
            vc.stateCode  = @"A41300_C_STATUS_0002";
            vc.timerType = clueListTimeTypeToday;
            vc.LEAD_START_TIME = @"2000-01-01 00:00:00";
            vc.LEAD_END_TIME = [nowTime stringByAppendingString:@" 23:59:59"];
            vc.isTab = NO;
            [self.rootVC.navigationController pushViewController:vc animated:YES];
            
        }else if ([model.name isEqualToString:@"预约到店"]){
			
			CGCAppointmentListVC *cvc=[[CGCAppointmentListVC alloc] init];
            cvc.IS_ARRIVE_SHOP  = @"未到店";
            cvc.C_TYPE_DD_ID = @"A41600_C_TYPE_0000";
            cvc.BOOK_START_TIME = [nowTime stringByAppendingString:@" 00:00:00"];
            cvc.BOOK_END_TIME = [nowTime stringByAppendingString:@" 23:59:59"];
			[self.rootVC.navigationController pushViewController:cvc animated:YES];
			
		}else if ([model.name isEqualToString:@"订单完工"] || [model.name  isEqualToString:@"交付提醒"]){
			CGCOrderListVC *cvc=[[CGCOrderListVC alloc] init];
            cvc.loudou = @"yes";
			cvc.startTime=@"1";
			cvc.statusID=@"A42000_C_STATUS_0002";
			[self.rootVC.navigationController pushViewController:cvc animated:YES];
			
		}else if ([model.name isEqualToString:@"粉丝互动"] || [model.name isEqualToString:@"桩脚互动"]){
			
            CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
            vc.type = BrokerCenterMembers;
            vc.LASTFOLLOW_TIME_TYPE = @"1";
            vc.C_STATUS_DD_ID = @"0";
            [self.rootVC.navigationController pushViewController:vc animated:YES];
			
		} else if ([model.name isEqualToString:@"订单跟进"] || [model.name isEqualToString:@"订单回访"] || [model.name isEqualToString:@"订单关怀"]) {
			CGCOrderListVC *cvc=[[CGCOrderListVC alloc] init];
            cvc.loudou = @"yes";
			cvc.LASTFOLLOW_TIME_TYPE=@"1";
			cvc.statusStr = @"今日";
			[self.rootVC.navigationController pushViewController:cvc animated:YES];
		} else if ([model.name isEqualToString:@"协助客户"]) {
			AssistViewController *vc = [[AssistViewController alloc]init];
			vc.XZCREATE_TIME_TYPE = @"1";
			vc.TYPE = @"0";
			[self.rootVC.navigationController pushViewController:vc animated:YES];
		} else if ([model.name isEqualToString:@"任务执行"]) {
			MJKNewTaskListViewController*vc=[[MJKNewTaskListViewController alloc]init];
			vc.status = @"6";
			vc.END_TIME_TYPE = @"1";
            vc.vcName = @"战板";
			[self.rootVC.navigationController pushViewController:vc animated:YES];
		} else if ([model.name isEqualToString:@"售后跟进"]) {
            MJKAfterManageViewController *vc = [[MJKAfterManageViewController alloc]init];
            vc.C_STATUS_DD_ID = @"A81500_C_STATUS_0001";
            vc.NEXTCOMMENT_START_TIME = [nowTime stringByAppendingString:@" 00:00:00"];
            vc.NEXTCOMMENT_END_TIME = [nowTime stringByAppendingString:@" 23:59:59"];
            [self.rootVC.navigationController pushViewController:vc animated:YES];
        } else if ([model.name isEqualToString:@"老客户跟进"]) {
            
            CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
            vc.type = BrokerCenterMembers;
            vc.index = @"1";
            
            vc.C_FSLX_DD_ID  = @"A47700_C_FSLX_0001";
            vc.LASTFOLLOW_START_TIME = [nowTime stringByAppendingString:@" 00:00:00"];
            vc.LASTFOLLOW_END_TIME = [nowTime stringByAppendingString:@" 23:59:59"];
            
            [self.rootVC.navigationController pushViewController:vc animated:YES];
        }  else if ([model.name isEqualToString:@"桩脚跟进"]) {
            
            CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
            vc.type = BrokerCenterMembers;
            vc.LASTFOLLOW_START_TIME = [nowTime stringByAppendingString:@" 00:00:00"];
            vc.LASTFOLLOW_END_TIME = [nowTime stringByAppendingString:@" 23:59:59"];
            vc.C_FSLX_DD_ID  = @"A47700_C_FSLX_0000";
            [self.rootVC.navigationController pushViewController:vc animated:YES];
        }
	}
	
	
	
#pragma 后三天待办任务
	if ([self.typeStr isEqualToString:@"后三天待办"]) {
		if ([model.name isEqualToString:@"客户跟进"]) {
			PotentailCustomerListViewController*vc=[[PotentailCustomerListViewController alloc]init];
            vc.loudou = @"yes";
//			vc.timerType=customerListTimeTypeThreeDay;
            vc.LASTFOLLOW_START_TIME = [oneDayTime stringByAppendingString:@" 00:00:00"];
            vc.LASTFOLLOW_END_TIME = [threeDayTime stringByAppendingString:@" 23:59:59"];
            vc.C_STATUS_DD_ID  = @"1";
			[self.rootVC.navigationController pushViewController:vc animated:YES];
			
			
		}else if ([model.name isEqualToString:@"预约到店"]){
			
			CGCAppointmentListVC *cvc=[[CGCAppointmentListVC alloc] init];
            cvc.IS_ARRIVE_SHOP  = @"未到店";
            cvc.C_TYPE_DD_ID = @"A41600_C_TYPE_0000";
            cvc.BOOK_START_TIME = [oneDayTime stringByAppendingString:@" 00:00:00"];
            cvc.BOOK_END_TIME = [threeDayTime stringByAppendingString:@" 23:59:59"];
			[self.rootVC.navigationController pushViewController:cvc animated:YES];
			
		}else if ([model.name isEqualToString:@"订单完工"] || [model.name  isEqualToString:@"交付提醒"]){
			CGCOrderListVC *cvc=[[CGCOrderListVC alloc] init];
            cvc.loudou = @"yes";
			cvc.startTime=@"inThreeDays";
			cvc.statusID=@"A42000_C_STATUS_0002";
			[self.rootVC.navigationController pushViewController:cvc animated:YES];
			
			
		} else if ([model.name isEqualToString:@"订单跟进"] || [model.name isEqualToString:@"订单回访"] || [model.name isEqualToString:@"订单关怀"]) {
			CGCOrderListVC *cvc=[[CGCOrderListVC alloc] init];
			cvc.LASTFOLLOW_TIME_TYPE=@"inThreeDays";
			cvc.statusStr = @"后三天";
			[self.rootVC.navigationController pushViewController:cvc animated:YES];
		} else if ([model.name isEqualToString:@"任务执行"]) {
			MJKNewTaskListViewController*vc=[[MJKNewTaskListViewController alloc]init];
			vc.status = @"6";
			vc.END_TIME_TYPE = @"inThreeDays";
            vc.vcName = @"战板";
			[self.rootVC.navigationController pushViewController:vc animated:YES];
        } else if ([model.name isEqualToString:@"粉丝互动"] || [model.name isEqualToString:@"桩脚互动"]){
            
            CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
            vc.type = BrokerCenterMembers;
            vc.LASTFOLLOW_TIME_TYPE = @"inThreeDays";
            vc.C_STATUS_DD_ID = @"0";
            [self.rootVC.navigationController pushViewController:vc animated:YES];
            
        }  else if ([model.name isEqualToString:@"售后跟进"]) {
           MJKAfterManageViewController *vc = [[MJKAfterManageViewController alloc]init];
           vc.C_STATUS_DD_ID = @"A81500_C_STATUS_0001";
            vc.NEXTCOMMENT_START_TIME = [oneDayTime stringByAppendingString:@" 00:00:00"];
            vc.NEXTCOMMENT_END_TIME = [threeDayTime stringByAppendingString:@" 23:59:59"];
           [self.rootVC.navigationController pushViewController:vc animated:YES];
       } else if ([model.name isEqualToString:@"老客户跟进"]) {
           CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
           vc.type = BrokerCenterMembers;
           vc.C_FSLX_DD_ID  = @"A47700_C_FSLX_0001";
           vc.LASTFOLLOW_START_TIME = [oneDayTime stringByAppendingString:@" 00:00:00"];
           vc.LASTFOLLOW_END_TIME = [threeDayTime stringByAppendingString:@" 23:59:59"];
           vc.index = @"1";
           [self.rootVC.navigationController pushViewController:vc animated:YES];
       }  else if ([model.name isEqualToString:@"桩脚跟进"]) {
           CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
           vc.type = BrokerCenterMembers;
           vc.LASTFOLLOW_START_TIME = [oneDayTime stringByAppendingString:@" 00:00:00"];
           vc.LASTFOLLOW_END_TIME = [threeDayTime stringByAppendingString:@" 23:59:59"];
           vc.C_FSLX_DD_ID  = @"A47700_C_FSLX_0000";
           [self.rootVC.navigationController pushViewController:vc animated:YES];
       }
		
		//ORDER_TIME_TYPE传inThreeDays,STATUS_TYPE传3
	}
	
	
#pragma 逾期未处理
	if ([self.typeStr isEqualToString:@"逾期未处理"]) {
        if ([model.name isEqualToString:@"人脸识别"]) {
            MJKFlowMeterViewController *meterVC = [[MJKFlowMeterViewController alloc]init];
            meterVC.END_TIME = [DBTools getProjectYesterdayTime];
            meterVC.CREATE_TIME_TYPE = @"0";
            [self.rootVC.navigationController pushViewController:meterVC animated:YES];
        } else
		if ([model.name isEqualToString:@"客户跟进"]) {
			PotentailCustomerListViewController*vc=[[PotentailCustomerListViewController alloc]init];
             vc.loudou = @"yes";
//			vc.timerType=customerListTimeTypeOverDay;
            vc.LASTFOLLOW_START_TIME = @"2000-01-01 00:00:00";
            vc.LASTFOLLOW_END_TIME = [beforeOneDayTime stringByAppendingString:@" 23:59:59"];
            vc.C_STATUS_DD_ID  = @"A41500_C_STATUS_0001";
			[self.rootVC.navigationController pushViewController:vc animated:YES];
			
			
			
		}else if ([model.code isEqualToString:@"A47500_C_SYTXXSSZ_0009"]){
			MJKFlowListViewController *vc = [[MJKFlowListViewController alloc]init];
			vc.timerType = flowListTimeTypeOverDay;
			[self.rootVC.navigationController pushViewController:vc animated:YES];
			
        }else if ([model.code isEqualToString:@"A47500_C_SYTXXSSZ_0001"]){
			MJKClueListViewController *vc = [[MJKClueListViewController alloc]init];
            vc.stateCode = @"2";
            vc.LEAD_START_TIME = @"2000-01-01 00:00:00";
            vc.LEAD_END_TIME = [beforeOneDayTime stringByAppendingString:@" 23:59:59"];
			vc.timerType = clueListTimeTypeOverDay;
            vc.isTab = NO;
			[self.rootVC.navigationController pushViewController:vc animated:YES];
			
		}else if ([model.name isEqualToString:@"预约到店"]){
			
			CGCAppointmentListVC *cvc=[[CGCAppointmentListVC alloc] init];
            cvc.IS_ARRIVE_SHOP  = @"未到店";
            cvc.C_TYPE_DD_ID = @"A41600_C_TYPE_0000";
            cvc.BOOK_START_TIME = @"2000-01-01 00:00:00";
            cvc.BOOK_END_TIME = [beforeOneDayTime stringByAppendingString:@" 23:59:59"];
			[self.rootVC.navigationController pushViewController:cvc animated:YES];
			
		}else if ([model.name isEqualToString:@"订单完工"] || [model.name  isEqualToString:@"交付提醒"]){
			
			CGCOrderListVC *cvc=[[CGCOrderListVC alloc] init];
            cvc.loudou = @"yes";
//            cvc.endTime=[DBTools getProjectYesterdayTime];
            cvc.startTime = @"yq";
			cvc.statusID=@"inThreeDays";
			[self.rootVC.navigationController pushViewController:cvc animated:YES];
			
        }else if ([model.name isEqualToString:@"粉丝互动"] || [model.name isEqualToString:@"桩脚互动"]){
            
            CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
            vc.type = BrokerCenterMembers;
            vc.LASTFOLLOW_END_TIME = [DBTools getProjectYesterdayTime];
            vc.C_STATUS_DD_ID = @"0";
            [self.rootVC.navigationController pushViewController:vc animated:YES];
            
        } else if ([model.name isEqualToString:@"订单跟进"] || [model.name isEqualToString:@"订单回访"] ||  [model.name isEqualToString:@"订单关怀"]) {
			CGCOrderListVC *cvc=[[CGCOrderListVC alloc] init];
            cvc.loudou = @"yes";
			cvc.LASTFOLLOW_END_TIME= [DBTools getProjectYesterdayTime];
			cvc.statusStr = @"逾期";
			[self.rootVC.navigationController pushViewController:cvc animated:YES];
		} else if ([model.name isEqualToString:@"任务执行"]) {
			MJKNewTaskListViewController*vc=[[MJKNewTaskListViewController alloc]init];
			vc.status = @"6";
			vc.END_END_TIME = [DBTools getProjectYesterdayTime];
            vc.vcName = @"战板";
			[self.rootVC.navigationController pushViewController:vc animated:YES];
		} else if ([model.name isEqualToString:@"售后跟进"]) {
            MJKAfterManageViewController *vc = [[MJKAfterManageViewController alloc]init];
            vc.C_STATUS_DD_ID = @"A81500_C_STATUS_0001";
            vc.NEXTCOMMENT_START_TIME = @"2000-01-01 00:00:00";
            vc.NEXTCOMMENT_END_TIME = [beforeOneDayTime stringByAppendingString:@" 23:59:59"];
            [self.rootVC.navigationController pushViewController:vc animated:YES];
        } else if ([model.name isEqualToString:@"老客户跟进"]) {
            CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
            vc.type = BrokerCenterMembers;
            vc.C_FSLX_DD_ID = @"A47700_C_FSLX_0001";
            vc.LASTFOLLOW_START_TIME = @"2000-01-01 00:00:00";
            vc.LASTFOLLOW_END_TIME = [beforeOneDayTime stringByAppendingString:@" 23:59:59"];
            vc.index = @"1";
            [self.rootVC.navigationController pushViewController:vc animated:YES];
        }  else if ([model.name isEqualToString:@"桩脚跟进"]) {
            CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
            vc.type = BrokerCenterMembers;
            vc.LASTFOLLOW_START_TIME = @"2000-01-01 00:00:00";
            vc.LASTFOLLOW_END_TIME = [beforeOneDayTime stringByAppendingString:@" 23:59:59"];
            
            vc.C_FSLX_DD_ID = @"A47700_C_FSLX_0000";
            [self.rootVC.navigationController pushViewController:vc animated:YES];
        }
		
		
	}
           

}

+(CGFloat)cellHeightTodoArray:(NSArray *)array {
	
	NSInteger rowCount = array.count / 4;
	NSInteger remainder = array.count % 4;
	CGFloat width = KScreenWidth / 4 - 20;
	if (remainder == 0) {
		return rowCount * width;
	} else {
		return (rowCount + 1) * width;
	}
	
}

#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKHomePageTodoNewCell";
    MJKHomePageTodoNewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
