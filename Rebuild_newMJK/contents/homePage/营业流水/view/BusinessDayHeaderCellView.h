//
//  BusinessDayHeaderCellView.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/25.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessDayHeaderCellView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property(nonatomic,copy)void(^closeBillBlock)();

@end
