//
//  CustomerDetailViewController.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/20.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PotentailCustomerListDetailModel.h"

@interface CustomerDetailViewController : DBBaseViewController

@property(nonatomic,strong)PotentailCustomerListDetailModel*mainModel;  //C_A41500_C_ID    还有是否战败    只用到了2个
/** 协助今日*/
@property (nonatomic, strong) NSString *assistStr;

@property(nonatomic,assign)UIViewController*popVC;  //左上角的返回按钮返回到  这个vc
@property(nonatomic,assign) BOOL isAssist;

/** <#注释#>*/
@property (nonatomic, strong) NSString *getFrom;

@property(nonatomic,assign)NSInteger touchButtonIndex;

@end
