//
//  SelCustomerCell.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/6/1.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "SelCustomerCell.h"
#import "SingleIntegarModel.h"

@implementation SelCustomerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"SelCustomerCell";
    SelCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
       
    }
    return cell;
    
}
- (void)reloadCellWithModel:(SingleIntegarModel *)model{
    self.nameLab.text=model.C_AGENTNAME;
    self.desLab.text=model.C_INTEGRAL_REMARK;
    self.blLab.text=[NSString stringWithFormat:@"积分比率：%@",model.C_INTEGRAL ];
    self.jfLab.text=model.C_INTEGRALVALUE;
    self.baobeiLab.text=[NSString stringWithFormat:@"报备人：%@", model.C_NAME ];
    self.timeLab.text=model.D_CREATE_TIME;
    
}
@end
