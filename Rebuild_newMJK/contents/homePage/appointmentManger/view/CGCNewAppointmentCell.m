//
//  CGCNewAppointmentCell.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/8/30.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCNewAppointmentCell.h"
#import "CGCNewAaddAppiontModel.h"

@implementation CGCNewAppointmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CGCNewAppointmentCell";
    CGCNewAppointmentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
   
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    return cell;
    
}

- (void)hidenStar:(NSIndexPath *)indexPath withModel:(CGCNewAaddAppiontModel *)model{

    if (indexPath.row==0/*||indexPath.row==1*/) {
        self.starLab.text=@"*";
        self.starLab.textColor= [UIColor redColor];
    }else{
        self.starLab.text=@"";
    }
    
    if (indexPath.row==1||indexPath.row==2) {
        
        self.jiaoImg.hidden=YES;
         self.leadingWith.constant=-10;
       
    }else{
         self.jiaoImg.hidden=NO;
         self.leadingWith.constant=5;
    }

    if (indexPath.row==0) {
         self.detailLab.text=model.C_A41500_C_NAME.length>0?model.C_A41500_C_NAME:@"请选择";
    }
    
    if (indexPath.row==1) {
//        self.detailLab.text=model.C_PHONE.length>0?model.C_PHONE:@"请输入";
        self.telLab.keyboardType=UIKeyboardTypeNumberPad;
        self.telLab.hidden=NO;
        self.telLab.text=model.C_PHONE;
        
    }else{
        self.telLab.hidden=YES;
    }
    
    if (indexPath.row==2) {
        self.detailLab.text= model.D_BOOK_TIME;

    }
    
    if (indexPath.row==3) {
        self.starLab.text=@"*";
        self.starLab.textColor= [UIColor redColor];
          self.detailLab.text=model.C_MODEFOLLOW_DD_NAME.length>0?model.C_MODEFOLLOW_DD_NAME:@"请选择";
    }
    
    if (indexPath.row==4) {
        self.starLab.text=@"*";
        self.starLab.textColor= [UIColor redColor];
          self.detailLab.text=model.C_ISDRIVE_DD_NAME.length>0?model.C_ISDRIVE_DD_NAME:@"请选择";
    }
    
    if (indexPath.row==5) {
          self.detailLab.text=model.C_SEX_DD_NAME.length>0?model.C_SEX_DD_NAME:@"请选择";
    }
    
    if (indexPath.row==6) {
        self.detailLab.text=model.C_OWNER_ROLENAME.length>0?model.C_OWNER_ROLENAME:@"请选择";
    }
    
    if (indexPath.row==7) {
        self.detailLab.text=model.X_REMARK.length>0?model.X_REMARK:@"";
    }
    
    self.titLab.text=@[@"客户姓名",@"手机号码",@"预约时间",@"邀约类型",@"邀约目标",@"性别",@"邀约人",@"预约备注"][indexPath.row];
    
    
}
    
- (void) hidenIcon:(NSIndexPath *)indexPath{
  
    self.titLab.text=@[@"客户姓名",@"手机号码",@"性别",@"来源",@"渠道",@"等级",@"预算",@"购车阶段",@"创建时间",@"预约时间",@"邀约类型",@"邀约目标",@"是否到店",@"邀约人",@"到店时间",@"预约备注"][indexPath.row];
    self.starLab.text=@"";
    self.leadingWith.constant=-10;
    self.jiaoImg.hidden=YES;
    self.telLab.hidden=YES;
    
    

}
    

@end
