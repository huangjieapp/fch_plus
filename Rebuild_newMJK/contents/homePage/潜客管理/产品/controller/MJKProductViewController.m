//
//  MJKProductViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/23.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKProductViewController.h"

//#import "WLBarcodeViewController.h"

#import "MJKProductModel.h"

#import "MJKProductCell.h"

@interface MJKProductViewController ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSafeLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSafeLayout;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *allProductButton;
@property (weak, nonatomic) IBOutlet UIButton *intentionProductButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 搜索条件*/
@property (nonatomic, strong) NSString *SEARCH_NAMEORCONTACT;
/** 只显示勾中的意向产品列表传1*/
@property (nonatomic, strong) NSString *IS_INTENTION;
/** data array*/
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MJKProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self initUI];
}

- (void)initUI {
	self.title = @"产品";
	self.topSafeLayout.constant = SafeAreaTopHeight;
	self.bottomSafeLayout.constant = SafeAreaBottomHeight;
	self.tableView.tableFooterView = [[UIView alloc]init];
	
//	UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"扫一扫白"] style:UIBarButtonItemStylePlain target:self action:@selector(clickSure)];
//	self.navigationItem.rightBarButtonItem = item;
	
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
	[button setImage:@"btn-返回"];
	button.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
	[button addTarget:self action:@selector(backVC)];
	UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:button];
	self.navigationItem.leftBarButtonItem = backItem;
	
	self.IS_INTENTION = @"";
	[self httpGetProductDatas];
	
}

- (void)backVC {
	MyLog(@"返回+++++++++=");
	NSMutableArray *array = [NSMutableArray array];
	for (MJKProductModel *model in self.dataArray) {
		if ([model.flag isEqualToString:@"1"]) {
			[array addObject:[NSString stringWithFormat:@"%@ %@ %@",model.C_PRODUCTCODE,model.C_A41900_C_NAME,model.B_PRICE]];
		}
	}
	NSString *str = [array componentsJoinedByString:@"\n"];
	if (self.backVCAddProductBlock) {
		self.backVCAddProductBlock(str);
	}
	[self.navigationController popViewControllerAnimated:YES];
}

//MARK:-产品类型按钮
- (IBAction)productTypeButtonAction:(UIButton *)sender {
	if ([sender.titleLabel.text isEqualToString:@"所有产品"]) {
		self.IS_INTENTION = @"";
		[sender setTitleColor:KNaviColor];
		[self.intentionProductButton setTitleColor:[UIColor blackColor]];
	} else {
		self.IS_INTENTION = @"1";
		[sender setTitleColor:KNaviColor];
		[self.allProductButton setTitleColor:[UIColor blackColor]];
	}
	[self httpGetProductDatas];
}

//MARK:-搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	self.SEARCH_NAMEORCONTACT = searchText;
	[self httpGetProductDatas];
}


//MARK:-UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	MJKProductModel *model = self.dataArray[indexPath.row];
	MJKProductCell *cell = [MJKProductCell cellWithTableView:tableView];
	cell.numberLabel.text = model.C_PRODUCTCODE;
	cell.productLabel.text = model.C_A41900_C_NAME;
	cell.priceLaebl.text = model.B_PRICE;
	if ([model.flag isEqualToString:@"1"]) {
		[cell.selectProductButton setImage:@"kuangselected"];
	} else {
		[cell.selectProductButton setImage:@"kuang_off"];
	}
	cell.clickLikeProductActionBlock = ^{
		if ([model.flag isEqualToString:@"1"]) {
			[weakSelf httpDeleteProductDataWithModel:model];
		} else {
			[weakSelf httpAddLikeProductDataWithModel:model];
		}
	};
	return cell;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

//MARK:-扫码功能
-(void)clickSure{
	DBSelf(weakSelf);
	
//	UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//	UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//	}];
//	UIAlertAction*sanfdal=[UIAlertAction actionWithTitle:@"扫码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
	
//		[weakSelf clickScanf];
		
		
		
//	}];
//	UIAlertAction*manual=[UIAlertAction actionWithTitle:@"手动输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//		[weakSelf.navigationController popViewControllerAnimated:YES];
////		[weakSelf clickManual];
//		if (weakSelf.backAddPageBlock) {
//			weakSelf.backAddPageBlock();
//		}
//	}];
//	[alertVC addAction:sanfdal];
//	[alertVC addAction:manual];
//	[alertVC addAction:cancel];
//	[self presentViewController:alertVC animated:YES completion:nil];
}

//-(void)clickScanf{
//	DBSelf(weakSelf);
//	WLBarcodeViewController*QRCode=[[WLBarcodeViewController alloc]initWithBlock:^(NSString *str, BOOL isSuccess) {
//
//		if (isSuccess) {
//			//成功
//			MyLog(@"%@",str);
//			for (MJKProductModel *model in self.dataArray) {
//				if ([model.C_PRODUCTCODE isEqualToString:str]) {
//					[weakSelf httpAddLikeProductDataWithModel:model];
//				}
//			}
//
////			[self addDataswithStr:str andAlertVC:nil];
//
//
//
//
//		}else{
//			UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"扫描结果" message:@"无法识别" preferredStyle:UIAlertControllerStyleAlert];
//			UIAlertAction*action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//			}];
//			[alertVC addAction:action];
//
//
//
//			[self presentViewController:alertVC animated:YES completion:nil];
//
//
//		}
//
//
//	}];
//
//	[self presentViewController:QRCode animated:YES completion:nil];
//
//
//}

