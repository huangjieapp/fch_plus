//
//  MJKOrganizationalViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2018/12/18.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKOrganizationalModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKOrganizationalViewController : UIViewController
/** 选中的组织架构*/
@property (nonatomic, copy) void(^selectOrganizationalModelBlock)(MJKOrganizationalModel *model);
@end

NS_ASSUME_NONNULL_END
