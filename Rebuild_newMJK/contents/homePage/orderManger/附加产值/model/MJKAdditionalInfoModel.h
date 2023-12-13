//
//  MJKAdditionalInfoModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/9/29.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKAdditionalInfoModel : MJKBaseModel

@property (nonatomic, strong) NSString *C_ADDRESS;
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_NAME;
@property (nonatomic, strong) NSString *C_PHONE;

@property (nonatomic, strong) NSString *dictValue;
@property (nonatomic, strong) NSString *dictLabel;


@property (nonatomic, strong) NSArray *children;
@property (nonatomic, strong) NSString *childrenCount;
@property (nonatomic, strong) NSString *C_C_ID;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *value;
@end



NS_ASSUME_NONNULL_END
