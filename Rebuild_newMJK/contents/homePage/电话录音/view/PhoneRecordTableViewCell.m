//
//  PhoneRecordTableViewCell.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/24.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "PhoneRecordTableViewCell.h"

@interface PhoneRecordTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *fourPhoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *allPhoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ducationTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property(nonatomic,strong)PhoneRecordHomeSubModel*subModel;

@end

@implementation PhoneRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.statusLabel.layer.cornerRadius=3;
//    self.statusLabel.layer.borderWidth=0.5;
//    self.statusLabel.layer.borderColor=[UIColor grayColor].CGColor;
//    self.statusLabel.layer.masksToBounds=YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)getValue:(PhoneRecordHomeSubModel*)subModel{
    _subModel=subModel;
    if ( [subModel.I_DIRECTION isEqualToString:@"0"]) {
        //呼入
        NSString*number=subModel.C_CALLER;
        NSRange range=NSMakeRange(number.length-4, 4);
        NSString*fourStr=[number substringWithRange:range];
        self.fourPhoneNumberLabel.text=fourStr;
        self.allPhoneNumberLabel.text=number;
        self.iconImageView.image=[UIImage imageNamed:@"操作_呼入"];
        
        
        
    }else if ([subModel.I_DIRECTION isEqualToString:@"1"]){
        //呼出
         NSString*number=subModel.C_CALLED;
        NSRange range=NSMakeRange(number.length-4, 4);
        NSString*fourStr=[number substringWithRange:range];
        self.fourPhoneNumberLabel.text=fourStr;
        self.allPhoneNumberLabel.text=number;
        self.iconImageView.image=[UIImage imageNamed:@"操作_呼出"];

    }
    
   
    self.startTimeLabel.text=subModel.D_TIME;
    self.ducationTimeLabel.text=subModel.C_MINUTE;
    self.statusLabel.text=subModel.C_RESULT_DD_NAME;
    if ([subModel.C_RESULT_DD_NAME isEqualToString:@"未分配"]) {
        self.statusLabel.textColor=KNaviColor;
    }else{
        self.statusLabel.textColor=[UIColor blackColor];
    }
    
    
    
    
}

- (IBAction)clickButton:(id)sender {
    MyLog(@"11");
    if (self.clickPlayBlock) {
        self.clickPlayBlock(self.subModel.C_URL);
    }
    
    
}

@end
