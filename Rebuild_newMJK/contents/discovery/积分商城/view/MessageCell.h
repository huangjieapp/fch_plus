//
//  MessageCell.h
//  CarBar
//
//  Created by FishYu on 2017/10/30.
//  Copyright © 2017年 car. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

//- (void)cellReloadWithModel:(MessageListModel*)model;
@end
