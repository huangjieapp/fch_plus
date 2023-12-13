//
//  MJKPhoneFlowMineModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/11.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKPhoneFlowMineModel : MJKBaseModel

@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *statusCode;
@property (nonatomic, strong) NSString *shopTimesCode;
@property (nonatomic, strong) NSString *saleCode;
@property (nonatomic, strong) NSString *marketCode;
@property (nonatomic, strong) NSString *arraiveShopCode;
@property (nonatomic, strong) NSString *proceTimeCode;
@property (nonatomic, strong) NSString *marketID;

@property (nonatomic, strong) NSString *START_TIME;
@property (nonatomic, strong) NSString *END_TIME;
@property (nonatomic, strong) NSString *DEAL_START_TIME;
@property (nonatomic, strong) NSString *DEAL_END_TIME;


@end
