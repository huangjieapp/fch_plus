//
//  scribeCustomLabelViewController.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/3.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "scribeCustomLabelViewController.h"
#import "CustomLabelTableViewCell.h"
#import "CustomLabelHeaderView.h"
#import "CustomLabelModel.h"

#define CELLHeader     @"CustomLabelHeaderView"
#define CELL0   @"CustomLabelTableViewCell"

@interface scribeCustomLabelViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSMutableArray*allLabelArray;  //所有的标签   model
@property(nonatomic,strong)NSMutableArray*allTitleArray;  //所有的title  就3个string
@property(nonatomic,strong)NSMutableArray*saveSelectedModel;   //保存选中的model
@property(nonatomic,strong)NSMutableArray*saveFrontArray; //保存上一个界面选中的tag 用来给saveSelectedModel 赋值的

@end

@implementation scribeCustomLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"编辑客户标签";
    [self getSelectedTag];
    [self getTagHttpPost];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[CustomLabelTableViewCell class] forCellReuseIdentifier:CELL0];
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomLabelHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:CELLHeader];
 
    [self addRightButton];
}


#pragma mark  --UI
-(void)addRightButton{
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
    item.tintColor=[UIColor blackColor];
    self.navigationItem.rightBarButtonItem=item;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allLabelArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray*array=self.allLabelArray[indexPath.row];
    
    CustomLabelTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.titleLabel.text=self.allTitleArray[indexPath.row];
    cell.labelArray=array;

    

    DBSelf(weakSelf);
  cell.getclickButtonBlock = ^(CustomLabelModel *model, BOOL isSelected) {
      if (isSelected) {
          [self.saveSelectedModel addObject:model];
      }else{
          [self.saveSelectedModel removeObject:model];
      }
      
      [weakSelf.tableView reloadData];

      
  };
    
    
 
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        CustomLabelHeaderView*header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:CELLHeader];
        header.allLabelArray=self.saveSelectedModel;
        header.mainModel=self.mainModel;

        return header;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
//        NSString *str = [NSString stringWithFormat:@"%@  %@",self.mainModel.C_PHONE,self.mainModel.C_ADDRESS] ;
//        CGSize size = [str boundingRectWithSize:CGSizeMake(KScreenWidth - 150, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
//        return size.height + 30 + 60;
		CGSize size = [self.mainModel.C_ADDRESS boundingRectWithSize:CGSizeMake(KScreenWidth - 150, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.f]} context:nil].size;
		if (self.mainModel.C_ADDRESS.length > 0) {
			return [CustomLabelHeaderView headerHeight:self.saveSelectedModel andType:CusomterInfoEditTag] + size.height + 10;
		} else {
			return [CustomLabelHeaderView headerHeight:self.saveSelectedModel andType:CusomterInfoEditTag] + 10;
		}
    }
    
        return 0.001;
    
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [CustomLabelTableViewCell cellHeightWithArray:self.allLabelArray[indexPath.row]];
}

#pragma mark  --click
-(void)clickRightItem{
    if (self.saveSelectedModel.count<1) {
        [JRToast showWithText:@"至少选择一个标签"];
        return;
    }
    
    NSMutableArray*idArray=[NSMutableArray array];
    for (CustomLabelModel*model in self.saveSelectedModel) {
        [idArray addObject:model.C_ID];
        
    }
    
    NSString*idStr=[idArray componentsJoinedByString:@","];
    
    [self portWithChooseTag:idStr];
    
    
    
    
}


#pragma mark  --getDatas
-(void)getSelectedTag{
//    [self.saveFrontArray removeAllObjects];
//    NSArray*tagArray=self.mainModel.labelsList;
//    for (NSDictionary*dict in tagArray) {
//        CustomLabelModel*model=[CustomLabelModel yy_modelWithDictionary:dict];
//        model.title=model.C_NAME;
////        model.currentColor=[UIColor redColor];
//        model.currentColor=[UIColor colorWithHexString:model.C_COLOR_DD_ID];
//        model.isSelected=YES;
//        
//        [self.saveFrontArray addObject:model];
//    }

    
    self.saveFrontArray=self.mainModel.labelsList;
    
}


-(void)portWithChooseTag:(NSString*)idStr{
    NSString*customID=self.mainModel.C_ID;
    
    
    NSMutableDictionary*mainDic=[DBObjectTools getAddressDicWithAction:HTTP_ChooseTag];
    NSDictionary*contentDic=@{@"C_A41500_C_ID":customID,@"C_A46700_C_ID":idStr};
    [mainDic setObject:contentDic forKey:@"content"];
    NSString*params=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:nil];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:params parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [JRToast showWithText:data[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }

        
        
    }];

    
}


