//
//  MJKShareFolderViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/20.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKShareFolderViewController : UIViewController
- (void)backVCAction;
/** <#注释#>*/
@property (nonatomic, strong) NSString *vcName;
/** <#注释#>*/
@property (nonatomic, strong) NSString *user_id;

@property (nonatomic, strong) NSString *user_name;
@end

NS_ASSUME_NONNULL_END

