//
//  MyViewController.m
//  FLHBaseProject
//
//  Created by fance on 16/5/26.
//  Copyright © 2016年 Fance. All rights reserved.
//

#import "MyViewController.h"

#define DIC_EXPANDED @"expanded" //是否是展开 0收缩 1展开

#define DIC_ARARRY @"array" //存放数组

#define DIC_TITILESTRING @"title"

#define CELL_HEIGHT 50.0f

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    __weak IBOutlet UITableView *mTableView;
    
    NSMutableArray *DataArray;
    
}

@end

@implementation MyViewController

//初始化数据
- (void)initDataSource{
    
    //创建一个数组
    DataArray=[[NSMutableArray alloc] init];
    
    for (int i = 0;i <= 5; i++) {
        
        NSMutableArray *array=[[NSMutableArray alloc] init];
        
        for (int j=0; j<=5;j++) {
            
            NSString *string=[NSString stringWithFormat:@"%i组-%i行",i,j];
            
            [array addObject:string];
            
        }
        
        NSString *string=[NSString stringWithFormat:@"第%i分组",i];
        
        //创建一个字典 包含数组，分组名，是否展开的标示
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:array,DIC_ARARRY,string,DIC_TITILESTRING,[NSNumber numberWithInt:0],DIC_EXPANDED,nil];
        
        //将字典加入数组
        [DataArray addObject:dic];
        
    }
    
}

- (void)viewDidLoad {
    
     [super viewDidLoad];
     self.title = @"我的分组";
     mTableView.backgroundColor = [UIColor whiteColor];
    
     [self initDataSource];
}

#pragma mark - UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return DataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableDictionary *dic=[DataArray objectAtIndex:section];
    
    NSArray *array=[dic objectForKey:DIC_ARARRY];
    
    //判断是收缩还是展开
    
    if ([[dic objectForKey:DIC_EXPANDED] intValue]) {
        
        return array.count;
        
    }else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str
                ];
    }
    NSArray *array = [[DataArray objectAtIndex:indexPath.section] objectForKey:DIC_ARARRY];
    cell.textLabel.text=[array objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor redColor];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, CELL_HEIGHT)];
    
    hView.backgroundColor=[UIColor whiteColor];
    
    UIButton* eButton = [[UIButton alloc] init];
    
    //按钮填充整个视图
    eButton.frame = hView.frame;
    
    [eButton addTarget:self action:@selector(expandButtonClicked:)
     
     forControlEvents:UIControlEventTouchUpInside];
    
    //把节号保存到按钮tag，以便传递到expandButtonClicked方法
    
    eButton.tag = section;
    
    //设置图标
    
    //根据是否展开，切换按钮显示图片
    
    if ([self isExpanded:section]){
        
        [eButton setImage: [UIImage imageNamed: @"arrow_right_grey" ]forState:UIControlStateNormal];
    } else {
        
        [eButton setImage: [UIImage imageNamed: @"arrow_down_grey" ]forState:UIControlStateNormal];
    }
    //设置分组标题
    
    [eButton setTitle:[[DataArray objectAtIndex:section] objectForKey:DIC_TITILESTRING] forState:UIControlStateNormal];
    
    [eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //设置button的图片和标题的相对位置
    
    //4个参数是到上边界，左边界，下边界，右边界的距离
    
    eButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    
    [eButton setTitleEdgeInsets:UIEdgeInsetsMake(5,-5, 0,0)];
    
    [eButton setImageEdgeInsets:UIEdgeInsetsMake(5,self.view.bounds.size.width - 25, 0,0)];
    
    //下显示线
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, hView.frame.size.height-1, hView.frame.size.width,1)];
    
    label.backgroundColor = [UIColor grayColor];
    [hView addSubview:label];
    
    [hView addSubview: eButton];
    
    return hView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

-(int)isExpanded:(NSInteger)section{
    
    NSDictionary *dic=[DataArray objectAtIndex:section];
    
    int expanded=[[dic objectForKey:DIC_EXPANDED] intValue];
    
    return expanded;
    
}

-(void)expandButtonClicked:(id)sender{
    
    UIButton* btn = (UIButton *)sender;
    
    NSInteger section= btn.tag;//取得tag知道点击对应哪个块
    
    [self collapseOrExpand:section];
    
    //刷新tableview
    
    [mTableView reloadData];
    
}

//对指定的节进行“展开/折叠”操作,若原来是折叠的则展开，若原来是展开的则折叠

-(void)collapseOrExpand:(NSInteger)section{
    
    NSMutableDictionary *dic = [DataArray objectAtIndex:section];
    
    int expanded=[[dic objectForKey:DIC_EXPANDED] intValue];
    
    if (expanded) {
        
        [dic setValue:[NSNumber numberWithInt:0] forKey:DIC_EXPANDED];
        
    }else {
        [dic setValue:[NSNumber numberWithInt:1] forKey:DIC_EXPANDED];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
