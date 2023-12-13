//
//  MJKOrderFullViewController.h
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/10/28.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGCOrderDetailModel;

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,FullType){
    FullTypeFull=0,
    FullTypeOut,
};

@interface MJKOrderFullViewController : DBBaseViewController
/** <#注释#> */
@property (nonatomic, assign) FullType Type;
/** <#注释#> */
@property (nonatomic, strong) CGCOrderDetailModel *omodel;
@end

NS_ASSUME_NONNULL_END
