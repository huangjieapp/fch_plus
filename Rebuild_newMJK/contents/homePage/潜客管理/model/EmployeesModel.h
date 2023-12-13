//
//  EmployeesModel.h
//  match
//
//  Created by huangjie on 2022/8/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmployeesSubModel : NSObject
/** <#注释#> */
@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *phonenumber;
@property (nonatomic, strong) NSString *u031Id;
@property (nonatomic, strong) NSString *u051Id;
@property (nonatomic, getter=isSelected) BOOL selected;
@end

@interface EmployeesModel : NSObject
/** <#注释#> */
@property (nonatomic, strong) NSString *storeName;
@property (nonatomic, strong) NSArray *userList;
/** <#注释#> */
@property (nonatomic, getter=isSelected) BOOL selected;
@end

NS_ASSUME_NONNULL_END
