//
//  ASignature&SignatureApproval&leaveApprovalViewController.m
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-5.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//
#import "AMSystemManager.h"
#import "LeaveAndApproveViewController.h"
#import "LeaveDetailViewController.h"

#import "PeoperData.h"
#import "MyCell.h"
#import "MyTableViewCell.h"
#import "MyJsonParser.h"

#import "UIColor+expanded.h"
#import "UIScrollView+VORefresh.h"//Down Pull Refresh Plugin

static NSString *CELL_NIB_NAME = @"MyTableViewCell";
static NSString *CELL_RESUSE_ID = @"Cell";
static NSString *FLAG_NOT_APPROVE = @"O";//未审核:0 已审核:Y
static NSString *FLAG_YET_APPROVE = @"Y";

@interface LeaveAndApproveViewController ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *lblViewTitle;
@property (weak, nonatomic) IBOutlet UIProgressView *Progress;
@property (weak, nonatomic) IBOutlet UIButton *btnApproved;//已审核
@property (weak, nonatomic) IBOutlet UIButton *btnApprove;//未审核
@property (weak, nonatomic) IBOutlet UIButton *btnFillForm;//填写假条
@property (strong ,nonatomic) UITableView *NotApproveView;//未审核视图区域
@property (strong ,nonatomic) UITableView *ApproveView;//已审核视图区域
@property (strong ,nonatomic) UIButton *btnBatchApprove;//用于审核请假界面的按钮
@property (strong, nonatomic) UIScrollView *ScrollView;

@property NSUserDefaults *userDefaults;
@property NSMutableArray *selectedLeaveId;
@property PeoperData *user;
@property NSString *apiKey;//OA API KEY
@property NSString *userType;

@property CGFloat viewHeight;
@property CGFloat viewWidth;
@property CGFloat topSpeace;//与顶间距
@property int viewCount;

@property BOOL isInitAtNotView;
@property BOOL isInitAtYetView;


@end

@implementation LeaveAndApproveViewController

@synthesize apiKey;
@synthesize userType;
@synthesize viewWidth;
@synthesize viewHeight;
@synthesize topSpeace;
@synthesize viewCount;
@synthesize isInitAtNotView;
@synthesize isInitAtYetView;

//返回按钮
- (IBAction)Back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.selectedLeaveId = [NSMutableArray array];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    apiKey = [self.userDefaults stringForKey:@"KEY"];
    userType = [self.userDefaults stringForKey:@"formMap.TYPE"];//用户类型
    viewHeight = self.view.frame.size.height;
    viewWidth = self.view.frame.size.width;
    topSpeace = 110;//与顶间距
    viewCount = 2;
    
    /*
     * (界面共享)
     * 识别线路来源 并预加载列表数据
     */
    if ([self.segueId isEqualToString:@"LeaveSegue"]) {
        //请假管理
        self.lblViewTitle.text = @"请假申请单";
        
        //来源为管理级别的都设置为普通员工
        if ([@"2" isEqualToString:userType]
            ||
            [@"1" isEqualToString:userType]) {
            self.userType = @"1";
        }
        
    }else if ([self.segueId isEqualToString:@"LeaveApprovalSegue"]) {
        //请假审核
        self.lblViewTitle.text = @"审核请假";
        
        [self.btnFillForm removeFromSuperview];//刷除请假管理的按钮
        [self initBatchApproveBtn];//初始化批量审核按钮
    }
    
    //绘制列表视图
    [self initScrollView];
    [self initNotApproveView];
    [self initApproveView];
    
    //优先请求未审核数据
    [self requestDataToInitTableViewByStatus:FLAG_NOT_APPROVE];
}

-(void) requestDataToInitTableViewByStatus:(NSString *)status{
    
    //请求接口
    [AMSystemManager interfaceLeaveInfos:apiKey
                             auditStatus:status
                                userType:self.userType
                              complation:^(id obj) {
                                  NSArray *dataAry = [MyJsonParser parseByArray:obj];
                                  if([status isEqualToString:FLAG_NOT_APPROVE]){
                                      notApproveDataAry = dataAry;
                                      [self.NotApproveView reloadData];
                                      isInitAtNotView = YES;//标示已读取过数据
                                  }else if([status isEqualToString:FLAG_YET_APPROVE]){
                                      approvedDataAry = dataAry;
                                      [self.ApproveView reloadData];
                                      isInitAtYetView = YES;//标示已读取过数据
                                  }
                                  //NSLog(@"requestDataToInitTableViewByStatus %@ Finish!",status);
                              }];
    
}

