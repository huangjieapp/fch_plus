//
//  CGCAppointmentCell.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/8/29.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCAppointmentCell.h"
#import "CGCAppointmentModel.h"
#import "CGCOrderDetailModel.h"
#import "MJKCarSourceSubModel.h"

@implementation CGCAppointmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.clipsToBounds=YES;
    self.iconImg.layer.cornerRadius=4.0;
    self.iconImg.layer.masksToBounds=YES;
    //    self.statusLab.layer.borderWidth=0.5;
    //    self.statusLab.layer.cornerRadius=2;
    //    self.statusLab.layer.masksToBounds=YES;
    //    self.statusLab.layer.borderColor=DBColor(229, 229, 229).CGColor;
    //    self.statusLab.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"all_bg"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setCarModel:(MJKCarSourceSubModel *)carModel {
    _carModel = carModel;
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:carModel.X_PICTURE] placeholderImage:nil];
    
    if (carModel.X_PICTURE.length==0) {
        self.iconLab.text=[carModel.C_NAME substringToIndex:1];
    }
    
    if ([carModel.C_SEX_DD_NAME isEqualToString:@"女"]) {
        self.sexImg.image=[UIImage imageNamed:@"iv_women"];
    }else if ([carModel.C_SEX_DD_NAME isEqualToString:@"男"]){
        self.sexImg.image=[UIImage imageNamed:@"iv_man"];
    }else{
        self.sexImg.hidden=YES;
    }
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",carModel.C_NAME,carModel.C_BY_A49600_C_NAME]];
    [attStr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f], NSForegroundColorAttributeName : [UIColor darkGrayColor]} range:NSMakeRange(carModel.C_NAME.length + 1, carModel.C_BY_A49600_C_NAME.length)];
    self.nameLab.attributedText = attStr;
    
    self.detailLab.text = carModel.C_OWNER_ROLENAME;
    self.statusLab.text = carModel.C_STATUS_DD_NAME;
    if (carModel.C_CPSZD_DD_NAME.length > 0) {
        self.phoneLabel.text = [NSString stringWithFormat:@"%@ %@%@",carModel.C_PHONE, carModel.C_CPSZD_DD_NAME,carModel.C_CPH];
    } else {
        self.phoneLabel.text = carModel.C_PHONE;
    }
    self.starImg.hidden = YES;
    if ([carModel.C_STATUS_DD_ID isEqualToString:@"A71000_C_STATUS_0004"]) {//上架
        self.statusLab.textColor = [UIColor colorWithHex:@"#81DE5C "];
    } else if ([carModel.C_STATUS_DD_ID isEqualToString:@"A71000_C_STATUS_0001"]) {//战败
        self.statusLab.textColor = [UIColor colorWithHex:@"#FF5757"];
    } else if ([carModel.C_STATUS_DD_ID isEqualToString:@"A71000_C_STATUS_0002"]) {//成交
        self.statusLab.textColor = [UIColor colorWithHex:@"#4BB0C4"];
    } else if ([carModel.C_STATUS_DD_ID isEqualToString:@"A71000_C_STATUS_0000"]) {//跟进中
        self.statusLab.textColor = [UIColor colorWithHex:@"#F0AD4E"];
    }
}

//重新指派多选
- (IBAction)selectButtonAction:(UIButton *)sender {
    self.model.selected = !self.model.isSelected;
    //    if ([self.model.C_STATUS_DD_NAME isEqualToString:@"已完成"] || [self.model.C_STATUS_DD_NAME isEqualToString:@"退单"]) {
    //        self.model.selected = NO;
    //    }
    [sender setImage:[UIImage imageNamed:self.model.isSelected ? @"选中" : @"未选中"] forState:UIControlStateNormal];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CGCAppointmentCell";
    CGCAppointmentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    return cell;
    
}

