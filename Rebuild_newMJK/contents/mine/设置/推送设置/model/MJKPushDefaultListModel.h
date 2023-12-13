//
//  MJKPushDefaultListModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/16.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKPushDefaultListModel : MJKBaseModel
/** 默认推送code*/
@property (nonatomic, strong) NSString *CODE;
/** 默认推送名称*/
@property (nonatomic, strong) NSString *NAME;
/** true表示勾中
 false表示未勾中*/
@property (nonatomic, strong) NSString *ISCHECK;
@property (nonatomic, strong) NSString *ISBUY;

/** <#注释#>*/
@property (nonatomic, getter=isSelected) BOOL selected;

@end

NS_ASSUME_NONNULL_END
