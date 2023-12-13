//
//  ReportTopTableViewCell.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/5.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "ReportTopTableViewCell.h"

@interface ReportTopTableViewCell()

@end

@implementation ReportTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)getValue:(ReportSheetModel*)mainModel{
    self.mainModel=mainModel;
    
    UILabel*change0=[self viewWithTag:1000];
    change0.text=mainModel.ZHL.length > 0 ? mainModel.ZHL : @"0%";
    UILabel*change1=[self viewWithTag:1001];
    change1.text=mainModel.DDL.length > 0 ? mainModel.DDL : @"0%";
    UILabel*change2=[self viewWithTag:1002];
    change2.text=mainModel.QDL.length > 0 ? mainModel.QDL : @"0%";
    UILabel*change3=[self viewWithTag:1003];
    change3.text=mainModel.WGL.length > 0 ? mainModel.WGL : @"0%";
    
    //线索
    UILabel*crue0=[self viewWithTag:100];
    crue0.text=self.mainModel.LL_ALL.length > 0 ? self.mainModel.LL_ALL : @"0";
    UILabel*crue1=[self viewWithTag:101];
    crue1.text=self.mainModel.LL_MD.length > 0 ? mainModel.LL_MD : @"0";
    UILabel*crue2=[self viewWithTag:102];
    crue2.text=mainModel.LL_XS.length > 0 ? mainModel.LL_XS : @"0";
    UILabel*crue3=[self viewWithTag:103];
    crue3.text=mainModel.LL_LD.length > 0 ? mainModel.LL_LD : @"0";
    
    //意向
    UILabel*inStore0=[self viewWithTag:200];
    inStore0.text=self.mainModel.YX_ALL.length > 0 ? self.mainModel.YX_ALL : @"0";
    UILabel*inStore1=[self viewWithTag:201];
    inStore1.text=self.mainModel.YX_MD.length > 0 ? mainModel.YX_MD : @"0";
    UILabel*inStore2=[self viewWithTag:202];
    inStore2.text=mainModel.YX_XS.length > 0 ? mainModel.YX_XS : @"0";
    UILabel*inStore3=[self viewWithTag:203];
    inStore3.text=mainModel.YX_LD.length > 0 ? mainModel.YX_LD : @"0";
    UILabel*inStore4=[self viewWithTag:203];
    inStore4.text=mainModel.YX_QT.length > 0 ? mainModel.YX_QT : @"0";
    
    //到店
    UILabel*record0=[self viewWithTag:300];
    record0.text=self.mainModel.YY_ALL.length > 0 ? self.mainModel.YY_ALL : @"0";
    UILabel*record1=[self viewWithTag:301];
    record1.text=self.mainModel.YY_WDD.length > 0 ? mainModel.YY_WDD : @"0";
    UILabel*record2=[self viewWithTag:302];
    record2.text=self.mainModel.YY_YDD.length > 0 ? mainModel.YY_YDD : @"0";
    UILabel*record3=[self viewWithTag:303];
    record3.text=self.mainModel.YY_YQX.length > 0 ? self.mainModel.YY_YQX : @"0";
    //    UILabel*record4=[self viewWithTag:304];
    //    record4.text=self.mainModel.QTLDS;
    
    
    //订单数
    UILabel*order0=[self viewWithTag:400];
    order0.text=self.mainModel.DD_ALL.length > 0 ? self.mainModel.DD_ALL : @"0";
    UILabel*order1=[self viewWithTag:401];
    order1.text=self.mainModel.DD_DJ.length > 0 ? mainModel.DD_DJ : @"0";
    UILabel*order2=[self viewWithTag:402];
    order2.text=self.mainModel.DD_QY.length > 0 ? mainModel.DD_QY : @"0";
    UILabel*order3=[self viewWithTag:403];
    order3.text=self.mainModel.DD_XD.length > 0 ? mainModel.DD_XD : @"0";
    UILabel*order4=[self viewWithTag:403];
    order4.text=self.mainModel.DD_AZ.length > 0 ? mainModel.DD_AZ : @"0";
    
    //成交数
    UILabel*deal0=[self viewWithTag:500];
    deal0.text=self.mainModel.WG_ALL.length > 0 ? self.mainModel.WG_ALL : @"0";
    UILabel*deal1=[self viewWithTag:501];
    deal1.text=self.mainModel.WG_JE.length > 0 ? mainModel.WG_JE : @"0";
    UILabel*deal2=[self viewWithTag:502];
    deal2.text=self.mainModel.WG_KDJ.length > 0 ? mainModel.WG_KDJ : @"0";
    //    UILabel*deal3=[self viewWithTag:503];
    //    deal3.text=self.mainModel.JFZQ.length > 0 ? mainModel.JFZQ : @"0";
    
}



//-(void)setMainModel:(ReportSheetModel *)mainModel{
//    self.mainModel=mainModel;
//    
//    
//    
//}

@end
