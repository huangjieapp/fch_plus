//
//  MJKFlowDetailViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/11.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKClueListViewModel.h"

@interface MJKFlowDetailViewController : DBBaseViewController
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) MJKClueListViewModel *clueListModel;
@property (nonatomic, strong) NSString *clueSourceName;
@property (nonatomic, copy) void(^backViewBlock)(NSString *str);
@property (nonatomic, strong) UIViewController *superVC;
@end
