//
//  SendMessagePublicTableViewCell.h
//  Mcr_2
//
//  Created by bipi on 2017/4/16.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendMessagePublicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *PhoneLabel;
@property (strong, nonatomic) IBOutlet UIButton *favBtn;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn;
@property (strong, nonatomic) IBOutlet UIImageView *imgLeft;

@property (strong, nonatomic) IBOutlet UIImageView *imgRight;
@end