//初始化滚动视图
-(void)initScrollView{
    
    //创建scrollView
    self.ScrollView = [[UIScrollView alloc]
                       initWithFrame:CGRectMake(0, topSpeace, viewWidth, viewHeight)];
    self.ScrollView.contentSize  = CGSizeMake(viewWidth * viewCount, viewHeight);
    self.ScrollView.pagingEnabled = YES;
    self.ScrollView.clipsToBounds = NO;
    
    //使用手势事件抹除ScrollView的横向滑动
    UIPanGestureRecognizer *dragGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleDragGesture:)];
    [self.ScrollView addGestureRecognizer:dragGesture];
    [self.view addSubview:self.ScrollView];
}

-(void)initNotApproveView{
    
    //没审核tableview
    self.NotApproveView = [[UITableView alloc]init];
    self.NotApproveView.frame = CGRectMake(viewWidth * 0, 0, viewWidth, viewHeight - topSpeace);
    self.NotApproveView.delegate = self;
    self.NotApproveView.dataSource = self;
    //UITableView隐藏多余的分割线
    self.NotApproveView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.NotApproveView registerNib:[UINib nibWithNibName:CELL_NIB_NAME bundle:nil] forCellReuseIdentifier:CELL_RESUSE_ID];
    [self.NotApproveView addTopRefreshWithTarget:self action:@selector(NotApproveTopRefreshing)];
    [self.ScrollView addSubview: self.NotApproveView];
}

-(void)initApproveView{
    
    //审核tableview
    self.ApproveView = [[UITableView alloc]init];
    self.ApproveView.frame = CGRectMake(viewWidth * 1, 0, viewWidth, viewHeight - topSpeace);
    self.ApproveView.delegate = self;
    self.ApproveView.dataSource = self;
    //UITableView隐藏多余的分割线
    self.ApproveView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.ApproveView registerNib:[UINib nibWithNibName:CELL_NIB_NAME bundle:nil] forCellReuseIdentifier:CELL_RESUSE_ID];
    [self.ApproveView addTopRefreshWithTarget:self action:@selector(ApproveTopRefreshing)];
    [self.ScrollView addSubview: self.ApproveView];
}

