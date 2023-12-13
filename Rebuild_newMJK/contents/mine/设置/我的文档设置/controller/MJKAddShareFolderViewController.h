//
//  MJKAddShareFolderViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/2.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKTypeFolderModel;

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ShareFolderAdd,
    ShareFolderEdit,
} ShareFolderType;

@interface MJKAddShareFolderViewController : DBBaseViewController
/** MJKFolderModel*/
@property (nonatomic, strong) MJKTypeFolderModel *model;
/** ShareFolderType*/
@property (nonatomic, assign) ShareFolderType type;
/** <#注释#>*/
@property (nonatomic, strong) NSString *vcName;
@end

NS_ASSUME_NONNULL_END