- (void)reloadCellWithModel:(CGCAppointmentModel *)model{
    
    
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.C_HEADIMGURL] placeholderImage:nil];
    
    if (model.C_HEADIMGURL.length==0) {
        self.iconLab.text=[model.C_A41500_C_NAME substringToIndex:1];
    }
    
    if ([model.C_SEX_DD_NAME isEqualToString:@"女"]) {
        
        self.sexImg.image=[UIImage imageNamed:@"iv_women"];
    }else if ([model.C_SEX_DD_NAME isEqualToString:@"男"]){
        
        self.sexImg.image=[UIImage imageNamed:@"iv_man"];
    }else{
        
        self.sexImg.hidden=YES;
    }
    
    self.timeLab.text=model.D_BOOK_TIME;
    self.nameLab.text=model.C_A41500_C_NAME;
    NSString *str;
    if (model.C_PHONE.length > 0) {
        if ([[NewUserSession  instance].configData.IS_TELEPHONEPRIVACY isEqualToString:@"0"]) {
            str = model.C_PHONE;
        } else {
            str = [model.C_PHONE stringByReplacingCharactersInRange:NSMakeRange(5, 3) withString:@"***"];
        }
        
    }
    self.telLab.text=str;
    self.statusLab.text=model.IS_ARRIVE_SHOP;
    self.detailLab.text=model.USER_NAME;
    if ([model.IS_ARRIVE_SHOP isEqualToString:@"已取消"]) {
        self.statusLab.textColor=DBColor(153,153,153);
    }
    if ([model.IS_ARRIVE_SHOP isEqualToString:@"已到店"]) {
        self.statusLab.textColor=DBColor(129,222,92);
    }
    if ([model.IS_ARRIVE_SHOP isEqualToString:@"未到店"]) {
        self.statusLab.textColor=DBColor(252,126,111);
    }
}


- (void)reloadOrderCellWithModel:(CGCOrderDetailModel *)model{
    self.iconLab.hidden=YES;
    NSString *str;
    if (model.C_PHONE.length > 0) {
        if ([[NewUserSession  instance].configData.IS_TELEPHONEPRIVACY isEqualToString:@"0"]) {
            str = model.C_PHONE;
        } else {
            str = [model.C_PHONE stringByReplacingCharactersInRange:NSMakeRange(5, 3) withString:@"***"];
        }
        
    }
    
    self.phoneLabel.text = model.D_START_TIME;
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.C_HEADIMGURL] placeholderImage:nil];
    
    if (model.C_HEADIMGURL.length==0) {
        self.iconLab.hidden=NO;
        if (model.C_BUYNAME.length > 0) {
            self.iconLab.text=[model.C_BUYNAME substringToIndex:1];
        }
        
    }
    
    if ([model.C_SEX_DD_NAME isEqualToString:@"女"]) {
        self.sexImg.hidden=NO;
        self.sexImg.image=[UIImage imageNamed:@"iv_women"];
    }else if ([model.C_SEX_DD_NAME isEqualToString:@"男"]){
        self.sexImg.hidden=NO;
        self.sexImg.image=[UIImage imageNamed:@"iv_man"];
    }else{
        
        self.sexImg.hidden=YES;
    }
    
    self.nameLab.text=model.C_BUYNAME;
    //    self.telLab.text=[NSString stringWithFormat:@"编号:%@",model.C_VOUCHERID];
    
    
    self.telLab.text=[NSString stringWithFormat:@"%@ %@-%@",(model.C_SPD?:@""),model.C_A70600_C_NAME, model.C_A49600_C_NAME];
    
    
    self.statusLab.text=model.C_STATUS_DD_NAME;
    //    [self.statusBtn setTitleNormal:model.C_STATUS_DD_NAME];
    self.detailLab.text=model.C_OWNER_ROLENAME;
    
    
    if ([model.C_STATUS_DD_ID isEqualToString:@"A42000_C_STATUS_0013"]) {//出库
        self.statusLab.textColor = KNaviColor;
    }
    
    if ([model.C_STATUS_DD_ID isEqualToString:@"A42000_C_STATUS_0001"]) {//全款
        self.statusLab.textColor = DBColor(232, 91, 152);
    }
    
    if ([model.C_STATUS_DD_ID isEqualToString:@"A42000_C_STATUS_0003"]) {//退单
        self.statusLab.textColor = [UIColor colorWithHex:@"#777777"];
    }
    
    if ([model.C_STATUS_DD_ID isEqualToString:@"A42000_C_STATUS_0000"]) {//新建
        self.statusLab.textColor = [UIColor redColor];
    }
    
    
    if ([model.C_STATUS_DD_ID isEqualToString:@"A42000_C_STATUS_0002"]) {//定金
        self.statusLab.textColor = KNaviColor;
    }
    
    
    [self.selectBtn setImage:[UIImage imageNamed:model.isSelected == YES ? @"选中" : @"未选中"]  forState:UIControlStateNormal];
    self.starImg.image = [UIImage imageNamed:[model.C_STAR_DD_ID isEqualToString:@"A42000_C_STAR_0000"] ? @"星标客户" : @"未星标客户"];
}


@end
