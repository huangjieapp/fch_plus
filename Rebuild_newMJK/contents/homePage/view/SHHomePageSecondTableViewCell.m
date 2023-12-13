//
//  SHHomePageSecondTableViewCell.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/3.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHHomePageSecondTableViewCell.h"
//#import "KKNoticeView.h"
#import "ADRollModel.h"
#import "ADRollView.h"

#import "NoticeInfoModel.h"

#import "MJKManagerModuleViewController.h"
#import "NoticeInfoDetailViewController.h"

@interface SHHomePageSecondTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *adBGView;

@property (nonatomic, strong) ADRollView *adRollView;

@property (nonatomic,strong) NSMutableArray *noticeTitles; //保存rollModel
@property(nonatomic,strong)NSMutableArray*allDatas;


@end

@implementation SHHomePageSecondTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.adRollView = [[ADRollView alloc] initWithFrame:self.adBGView.frame];
   
    
    //点击公告内容
    __weak __typeof(self)weakSelf = self;
    self.adRollView.clickBlock = ^(NSInteger index) {
        UIViewController*superVC=[DBTools getSuperViewWithsubView:weakSelf];
        NoticeInfoDetailViewController*vc=[[NoticeInfoDetailViewController alloc]init];
        vc.allDatas=weakSelf.allDatas;
        [superVC.navigationController pushViewController:vc animated:YES];
    };
    
    [_adBGView addSubview:self.adRollView];

    
    
}




- (IBAction)clickAll:(id)sender {
    MyLog(@"clickAll");
      UIViewController*mainVC=[DBTools getSuperViewWithsubView:self];
    MJKManagerModuleViewController*vc=[[MJKManagerModuleViewController alloc]init];
    [mainVC.navigationController pushViewController:vc animated:YES];
    
 
}


-(void)getNoticeValue:(NSMutableArray*)mtArray{
    self.allDatas=mtArray;
    for (NoticeInfoModel*model in mtArray) {
        ADRollModel *newModel = [[ADRollModel alloc] init];
        newModel.noticeType = @"通知";
        newModel.noticeTitle = model.C_TITLE;
        newModel.addTime = nil;
        newModel.urlString = nil;
     
        [self.noticeTitles addObject:newModel];
        
    }
    
    
    
      [self.adRollView stopTimer];
      [self.adRollView setVerticalShowDataArr:self.noticeTitles];
      [self.adRollView start];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//-(void)setNoticeTitles:(NSMutableArray *)noticeTitles{
////    self
//    
//}


- (NSMutableArray *)noticeTitles
{
    if (!_noticeTitles) {
        _noticeTitles = [NSMutableArray array];
    }
    return _noticeTitles;
}

@end
