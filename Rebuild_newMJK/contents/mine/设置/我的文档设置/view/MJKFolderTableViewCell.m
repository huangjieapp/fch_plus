//
//  MJKFolderTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/7/23.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKFolderTableViewCell.h"
#import "CustomerLvevelNextFollowModel.h"
#import "MJKFolderModel.h"

@interface MJKFolderTableViewCell ()
@end

@implementation MJKFolderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFolderModel:(MJKFolderModel *)folderModel {
    _folderModel = folderModel;
    self.folderNameTF.text = folderModel.C_A70600_C_NAME;
}

- (void)setModel:(MJKFolderModel *)model {
    _model = model;
    self.folderNameTF.text = model.C_A70600_C_NAME;
}
- (IBAction)editButtonAction:(id)sender {
    if (self.buttonActionBlock) {
        self.buttonActionBlock(@"编辑");
    }
}
- (IBAction)deleteButtonAction:(id)sender {
    if (self.buttonActionBlock) {
        self.buttonActionBlock(@"删除");
    }
}
- (IBAction)changeValueTF:(UITextField *)sender {
    if (self.changeValueBlock) {
        self.changeValueBlock(sender.text);
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKFolderTableViewCell";
    MJKFolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
