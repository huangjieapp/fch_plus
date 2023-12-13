//
//  BusinessDayViewController.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/25.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessDayViewController : UIViewController

@property(nonatomic,strong)NSString*C_A46300_C_ID;  //当日交易记录id（不传取当天）  没有值就不传
@property(nonatomic,strong)NSString*D_CREATE_TIME;  //哪天点进来传哪天（格式年月日时分秒）

@end
