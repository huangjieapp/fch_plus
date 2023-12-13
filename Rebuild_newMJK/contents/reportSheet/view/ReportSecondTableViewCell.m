//
//  ReportSecondTableViewCell.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/5.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "ReportSecondTableViewCell.h"


@interface ReportSecondTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;


@end

@implementation ReportSecondTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)getValue:(NSDictionary*)allDatas{
    self.mainImageView.image=[UIImage imageNamed:allDatas[@"image"]];
    self.titleLabel.text=allDatas[@"title"];
    self.subLabel.text=allDatas[@"description"];
    
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
