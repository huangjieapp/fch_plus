//
//  ReportTopTableViewCell.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/5.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "ReportTopTableViewCellNoGroup_bak.h"

#import "MJKFlowListViewController.h"
#import "PotentailCustomerListViewController.h"
#import "MJKLouDouDetailViewController.h"
#import "CGCAppointmentListVC.h"
#import "CGCOrderListVC.h"
#import "MJKClueListViewController.h"
#import "CGCBrokerCenterVC.h"

#import "MJKBFBListModel.h"

@interface ReportTopTableViewCellNoGroup_bak()

@end

@implementation ReportTopTableViewCellNoGroup_bak

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)getValue:(ReportSheetModel*)mainModel{
    self.mainModel=mainModel;
	int index = 0;
	for (int i = 0; i < mainModel.tabList.count; i++) {
		NSArray *listArray = mainModel.tabList[i];
		for (int j = 0; j < listArray.count; j++) {
			NSDictionary *dic = listArray[j];
			UILabel *label = [self viewWithTag:1000 + index];
            if (index == 22) {
                label.text = [NSString stringWithFormat:@"粉丝新增:%@",dic[@"count"]];
            } else if (index == 23) {
                label.text = [NSString stringWithFormat:@"累计%@",dic[@"count"]];
            } else if (index == 24) {
                label.text = [NSString stringWithFormat:@"裂变率%@",dic[@"count"]];
            } else {
                label.text = [NSString stringWithFormat:@"%@",dic[@"count"]];
            }
			index += 1;
		}
	}
	int count = 0;
	for (int i = 0; i < mainModel.bfbList.count; i++) {
		MJKBFBListModel *model = mainModel.bfbList[i];
//		UILabel *nameLabel = [self viewWithTag:4000 + count];
		UILabel *countLabel = [self viewWithTag:3000 + count];
//		nameLabel.text = model.NAME;
		countLabel.text = model.count;
		count += 1;
		
	}
    
}

- (IBAction)clickToVCAction:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender.tag);
    }
	
//	if (sender.tag == 2000) {
//		MJKFlowListViewController * vc=[[MJKFlowListViewController alloc] init];
//        vc.statusCode = @"1";
//		[self.rootVC.navigationController pushViewController:vc animated:YES];
//
//    } else if (sender.tag == 2001 || sender.tag == 2002) {
//        MJKClueListViewController *vc = [[MJKClueListViewController alloc]init];
//        vc.stateCode = @"2";
//        if (sender.tag == 2001) {
//            vc.IS_A47700 = @"0";
//        } else {
//            vc.IS_A47700 = @"1";
//        }
//        [self.rootVC.navigationController pushViewController:vc animated:YES];
//    }
//
//    else if (sender.tag == 2003 || sender.tag == 2004 || sender.tag == 2005 || sender.tag == 2006 || sender.tag == 2007 || sender.tag == 2008) {
//		PotentailCustomerListViewController * vc=[[PotentailCustomerListViewController alloc] init];
//        vc.loudou = @"yes";
//        vc.typeStr = @"5";
//        if (sender.tag == 2003) {
//            vc.C_APPSOURCE_DD_ID = @"A41500_C_APPSOURCE_0000";
//        } else if (sender.tag == 2004) {
//            vc.C_APPSOURCE_DD_ID = @"0";
//            vc.IS_A47700 = @"0";
//        } else if (sender.tag == 2005) {
//            vc.C_APPSOURCE_DD_ID = @"A41500_C_APPSOURCE_0002";
//            vc.IS_A47700 = @"1";
//        } else if (sender.tag == 2006) {
//            vc.C_APPSOURCE_DD_ID = @"A41500_C_APPSOURCE_0000";
//            vc.DD_TYPE = @"2";
//        } else if (sender.tag == 2007) {
//            vc.C_APPSOURCE_DD_ID = @"0";
//            vc.IS_A47700 = @"0";
//            vc.DD_TYPE = @"2";
//        } else {
//            vc.C_APPSOURCE_DD_ID = @"A41500_C_APPSOURCE_0002";
//            vc.IS_A47700 = @"1";
//            vc.DD_TYPE = @"2";
//        }
//		[self.rootVC.navigationController pushViewController:vc animated:YES];
//
//	} else if (sender.tag == 2009 || sender.tag == 2010 || sender.tag == 2011 || sender.tag == 2012 || sender.tag == 2013 || sender.tag == 2014 || sender.tag == 2015) {
//		CGCOrderListVC * vc=[[CGCOrderListVC alloc] init];
//        vc.loudou = @"yes";
//        if (sender.tag == 2009) {
//            vc.IS_ASSISTANT = @"0";
//            vc.statusID = @"A42000_C_STATUS_0000";
//            vc.CUSTOMERTYPE = @"0";
//        } else if (sender.tag == 2010) {
//            vc.IS_ASSISTANT = @"0";
//            vc.statusID = @"A42000_C_STATUS_0000";
//            vc.CUSTOMERTYPE = @"1";
//        } else if (sender.tag == 2011) {
//            vc.IS_ASSISTANT = @"0";
//            vc.statusID = @"A42000_C_STATUS_0000";
//            vc.CUSTOMERTYPE = @"2";
//        } else if (sender.tag == 2012) {
//            vc.IS_ASSISTANT = @"0";
//            vc.statusID = @"A42000_C_STATUS_0002";
//            vc.CUSTOMERTYPE = @"0";
//        } else if (sender.tag == 2013) {
//            vc.IS_ASSISTANT = @"0";
//            vc.statusID = @"A42000_C_STATUS_0002";
//            vc.CUSTOMERTYPE = @"1";
//        } else if (sender.tag == 2014) {
//            vc.IS_ASSISTANT = @"0";
//            vc.statusID = @"A42000_C_STATUS_0002";
//            vc.CUSTOMERTYPE = @"2";
//        } else {
//            vc.statusID = @"A42000_C_STATUS_0001";
//        }
//		[self.rootVC.navigationController pushViewController:vc animated:YES];
//    } else if (sender.tag == 2016 || sender.tag == 2017) {
//        CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
//        vc.loudou = @"yes";
//        vc.C_TYPE_DD_ID = @"A47700_C_TYPE_0002";
//        [self.rootVC.navigationController pushViewController:vc animated:YES];
//    }
	
}
#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"ReportTopTableViewCellNoGroup";
	ReportTopTableViewCellNoGroup *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

//-(void)setMainModel:(ReportSheetModel *)mainModel{
//    self.mainModel=mainModel;
//    
//    
//    
//}

@end
