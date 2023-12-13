//
//  CGCTalkTable.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/18.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCTalkTable.h"
#import "CGCTalkCell.h"
#import "CGCTalkModel.h"
#import "CGCOtherTalkModel.h"
#import "CGCTalkDetailModel.h"
#import "CGCPicCell.h"
#import "CGCPicTextCell.h"
#import "MJKTemplateSendView.h"

#define HIDEHEAD

@interface CGCTalkTable()<UITableViewDelegate,UITableViewDataSource>
{

    CGCTalkTableStyle _style;
    EidtStyle _eidtStyle;
    
}

@property (nonatomic, strong) UIView *headSelView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSMutableArray *headTitleArr;

@property (nonatomic, strong) UIButton *selBtn;

@property (nonatomic, copy) NSString *selBtnStr;

@end

@implementation CGCTalkTable


- (instancetype)initWithFrame:(CGRect)frame withTitleArr:(NSArray *)titleArr withStyle:(CGCTalkTableStyle)style withEidt:(EidtStyle)eidtStyle{
    
    if (self=[super initWithFrame:frame]) {
        self.indexPath=[NSIndexPath indexPathForRow:999 inSection:999];
        self.headTitleArr=[NSMutableArray arrayWithArray:titleArr];
        _style=style;
        _eidtStyle=eidtStyle;
        self.selBtnStr=@"123";
        [self addSubview:self.tableView];
       
    }
  
    return self;
}



