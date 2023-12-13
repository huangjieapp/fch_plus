//
//  ServiceTaskTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/27.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "ServiceTaskTableViewCell.h"

@interface ServiceTaskTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UILabel *headImageLab;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightBottomLab;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeftHorValue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeftHorValue;
@property (weak, nonatomic) IBOutlet UILabel *highLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeOutImageView;
@property (weak, nonatomic) IBOutlet UIImageView *allBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeOutImageViewLeftLayout;

@end


@implementation ServiceTaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.sexImageV.hidden=YES;
    
    
    self.imageLeftHorValue.constant=18;
    self.selectButton.hidden=YES;
    self.selectButton.userInteractionEnabled=NO;
    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"未打钩"] forState:UIControlStateNormal];
    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"打钩"] forState:UIControlStateSelected];

    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

#pragma mark  --set
-(void)setPubMainDatasModel:(ServiceTaskSubModel *)pubMainDatasModel{
    _pubMainDatasModel=pubMainDatasModel;
    if (pubMainDatasModel.C_HEADIMGURL&&![pubMainDatasModel.C_HEADIMGURL isEqualToString:@""]) {
        self.headImageLab.hidden=YES;
        [self.headImageV sd_setImageWithURL:[NSURL URLWithString:pubMainDatasModel.C_HEADIMGURL] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];

        
    }else{
		self.headImageLab.hidden=NO;
		if (pubMainDatasModel.C_A41500_C_NAME.length>=1) {
			
			NSString*firstStr=[pubMainDatasModel.C_A41500_C_NAME substringToIndex:1];
			self.headImageLab.text=firstStr;
			
		} else {
			self.headImageLab.text=@"";
		}
		
		

    }
    
    if (self.tabType.length > 0) {
        self.nameLabel.text=[NSString stringWithFormat:@"%@ - %@",pubMainDatasModel.C_A41500_C_NAME,pubMainDatasModel.C_TYPE_DD_NAME];
        self.timeOutImageViewLeftLayout.constant = 10;
    } else {
        
        if (pubMainDatasModel.C_TYPE_DD_NAME.length <= 0) {
            self.nameLabel.text=[NSString stringWithFormat:@"%@ - 当前任务: 暂无",pubMainDatasModel.C_A41500_C_NAME];
            self.allBgView.hidden = self.startLabel.hidden = self.finishLabel.hidden = YES;
        } else {
            self.nameLabel.text=[NSString stringWithFormat:@"%@ - 当前任务: %@",pubMainDatasModel.C_A41500_C_NAME,pubMainDatasModel.C_TYPE_DD_NAME];
            self.allBgView.hidden = self.startLabel.hidden = self.finishLabel.hidden = NO;
        }
        self.timeOutImageViewLeftLayout.constant = -20;
    }
    
    
    self.detailLabel.text=pubMainDatasModel.C_ADDRESS;
	self.startLabel.text = [NSString stringWithFormat:@"开始:%@",pubMainDatasModel.ALREADYDAY];
	self.finishLabel.text = [NSString stringWithFormat:@"完成:%@",pubMainDatasModel.TIMEOUT];
	if ([pubMainDatasModel.TIMEOUT hasPrefix:@"超时"]) {
		self.timeOutImageView.hidden = NO;
	} else {
		self.timeOutImageView.hidden = YES;
	}
	
	if (pubMainDatasModel.C_TASKSTATUS_DD_NAME.length > 0) {
		self.highLabel.hidden = NO;
		self.highLabel.text = pubMainDatasModel.C_TASKSTATUS_DD_NAME;
		if ([pubMainDatasModel.C_TASKSTATUS_DD_NAME isEqualToString:@"高"]) {
			self.highLabel.backgroundColor = COLOR_RGB(0xFC1500);
		} else if ([pubMainDatasModel.C_TASKSTATUS_DD_NAME isEqualToString:@"中"]) {
			self.highLabel.backgroundColor = COLOR_RGB(0xFACB49);
		} else {
			self.highLabel.backgroundColor = COLOR_RGB(0x748E8E);
		}
	} else {
		self.highLabel.hidden = YES;
	}
	
	
    self.statusLabel.text=pubMainDatasModel.C_STATUS_DD_NAME;
	if ([pubMainDatasModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0003"]) {
		self.statusLabel.textColor = DBColor(248, 106, 95) ;
	} else if ([pubMainDatasModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0001"]) {
		self.statusLabel.textColor = DBColor(114, 218, 73);
	} /*else if ([pubMainDatasModel.C_STATUS_DD_NAME isEqualToString:@"退回"]) {
		self.statusLabel.textColor = DBColor(189, 189, 189);
	} else if ([pubMainDatasModel.C_STATUS_DD_NAME isEqualToString:@"执行中"]) {
		self.statusLabel.textColor = DBColor(240,173,78);
	}*/ else if ([pubMainDatasModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0004"]) {
		self.statusLabel.textColor = DBColor(62, 161, 183);
	} else if ([pubMainDatasModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0005"]) {
		self.statusLabel.textColor = DBColor(189, 189, 189);
	}
    
    self.rightBottomLab.text=pubMainDatasModel.C_OWNER_ROLENAME;
    
}

-(void)setPubOrderDatasModel:(ServiceOrderSubModel *)pubOrderDatasModel{
    _pubOrderDatasModel=pubOrderDatasModel;
    if (pubOrderDatasModel.C_HEADIMGURL&&![pubOrderDatasModel.C_HEADIMGURL isEqualToString:@""]) {
        self.headImageLab.hidden=YES;
        [self.headImageV sd_setImageWithURL:[NSURL URLWithString:pubOrderDatasModel.C_HEADIMGURL] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        
    }else{
        self.headImageLab.hidden=NO;
        if (pubOrderDatasModel.C_A41500_C_NAME.length>=1) {
            NSString*firstStr=[pubOrderDatasModel.C_A41500_C_NAME substringToIndex:1];
            self.headImageLab.text=firstStr;
            
        }
        
    }
    
    
    self.nameLabel.text=[NSString stringWithFormat:@"%@ - %@",pubOrderDatasModel.C_A41500_C_NAME,pubOrderDatasModel.C_TYPE_DD_NAME];
    
    self.detailLabel.text=pubOrderDatasModel.C_ADDRESS;
    
    
    self.statusLabel.text=pubOrderDatasModel.C_STATUS_DD_NAME;
	if ([pubOrderDatasModel.C_STATUS_DD_NAME isEqualToString:@"未完成"]) {
		self.statusLabel.textColor = DBColor(255, 87, 87);
	}
	if ([pubOrderDatasModel.C_STATUS_DD_NAME isEqualToString:@"完成"]) {
		self.statusLabel.textColor = DBColor(75, 176, 196);
	}
    
    self.rightBottomLab.text=pubOrderDatasModel.C_OWNER_ROLENAME;

    
    
}




-(void)setIsNewAssign:(BOOL)isNewAssign{
    _isNewAssign=isNewAssign;
    
    if (isNewAssign) {
        self.imageLeftHorValue.constant=50;
        self.selectButton.hidden=NO;
        //只有服务任务有
        self.selectButton.selected=self.pubMainDatasModel.isSelected;
        
        
    }else{
        self.imageLeftHorValue.constant=18;
        self.selectButton.hidden=YES;
        
    }
    
    
}

@end
