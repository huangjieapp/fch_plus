//
//  CGCAddBrokerVC.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/7/18.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "DBBaseViewController.h"
#import "SingleIntegarModel.h"

typedef enum : NSUInteger {
    CGCAddBrokerEdit,
    CGCAddBrokerAdd,
} CGCAddBrokerType;

typedef void(^ADDBROBLOCK)(void);
@interface CGCAddBrokerVC : DBBaseViewController

@property (nonatomic, strong) SingleIntegarModel *model;

@property(nonatomic,strong)NSString*portraitAddress; //头像地址    @“C_HEADIMGURL”
@property (nonatomic, copy) ADDBROBLOCK addBlock;
/** <#注释#>*/
@property (nonatomic, strong) NSString *c_id;
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_A41500_C_IDStr;
/** <#注释#>*/
@property (nonatomic, assign) CGCAddBrokerType type;
@end