#pragma mark --- tableViewDelegate



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (_style==CGCTalkTableTemplate
        ||_style==CGCTalkTableVideo
        ||_style==CGCTalkTableVoice
        ||_style==CGCTalkTablePic_Text
        ||_style==CGCTalkTablePic
        ||_style==CGCTalkTableFile) {
    
        return 1;
    }
    
    
    CGCTalkModel * model=[self.dataArray firstObject];
    return model.array.count>0?self.dataArray.count:1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_style==CGCTalkTableTemplate
        ||_style==CGCTalkTableVideo
        ||_style==CGCTalkTableVoice
        ||_style==CGCTalkTablePic_Text
        ||_style==CGCTalkTablePic
        ||_style==CGCTalkTableFile) {
        
        return self.dataArr.count;
    }
    
    
    if (self.dataArray.count==0) {
        return 0;
    }
    CGCTalkModel * model=self.dataArray[section];
    return model.array.count>0?model.array.count:self.dataArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
       if (_style==CGCTalkTableText) {
           CGCTalkModel *model=self.dataArray[indexPath.section];
           CGCTalkDetailModel * desModel=[self.dataArray[indexPath.section] array][indexPath.row];

        CGCTalkCell * cell= [CGCTalkCell cellWithTableView:tableView];
        
		   
        if (model.array.count>0) {
			cell.iconImg.hidden = YES;
			cell.collectionButton.hidden = NO;
			cell.collectionButton.tag = indexPath.row;
//			if ([desModel.ISCOLLECTION isEqualToString:@"true"]) {
//				[cell.collectionButton setImage:@"星星-黄色"];
//				cell.collectionButton.selected = YES;
//			}else{
				[cell.collectionButton setImage:@"星星-灰色"];
				cell.collectionButton.selected = NO;
//			}
			[cell.collectionButton addTarget:self action:@selector(collectionButtonAction:)];
            cell.titLab.text=desModel.C_NAME;
            cell.desLab.text=desModel.X_PICCONTENT;
        }else{
			cell.iconImg.hidden = YES;
			cell.desLabelRightLayout.constant = 10;
			cell.collectionButton.hidden = YES;
			if (self.indexPath==indexPath) {
				[cell.iconImg setImage:[UIImage imageNamed:@"选中"]];
			}else{
				[cell.iconImg setImage:[UIImage imageNamed:@"未选中"]];
			}
             CGCTalkModel *model=self.dataArray[indexPath.row];
            cell.titLab.text=model.C_NAME;
            cell.desLab.text=model.X_PICCONTENT;
        }
        return cell;
    }
   
   
    if (_style==CGCTalkTablePic) {
        
        CGCOtherTalkModel *model=self.dataArr[indexPath.row];
        
        CGCPicCell* cell=[CGCPicCell cellWithTableView:tableView];
        
        
        if (self.indexPath==indexPath) {
            [cell.selIconImg setImage:[UIImage imageNamed:@"选中"]];
        }else{
            [cell.selIconImg setImage:[UIImage imageNamed:@"未选中"]];
        }
        [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:model.X_MEDIAURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        cell.titLab.text=model.X_PICCONTENT;
        return cell;
    }
    if (_style==CGCTalkTableVideo||_style==CGCTalkTableVoice||_style==CGCTalkTablePic_Text||_style==CGCTalkTableTemplate||_style==CGCTalkTableFile) {
        CGCPicTextCell * cell=[CGCPicTextCell cellWithTableView:tableView];
        
        if (self.indexPath==indexPath) {
            [cell.selIconImg setImage:[UIImage imageNamed:@"选中"]];
        }else{
            [cell.selIconImg setImage:[UIImage imageNamed:@"未选中"]];
        }
        CGCOtherTalkModel *model=self.dataArr[indexPath.row];
        [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:model.X_MEDIAURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        cell.titLab.text=model.X_PICCONTENT;
        return cell;
 
    }
    
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    
//    if (_style==CGCTalkTableTemplate
//        ||_style==CGCTalkTableVideo
//        ||_style==CGCTalkTableVoice
//        ||_style==CGCTalkTablePic_Text
//        ||_style==CGCTalkTablePic
//        ||_style==CGCTalkTableFile) {
//
//        return nil;
//    }
//
//
//    if (self.dataArray.count==0) {
//        return nil;
//    }
//    CGCTalkModel *model=self.dataArray[section];
//    if (model.array.count>0) {
//        UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
//        view.backgroundColor=DBColor(245, 245, 245);
//        UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
//        lab.font=[UIFont systemFontOfSize:14];
//        lab.textAlignment=NSTextAlignmentLeft;
//        lab.text=model.total;
//        [view addSubview:lab];
//
//        return view;
//    }
//
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (_style==CGCTalkTableTemplate
//        ||_style==CGCTalkTableVideo
//        ||_style==CGCTalkTableVoice
//        ||_style==CGCTalkTablePic_Text
//        ||_style==CGCTalkTablePic
//        ||_style==CGCTalkTableFile) {
//
//        return 0.5;
//    }
//
//
//
//    if (self.dataArray.count==0) {
//        return 0.5;
//    }
//    CGCTalkModel *model=self.dataArray[section];
//    if (model.array.count>0) {
//     return 20.0;
//    }
	
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.5;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_style==CGCTalkTableTemplate
        ||_style==CGCTalkTableVideo
        ||_style==CGCTalkTableVoice
        ||_style==CGCTalkTablePic_Text
        ||_style==CGCTalkTablePic
        ||_style==CGCTalkTableFile) {
        
        return 80;
	} else {
		CGCTalkModel *model=self.dataArray[indexPath.section];
		CGCTalkDetailModel * desModel=[self.dataArray[indexPath.section] array][indexPath.row];
		if (model.array.count>0) {
			CGSize size = [desModel.X_PICCONTENT boundingRectWithSize:CGSizeMake(KScreenWidth - 60, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
			return size.height + 44;
		}else{
			CGCTalkModel *model=self.dataArray[indexPath.row];
			CGSize size = [model.X_PICCONTENT boundingRectWithSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
			return size.height + 50;
		}
	}
    
	
//    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MJKTemplateSendView *sendView = [[NSBundle mainBundle]loadNibNamed:@"MJKTemplateSendView" owner:nil options:nil].firstObject;
	CGCTalkModel *model1=self.dataArray[indexPath.section];
//	CGCTalkDetailModel * desModel1=[self.dataArray[indexPath.section] array][indexPath.row];
	if (model1.array.count>0) {
		sendView.sendView.hidden = YES;
		sendView.publicSendView.hidden = NO;
	} else {
		sendView.sendView.hidden = NO;
		sendView.publicSendView.hidden = YES;
	}
	[[UIApplication sharedApplication].keyWindow addSubview:sendView];
    if (_style==CGCTalkTableTemplate
        ||_style==CGCTalkTableVideo
        ||_style==CGCTalkTableVoice
        ||_style==CGCTalkTablePic_Text
        ||_style==CGCTalkTablePic
        ||_style==CGCTalkTableFile) {
        
        CGCTalkDetailModel * desModel=((self.dataArray.count>indexPath.section)&&[[self.dataArray[indexPath.section] array]count]>indexPath.row)?[self.dataArray[indexPath.section] array][indexPath.row]:nil;
        if ([self.delegate respondsToSelector:@selector(talkTable:didSelectWithIndex:withSelectText:withSelC_ID:)]) {
            [self.delegate talkTable:self didSelectWithIndex:indexPath withSelectText:@"" withSelC_ID:desModel.C_ID];
        }
    }
    
    
    if (_style==CGCTalkTableText) {
        CGCTalkModel *model=(self.dataArray.count>indexPath.row)?self.dataArray[indexPath.row]:nil;
        
        CGCTalkDetailModel * desModel=((self.dataArray.count>indexPath.section)&&[[self.dataArray[indexPath.section] array]count]>indexPath.row)?[self.dataArray[indexPath.section] array][indexPath.row]:nil;
        NSString * str=@"";
        NSString * c_id=@"";
        
//        if (model.array.count>0) {
		
            str=desModel.X_PICCONTENT.length > 0 ? desModel.X_PICCONTENT : model.X_PICCONTENT;
            c_id=desModel.C_ID.length > 0 ? desModel.C_ID : model.C_ID;
//        }else{
//
//            str=model.X_PICCONTENT;
//            c_id=model.C_ID;
//        }
		sendView.messageTextView.text = str;
		sendView.saveBlock = ^(NSString * _Nonnull textStr) {
			if ([self.delegate respondsToSelector:@selector(talkTable:didClickEidtIndex:withEidt:withTitle:andText:)]) {
				[self.delegate talkTable:self didClickEidtIndex:indexPath withEidt:_eidtStyle withTitle:@"编辑" andText:textStr];
			}
		};
		sendView.sendBlock = ^(NSString * _Nonnull textStr) {
			
			if ([self.delegate respondsToSelector:@selector(talkTable:didSelectWithIndex:withSelectText:withSelC_ID:)]) {
				[self.delegate talkTable:self didSelectWithIndex:indexPath withSelectText:textStr.length > 0 ? textStr : str withSelC_ID:c_id];
			}
		};
//        if ([self.delegate respondsToSelector:@selector(talkTable:didSelectWithIndex:withSelectText:withSelC_ID:)]) {
//            [self.delegate talkTable:self didSelectWithIndex:indexPath withSelectText:str withSelC_ID:c_id];
//        }
		

    }
   
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    if (_style==CGCTalkTablePic||_style==CGCTalkTableFile||_style==CGCTalkTableVideo||_style==CGCTalkTableVoice||_style==CGCTalkTablePic_Text||_style==CGCTalkTableTemplate) {
        
        return NO;
    }
    
    return YES;
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewRowAction *collect = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                   title:@" 收藏 "
                                                                 handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                     
                                                                     [self tableScrollClick:indexPath withTitle:@"收藏"];
                                                                 }];
    collect.backgroundColor=KNaviColor;
    UITableViewRowAction *eidt = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                 
                                                                   title:@" 编辑 "
                                                                 handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                     
                                                                     
                                                                     [self tableScrollClick:indexPath withTitle:@"编辑"];
                                                                     
                                                                 }];
    
     eidt.backgroundColor= KNaviColor;
    
    UITableViewRowAction *del = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                       title:@" 删除 "
                                                                     handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                         
                                                                         [self tableScrollClick:indexPath withTitle:@"删除"];
                                                                         
                                                                     }];
    
        del.backgroundColor= KNaviColor;
    
    NSArray *arr = @[];
    //C_STATUS_DD_ID
    if (_eidtStyle==EidtUp&&_style==CGCTalkTableText) {
        arr=@[/*eidt,*/del];
        return arr;
        
    }else if(_eidtStyle==EidtDown&&_style==CGCTalkTableText){
//        arr=@[collect];
        return arr;
        
    }else{
        
        return arr;
    }
    
    
}

