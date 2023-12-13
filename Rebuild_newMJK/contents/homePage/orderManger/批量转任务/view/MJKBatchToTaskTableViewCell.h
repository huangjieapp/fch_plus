//
//  MJKBatchToTaskTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/15.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ServiceTaskDetailModel;

typedef NS_ENUM(NSInteger,ChooseBatchType){
    ChooseTableViewTaskType,
    ChooseTableViewSale,
    ChooseTableTypeDateToMimute, //全时间   跟进时间   2017-04-10 HH:mm:ss
    
};

NS_ASSUME_NONNULL_BEGIN

@interface MJKBatchToTaskTableViewCell : UITableViewCell
/** MJKOrderMoneyListModel*/
@property (nonatomic, strong) ServiceTaskDetailModel *model;
/** <#注释#>*/
@property (nonatomic, weak) UIViewController *rootVC;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSale;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEndTime;
@property (weak, nonatomic) IBOutlet UITextField *textFieldStartTime;
@property (weak, nonatomic) IBOutlet UITextField *textFieldType;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic, copy) void(^deleteButtonActionBlock)(void);
/** <#备注#>*/
@property (nonatomic, copy) void(^chooseBlock)(NSString *title, NSString *postStr, UITextField *tf);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
