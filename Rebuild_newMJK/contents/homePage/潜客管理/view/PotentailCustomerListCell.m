//
//  PotentailCustomerListCell.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "PotentailCustomerListCell.h"

@interface PotentailCustomerListCell()
@property (weak, nonatomic) IBOutlet UIImageView *mainImageV;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageV;
@property (weak, nonatomic) IBOutlet UILabel *FirstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageV;
@property (weak, nonatomic) IBOutlet UIImageView *starImageV;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *salerLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *all_bg;

//18 和  50
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeftHorValue;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;


@end

@implementation PotentailCustomerListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mainImageV.layer.cornerRadius=6;
    self.mainImageV.layer.masksToBounds=YES;
    self.FirstNameLabel.layer.cornerRadius=6;
    self.FirstNameLabel.layer.masksToBounds=YES;
    self.FirstNameLabel.hidden=YES;
//    self.statusLabel.layer.cornerRadius=5;
//    self.statusLabel.layer.masksToBounds=YES;
//    self.statusLabel.layer.borderWidth=0.5;
//    self.statusLabel.layer.borderColor=KColorGrayTitle.CGColor;
    
	
    self.imageLeftHorValue.constant=18;
    self.selectButton.hidden=YES;
    self.selectButton.userInteractionEnabled=NO;
    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"未打钩"] forState:UIControlStateNormal];
    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"打钩"] forState:UIControlStateSelected];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    // Configure the view for the selected state
}

- (void)setAfterModel:(MJKOldCustomerSalesModel *)afterModel  {
    _afterModel = afterModel;
    self.nameLabel.text = afterModel.C_KH_NAME;
    self.phoneLabel.text = [NSString  stringWithFormat:@"%@-%@",  afterModel.C_A70600_C_NAME, afterModel.C_A49600_C_NAME];
    self.detailLabel.text = [NSString stringWithFormat:@"车架号%@", afterModel.C_JTXH];
    self.statusLabel.text = afterModel.C_STATUS_DD_NAME;
    self.salerLabel.text = afterModel.C_OWNER_ROLENAME;
    self.FirstNameLabel.hidden=NO;
    if (afterModel.C_KH_NAME.length>=1) {
        NSString*firstStr=[afterModel.C_KH_NAME substringToIndex:1];
        self.FirstNameLabel.text=firstStr;

    }
    self.genderImageV.hidden =  self.starImageV.hidden = self.levelImageV.hidden = YES;
    if ([afterModel.C_STATUS_DD_ID isEqualToString:@"A81500_C_STATUS_0002"]) {//通过
        
        self.statusLabel.textColor=DBColor(75,176,196);
        
    }else if ([afterModel.C_STATUS_DD_ID isEqualToString:@"A81500_C_STATUS_0001"]){//待审核
        self.statusLabel.textColor=DBColor(129,222,92);
    }else if ([afterModel.C_STATUS_DD_ID isEqualToString:@"A81500_C_STATUS_0000"]){//未完成
        self.statusLabel.textColor=DBColor(252,126,111);
    }else{
         self.statusLabel.textColor=DBColor(153,153,153);
    }
}


#pragma mark  --set
-(void)setDetailModel:(PotentailCustomerListDetailModel *)model{
    _detailModel=model;
	if (model.isSelected == YES) {
		[self.selectButton setBackgroundImage:[UIImage imageNamed:@"打钩"] forState:UIControlStateNormal];
	} else {
		
		[self.selectButton setBackgroundImage:[UIImage imageNamed:@"未打钩"] forState:UIControlStateNormal];
	}
   
        self.nameLabel.text=model.C_NAME;
    
    
    if (model.C_A41200_C_NAME.length > 0) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",model.C_PHONE,model.C_A41200_C_NAME]];
        [str addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10.f], NSForegroundColorAttributeName : [UIColor darkGrayColor]} range:NSMakeRange(model.C_PHONE.length + 1, model.C_A41200_C_NAME.length)];

        self.phoneLabel.attributedText = str;
    } else {

        self.phoneLabel.text = model.C_PHONE;
    }
//	self.phoneLabel.hidden = YES;
    if (model.C_HEADIMGURL&&![model.C_HEADIMGURL isEqualToString:@""]) {
        self.FirstNameLabel.hidden=YES;
        [self.mainImageV sd_setImageWithURL:[NSURL URLWithString:model.C_HEADIMGURL_SHOW] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];

    }else{
        self.FirstNameLabel.hidden=NO;
        if (model.C_NAME.length>=1) {
            NSString*firstStr=[model.C_NAME substringToIndex:1];
            self.FirstNameLabel.text=firstStr;

        }
        
    }
    
    
    if ([model.C_SEX_DD_NAME isEqualToString:@"女"]) {
        self.genderImageV.image=[UIImage imageNamed:@"iv_women"];
    }else if ([model.C_SEX_DD_NAME isEqualToString:@"男"]){
        self.genderImageV.image=[UIImage imageNamed:@"iv_man"];
    }
    
    else{
        self.genderImageV.image=[UIImage imageNamed:@""];
    }
    
    
    NSString*CustomType=model.C_LEVEL_DD_NAME;
    if (CustomType.length>=1) {
        NSString*sortStr=[CustomType substringToIndex:1];
        self.levelImageV.image=[UIImage imageNamed:sortStr];
        
    }
    
    
    if ([model.C_STAR_DD_ID isEqualToString:@"A41500_C_STAR_0000"]) {
        //是星标
        self.starImageV.image=[UIImage imageNamed:@"星标"];
    } else {
         self.starImageV.image=[UIImage imageNamed:@"未星标"];
    }
    
    
    if (model.C_A48200_C_NAME.length > 0 && ![model.C_A48200_C_NAME isEqualToString:@" "]) {
        
        self.detailLabel.text= [model.C_A48200_C_NAME stringByAppendingString: model.C_A49600_C_NAME];
    } else {
        self.detailLabel.text=   model.C_A49600_C_NAME;
    }
    
    
    self.statusLabel.text=model.C_STATUS_DD_NAME;
    if ([model.C_STATUS_DD_ID isEqualToString:@"A41500_C_STATUS_0000"]) {
        
        self.statusLabel.textColor=DBColor(75,176,196);
        
    }else if ([model.C_STATUS_DD_ID isEqualToString:@"A41500_C_STATUS_0004"]){
        self.statusLabel.textColor=DBColor(129,222,92);
    }else if ([model.C_STATUS_DD_ID isEqualToString:@"A41500_C_STATUS_0001"]){
        self.statusLabel.textColor=DBColor(252,126,111);
    }else{
         self.statusLabel.textColor=DBColor(153,153,153);
    }
    
    
    self.salerLabel.text=model.C_OWNER_ROLENAME;
    
	self.statusLabel.hidden = NO;
	self.salerLabel.hidden = NO;
	self.all_bg.hidden = NO;
    
}

