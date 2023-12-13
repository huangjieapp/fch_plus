//
//  MJKGroupReportListTableViewCell.h
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/12/7.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface MJKGroupReportListTableViewCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) NSString *tableType;
/** <#注释#> */
@property (nonatomic, strong) NSArray *dataArray;
/** <#注释#>*/
@property (nonatomic, copy) void(^backToDetailBlock)(NSString *code);

@end

NS_ASSUME_NONNULL_END
