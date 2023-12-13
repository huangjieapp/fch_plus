//
//  VerificationCell.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/16.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerificationCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titLab;

@property (weak, nonatomic) IBOutlet UILabel *desLab;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
