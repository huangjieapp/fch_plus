//
//  SHChooseView.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/1.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SHSELBLOCK)(NSString *str,UIButton *btn);


@interface SHChooseView : UIView

@property (nonatomic, copy) SHSELBLOCK selBlock;

-(instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)dataArr withPicArr:(NSArray *)picArr withSel:(SHSELBLOCK )selB;
@end
