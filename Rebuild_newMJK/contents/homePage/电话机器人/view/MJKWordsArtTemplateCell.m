//
//  MJKWordsArtTemplateCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/20.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKWordsArtTemplateCell.h"

#import "MJKWordsArtTemplateModel.h"

@interface MJKWordsArtTemplateCell ()
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *playVoiceButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
/** <#注释#>*/
@property (nonatomic, strong)  MJKWordsArtTemplateModel *preModel;

@end

@implementation MJKWordsArtTemplateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKWordsArtTemplateModel *)model {
    _model = model;
    if (self.model.isSelected == YES) {
        self.selectImageView.image = [UIImage imageNamed:@"icon_1_highlight"];
    } else {
        self.selectImageView.image = [UIImage imageNamed:@"icon_1_normal"];
    }
    self.titleLabel.text = [model.nlpEventName stringByAppendingString:@" 话术模板"];
}

- (IBAction)selectButtonAction:(UIButton *)sender {
    self.model.selected = !self.model.isSelected;
    if (self.model.isSelected == YES) {
        self.selectImageView.image = [UIImage imageNamed:@"icon_1_highlight"];
    } else {
        self.selectImageView.image = [UIImage imageNamed:@"icon_1_normal"];
    }
    if (self.selectModelBlock) {
        self.selectModelBlock();
    }
}



+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKWordsArtTemplateCell";
    MJKWordsArtTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
