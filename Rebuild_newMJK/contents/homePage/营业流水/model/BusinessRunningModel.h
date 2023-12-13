//
//  BusinessRunningModel.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/25.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessRunningModel : MJKBaseModel

@property(nonatomic,strong)NSString*ALL_AMOUNT;
@property(nonatomic,strong)NSString*ALL_COUNT;
@property(nonatomic,strong)NSString*countNumber;
@property(nonatomic,strong)NSArray*content;

@property(nonatomic,strong)NSString*MONTHNAME;   //xx年xx月

@end






//"ALL_AMOUNT" = "9655.20";
//"ALL_COUNT" = 11;
//code = 200;
//content =     (
//               {
//                   AMOUNT = "555.00";
//                   COUNT = 1;
//                   "C_ID" = "67abae24-af66-11e7-97f7-00163e0ceec2";
//                   "C_STATUS" = 0;
//                   "D_CREATE_TIME" = "2017\U5e7410\U670813\U65e5";
//               },
//               {
//                   AMOUNT = "100.20";
//                   COUNT = 5;
//                   "C_ID" = "3d2785d2-ae9d-11e7-97f7-00163e0ceec2";
//                   "C_STATUS" = 0;
//                   "D_CREATE_TIME" = "2017\U5e7410\U670812\U65e5";
//               },
//               {
//                   AMOUNT = "9000.00";
//                   COUNT = 5;
//                   "C_ID" = "e82c15d6-ad0a-11e7-97f7-00163e0ceec2";
//                   "C_STATUS" = 1;
//                   "D_CREATE_TIME" = "2017\U5e7410\U670810\U65e5";
//               }
//               );
//countNumber = 3;
//currPage = 2;
//message = "\U64cd\U4f5c\U6210\U529f";
//pageSize = 10;
