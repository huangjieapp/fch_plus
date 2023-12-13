//
//  CustomerLevelModel.h
//  match
//
//  Created by huangjie on 2022/7/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomerLevelSubModel : NSObject
/** 等级id */
@property (nonatomic, strong) NSString *C_ID;
/** 等级名称 */
@property (nonatomic, strong) NSString *C_NAME;
/** 天数 */
@property (nonatomic, strong) NSString *I_NUMBER;
/** 等级code（一般都用这个code） */
@property (nonatomic, strong) NSString *C_VOUCHERID;
/** 等级名称加天数 */
@property (nonatomic, strong) NSString *C_DAYNAME;

@end


@interface CustomerLevelModel : NSObject
/** <#注释#> */
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSArray *list;
@end

NS_ASSUME_NONNULL_END
