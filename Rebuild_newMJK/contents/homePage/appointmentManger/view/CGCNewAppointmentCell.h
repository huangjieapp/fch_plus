//
//  CGCNewAppointmentCell.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/8/30.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGCNewAaddAppiontModel;

@interface CGCNewAppointmentCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView ;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailWidthLayout;

@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UIImageView *rightCustomerImageView;


@property (weak, nonatomic) IBOutlet UILabel *starLab;


@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@property (weak, nonatomic) IBOutlet UITextField *telLab;

@property (weak, nonatomic) IBOutlet UIImageView *jiaoImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingWith;



- (void) hidenStar:(NSIndexPath *)indexPath withModel:(CGCNewAaddAppiontModel *)model;

- (void) hidenIcon:(NSIndexPath *)indexPath;
    
@end
