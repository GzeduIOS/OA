//
//  SignatureApprovalViewController.m
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-24.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import "SignatureApprovalViewController.h"
#import "LeaveDetailViewController.h"
#import "AMSystemManager.h"//OA_API
#import "My2TableViewCell.h"
#import "MyJsonParser.h"//OA JSON Data parser
#import "PeoperData.h"//Data Object
#import "UIColor+expanded.h"
#import "UIScrollView+VORefresh.h"//Down Pull Refresh Plugin

static NSString *CELL_NIB_NAME = @"My2TableViewCell";
static NSString *CELL_RESUSE_ID = @"Cell2";
static NSString *FLAG_NOT_APPROVE = @"O";
static NSString *FLAG_YET_APPROVE = @"Y";

@interface SignatureApprovalViewController ()

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (strong ,nonatomic) UITableView *NotApproveView;//未审核视图
@property (strong ,nonatomic) UITableView *ApproveView;//已审核视图

@property (strong, nonatomic) UIButton *btnBatchApprove;//批量审核按钮
@property (strong, nonatomic) UIButton *btnConfirm;//批量审核的确认按钮

@property NSUserDefaults *userDefaults;
@property PeoperData *user;
@property NSMutableArray *selectedLeaveId;
@property BOOL isInitAtNotView;
@property BOOL isInitAtYetView;

@end

@implementation SignatureApprovalViewController

@synthesize isInitAtNotView;
@synthesize isInitAtYetView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //标题
    self.TintLabel.text = @"考勤签到审核";
    self.selectedLeaveId = [NSMutableArray array];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    /*
     * 绘制视图
     */
    [self initBatchApproveBtn];//绘制按钮
    [self initScrollView];
    [self initNotApproveView];
    [self initApproveView];
    
    [self requestDataToInitTableViewByStatus:FLAG_NOT_APPROVE];//发送请求并绘制审核视图 先请求未审核
    
    
}

-(void) requestDataToInitTableViewByStatus:(NSString *)status{

    //读取数据绘制视图
    //NSArray *approveType = [[NSArray alloc]initWithObjects:@"Y", @"O", nil];
    NSString *apiKey = [self.userDefaults stringForKey:@"KEY"];
    NSString *type = [self.userDefaults stringForKey:@"formMap.TYPE"];
    
    
    [AMSystemManager interfaceAttendaceInfos:apiKey
                                 auditStatus:status
                                    userType:type
                                  complation:^(id obj) {

                                      NSArray *dataAry = [MyJsonParser parseAttendByarr:obj];
                                      
                                      //数据处理完成后再交回主线程绘制
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          if([status isEqualToString:FLAG_NOT_APPROVE]){
                                              notApproveDataAry = dataAry;
                                              [self.NotApproveView reloadData];
                                              isInitAtNotView = YES;//标示已读取过数据
                                          }else if([status isEqualToString:FLAG_YET_APPROVE]){
                                              approvedDataAry = dataAry;
                                              [self.ApproveView reloadData];
                                              isInitAtYetView = YES;
                                          }
                                      });
                                      //NSLog(@"requestDataToInitTableViewByStatus reloadData Finish!");
                                  }];
}

//滑动视图
-(void)initScrollView{
    
    //创建scrollView
    self.ScrollView = [[UIScrollView alloc]init];
    self.ScrollView.frame = CGRectMake(0,110,self.view.frame.size.width,self.view.frame.size.height);
    self.ScrollView.contentSize = CGSizeMake(2*self.ScrollView.frame.size.width,self.ScrollView.frame.size.height);
    self.ScrollView.showsHorizontalScrollIndicator = NO;
    self.ScrollView.showsVerticalScrollIndicator = NO;
    self.ScrollView.pagingEnabled = YES;
    self.ScrollView.clipsToBounds = NO;
    self.ScrollView.opaque = YES;
    [self.ScrollView setContentOffset:CGPointMake(0, 0)];
    
    //使用手势事件抹除ScrollView的横向滑动
    UIPanGestureRecognizer *dragGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleDragGesture:)];
    [self.ScrollView addGestureRecognizer:dragGesture];
    [self.view addSubview:self.ScrollView];
}

-(void)initNotApproveView{
    
    //没审核tableview
    self.NotApproveView = [[UITableView alloc]init];
    self.NotApproveView.frame = CGRectMake(320*0, 0, 320, self.ScrollView.bounds.size.height-110);
    self.NotApproveView.delegate = self;
    self.NotApproveView.dataSource = self;
    self.NotApproveView.opaque = YES;
    self.NotApproveView.tag = 100;
    //UITableView隐藏多余的分割线
    self.NotApproveView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.NotApproveView registerNib:[UINib nibWithNibName:CELL_NIB_NAME bundle:nil] forCellReuseIdentifier:CELL_RESUSE_ID];
    [self.NotApproveView addTopRefreshWithTarget:self action:@selector(NotApproveTopRefreshing)];
    [self.ScrollView addSubview: self.NotApproveView];
    
    
}

-(void)initApproveView{
    //审核tableview
    self.ApproveView = [[UITableView alloc]init];
    self.ApproveView.frame = CGRectMake(320*1, 0, 320, self.ScrollView.bounds.size.height-110);
    self.ApproveView.delegate = self;
    self.ApproveView.dataSource = self;
    self.ApproveView.opaque = YES;
    self.ApproveView.tag = 200;
    //UITableView隐藏多余的分割线
    self.ApproveView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.ApproveView registerNib:[UINib nibWithNibName:CELL_NIB_NAME bundle:nil] forCellReuseIdentifier:CELL_RESUSE_ID];
    [self.ApproveView addTopRefreshWithTarget:self action:@selector(ApproveTopRefreshing)];
    [self.ScrollView addSubview: self.ApproveView];
}

