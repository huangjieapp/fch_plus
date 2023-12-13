//
//  SHDealDetailHeaderView.m
//  Mcr_2
//
//  Created by 黄佳峰 on 2017/6/15.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import "SHDealDetailHeaderView.h"

@implementation SHDealDetailHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    NSString*aa=@"1555.11";
    NSString*moneyValue=[DBTools addSeparatorForPriceString:aa];
    NSMutableAttributedString*str1=[[NSMutableAttributedString alloc]initWithString:moneyValue attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    NSMutableAttributedString*str2=[[NSMutableAttributedString alloc]initWithString:@"  元" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [str1 appendAttributedString:str2];
    self.moneyLabel.attributedText=str1;
    
    
    NSString*numberStr=@"3";
    NSMutableAttributedString*strr1=[[NSMutableAttributedString alloc]initWithString:@"合计" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    NSMutableAttributedString*strr2=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"  %@笔",numberStr] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [strr1 appendAttributedString:strr2];
    self.numberLabel.attributedText=strr1;
    
    
}


- (IBAction)clickManalAdd:(id)sender {
    if (self.clickAddBlock) {
        self.clickAddBlock();
    }
   
}


- (IBAction)clickForceChange:(id)sender {
    if (self.clickChangeBlock) {
        self.clickChangeBlock();
    }
    
}


@end
