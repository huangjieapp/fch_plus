//
//  ProvincesAndCityModel.h
//  match5.0
//
//  Created by huangjie on 2023/2/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProvincesAndCityModel : NSObject
/** <#注释#> */
@property (nonatomic, strong) NSArray *children;
@property (nonatomic, strong) NSString *childrenCount;
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *value;
/** <#注释#> */
@property (nonatomic, getter=isSelected) BOOL selected;
@end


NS_ASSUME_NONNULL_END