-(void)initBatchApproveBtn{
    self.btnBatchApprove = [[UIButton alloc]initWithFrame:CGRectMake(232, 10, 68, 30)];
    self.btnBatchApprove.titleLabel.font = [UIFont systemFontOfSize:15];
    self.btnBatchApprove.backgroundColor = [UIColor colorWithHexString:@"0D74FD"];
    [self.btnBatchApprove setTitle:@"批量审核" forState:UIControlStateNormal];//0D74FD
    [self.btnBatchApprove setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.btnBatchApprove addTarget:self action:@selector(remindAndSubmitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.btnBatchApprove];
}
//手势手指拖事件
-(void)handleDragGesture:(UIPanGestureRecognizer *)sender{
}

//下拉刷新 未审核
- (void)NotApproveTopRefreshing{
    [self requestDataToInitTableViewByStatus:FLAG_NOT_APPROVE];
    [self.NotApproveView.topRefresh endRefreshing];
}
//下拉刷新 已审核
-(void)ApproveTopRefreshing{
    [self requestDataToInitTableViewByStatus:FLAG_YET_APPROVE];
    [self.ApproveView.topRefresh endRefreshing];
}

//初始化TableView的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *dataAry = tableView == self.NotApproveView ? notApproveDataAry : approvedDataAry;
    if (dataAry==nil || dataAry.count<=0){return 1;}
    
    //显示选择标示按钮
    if ( tableView == self.NotApproveView) {
        self.NotApproveView.allowsMultipleSelectionDuringEditing = YES;
        [self.NotApproveView setEditing:YES animated:YES];
    }
    
    return dataAry.count;
}

//创建并设置每行显示的内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL viewFlag = tableView == self.NotApproveView;
    BOOL initFlag = viewFlag ? isInitAtNotView : isInitAtYetView;
    
    //载入数据
    NSArray *dataAry;
    if (viewFlag) {
        dataAry = notApproveDataAry;
    }else{
        dataAry = approvedDataAry;
    }
    
    //从缓存中得到实例Cell复用
    My2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_RESUSE_ID];

    if (dataAry==nil || dataAry.count == 0) {
        //空数据情况处理
        for (UIView *view in cell.contentView.subviews) {
            view.hidden = YES;
        }
        cell.textLabel.hidden = NO;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = initFlag ? @"暂无数据" : @"数据正在加载..";
    }else{
        cell.textLabel.hidden = YES;
        cell.textLabel.text = nil;
        for (UIView *view in cell.contentView.subviews) {
            view.hidden = NO;
        }
        cell.person = dataAry[indexPath.row];
    }
    
    return cell;
}


//某行已经被选中时调用
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((tableView == self.NotApproveView) && (notApproveDataAry.count != 0) ) {
        PeoperData *peoper = notApproveDataAry[indexPath.row];
        [self.selectedLeaveId addObject:peoper.attendanceId];
    }
}
//某行已经结束被选中时调用
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    PeoperData *peoper = notApproveDataAry[indexPath.row];
    [self.selectedLeaveId removeObject:peoper.attendanceId];
}
//设置行高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}


//提示并确认审核事件
- (void)remindAndSubmitAction:(UIButton *)sender {
    UIAlertView *alerVC = [[UIAlertView alloc]initWithTitle:@"确认提示" message:@"请对进行的记录进行审核通过/不通过操作。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"不通过",@"通过", nil];
    
    [alerVC show];
}

//监听提示框按钮反馈(remindAndSubmitAction - alertView)
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {return;}
    
    if (self.selectedLeaveId.count && (buttonIndex == 1 || buttonIndex == 2)){
        NSString *status = (buttonIndex == 1) ? @"N" : (buttonIndex == 2) ? @"Y" : nil;
        NSString *string = [self.selectedLeaveId componentsJoinedByString:@","];
        
        [AMSystemManager interfaceAttendaceBatchApprove:[self.userDefaults stringForKey:@"KEY"] attendanceIds:string auditStatus:status complation:^(id obj) {
            [self requestDataToInitTableViewByStatus:FLAG_NOT_APPROVE];
        }];
        
    }
}

//审核Tab的TouchUp触发(动画过度效果)
- (IBAction)btnApproveAnimation:(UIButton *)sender {
    NSInteger index = sender.tag -1;
    
    if (index == 0) {//没审核
        self.btnBatchApprove.hidden = NO;
        if(!isInitAtNotView){
            [self requestDataToInitTableViewByStatus:FLAG_NOT_APPROVE];
        }
    }else if(index == 1){//已审核
        self.btnBatchApprove.hidden = YES;
        if(!isInitAtYetView){
            [self requestDataToInitTableViewByStatus:FLAG_YET_APPROVE];
        }
    }
    
    /*
     *动画效果
     */
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.3];
    
    //过程条改变样式
    self.Progress.progressTintColor =
    (index == 0 ? [UIColor blueColor] : [UIColor lightGrayColor]);
    self.Progress.trackTintColor =
    (index == 0 ? [UIColor lightGrayColor] : [UIColor blueColor]);
    
    //scrollView动画
    [self.ScrollView setContentOffset:CGPointMake(320 * index, 0)];//页面滑动
    
    [UIView commitAnimations];
    
}

- (IBAction)Back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
