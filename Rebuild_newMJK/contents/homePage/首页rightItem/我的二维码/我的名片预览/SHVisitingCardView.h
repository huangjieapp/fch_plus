//
//  SHVisitingCardView.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/10.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHVisitingCardView : UIView

+(instancetype)visitingCardView;

-(void)show;
-(void)hidden;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property(nonatomic,copy)void(^ClickImageButtonBlock)();

@end
