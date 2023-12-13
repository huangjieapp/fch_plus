//
//  CustomerPCModel.h
//  match
//
//  Created by huangjie on 2022/7/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomerPCSubModel : NSObject
/** 市id */
@property (nonatomic, strong) NSString *value;
/** 市名称 */
@property (nonatomic, strong) NSString *label;
/** 市下面市的数量 */
@property (nonatomic, strong) NSString *childrenCount;
@end

@interface CustomerPCModel : NSObject
/** 省id */
@property (nonatomic, strong) NSString *value;
/** 省名称 */
@property (nonatomic, strong) NSString *label;
/** 省下面市的数量 */
@property (nonatomic, strong) NSString *childrenCount;
/** 市 */
@property (nonatomic, strong) NSArray *children;


@property (nonatomic, strong) NSString *C_ADDRESS;
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_NAME;
@property (nonatomic, strong) NSString *C_PHONE;
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
@property (nonatomic, strong) NSArray *child;
@end

NS_ASSUME_NONNULL_END