-(void)initBatchApproveBtn{
    /*
     * 绘制"批量审核"按钮
     * 大小,位置
     * 文字,颜色
     */
    self.btnBatchApprove = [[UIButton alloc]initWithFrame:CGRectMake(232, 10, 68, 30)];
    self.btnBatchApprove.titleLabel.font = [UIFont systemFontOfSize:15];
    self.btnBatchApprove.backgroundColor = [UIColor colorWithHexString:@"0D74FD"];
    [self.btnBatchApprove setTitle:@"批量审核" forState:UIControlStateNormal];//0D74FD
    [self.btnBatchApprove setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    //按钮添加事情
    [self.btnBatchApprove addTarget:self action:@selector(btnBatchApproveUpAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //加入按钮元素
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

//"批量审核"(请假审核界面)按钮触发事件
-(void)btnBatchApproveUpAction:(UIButton *)sender{
    if (notApproveDataAry.count) {
        self.NotApproveView.allowsMultipleSelectionDuringEditing = YES;
        [self.NotApproveView setEditing:YES animated:YES];
        
        self.btnBatchApprove = nil;//原按钮指向空
        
        self.btnConfirm = [[UIButton alloc]initWithFrame:CGRectMake(232, 10, 68, 30)];
        self.btnConfirm.titleLabel.font = [UIFont systemFontOfSize:15];
        self.btnConfirm.backgroundColor = [UIColor colorWithHexString:@"0D74FD"];
        [self.btnConfirm setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [self.btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
        [self.btnConfirm addTarget:self action:@selector(remindAndSubmitAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:self.btnConfirm];
    }
    
}

//提示并确认审核事件
-(void)remindAndSubmitAction:(UIButton *)sender{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确认提示" message:@"请对进行的记录进行审核通过/不通过操作。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"不通过",@"通过", nil];
    
    [alertView show];
}

//监听提示框按钮反馈(remindAndSubmitAction - alertView)
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    /*
     * 0:取消
     * 1:不通过
     * 2:通过
     */
    if(self.selectedLeaveId.count && (buttonIndex == 1 || buttonIndex == 2)){
        //设置不同状态
        NSString *status = (buttonIndex == 1) ? @"N" : (buttonIndex == 2) ? @"Y" : nil;
        
        NSString *string = [self.selectedLeaveId componentsJoinedByString:@","];
        [AMSystemManager interfaceLeaveBatchApprove:apiKey leaveApplyIds:string auditStatus:status complation:nil];
    }
    
    //按下按钮触发
    
    if(buttonIndex == 0 || buttonIndex == 1 || buttonIndex == 2){
        [self.btnConfirm removeFromSuperview];
        [self.btnBatchApprove setTitle:@"批量审核" forState:UIControlStateNormal];
        self.NotApproveView.allowsMultipleSelectionDuringEditing = NO;
        [self.NotApproveView setEditing:NO animated:YES];
        
    }
    
}




//审核Tab的TouchUp触发(动画过度效果)
- (IBAction)btnApproveAnimation:(UIButton *)sender {
    CGFloat index = sender.tag -1;
    if (index == 0) {//没审核
        self.btnBatchApprove.hidden = NO;
        self.btnFillForm.hidden = NO;
        if(!isInitAtNotView){
            [self requestDataToInitTableViewByStatus:FLAG_NOT_APPROVE];
        }
    }else if(index == 1){//已审核
        self.btnBatchApprove.hidden = YES;
        self.btnFillForm.hidden = YES;
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

//初始化TableView的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *dataAry = tableView == self.NotApproveView ? notApproveDataAry : approvedDataAry;
    
    if (dataAry==nil || dataAry.count==0) {
        return 1;
    }else{
        return dataAry.count;
    }
    
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
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_RESUSE_ID];
    
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
        cell.peoper = dataAry[indexPath.row];
    }
    
    return cell;
    
}

//某行已经被选中时调用
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *dataAry = tableView == self.NotApproveView ? notApproveDataAry : approvedDataAry;
    if (dataAry==nil || dataAry.count == 0) {return;}//数据空则跳出
    
    PeoperData *peoper = dataAry[indexPath.row];
    NSString *roleCode = self.userInfoDictionary[@"USERINFO"][@"ROLE_CODE"];
    
    /*
     * 已审核视图
     */
    if (tableView == self.ApproveView) {
        
        LeaveDetailViewController *infoVC = [self createInfoView:peoper andRoleCode:roleCode];
        
        [self presentViewController:infoVC animated:YES completion:nil];
    }
    
    /*
     * 未审核视图
     */
    if (tableView == self.NotApproveView) {
        if( self.NotApproveView.allowsMultipleSelectionDuringEditing == YES){
            [self.selectedLeaveId addObject:peoper.leaveId];
        }else{
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:peoper.leaveId forKey:@"leaveID"];
            [user synchronize];
            
            LeaveDetailViewController *infoVC = [self createInfoView:peoper andRoleCode:roleCode];
            
            [self presentViewController:infoVC animated:YES completion:nil];
        }
    }
}

//创建请假详情界面
-(LeaveDetailViewController *) createInfoView:(PeoperData *)peoper andRoleCode:(NSString *)roleCode {
    
    LeaveDetailViewController *infoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LeaveDetailViewId"];
    
    infoVC.applyType = peoper.applyType;
    infoVC.applyReason = peoper.applyReason;
    infoVC.applyBeginDate = peoper.applyBeginDate;
    infoVC.applyEndDate = peoper.applyEndDate;
    infoVC.applyTimeSpan = [NSString stringWithFormat:@"%@ 小时",peoper.applyTimeSpan];
    infoVC.userRoleCode = roleCode;
    infoVC.leaveId = peoper.leaveId;
    infoVC.isHiddenApproveArea = [self.segueId isEqualToString:@"LeaveSegue"];
    return infoVC;
}

//某行已经结束被选中时调用
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    PeoperData *peoper = notApproveDataAry[indexPath.row];
    [self.selectedLeaveId removeObject:peoper.leaveId];
}

//设置行高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end
