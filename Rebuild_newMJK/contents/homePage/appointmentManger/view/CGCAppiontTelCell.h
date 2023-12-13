//
//  CGCAppiontTelCell.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/8/31.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGCAppiontTelCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
 
@property (weak, nonatomic) IBOutlet UIButton *telBtn;
    
@property (weak, nonatomic) IBOutlet UILabel *numLab;
    
@end