-(void)clickManual{
	MyLog(@"手动输入");
	DBSelf(weakSelf);
	UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"提示" message:@"请输入意向产品编号码" preferredStyle:UIAlertControllerStyleAlert];
	[alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
		
	}];
	UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		
	}];
	UIAlertAction*sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		UITextField*textField=alertVC.textFields.firstObject;
		if (textField.text.length<1) {
			[JRToast showWithText:@"请输入产品码"];
			[weakSelf presentViewController:alertVC animated:YES completion:nil];
			return ;
		}
		
		[weakSelf addDataswithStr:textField.text andAlertVC:alertVC];
		
		
	}];
	
	[alertVC addAction:cancel];
	[alertVC addAction:sure];
	
	[self presentViewController:alertVC animated:YES completion:nil];
	
	
	
	
}

//产品编码 获取产品
-(void)addDataswithStr:(NSString*)textStr andAlertVC:(UIAlertController*)alertVC{
	DBSelf(weakSelf);
	
	//    NSString*urlStr=[NSString stringWithFormat:@"%@",newHttp_address];
	NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_AddProduct];
	
	NSDictionary*dict=@{@"C_VOUCHERID":textStr};
	[mainDict setObject:dict forKey:@"content"];
	
	NSString*paramStr= [DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:paramStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
//			CodeShoppingModel*model=[CodeShoppingModel yy_modelWithDictionary:data];
//			model.isStatus=@"add";
//			[self.saveAllShoppingInfo addObject:model];
//
//
//			self.showProductView.hidden=NO;
//			[[DBTools findFirstResponderBeneathView:self.view] resignFirstResponder];
			
//			[self.showProductView getShowValue:self.saveAllShoppingInfo];
			
			
			
		}else if ([data[@"message"] isEqualToString:@"产品编码对应的产品不存在"]){
			[JRToast showWithText:data[@"message"]];
			if (alertVC) {
				[weakSelf presentViewController:alertVC animated:YES completion:nil];
			}
			
		}
		
		else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
		
		
		
	}];
	
	
}

//MARK:-http data
- (void)httpGetProductDatas {
	DBSelf(weakSelf);
	NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A41900WebService-getIntentionList"];
	
	NSMutableDictionary*dict=[NSMutableDictionary dictionary];
	dict[@"TYPE"] = self.productType;
	dict[@"C_OBJECTID"] = self.C_OBJECTID;
	dict[@"SEARCH_NAMEORCONTACT"] = self.SEARCH_NAMEORCONTACT;
	dict[@"IS_INTENTION"] = self.IS_INTENTION;
	
	[mainDict setObject:dict forKey:@"content"];
	
	NSString*paramStr= [DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:paramStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.dataArray = [MJKProductModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
			[weakSelf.tableView reloadData];
			
			
		} else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)httpAddLikeProductDataWithModel:(MJKProductModel *)model {
	DBSelf(weakSelf);
	NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A47100WebService-insert"];
	
	NSMutableDictionary*dict=[NSMutableDictionary dictionary];
	dict[@"C_ID"] = [DBObjectTools getA47100C_id];
	if ([self.productType isEqualToString:@"1"]) {
		dict[@"C_A41500_C_ID"] = self.C_OBJECTID;
		dict[@"C_TYPE_DD_ID"] = @"A47100_C_TYPE_0001";
	} else {
		dict[@"C_A41500_C_ID"] = self.customerID;
		dict[@"C_A42000_C_ID"] = self.C_OBJECTID;
		dict[@"C_TYPE_DD_ID"] = @"A47100_C_TYPE_0000";
	}
	dict[@"C_PRODUCTCODE"] = model.C_PRODUCTCODE;
	dict[@"C_A41900_C_ID"] = model.C_A41900_C_ID;
	dict[@"C_A41900_C_NAME"] = model.C_A41900_C_NAME;
	dict[@"B_PRICE"] = model.B_PRICE;
	
	[mainDict setObject:dict forKey:@"content"];
	
	NSString*paramStr= [DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkWithUrl:paramStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf httpGetProductDatas];
			[JRToast showWithText:@"意向产品添加成功"];
		} else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)httpDeleteProductDataWithModel:(MJKProductModel *)model {
	DBSelf(weakSelf);
	NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A47100WebService-delete"];
	
	NSMutableDictionary*dict=[NSMutableDictionary dictionary];
	dict[@"C_ID"] = model.C_ID;
	
	[mainDict setObject:dict forKey:@"content"];
	
	NSString*paramStr= [DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkWithUrl:paramStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf httpGetProductDatas];
//			[JRToast showWithText:data[@"message"]];
		} else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

@end
