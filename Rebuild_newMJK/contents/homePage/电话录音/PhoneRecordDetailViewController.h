//
//  PhoneRecordDetailViewController.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/25.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneRecordDetailViewController : UIViewController

@property(nonatomic,strong)NSString*C_ID;  //必传。
@property(nonatomic,weak)UIViewController*superVC;  //pop 的时候的返回的视图


@end
