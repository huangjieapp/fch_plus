//
//  CGCExpandLabelCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/15.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CGCExpandLabeSublModel;

NS_ASSUME_NONNULL_BEGIN

@interface CGCExpandLabelCell : UITableViewCell
/** <#注释#>*/
@property (nonatomic, strong) NSArray *labelArray;
+ (CGFloat)cellHeight:(NSArray *)labelArray;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** <#注释#>*/
@property (nonatomic, assign) BOOL isButtonSelected;
/** <#备注#>*/
@property (nonatomic, copy) void(^selectLabelBlock)(CGCExpandLabeSublModel *subModel);
@end

NS_ASSUME_NONNULL_END
