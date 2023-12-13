//
//  MJKTelephoneRobotProcessCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/21.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKTelephoneRobotProcessCell.h"

@interface MJKTelephoneRobotProcessCell ()
@property (weak, nonatomic) IBOutlet UILabel *robotContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *chatContentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *robotHeightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatHeightLayout;
@end

@implementation MJKTelephoneRobotProcessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKTelephoneRobotProcessSubModel *)model {
    _model = model;
    self.robotContentLabel.text = model.chatContent;
    self.chatContentLabel.text = model.botContent;
    
    CGSize robotSize = [model.chatContent boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size;
    self.robotHeightLayout.constant = robotSize.height;
    
    CGSize chatSize = [model.botContent boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
    self.chatHeightLayout.constant = chatSize.height;
    
}

+ (CGFloat)cellHeight:(MJKTelephoneRobotProcessSubModel *)model {
    CGSize robotSize = [model.chatContent boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size;
    
    CGSize chatSize = [model.botContent boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size;
    
    return robotSize.height + chatSize.height + 84;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKTelephoneRobotProcessCell";
    MJKTelephoneRobotProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
