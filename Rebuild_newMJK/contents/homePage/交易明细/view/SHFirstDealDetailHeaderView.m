//
//  SHFirstDealDetailHeaderView.m
//  Mcr_2
//
//  Created by 黄佳峰 on 2017/6/15.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import "SHFirstDealDetailHeaderView.h"

@implementation SHFirstDealDetailHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor=[UIColor whiteColor];
    
  
    
}

-(void)setModel:(SHFirstDealModel *)model{
    _model=model;
    
    NSString*aa=model.dyjymoney;
    NSString*moneyValue=[DBTools addSeparatorForPriceString:aa];
    NSMutableAttributedString*str1=[[NSMutableAttributedString alloc]initWithString:moneyValue attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    NSMutableAttributedString*str2=[[NSMutableAttributedString alloc]initWithString:@"  元" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [str1 appendAttributedString:str2];
    self.moneyLabel.attributedText=str1;
    
    
    NSString*numberStr=model.dyjycount;
    NSMutableAttributedString*strr1=[[NSMutableAttributedString alloc]initWithString:@"合计" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    NSMutableAttributedString*strr2=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"  %@笔",numberStr] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [strr1 appendAttributedString:strr2];
    self.numberLabel.attributedText=strr1;

    
    
    //标题
    NSDate*currentDate=[NSDate date];
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月"];
   NSString*currentYearMonth= [formatter stringFromDate:currentDate];
    self.timeLabel.text=[NSString stringWithFormat:@"%@的流水",currentYearMonth];
    
    
}


@end
