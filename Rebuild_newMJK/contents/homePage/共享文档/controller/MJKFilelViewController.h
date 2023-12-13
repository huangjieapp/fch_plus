//
//  MJKFolderDetailViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/2.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKFilelViewController : DBBaseViewController
/** titleStr*/
@property (nonatomic, strong) NSString *titleStr;
/** 如果是文件夹列表，传入文件分类id*/
@property (nonatomic, strong) NSString *C_A70600_C_ID;
@property (nonatomic, strong) NSString *C_A70600_C_NAME;
@end

NS_ASSUME_NONNULL_END
