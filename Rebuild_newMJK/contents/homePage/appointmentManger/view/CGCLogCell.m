//
//  CGCLogCell.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/1.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCLogCell.h"
#import "CGCLogModel.h"
#import "HistoryDetailView.h"
#import "MJKAdditionalTrackModel.h"

@implementation CGCLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)detailButtonAction:(UIButton *)sender {
	if (self.detailButtonClickBlock) {
		self.detailButtonClickBlock();
	}
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CGCLogCell";
    CGCLogCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    return cell;
    
}

- (void)setClueHistoryModel:(CGCLogModel *)clueHistoryModel {
    _clueHistoryModel = clueHistoryModel;
    if (clueHistoryModel.calldatetime.length > 0) {
        self.datelab.text= [[clueHistoryModel.calldatetime substringToIndex:16] stringByReplacingOccurrencesOfString:@"-" withString:@"/"] ;
    }
    
    self.nameLab.text=clueHistoryModel.C_OWNER_ROLENAME ;
    self.statusLab.text=[NSString stringWithFormat:@"%@\n%@",clueHistoryModel.C_A70100_C_NAME,clueHistoryModel.nlpEventName];
}

- (void)reloadCellWithModel:(CGCLogModel *)model{
      
    self.datelab.text= [[model.D_CREATE_TIME substringToIndex:16] stringByReplacingOccurrencesOfString:@"-" withString:@"/"] ;
    self.nameLab.text=model.C_OWNER_ROLENAME;
    self.statusLab.text=model.X_REMARK;
    
}

- (void)setAdditionalModel:(MJKAdditionalTrackModel *)additionalModel {
    _additionalModel = additionalModel;
    self.datelab.text= additionalModel.D_LASTUPDATE_TIME;
    NSMutableString* str1=[[NSMutableString alloc]initWithString:additionalModel.C_TYPE_DD_NAME];
    NSInteger count = additionalModel.C_TYPE_DD_NAME.length;
    while (count > 0) {
        [str1 insertString:@"\n" atIndex:count / 2 * 2];
        count = count - 2;
    }
    self.nameLab.text=(additionalModel.C_TYPE_DD_NAME.length / 2) > 0 ? str1 : additionalModel.C_TYPE_DD_NAME;
    self.nameLab.numberOfLines = 0;
    self.statusLab.text=additionalModel.X_REMARK;
}

