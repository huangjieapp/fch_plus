//
//  SHDiscoveryButton.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/5.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHDiscoveryButton.h"

@implementation SHDiscoveryButton


-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.mainImageView=[[UIImageView alloc]init];
        [self addSubview:self.mainImageView];
        
        
        self.mainLabel=[[UILabel alloc]init];
        self.mainLabel.textAlignment=NSTextAlignmentCenter;
        self.mainLabel.font=[UIFont systemFontOfSize:14];
        [self addSubview:self.mainLabel];
        
//        self.mainImageView.backgroundColor=[UIColor blueColor];
//        self.mainLabel.backgroundColor=[UIColor greenColor];

        
    }
    
    return self;
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(25));
        make.height.mas_equalTo(@(25));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-20);
    
    }];
    
    
    [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.width-10);
        make.height.mas_equalTo(@(15));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).offset(20);
        
    }];

    
}


@end