- (void)setSeaModel:(MJKCustomerSeaSubModel *)seaModel {
	_seaModel = seaModel;
	if (seaModel.isSelected == YES) {
		[self.selectButton setBackgroundImage:[UIImage imageNamed:@"打钩"] forState:UIControlStateNormal];
	} else {
		
		[self.selectButton setBackgroundImage:[UIImage imageNamed:@"未打钩"] forState:UIControlStateNormal];
	}
    
	self.nameLabel.text=seaModel.C_NAME;
	self.phoneLabel.hidden = YES;
//	self.phoneLabel.text = seaModel.C_PHONE;
	if (seaModel.C_HEADIMGURL&&![seaModel.C_HEADIMGURL isEqualToString:@""]) {
		self.FirstNameLabel.hidden=YES;
		[self.mainImageV sd_setImageWithURL:[NSURL URLWithString:seaModel.C_HEADIMGURL] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			
		}];
		
	}else{
		self.FirstNameLabel.hidden=NO;
		if (seaModel.C_NAME.length>=1) {
			NSString*firstStr=[seaModel.C_NAME substringToIndex:1];
			self.FirstNameLabel.text=firstStr;
			
		}
		
	}
	
	
	if ([seaModel.C_SEX_DD_NAME isEqualToString:@"女"]) {
		self.genderImageV.image=[UIImage imageNamed:@"iv_women"];
	}else if ([seaModel.C_SEX_DD_NAME isEqualToString:@"男"]){
		self.genderImageV.image=[UIImage imageNamed:@"iv_man"];
	}
	
	else{
		self.genderImageV.image=[UIImage imageNamed:@""];
	}
	
	
	NSString*CustomType=seaModel.C_LEVEL_DD_NAME;
	if (CustomType.length>=1) {
		NSString*sortStr=[CustomType substringToIndex:1];
		self.levelImageV.image=[UIImage imageNamed:sortStr];
		
	}
	
	
	if ([seaModel.C_STAR_DD_ID isEqualToString:@"A41500_C_STAR_0000"]) {
		//是星标
		self.starImageV.image=[UIImage imageNamed:@"星标"];
	}else{
		self.starImageV.image=[UIImage imageNamed:@"未星标"];
	}
	
	
	self.detailLabel.text=seaModel.C_ADDRESS;
	
	self.statusLabel.hidden = NO;
    if ([seaModel.C_CHANGEINTO_DD_ID isEqualToString:@"A41500_C_CHANGEINTO_0000"]) {
        self.statusLabel.textColor = COLOR_RGB(0xF0AD4E);
    } else if ([seaModel.C_CHANGEINTO_DD_ID isEqualToString:@"A41500_C_CHANGEINTO_0001"]) {
        self.statusLabel.textColor = COLOR_RGB(0xF0AD4E);
    }else if ([seaModel.C_CHANGEINTO_DD_ID isEqualToString:@"A41500_C_CHANGEINTO_0002"]) {
        self.statusLabel.textColor = COLOR_RGB(0x4BB0C4);
    }else if ([seaModel.C_CHANGEINTO_DD_ID isEqualToString:@"A41500_C_CHANGEINTO_0003"]) {
        self.statusLabel.textColor = COLOR_RGB(0x5cb85c);
    }else if ([seaModel.C_CHANGEINTO_DD_ID isEqualToString:@"A41500_C_CHANGEINTO_0004"]) {
        self.statusLabel.textColor = COLOR_RGB(0xFF5757);
    }
	self.salerLabel.hidden = NO;
	self.all_bg.hidden = NO;
	self.statusLabel.text = seaModel.C_CHANGEINTO_DD_NAME;
	self.salerLabel.text = seaModel.C_SOURCEOWNERNAME;
}


-(void)setIsNewAssign:(BOOL)isNewAssign{
    _isNewAssign=isNewAssign;
    
    if (isNewAssign) {
        self.imageLeftHorValue.constant=50;
        self.selectButton.hidden=NO;
        self.selectButton.selected=self.detailModel.isSelected;
    	self.selectButton.selected = self.seaModel.isSelected;
     
    }else{
        self.imageLeftHorValue.constant=18;
        self.selectButton.hidden=YES;

    }
    
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"PotentailCustomerListCell";
    PotentailCustomerListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}


@end
