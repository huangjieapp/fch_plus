//
//  SHFirstDealDetailTableViewCell.m
//  Mcr_2
//
//  Created by 黄佳峰 on 2017/6/15.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import "SHFirstDealDetailTableViewCell.h"

@implementation SHFirstDealDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark  -- set
-(void)setModel:(SHFirstDealSubModel *)model{
    _model=model;
     SHFirstSubSubModel*smallModel= model.content[0];;
    
    NSString*status=smallModel.c_status;
    NSString*countStr=smallModel.jycount;
    NSString*moneyStr=smallModel.jymoney;
    
    NSString*timeStr=model.total;
    
    self.numberLabel.text=countStr;
    self.moneyLabel.text=[DBTools addSeparatorForPriceString:moneyStr];
    //时间
    self.todayLabel.text=timeStr;
    
    
    
    if ([status isEqualToString:@"0"]) {
        self.numberLabel.textColor=[UIColor blackColor];
        self.moneyLabel.textColor=[UIColor blackColor];
    }else{
        self.numberLabel.textColor=[UIColor redColor];
        self.moneyLabel.textColor=[UIColor redColor];
    }
    
    
}


@end
