//
//  MJKCustomReturnTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKCustomReturnSubModel.h"
#import "MJKCustomReturnModel.h"
@class MJKPersonalPerformanceTargetModel;

@interface MJKCustomReturnTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UISwitch *openSwitchButton;
@property (nonatomic, copy) void(^textFieldEdit)(UITextField *textField);
@property (nonatomic, copy) void(^textFieldEndEdit)(UITextField *textField);

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) MJKCustomReturnSubModel *model;
- (void)updataCell:(NSString *)customName;
- (void)updataNumberCell:(MJKCustomReturnModel *)model andTitleArray:(NSArray *)titleArray andDetail:(BOOL)isDetail andRow:(NSInteger)row andStatusArray:(NSArray *)statusArray;
- (void)updataNumberCell:(MJKPersonalPerformanceTargetModel *)model;
@property (nonatomic, copy) void(^backSelectBlock)(NSString *C_ID, NSString *boolSelect);
@property (nonatomic, copy) void(^backTextBlock)(NSString *str, NSInteger row);
/** switch button block*/
@property (nonatomic, copy) void(^openSwitchBlock)(BOOL isOn);
@end