- (void)tableScrollClick:(NSIndexPath *)indexPath withTitle:(NSString *)title{
	
    if ([self.delegate respondsToSelector:@selector(talkTable:didClickEidtIndex:withEidt:withTitle:andText:)]) {
        [self.delegate talkTable:self didClickEidtIndex:indexPath withEidt:_eidtStyle withTitle:title andText:nil];
    }

}




- (void)reloadTableWithArray:(NSMutableArray *)arr withStyle:(CGCTalkTableStyle)style{
    _style=style;

    if (_style==CGCTalkTableTemplate
        ||_style==CGCTalkTableVideo
        ||_style==CGCTalkTableVoice
        ||_style==CGCTalkTablePic_Text
        ||_style==CGCTalkTablePic
        ||_style==CGCTalkTableFile) {
        
        self.dataArr=arr;
    
        
        [self.tableView reloadData];
        return;
    }
    
    self.dataArray=arr;
    CGCTalkModel *model=[self.dataArray firstObject];
    if (model.array.count>0) {
       
        
    }else{
    
//        self.tableView.height=arr.count*100;
    }

    [self.tableView reloadData];

}

#pragma mark - 收藏星
- (void)collectionButtonAction:(UIButton *)sender {
	sender.selected = !sender.isSelected;
	CGCTalkCell * cell = (CGCTalkCell *)[[sender superview] superview];
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	[sender setImage:sender.isSelected == YES ? @"星星-黄色" : @"星星-灰色"];
	[self tableScrollClick:indexPath withTitle:@"收藏"];
}

