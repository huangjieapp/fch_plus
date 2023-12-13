//
//  SetManagementModel.h
//  match
//
//  Created by huangjie on 2022/8/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SetManagementSubModel : MJKBaseModel

@property (nonatomic, strong) NSString *CODE;
@property (nonatomic, strong) NSString *ISBUY;
@property (nonatomic, strong) NSString *ISCHECK;
@property (nonatomic, strong) NSString *NAME;
@end

@interface SetManagementModel : MJKBaseModel
/** <#注释#> */
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_NAME;
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;
@property (nonatomic, strong) NSString *C_VOUCHERID;
@property (nonatomic, strong) NSArray *defaultList;
@end

NS_ASSUME_NONNULL_END