-(void)getTagHttpPost{
    NSMutableDictionary*mainDic=[DBObjectTools getAddressDicWithAction:HTTP_TagList];
    NSDictionary*contentDic=@{@"currPage":@"1",@"pageSize":@"1000"};
    [mainDic setObject:contentDic forKey:@"content"];
    NSString*params=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:nil];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:params parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [self.allTitleArray removeAllObjects];
            [self.allLabelArray removeAllObjects];
            
            
            NSArray*mainArray=data[@"content"];
            for (NSDictionary*dict in mainArray) {
                
                
                NSArray*subArray=dict[@"content"];
                NSMutableArray*saveArray=[NSMutableArray array];
                for (NSDictionary*subDic in subArray) {
                    CustomLabelModel*model=[CustomLabelModel yy_modelWithDictionary:subDic];
                    model.title=model.C_NAME;
                    model.currentColor=[UIColor colorWithHexString:model.C_COLOR_DD_ID];
                    model.isSelected=NO;
                    
                    [saveArray addObject:model];
                
                    
                    //这里是一开始默认选中的tag 和所有的标签对比
                    for (CustomLabelModel*FrontModel in self.saveFrontArray) {
                        if ([model.C_NAME isEqualToString:FrontModel.C_NAME]&&![model.C_NAME isEqualToString:@""]&&model.C_NAME!=nil) {
                            model.isSelected=YES;
                            [self.saveSelectedModel addObject:model];
                        }
                        
                    }
                    
                    
                    
                    
                }
                
                
                [self.allTitleArray addObject:dict[@"type_name"]];
                [self.allLabelArray addObject:saveArray];
                
                
            }
            
            
            
            
            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
        
    }];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark  --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
    }
    return _tableView;
}


-(NSMutableArray *)allTitleArray{
    if (!_allTitleArray) {
        _allTitleArray=[NSMutableArray array];
//        NSArray*array=@[@"饮水偏好",@"生活习惯",@"购车关注点"];
//        [_allTitleArray addObjectsFromArray:array];
    }
    
    return _allTitleArray;
}


-(NSMutableArray *)allLabelArray{
    if (!_allLabelArray) {
        _allLabelArray=[NSMutableArray array];
        
        
//        NSMutableArray*array=[NSMutableArray array];
//        NSArray*aa=@[@"冰水",@"温水",@"开水",@"红茶",@"打游戏",@"运动",@"新能源",@"我也不知道设什么",@"很差钱"];
//        for (int i=0; i<aa.count; i++) {
//            CustomLabelModel*model=[[CustomLabelModel alloc]init];
//            model.title=aa[i];
//            model.currentColor=[UIColor redColor];
//            model.isSelected=NO;
//
//            [array addObject:model];
//        }
//        
//        
//        NSMutableArray*array1=[NSMutableArray array];
//        NSArray*bb=@[@"冰水",@"温水",@"开水",@"红茶",@"打游戏",@"运动",@"新能源",@"我也不知道设什么",@"很差钱"];
//        for (int i=0; i<bb.count; i++) {
//            CustomLabelModel*model=[[CustomLabelModel alloc]init];
//            model.title=bb[i];
//            model.currentColor=[UIColor blueColor];
//            model.isSelected=NO;
//            
//            [array1 addObject:model];
//        }
//
//        NSMutableArray*array2=[NSMutableArray array];
//        NSArray*cc=@[@"冰水",@"温水",@"开水",@"红茶",@"打游戏",@"运动",@"新能源",@"我也不知道设什么",@"很差钱"];
//        for (int i=0; i<cc.count; i++) {
//            CustomLabelModel*model=[[CustomLabelModel alloc]init];
//            model.title=cc[i];
//            model.currentColor=[UIColor greenColor];
//            model.isSelected=NO;
//            
//            [array2 addObject:model];
//        }
//
//        
//        [_allLabelArray addObject:array];
//        [_allLabelArray addObject:array1];
//        [_allLabelArray addObject:array2];
    }
    return _allLabelArray;
}

//保存选中的model
-(NSMutableArray *)saveSelectedModel{
    if (!_saveSelectedModel) {
        _saveSelectedModel=[NSMutableArray array];
    }
    return _saveSelectedModel;
}

-(NSMutableArray *)saveFrontArray{
    if (!_saveFrontArray) {
        _saveFrontArray=[NSMutableArray array];
    }
    return _saveFrontArray;
}


@end
