//
//  CustomerDetailFirstRowTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/22.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarSourceDetailFirstRowTableViewCell : UITableViewCell




@property (weak, nonatomic) IBOutlet UIButton *cardButton;

@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property(nonatomic,strong)NSString*remarkText;    //备注
@property(nonatomic,strong)NSMutableArray*numberArray;  //8个按钮所对应的数据

@property(nonatomic,copy)void(^clickTopThreeButtonBlock)(NSInteger index);   //0  1  2
@property(nonatomic,copy)void(^clickBottomEightButtonBlock)(NSInteger index);  //0 1 2 3 4 5 6 7 8

@property (nonatomic, copy) NSString *type;
+ (instancetype)cellWithTableView:(UITableView *)tableView withType:(NSString *)strType;
@end
