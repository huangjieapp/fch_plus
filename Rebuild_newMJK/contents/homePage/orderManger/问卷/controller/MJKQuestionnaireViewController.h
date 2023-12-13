//
//  MJKQuestionnaireViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/10/8.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGCOrderDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKQuestionnaireViewController : DBBaseViewController
/** <#注释#>*/
@property (nonatomic, strong) CGCOrderDetailModel *detailModel;
/** <#注释#>*/
@property (nonatomic, strong) NSString *vcName;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_ID;
@end

NS_ASSUME_NONNULL_END
