//
//  MJKHomePagePersonCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/25.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKPayModel;
@class MJKHomePageJXModel;

@interface MJKHomePagePersonCell : UITableViewCell
/** MJKPayModel*/
@property (nonatomic, strong) MJKPayModel *payModel;
/** <#备注#>*/
@property (nonatomic, copy) void(^gotoDetailPayVCBlock)(NSInteger tag);
@property (weak, nonatomic) IBOutlet UILabel *todayCompleteLabel;
@property (weak, nonatomic) IBOutlet UILabel *completeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
/** <#注释#>*/
@property (nonatomic, strong) MJKHomePageJXModel *dbModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** all data*/
@property (nonatomic, strong) NSMutableArray *allDatas;
/** announcementButtonAction block*/
@property (nonatomic, copy) void(^announcementButtonActionBlock)(void);
-(void)getNoticeValue:(NSMutableArray*)mtArray;
@end
