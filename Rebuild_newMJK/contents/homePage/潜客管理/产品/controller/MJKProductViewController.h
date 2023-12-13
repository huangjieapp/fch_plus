//
//  MJKProductViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/23.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKProductViewController : UIViewController
/** vc name*/
@property (nonatomic, strong) NSString *productType;
/** couster id or order id */
@property (nonatomic, strong) NSString *C_OBJECTID;
/** order customer id */
@property (nonatomic, strong) NSString *customerID;
/** 点击手动输入返回新增页*/
@property (nonatomic, copy) void(^backAddPageBlock)(void);
/** 返回添加*/
@property (nonatomic, copy) void(^backVCAddProductBlock)(NSString *str);
@end
