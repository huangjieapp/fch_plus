//
//  BrokerCustomVC.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/15.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "DBBaseViewController.h"
#import "PotentailCustomerListDetailModel.h"


@interface BrokerOldCustomerVC : DBBaseViewController


@property(nonatomic,strong)PotentailCustomerListDetailModel*mainModel;  //C_A41500_C_ID    还有是否战败    只用到了2个


@property(nonatomic,assign)UIViewController*popVC;  //左上角的返回按钮返回到  这个vc
@property(nonatomic,assign) BOOL isAssist;



@end
