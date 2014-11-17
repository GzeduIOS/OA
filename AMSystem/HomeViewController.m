//
//  HomeViewController.m
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-5.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import "HomeViewController.h"
#import "LeaveAndApproveViewController.h"
#import "SignatureViewController.h"
#import "SignatureApprovalViewController.h"
#import "AQueryViewController.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *Btn;
@property (weak, nonatomic) IBOutlet UIButton *Btn2;
@property (weak, nonatomic) IBOutlet UIButton *Btn3;
@property (weak, nonatomic) IBOutlet UIButton *Btn4;
@property (weak, nonatomic) IBOutlet UIButton *Btn5;
@property (weak, nonatomic) IBOutlet UIButton *Btn6;

@end

@implementation HomeViewController

//发送跳转前预处理
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
    backBarButtonItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backBarButtonItem;
    
    if ([segue.identifier isEqualToString:@"LeaveSegue"]) {//请假申请单
        LeaveAndApproveViewController *leaveVC = segue.destinationViewController;
        leaveVC.userInfoDictionary = self.Dic;
        leaveVC.segueId = segue.identifier;
 
    }else if([segue.identifier isEqualToString:@"LeaveApprovalSegue"]){//请假审核
        LeaveAndApproveViewController *leaveApprovalVC = segue.destinationViewController;
        leaveApprovalVC.userInfoDictionary = self.Dic;
        leaveApprovalVC.segueId = segue.identifier;
        
    }else if([segue.identifier isEqualToString:@"SignatureApprovalSegue"]){//考勤审核
        SignatureApprovalViewController *signatureApprovalVC = segue.destinationViewController;
        signatureApprovalVC.userInfoDictionary = self.Dic;
        signatureApprovalVC.segueId = segue.identifier;
        
    }else if([segue.identifier isEqualToString:@"SignatureSegue"]){//考勤签到
        SignatureViewController *signVC = segue.destinationViewController;
        signVC.SignatureDic = self.Dic;
        
    }else if([segue.identifier isEqualToString:@"AQuerySegue"]){//考勤查询
        AQueryViewController *queryVC = segue.destinationViewController;
        queryVC.key = self.Dic[@"KEY"];
        
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"考勤管理";
    self.navigationItem.hidesBackButton = YES;
    
    //按钮圆角化
    self.Btn.layer.cornerRadius = 5;
    self.Btn2.layer.cornerRadius = 5;
    self.Btn3.layer.cornerRadius = 5;
    self.Btn4.layer.cornerRadius = 5;
    self.Btn5.layer.cornerRadius = 5;
    self.Btn6.layer.cornerRadius = 5;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.Dic[@"KEY"] forKey:@"KEY"];//登录接口返回的用户KEY
    [userDefaults synchronize];
    
    //权限设置
    if ([@"A"isEqualToString:self.Dic[@"USERINFO"][@"ROLE_CODE"]]){
        //标识为"A" - 普通员工
        [userDefaults setObject:@"1" forKey:@"formMap.TYPE"];
        [userDefaults synchronize];
        
        //权限不足,不显示以下按钮
        self.Btn4.hidden = YES;//考勤报表
        self.Btn5.hidden = YES;//考勤签到审核
        self.Btn6.hidden = YES;//请假审核
        
    }else if ([@"B"isEqualToString:self.Dic[@"USERINFO"][@"ROLE_CODE"]]){
        //标识为"B" - 可管理
        [userDefaults setObject:@"2" forKey:@"formMap.TYPE"];
    }else{
        [userDefaults setObject:@"2" forKey:@"formMap.TYPE"];
    }
    
    
    MyLog(@"formMap.TYPE:%@  %@",[userDefaults stringForKey:@"formMap.TYPE"],self.Dic[@"USERINFO"][@"ROLE_CODE"]);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
