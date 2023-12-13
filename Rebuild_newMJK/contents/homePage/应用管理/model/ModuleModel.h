//
//  ModuleModel.h
//  match
//
//  Created by huangjie on 2022/8/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface ModuleSubModel : MJKBaseModel
/** <#注释#> */
@property (nonatomic, strong) NSString *CODE;
@property (nonatomic, assign) BOOL ISBUY;
@property (nonatomic, assign) BOOL ISCHECK;
@property (nonatomic, strong) NSString *NAME;
@end

@interface ModuleModel : MJKBaseModel
/** <#注释#> */
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_NAME;
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;
@property (nonatomic, strong) NSString *C_VOUCHERID;
@property (nonatomic, strong) NSArray *defaultList;
@end

NS_ASSUME_NONNULL_END
