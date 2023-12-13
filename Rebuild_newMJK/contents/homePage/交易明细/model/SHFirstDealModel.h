//
//  SHFirstDealModel.h
//  Mcr_2
//
//  Created by 黄佳峰 on 2017/6/15.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHFirstDealSubModel.h"

@interface SHFirstDealModel : NSObject

@property(nonatomic,strong)NSString*C_STATUS;  //状态  0 黑色  1红色的 强制修改过的交易记录
@property(nonatomic,strong)NSString*currPage;
@property(nonatomic,strong)NSString*pageSize;
@property(nonatomic,strong)NSString*dyjycount;
@property(nonatomic,strong)NSString*dyjymoney;

@property(nonatomic,strong)NSArray*content;


@end

//{
//    "C_STATUS" = 0;
//    code = 200;
//    content =     (
//                   {
//                       content =             (
//                                              {
//                                                  "c_status" = 0;
//                                                  jycount = 0;
//                                                  jymoney = "0.0";
//                                              }
//                                              );
//                   }
//                   );
//    currPage = 1;
//    dyjycount = 0;
//    dyjymoney = "0.00";
//    message = "\U64cd\U4f5c\U6210\U529f";
//    pageSize = 30;
//}


//{
//    "C_STATUS" = 0;
//    code = 200;
//    content =     (
//                   {
//                       content =             (
//                                              {
//                                                  "D_CREATE_TIME" = "2017-06-15";
//                                                  jycount = 0;
//                                                  jymoney = "0.0";
//                                              }
//                                              );
//                   },
//                   {
//                       content =             (
//                                              {
//                                                  "D_CREATE_TIME" = "2017-06-15";
//                                                  jycount = 0;
//                                                  jymoney = "0.0";
//                                              }
//                                              );
//                   }
//                   );
//    currPage = 1;
//    dyjycount = 0;
//    dyjymoney = "0.0";
//    message = "\U64cd\U4f5c\U6210\U529f";
//    pageSize = 30;
//}
