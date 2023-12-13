//
//  MessageCell.m
//  CarBar
//
//  Created by FishYu on 2017/10/30.
//  Copyright © 2017年 car. All rights reserved.
//

#import "MessageCell.h"

//#import "MessageListModel.h"

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

//- (void)setFrame:(CGRect)frame
//{
//
//    frame.origin.y += CellMargin;
//
//    frame.size.height -= CellMargin;
//    [super setFrame:frame];
//}
//
//- (void)cellReloadWithModel:(MessageListModel*)model{
//    
//    if ([model.read_status isEqualToString:@"true"]) {
//        self.readIcon.hidden=YES;
//    }else{
//         self.readIcon.hidden=NO;
//    }
//    
//    self.contentLab.text=[NSString stringWithFormat:@"%@",model.title ];
//    self.timeLab.text=model.create_time;
//    
//    
//}
@end
