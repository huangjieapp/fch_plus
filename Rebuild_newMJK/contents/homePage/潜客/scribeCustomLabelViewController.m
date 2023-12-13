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

@end

@implementation scribeCustomLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"编辑潜客标签";
 
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[CustomLabelTableViewCell class] forCellReuseIdentifier:CELL0];
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomLabelHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:CELLHeader];
    
}


#pragma mark  --UI
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
        //弄个字典传过去 头像什么的东西
        
       
        
        return header;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
         return [CustomLabelHeaderView headerHeight:self.saveSelectedModel];
    }
    
        return 0.001;
    
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [CustomLabelTableViewCell cellHeightWithArray:self.allLabelArray[indexPath.row]];
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
    }
    return _tableView;
}


-(NSMutableArray *)allTitleArray{
    if (!_allTitleArray) {
        _allTitleArray=[NSMutableArray array];
        NSArray*array=@[@"饮水偏好",@"生活习惯",@"购车关注点"];
        [_allTitleArray addObjectsFromArray:array];
    }
    
    return _allTitleArray;
}


-(NSMutableArray *)allLabelArray{
    if (!_allLabelArray) {
        _allLabelArray=[NSMutableArray array];
        
        
        NSMutableArray*array=[NSMutableArray array];
        NSArray*aa=@[@"冰水",@"温水",@"开水",@"红茶",@"打游戏",@"运动",@"新能源",@"我也不知道设什么",@"很差钱"];
        for (int i=0; i<aa.count; i++) {
            CustomLabelModel*model=[[CustomLabelModel alloc]init];
            model.title=aa[i];
            model.currentColor=[UIColor redColor];
            model.isSelected=NO;

            [array addObject:model];
        }
        
        
        NSMutableArray*array1=[NSMutableArray array];
        NSArray*bb=@[@"冰水",@"温水",@"开水",@"红茶",@"打游戏",@"运动",@"新能源",@"我也不知道设什么",@"很差钱"];
        for (int i=0; i<bb.count; i++) {
            CustomLabelModel*model=[[CustomLabelModel alloc]init];
            model.title=bb[i];
            model.currentColor=[UIColor blueColor];
            model.isSelected=NO;
            
            [array1 addObject:model];
        }

        NSMutableArray*array2=[NSMutableArray array];
        NSArray*cc=@[@"冰水",@"温水",@"开水",@"红茶",@"打游戏",@"运动",@"新能源",@"我也不知道设什么",@"很差钱"];
        for (int i=0; i<cc.count; i++) {
            CustomLabelModel*model=[[CustomLabelModel alloc]init];
            model.title=cc[i];
            model.currentColor=[UIColor greenColor];
            model.isSelected=NO;
            
            [array2 addObject:model];
        }

        
        [_allLabelArray addObject:array];
        [_allLabelArray addObject:array1];
        [_allLabelArray addObject:array2];
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


@end
