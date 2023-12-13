//
//  MJKWordsArtTemplateCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/20.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKWordsArtTemplateModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKWordsArtTemplateCell : UITableViewCell
/** MJKWordsArtTemplateModel*/
@property (nonatomic, strong) MJKWordsArtTemplateModel *model;
/** <#备注#>*/
@property (nonatomic, copy) void(^selectModelBlock)(void);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
