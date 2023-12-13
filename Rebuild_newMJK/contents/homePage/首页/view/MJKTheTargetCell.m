//
//  MJKTheTargetCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/27.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKTheTargetCell.h"
#import "MJKHomePageJXModel.h"

#import "CGCOrderListVC.h"
#import "PotentailCustomerListViewController.h"
#import "WorkCalendartListViewController.h"
#import "MJKClueListViewController.h"
#import "CGCAppointmentListVC.h"

@interface MJKTheTargetCell ()
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthOnMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *completeLabel;
@property (weak, nonatomic) IBOutlet UIButton *todayButton;
@property (weak, nonatomic) IBOutlet UIButton *monthButton;
/** MJKHomePageJXModel*/
@property (nonatomic, strong) MJKHomePageJXModel *model;

/** <#注释#>*/
@property (nonatomic, assign) NSInteger row;
@end

@implementation MJKTheTargetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)todayButtonAction:(UIButton *)sender {
	UIViewController*mainVC=[DBTools getSuperViewWithsubView:self];
	NSLog(@"%ld",sender.tag);
	NSInteger bTag = sender.tag;
    
    if ([self.titleStr isEqualToString:@"订单新增"]) {//订单新增今日
        CGCOrderListVC * vc=[[CGCOrderListVC alloc] init];
        vc.createTimeType = @"1";
        vc.IS_ASSISTANT = @"0";
        vc.statusID = @" ";//因为订单模块默认进入是跟进中
        vc.saleCode = self.model.USERID;
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([self.titleStr isEqualToString:@"订单交付"]) {//订单完工今日
        CGCOrderListVC * vc=[[CGCOrderListVC alloc] init];
        vc.SEND_TIME_TYPE = @"1";
        vc.IS_ASSISTANT = @"0";
        vc.statusID = @" ";
        vc.saleCode = self.model.USERID;
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([self.titleStr isEqualToString:@"预估金额"]) {//预估金额今日
        CGCOrderListVC * vc=[[CGCOrderListVC alloc] init];
        vc.createTimeType = @"1";
        vc.IS_ASSISTANT = @"0";
        vc.statusID = @" ";
        vc.saleCode = self.model.USERID;
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([self.titleStr isEqualToString:@"回款金额"]) {//回款金额今日
        CGCOrderListVC * vc=[[CGCOrderListVC alloc] init];
        vc.QUEREN_TIME_TYPE = @"1";
        vc.statusID = @" ";
        vc.saleCode = self.model.USERID;
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([self.titleStr isEqualToString:@"客户新增"]) {//客户新增今日
        PotentailCustomerListViewController * vc=[[PotentailCustomerListViewController alloc] init];
        vc.CREATE_TIME = @"1";
        vc.FOLLOW_TIME_TYPE = @"9";
        vc.saleCode = self.model.USERID;
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([self.titleStr isEqualToString:@"客户跟进"]) {//客户跟进今日
        WorkCalendartListViewController*vc=[[WorkCalendartListViewController alloc]init];
        vc.C_TYPE_DD_ID = @"0";
        vc.CREATE_TIME_TYPE = @"1";
        vc.saleCode = self.model.USERID;
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([self.titleStr isEqualToString:@"线索新增"]) {//名单新增今日
        MJKClueListViewController *mjkClueVC = [[MJKClueListViewController alloc]init];
        mjkClueVC.CREATE_TIME_TYPE = @"1";
        mjkClueVC.saleCode = self.model.USERID;
        [mainVC.navigationController pushViewController:mjkClueVC animated:YES];
    } else  {//邀约到店今日
        CGCAppointmentListVC * vc=[[CGCAppointmentListVC alloc] init];
        vc.ARRIVE_TIME_TYPE = @"1";
        vc.IS_ARRIVE_SHOP = @"2";
        vc.saleCode = self.model.USERID;
        [mainVC.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)monthButtonAction:(UIButton *)sender {
	NSLog(@"%ld",sender.tag);
	UIViewController*mainVC=[DBTools getSuperViewWithsubView:self];
	NSLog(@"%ld",sender.tag);
	NSInteger bTag = sender.tag;
    if ([self.titleStr isEqualToString:@"订单新增"]) {
        CGCOrderListVC * vc=[[CGCOrderListVC alloc] init];
        vc.createTimeType = @"3";
        vc.IS_ASSISTANT = @"0";
        vc.statusID = @" ";
        vc.saleCode = self.model.USERID;
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([self.titleStr isEqualToString:@"订单交付"]) {
        CGCOrderListVC * vc=[[CGCOrderListVC alloc] init];
        vc.SEND_TIME_TYPE = @"3";
        vc.IS_ASSISTANT = @"0";
        vc.statusID = @" ";
        vc.saleCode = self.model.USERID;
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([self.titleStr isEqualToString:@"预估金额"]) {
        CGCOrderListVC * vc=[[CGCOrderListVC alloc] init];
        vc.createTimeType = @"3";
        vc.IS_ASSISTANT = @"0";
        vc.statusID = @" ";
        vc.saleCode = self.model.USERID;
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([self.titleStr isEqualToString:@"回款金额"]) {
        CGCOrderListVC * vc=[[CGCOrderListVC alloc] init];
        vc.QUEREN_TIME_TYPE = @"3";
        vc.statusID = @" ";
        vc.saleCode = self.model.USERID;
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([self.titleStr isEqualToString:@"客户新增"]) {
        PotentailCustomerListViewController * vc=[[PotentailCustomerListViewController alloc] init];
        vc.CREATE_TIME = @"3";
        vc.FOLLOW_TIME_TYPE = @"9";
        vc.saleCode = self.model.USERID;
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([self.titleStr isEqualToString:@"客户跟进"]) {
        WorkCalendartListViewController*vc=[[WorkCalendartListViewController alloc]init];
        vc.C_TYPE_DD_ID = @"0";
        vc.CREATE_TIME_TYPE = @"3";
        vc.saleCode = self.model.USERID;
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([self.titleStr isEqualToString:@"线索新增"]) {
        MJKClueListViewController *mjkClueVC = [[MJKClueListViewController alloc]init];
        mjkClueVC.CREATE_TIME_TYPE = @"3";
        mjkClueVC.saleCode = self.model.USERID;
        [mainVC.navigationController pushViewController:mjkClueVC animated:YES];
    } else  {
        CGCAppointmentListVC * vc=[[CGCAppointmentListVC alloc] init];
        vc.ARRIVE_TIME_TYPE = @"3";
        vc.IS_ARRIVE_SHOP = @"2";
        vc.saleCode = self.model.USERID;
        [mainVC.navigationController pushViewController:vc animated:YES];

    }
//    if (bTag - 11 == self.row) {
//        CGCAppointmentListVC * vc=[[CGCAppointmentListVC alloc] init];
//        vc.ARRIVE_TIME_TYPE = @"3";
//        vc.IS_ARRIVE_SHOP = @"2";
////        vc.saleCode = @""
//        [mainVC.navigationController pushViewController:vc animated:YES];
//    }
//    if (bTag == 11) {//订单新增月
//    } else if (bTag == 12) {//订单完工月
//    } else if (bTag == 13) {//预估金额月
//    } else if (bTag == 14) {//回款金额月
//    } else if (bTag == 15) {//客户新增月
//    } else if (bTag == 16) {//客户跟进月
//    } else if (bTag == 17) {//名单新增月
//    } else if (bTag == 18) {//邀约到店月
//    }
}

- (void)reloadCellWithModel:(MJKHomePageJXModel *)model andIndexRow:(NSInteger)row {
	self.typeNameLabel.text = model.NAME;
    self.row = row;
    self.model = model;
	if ([self.titleStr isEqualToString:@"预估金额"] || [self.titleStr isEqualToString:@"回款金额"]) {
		if ([model.MIDCOUNT isEqualToString:@"0"]) {
			self.monthLabel.text = model.MIDCOUNT;
		} else {
			NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@万",model.MIDCOUNT]];
			[str addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:8.f]} range:NSMakeRange(model.MIDCOUNT.length, 1)];
			self.monthLabel.attributedText = str;
		}
		if ([model.MB isEqualToString:@"0"]) {
			self.targetLabel.text = model.MB;
		} else {
			NSMutableAttributedString *mbStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@万",model.MB]];
			[mbStr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:8.f]} range:NSMakeRange(model.MB.length, 1)];
			self.targetLabel.attributedText = mbStr;
		}
		
		if ([model.JRCOUNT isEqualToString:@"0"]) {
			self.todayLabel.text = model.JRCOUNT;
		} else {
			NSMutableAttributedString *jrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@万",model.JRCOUNT]];
			[jrStr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:8.f]} range:NSMakeRange(model.JRCOUNT.length, 1)];
			self.todayLabel.attributedText = jrStr;
		}
		
	} else {
		self.targetLabel.text = model.MB;
		self.todayLabel.text = model.JRCOUNT;
		self.monthLabel.text = model.MIDCOUNT;
	}
//	self.targetLabel.text = model.MB;
//	self.todayLabel.text = model.JRCOUNT;
//	self.monthLabel.text = model.MIDCOUNT;
	if ([model.FLAG isEqualToString:@"UP"]) {
		self.monthOnMonthLabel.textColor = [UIColor colorWithHexString:@"#FF5757"];
	} else {
		self.monthOnMonthLabel.textColor = [UIColor colorWithHexString:@"#1FBF22"];
	}
	if ([model.WCL_FLAG isEqualToString:@"UP"]) {
		self.completeLabel.textColor = [UIColor colorWithHexString:@"#FF5757"];
	} else {
		self.completeLabel.textColor = [UIColor colorWithHexString:@"#1FBF22"];
	}
	self.monthOnMonthLabel.text = model.BL;
	self.completeLabel.text = model.WCL;
	self.todayButton.tag = row + 1;
	self.monthButton.tag = row + 11;
}

#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKTheTargetCell";
	MJKTheTargetCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
