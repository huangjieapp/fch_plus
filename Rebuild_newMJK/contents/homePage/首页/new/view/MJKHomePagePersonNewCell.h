//
//  MJKHomePagePersonCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/25.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKHomePagePersonNewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *qcodeButton;
/** <#注释#> */
@property (nonatomic,copy) void(^codeButtonActionBlock)(void);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
