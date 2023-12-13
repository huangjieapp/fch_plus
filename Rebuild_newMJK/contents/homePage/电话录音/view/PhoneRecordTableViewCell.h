//
//  PhoneRecordTableViewCell.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/24.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneRecordHomeModel.h"

@interface PhoneRecordTableViewCell : UITableViewCell

-(void)getValue:(PhoneRecordHomeSubModel*)subModel;
@property(nonatomic,copy)void(^clickPlayBlock)(NSString*playUrl);



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewLeftValue;

@end