- (void)reloadOrderCellWithModel:(MJKOrderMoneyListModel *)model andType:(NSString *)type andRow:(NSInteger)row {
	if ([type isEqualToString:@"订单节点"]) {
//        if (row == 0) {
//            self.morePlanButton.hidden = NO;
//        } else {
//            self.morePlanButton.hidden = YES;
//        }
		if (model.D_ACTUAL_TIME.length > 0) {
			self.planButton.hidden = self.completeButton.hidden = YES;
			self.showDetailButton.hidden = NO;
		} else {
			self.showDetailButton.hidden = YES;
			self.planButton.hidden = self.completeButton.hidden = NO;
		}
		self.sepLabel.hidden = YES;
		self.buttonSepView.hidden = NO;
//		self.uploadButton.hidden = NO;
		if (model.D_PLANNED_TIME.length > 0) {//D_PLANNED_TIME
			if (model.D_ACTUAL_TIME.length > 0) {
				[self.trajectoryImg setImage:[UIImage imageNamed:@"绿色确定√"]];
				NSString *dateYMD = [model.D_ACTUAL_TIME substringToIndex:10];
				NSString *planDate = [model.D_PLANNED_TIME substringToIndex:10];
				NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n计划:%@\n完成:%@",model.C_NAME,planDate,dateYMD]];
				[attStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} range:NSMakeRange(0, model.C_NAME.length)];
				[attStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:8.f], NSForegroundColorAttributeName : [UIColor darkGrayColor]} range:NSMakeRange(model.C_NAME.length + @"\n".length, dateYMD.length + 3 + planDate.length + 3 + 1)];
				self.datelab.attributedText = attStr;
				self.statusLab.text = [NSString stringWithFormat:@"备注:%@",model.X_REMARK];
			} else {
				[self.trajectoryImg setImage:[UIImage imageNamed:@"订单跟踪-红色小点"]];
				NSString *dateYMD = [model.D_PLANNED_TIME substringToIndex:10];
				NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n计划:%@",model.C_NAME,dateYMD]];
				[attStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} range:NSMakeRange(0, model.C_NAME.length)];
				[attStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:8.f], NSForegroundColorAttributeName : [UIColor darkGrayColor]} range:NSMakeRange(model.C_NAME.length + @"\n".length, dateYMD.length + 3)];
				self.datelab.attributedText = attStr;
				//			self.datelab.text =
				self.statusLab.text = [NSString stringWithFormat:@"备注:%@",model.X_PLANNEDREMARK];
			}
			
		} else if (model.D_ACTUAL_TIME.length > 0) {
			[self.trajectoryImg setImage:[UIImage imageNamed:@"绿色确定√"]];
			NSString *dateYMD = [model.D_ACTUAL_TIME substringToIndex:10];
			NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n完成:%@",model.C_NAME,dateYMD]];
			[attStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} range:NSMakeRange(0, model.C_NAME.length)];
			[attStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:8.f], NSForegroundColorAttributeName : [UIColor darkGrayColor]} range:NSMakeRange(model.C_NAME.length + @"\n".length, dateYMD.length + 3)];
			self.datelab.attributedText = attStr;
			self.statusLab.text = [NSString stringWithFormat:@"备注:%@",model.X_REMARK];
		}
		else {
			if ([model.C_STATUS_DD_ID isEqualToString:@"A47300_C_STATUS_0001"]) {//已完成
				self.datelab.text = model.C_NAME;
				self.statusLab.text = model.X_REMARK;
				[self.trajectoryImg setImage:[UIImage imageNamed:@"绿色确定√"]];
				self.planButton.hidden = self.completeButton.hidden = YES;
				self.showDetailButton.hidden = NO;
			} else {
				self.datelab.text = @"未计划" /*[NSString stringWithFormat:@"step%ld\n未完成",row + 1]*/;
				self.statusLab.text = model.C_NAME;
			}
		}
		
	} else if ([type isEqualToString:@"收款记录"]) {
		self.statusRightLayout.constant = 10.f;
		self.sepLabel.hidden = YES;
		self.datelab.text= [NSString stringWithFormat:@"%@ %@",model.D_CREATE_DATE,model.D_CREATE_TIME];
//        if ([model.C_TYPE_DD_ID isEqualToString:@"A04200_C_TYPE_0002"]) {
//            self.statusLab.text=[NSString stringWithFormat:@"金额:%@\n类型:%@",model.AMOUNT,model.C_TYPE_DD_NAME];
//        } else {
            self.statusLab.text=[NSString stringWithFormat:@"金额:%@\n状态:%@\n类型:%@",model.B_AMOUNT,model.C_STATUS_DD_NAME,model.C_TYPE_DD_NAME];
//        }
        
	} else if ([type isEqualToString:@"订单动态"]) {
		self.statusRightLayout.constant = 10.f;
		self.sepLabel.hidden = YES;
		self.datelab.text = model.D_FOLLOW_TIME;
        self.statusLab.text = model.CONTENT;
	} else if ([type isEqualToString:@"所有附件"]) {
		
	}
	
}

- (IBAction)uploadButtonAction:(UIButton *)sender {
	if (self.memoViewBlock) {
		self.memoViewBlock();
	}
}

- (IBAction)completeButtonAction:(UIButton *)sender {
	if (self.completeButtonActionBlock) {
		self.completeButtonActionBlock();
	}
}

- (IBAction)morePlanButtonAction:(UIButton *)sender {
    if (self.morePlanButtonActionBlock) {
        self.morePlanButtonActionBlock();
    }
}

- (IBAction)planButtonAction:(UIButton *)sender {
	if (self.planButtonActionBlock) {
		self.planButtonActionBlock();
	}
}
- (IBAction)showDetailButtonAction:(UIButton *)sender {
	if (self.showDetailButtonActionBlock) {
		self.showDetailButtonActionBlock();
	}
}

@end
