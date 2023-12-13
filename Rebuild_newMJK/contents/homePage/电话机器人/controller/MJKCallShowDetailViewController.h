//
//  MJKCallShowDetailViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/3/28.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKCallShowDetailViewController : UIViewController
/** C_ID*/
@property (nonatomic, strong) NSString *C_ID;
/** searchDataArray*/
@property (nonatomic, strong) NSArray *searchDataArray;
/** <#注释#>*/
@property (nonatomic, strong) NSString *nlpThemeId;
@end

NS_ASSUME_NONNULL_END
