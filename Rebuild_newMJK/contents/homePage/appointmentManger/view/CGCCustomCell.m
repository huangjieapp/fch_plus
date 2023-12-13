//
//  CGCCustomCell.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/1.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCCustomCell.h"
#import "CGCCustomModel.h"
#import "PointorderModel.h"

@implementation CGCCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImg.layer.cornerRadius=4.0;
    self.headImg.layer.masksToBounds=YES;
//    self.statusLab.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"all_bg"]];
	
}

-(void)verificationCellReloadCell:(PointorderModel *)model{
    
    
    self.selBtn.hidden=YES;
    self.AImg.hidden=YES;
    self.starImg.hidden=YES;
    self.sexImg.hidden=YES;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.smallpicture]];
    self.statusLab.text=model.status;
    self.sellNameLab.text=model.name;
    
    
}

-(void)brokerCellWithModel:(CGCCustomModel *)model{
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.C_PICURL] placeholderImage:nil];
    
    self.nameLab.text=model.C_NAME;
    self.statusLab.text=model.C_STATUS_DD_NAME;
    self.selBtn.hidden=YES;
    self.AImg.hidden=YES;
    self.starImg.hidden=YES;
    self.sexImg.hidden=YES;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CGCCustomCell";
    CGCCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    return cell;
    
}
- (void)setCellWithType:(CGCCustomCellType)cellType withModel:(CGCCustomModel *)model{

    if (cellType==CGCCustomCellNormal) {
        self.leadingWidth.constant=-10;
        self.selBtn.hidden=YES;
    }else{
        self.leadingWidth.constant=10;
        self.selBtn.hidden=NO;
    }
    
    if (model.C_PICURL.length==0) {
		if (model.C_NAME.length > 0) {
			self.iconLab.text=[model.C_NAME  substringToIndex:1];
		}
    }
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.C_PICURL] placeholderImage:nil];
    
    self.nameLab.text=model.C_NAME;
    self.statusLab.text=model.C_STATUS_DD_NAME;
    
    if ([model.C_STATUS_DD_ID isEqualToString:@"A41500_C_STATUS_0000"]) {
        
        self.statusLab.textColor=DBColor(75,176,196);
        
    }else if ([model.C_STATUS_DD_ID isEqualToString:@"A41500_C_STATUS_0004"]){
        self.statusLab.textColor=DBColor(129,222,92);
    }else if ([model.C_STATUS_DD_ID isEqualToString:@"A41500_C_STATUS_0001"]){
        self.statusLab.textColor=DBColor(252,126,111);
    }else{
        self.statusLab.textColor=DBColor(153,153,153);
    }
    
//    if ([model.C_STATUS_DD_NAME isEqualToString:@"逾期"]) {
//        self.statusLab.textColor=DBColor(252, 126, 111);
//    }else if ([model.C_STATUS_DD_NAME hasSuffix:@"订单"]) {
//        self.statusLab.textColor=DBColor(129,222,92);
//    }else if ([model.C_STATUS_DD_NAME isEqualToString:@"正常"]) {
//        self.statusLab.textColor=DBColor(75,176,196);
//    }else if ([model.C_STATUS_DD_NAME isEqualToString:@"战败"]||[model.C_STATUS_DD_NAME isEqualToString:@"申请中"]) {
//        self.statusLab.textColor=DBColor(153,153,153);
//    }
    
    if ([model.C_SEX_DD_NAME isEqualToString:@"女"]) {
        self.sexImg.image=[UIImage imageNamed:@"iv_women"];
    }else if ([model.C_SEX_DD_NAME isEqualToString:@"男"]){
        self.sexImg.image=[UIImage imageNamed:@"iv_man"];
    }else{
        self.sexImg.hidden=YES;
    }
    
    
    if ([model.C_LEVEL_DD_NAME isEqualToString:@"A类"]) {
        self.AImg.image=[UIImage imageNamed:@"A"];

    }else if ([model.C_LEVEL_DD_NAME isEqualToString:@"B类"]){
        self.AImg.image=[UIImage imageNamed:@"B"];
    }else if ([model.C_LEVEL_DD_NAME isEqualToString:@"C类"]){
         self.AImg.image=[UIImage imageNamed:@"C"];
    }else if ([model.C_LEVEL_DD_NAME isEqualToString:@"N类"]){
         self.AImg.image=[UIImage imageNamed:@"N"];
    }else if ([model.C_LEVEL_DD_NAME isEqualToString:@"H类"]){
         self.AImg.image=[UIImage imageNamed:@"H"];
    }else if ([model.C_LEVEL_DD_NAME isEqualToString:@"Z类"]){
        self.AImg.image=[UIImage imageNamed:@"Z"];
    }
    
    if ([model.C_STAR_DD_ID isEqualToString:@"A41500_C_STAR_0001"]) {
        self.starImg.image=[UIImage imageNamed:@"未星标"];
    }else if([model.C_STAR_DD_ID isEqualToString:@"A41500_C_STAR_0000"]){
        self.starImg.image=[UIImage imageNamed:@"星标"];
    }
    if (model.isSelChecked) {
        [self.selBtn setImage:@"选中"];
    }else{
        [self.selBtn setImage:@"未选中"];
    }
    self.desLab.text=model.C_ADDRESS;
    self.cusName.text=model.C_OWNER_ROLENAME;
    
    CGFloat width = self.cusName.frame.origin.x + self.desLab.frame.origin.x-170;
    [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
}
@end
