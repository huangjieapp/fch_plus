//
//  BusinessSubRunningModel.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/25.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessSubRunningModel : MJKBaseModel

@property(nonatomic,strong)NSString*AMOUNT;
@property(nonatomic,strong)NSString*COUNT;
@property(nonatomic,strong)NSString*C_ID;
@property(nonatomic,strong)NSString*C_STATUS;    //0是未修改，1是被修改过
@property(nonatomic,strong)NSString*D_CREATE_TIME;



@end



//{
    //                   AMOUNT = "555.00";
    //                   COUNT = 1;
    //                   "C_ID" = "67abae24-af66-11e7-97f7-00163e0ceec2";
    //                   "C_STATUS" = 0;
    //                   "D_CREATE_TIME" = "2017\U5e7410\U670813\U65e5";
    //               },
