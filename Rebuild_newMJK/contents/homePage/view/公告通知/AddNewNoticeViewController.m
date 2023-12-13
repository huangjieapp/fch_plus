//
//  AddNewNoticeViewController.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/29.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "AddNewNoticeViewController.h"
#import "AddCustomerInputTableViewCell.h"
#import "CGCNewAppointTextCell.h"

#import "MJKPhotoView.h"


#define CELL0    @"AddCustomerInputTableViewCell"
#define CELL1    @"CGCNewAppointTextCell"

@interface AddNewNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSString*titleStr;
@property(nonatomic,strong)NSString*contentStr;
@property(nonatomic,assign)BOOL canSave;
/** MJKPhotoView*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;
/** <#备注#>*/
@property (nonatomic, strong) NSArray *imageUrlArray;

@end

@implementation AddNewNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"新增公告";
//    [self setupNavi];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self.tableView registerNib:[UINib nibWithNibName:CELL1 bundle:nil] forCellReuseIdentifier:CELL1];
    
    
}

#pragma mark  --UI
-(void)setupNavi{
	
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(ClickComplete)];
	item.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem=item;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        AddCustomerInputTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
      cell.nameTitleLabel.text=@"标题";
      cell.changeTextBlock = ^(NSString *textStr) {
          MyLog(@"%@",textStr);
          self.titleStr=textStr;
          
      };
        
        return cell;
    }else{
        CGCNewAppointTextCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL1];
        cell.topTitleLabel.text=@"备注";
        cell.changeTextBlock = ^(NSString *textStr) {
            MyLog(@"%@",textStr);
            self.contentStr=textStr;
        };
        
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
		return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 44;
    }else{
        return 150;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
	[bgView addSubview:self.tableFootPhoto];
	
	UIButton *commitButton = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tableFootPhoto.frame) + 5, KScreenWidth - 20, 40)];
	commitButton.backgroundColor = KNaviColor;
	[commitButton setTitleNormal:@"提交"];
	[commitButton addTarget:self action:@selector(ClickComplete)];
	[bgView addSubview:commitButton];
	return bgView;
}

- (MJKPhotoView *)tableFootPhoto {
	DBSelf(weakSelf);
	if (!_tableFootPhoto) {
		_tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
		_tableFootPhoto.isEdit = YES;
		_tableFootPhoto.isCamera = NO;
		_tableFootPhoto.rootVC = self;
        _tableFootPhoto.backUrlArray = ^(NSArray *arr, NSArray *saveArr) {
			weakSelf.imageUrlArray = arr;
		};
	}
	return _tableFootPhoto;
};

#pragma mark  --touch
-(void)ClickComplete{
    NSString*judgeStr=[self judgeSave];
    if (!_canSave) {
        [JRToast showWithText:judgeStr];
        return;
    }
    
    
    [self httpPostAddNewNotice];
    
    
}

#pragma mark  --datas
-(void)httpPostAddNewNotice{
    NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:HTTP_AddNewNotice];
    NSString*C_id=[DBObjectTools getNoticeFollowC_id];
	NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
	contentDict[@"C_TITLE"] = self.titleStr;
	contentDict[@"X_REMARK"] = self.contentStr;
	contentDict[@"C_ID"] = C_id;
	if (self.imageUrlArray.count > 0) {
		contentDict[@"urlList"] = self.imageUrlArray;
	}
    [mtDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            [self.navigationController popViewControllerAnimated:YES];
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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
    }
    
    return _tableView;
}


#pragma mark  --funcation
-(NSString*)judgeSave{
    _canSave=YES;
    if (self.titleStr.length<1) {
        _canSave=NO;
        return @"标题不能为空";
    }else if (self.contentStr.length<1){
        _canSave=NO;
        return @"内容不能为空";
    }
    
    
    
    return nil;
}


#pragma mark  隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

//touch began
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}


- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}

@end
