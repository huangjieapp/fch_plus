//
//  MJKJxInfoModel.h
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/10/10.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKJxInfoModel : MJKBaseModel
/** <#注释#> */
@property (nonatomic, strong) NSString *childrenCount;
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *value;
/** <#注释#> */
@property (nonatomic, strong) NSArray *children;
@end

NS_ASSUME_NONNULL_END
