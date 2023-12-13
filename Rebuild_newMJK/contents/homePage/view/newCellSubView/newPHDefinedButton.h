//
//  newPHDefinedButton.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/2.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newPHDefinedButton : UIButton
@property (weak, nonatomic) IBOutlet UILabel *topNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomShowLabel;



+(instancetype)newPHDefinedButton;

@end
