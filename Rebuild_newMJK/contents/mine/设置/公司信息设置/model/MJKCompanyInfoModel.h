//
//  MJKCompanyInfoModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/24.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKCompanyInfoModel : MJKBaseModel
/** <#注释#>*/
@property (nonatomic, strong) NSString *B_GSDZ_LAT;
@property (nonatomic, strong) NSString *B_GSDZ_LON;
@property (nonatomic, strong) NSString *C_ADDRESS;
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *X_PHONE;
@property (nonatomic, strong) NSString *X_REMARK;
@property (nonatomic, strong) NSArray *urlList;
@end

NS_ASSUME_NONNULL_END
