//
//  CGCTalkCell.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/18.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGCTalkCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titLab;

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UILabel *desLab;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
