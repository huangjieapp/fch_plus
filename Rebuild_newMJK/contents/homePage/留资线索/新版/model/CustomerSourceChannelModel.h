//
//  CustomerSourceChannelModel.h
//  match
//
//  Created by huangjie on 2022/7/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomerSourceChannelSubModel : NSObject
/** <#注释#> */
@property (nonatomic, strong) NSString * C_ID;
/** <#注释#> */
@property (nonatomic, strong) NSString * C_NAME;
/** <#注释#> */
@property (nonatomic, strong) NSString * C_STATUS_DD_ID;
/** <#注释#> */
@property (nonatomic, strong) NSString * C_STATUS_DD_NAME;
/** <#注释#> */
@property (nonatomic, strong) NSString * D_START_TIME;
/** <#注释#> */
@property (nonatomic, strong) NSString * D_END_TIME;
/** <#注释#> */
@property (nonatomic, strong) NSString * C_VOUCHERID;
/** <#注释#> */
@property (nonatomic, strong) NSString * C_CLUESOURCE_DD_ID;
/** <#注释#> */
@property (nonatomic, strong) NSString * C_CLUESOURCE_DD_NAME;
/** <#注释#> */
@property (nonatomic, strong) NSString * C_TYPE_DD_ID;
/** <#注释#> */
@property (nonatomic, strong) NSString * C_TYPE_DD_NAME;
@end



@interface CustomerSourceChannelModel : NSObject

@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSArray *list;
@end

NS_ASSUME_NONNULL_END