#pragma mark --- set
- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView=[[UIView alloc] init];
        if (self.headTitleArr.count>0) {
         _tableView.tableHeaderView=self.headSelView;
        }
       
    }
    
    return _tableView;
}

-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }

    return _dataArray;
}


- (UIView *)headSelView{

    if (!_headSelView) {
        
        UIView * line=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.5)];
        line.backgroundColor=DBColor(199, 197, 202);
        _headSelView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
        for (int i=0; i<self.headTitleArr.count; i++) {
            UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat bw=KScreenWidth/self.headTitleArr.count;
            btn.titleLabel.font=[UIFont systemFontOfSize:14];
            btn.frame=CGRectMake(i*bw, 0, bw, 50);
            [btn setTitleNormal:self.headTitleArr[i]];
           
            [btn setTitleColor:[UIColor lightGrayColor]];
            [btn setTitleColor:DBColor(222, 203, 0) forState:UIControlStateSelected];
            [btn setImage:@"小三角"];
            [btn setImage:[UIImage imageNamed:@"选中三角"] forState:UIControlStateSelected];
           
            [btn addTarget:self action:@selector(headSelClick:)];
            btn.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
          
            [_headSelView addSubview:btn];
            
        }
        [_headSelView addSubview:line];
        
    }

    return _headSelView;

}


- (void)headSelClick:(UIButton *)button{

    if ([self.delegate respondsToSelector:@selector(talkTable:didClickWithTitle:)]&&![self.selBtnStr isEqualToString:button.titleNormal]) {
        self.selBtnStr=button.titleNormal;
        [self.delegate talkTable:self didClickWithTitle:button.titleNormal];
    }
    
    if (button != self.selBtn)
    {
        self.selBtn.selected = NO;
        self.selBtn = button;
    }
    self.selBtn.selected = YES;

}

- (NSMutableArray *)headTitleArr{

    if (!_headTitleArr) {
        _headTitleArr=[NSMutableArray array];
    }

    return _headTitleArr;
}
- (NSMutableArray *)dataArr{

    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
    }

    return _dataArr;
}

@end
