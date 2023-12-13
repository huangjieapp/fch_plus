//
//  MJKTaskNewWorkListCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/14.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKTaskNewWorkListCell.h"

#import "MJKTaskWorkListModel.h"

@interface MJKTaskNewWorkListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *colorViews;

@end

@implementation MJKTaskNewWorkListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKTaskWorkListModel *)model {
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.C_HEADIMGURL]];
    self.nameLabel.text = model.USERNAME;
    self.countLabel.text = model.timeOutCount;
    
    
    
    for (int i = 0; i < model.rwfbList.count; i++) {
        UIView *colorView = self.colorViews[i];
        NSArray *arr = model.rwfbList[i];
        for (int j = 0; j < arr.count; j++) {
            NSString *str = arr[j];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(j * colorView.frame.size.width / arr.count, 0, colorView.frame.size.width / arr.count + 7, colorView.frame.size.height)];
            if ([str isEqualToString:@"qr"]) {
                view.backgroundColor = [UIColor redColor];
            } else if ([str isEqualToString:@"wqr"]) {
                view.backgroundColor = KNaviColor;
            } else {
                view.backgroundColor = KGreenColor;
            }
            [colorView addSubview:view];
        }
    }
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKTaskNewWorkListCell";
    MJKTaskNewWorkListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
@end
