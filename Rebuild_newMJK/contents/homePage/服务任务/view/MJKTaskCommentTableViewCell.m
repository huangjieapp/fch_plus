//
//  MJKTaskCommentTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/21.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKTaskCommentTableViewCell.h"
#import "MJKCommentsListModel.h"
#import "MJKTaskCommentModel.h"

#import "MJKTaskCommentSUbTableViewCell.h"

@interface MJKTaskCommentTableViewCell ()<UITableViewDelegate, UITableViewDataSource>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MJKTaskCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubview:self.tableView];
}

- (void)setModel:(MJKCommentsListModel *)model {
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.C_HEADIMGURL] placeholderImage:[UIImage imageNamed:@"logo"]];
    self.nameLabel.text = model.C_CREATOR_ROLENAME;
    self.timeLabel.text = model.D_CREATE_TIME;
    NSString *desStr = model.X_REMARK;
    if (self.model.X_REMINDING.length > 0) {
        desStr = [NSString stringWithFormat:@"%@\n@%@",model.X_REMARK,model.X_REMINDINGNAME];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n@%@",model.X_REMARK,model.X_REMINDINGNAME]];
        [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:@"#99b5fa"]} range:NSMakeRange([[NSString stringWithFormat:@"%@\n",model.X_REMARK] length], model.X_REMINDINGNAME.length)];
        self.desLabel.attributedText = attStr;
    } else {
        self.desLabel.text = model.X_REMARK;
    }
    CGFloat height = 0;
     CGFloat y = [desStr boundingRectWithSize:CGSizeMake(KScreenWidth - 100, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
    if (y + 55 > 80) {
        y += 55 + 10;
    } else {
        y = 80;
    }
    
    for (MJKTaskCommentModel *subModel in model.hf_list) {
        NSString *subDesStr = subModel.X_REMARK;
        if (subModel.X_REMINDING.length > 0) {
            subDesStr = [NSString stringWithFormat:@"%@\n@%@",subModel.X_REMARK,subModel.X_REMINDINGNAME];
        }
        CGFloat desHeight = [subDesStr boundingRectWithSize:CGSizeMake(KScreenWidth - 100, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
        if (desHeight + 55 > 70) {
            height += desHeight + 55;
        } else {
            height += 70;
        }
    }
    self.tableView.frame = CGRectMake(80, y, KScreenWidth - 100, height);
    
}

- (IBAction)reCommentButtonAction:(UIButton *)sender {
    if (self.reCommentActionBlock) {
        self.reCommentActionBlock();
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKTaskCommentTableViewCell";
    MJKTaskCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.hf_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKTaskCommentModel *model = self.model.hf_list[indexPath.row];
    MJKTaskCommentSUbTableViewCell *cell = [MJKTaskCommentSUbTableViewCell cellWithTableView:tableView];
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ 回复 %@",model.C_CREATOR_ROLENAME,self.model.C_CREATOR_ROLENAME]];
    [titleStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:@"#576a94"]} range:NSMakeRange(0, model.C_CREATOR_ROLENAME.length +1)];
    [titleStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:@"#576a94"]} range:NSMakeRange(model.C_CREATOR_ROLENAME.length + 4, self.model.C_CREATOR_ROLENAME.length)];
    
    cell.titleLabel.attributedText = titleStr;
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKTaskCommentModel *model = self.model.hf_list[indexPath.row];
    NSString *desStr = model.X_REMARK;
    if (model.X_REMINDING.length > 0) {
        desStr = [NSString stringWithFormat:@"%@\n@%@",model.X_REMARK,model.X_REMINDINGNAME];
    }
    CGFloat desHeight = [desStr boundingRectWithSize:CGSizeMake(KScreenWidth - 100, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
    if (desHeight + 55 > 70) {
        return desHeight + 55;
    } else {
        return 70;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.layer.cornerRadius = 5.f;
        
    }
    return _tableView;
}

@end
