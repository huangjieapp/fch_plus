//
//  MJKFlowProcessCustomerInfoCell.h
//  Rebuild_newMJK
//
//  Created by mac on 2018/12/3.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKFlowProcessCustomerInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *toCustomDetailButton;
@property (weak, nonatomic) IBOutlet UILabel *mustbeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectCustomerButton;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTFRightLayout;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITextField *peopleCountTF;
@property (weak, nonatomic) IBOutlet UIButton *subButton;
/** <#备注#>*/
@property (nonatomic, copy) void(^textBeginEditBlock)(void);
@property (nonatomic, copy) void(^textEndEditBlock)(void);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
