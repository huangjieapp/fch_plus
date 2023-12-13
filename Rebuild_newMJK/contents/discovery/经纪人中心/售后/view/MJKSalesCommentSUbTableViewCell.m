//
//  MJKTaskCommentSUbTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/22.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKSalesCommentSUbTableViewCell.h"
#import "MJKCommentsListModel.h"

@implementation MJKSalesCommentSUbTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKCommentsListModel *)model{
    _model = model;
    NSString *desStr = model.X_REMARK;
    if (self.model.X_REMINDING.length > 0) {
        desStr = [NSString stringWithFormat:@"%@\n@%@",model.X_REMARK,model.X_REMINDINGNAME];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n@%@",model.X_REMARK,model.X_REMINDINGNAME]];
        [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:@"#99b5fa"]} range:NSMakeRange([[NSString stringWithFormat:@"%@\n",model.X_REMARK] length], model.X_REMINDINGNAME.length)];
        self.desLabel.attributedText = attStr;
    } else {
        self.desLabel.text = model.X_REMARK;
    }
    self.timeLabel.text = model.D_CREATE_TIME;
    
    if (model.fileList.count > 0) {
        CGRect frame = self.tableCommentDetailPhoto.frame;
        frame.origin.y = 80;
        self.tableCommentDetailPhoto.frame = frame;
        [self.contentView addSubview:self.tableCommentDetailPhoto];
        NSMutableArray *arr = [NSMutableArray array];
        for (MJKCommentsFileListModel *fileModel in model.fileList) {
            [arr addObject:fileModel.url];
        }
        self.tableCommentDetailPhoto.imageURLArray = arr;
        
//        y += 130;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKSalesCommentSUbTableViewCell";
    MJKSalesCommentSUbTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kBackgroundColor;
    }
    return cell;
}


- (MJKPhotoView *)tableCommentDetailPhoto {
    if (!_tableCommentDetailPhoto) {
        _tableCommentDetailPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth - 100, 110)];
        _tableCommentDetailPhoto.isEdit = NO;
        _tableCommentDetailPhoto.isCamera = NO;
        _tableCommentDetailPhoto.rootVC = self.rootVC;
        _tableCommentDetailPhoto.titleNameStr = @"回复评论";
        _tableCommentDetailPhoto.backgroundColor  = [UIColor colorWithHex:@"#efeff4"];
    }
    return _tableCommentDetailPhoto;
};
@end
