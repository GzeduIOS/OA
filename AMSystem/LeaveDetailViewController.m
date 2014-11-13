//
//  InformationViewController.m
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-22.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import "LeaveDetailViewController.h"
#import "AMSystemManager.h"
#import "LeaveAndApproveViewController.h"
@interface LeaveDetailViewController ()

@end

@implementation LeaveDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _userKey = [userDefaults stringForKey:@"KEY"];
    
    _lblApplyType.text = _applyType;
    _lblApplyReason.text = _applyReason;
    _lblApplyBeginDate.text = _applyBeginDate;
    _lblApplyEndDate.text = _applyEndDate;
    _lblApplyTimeSpan.text = _applyTimeSpan;
    
    //普通员工不允许操作
    if([_userRoleCode isEqualToString:@"A"] || _isHiddenApproveArea){
        self.txtMemo.hidden = YES;
        self.btnPass.hidden = YES;
        self.btnReject.hidden = YES;
        self.lblMemoDescription.hidden = YES;
    }
}

//textview获得焦点之前会调用
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
//点击View的其他区域隐藏软键盘。
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.txtMemo resignFirstResponder];
}
//textview获得焦点后，并已是第一响应者（first responder）时调用
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.3];
    [self.txtMemo setFrame:CGRectMake(0, self.txtMemo.frame.origin.y-60, self.txtMemo.frame.size.width, self.txtMemo.frame.size.height)];
    [UIView commitAnimations];
}

//审核按钮
- (IBAction)btnPassAndRejectAction:(UIButton *)sender {
    /*
     * 1:通过
     * 2:驳回
     */
    NSString *status = sender.tag == 1 ? @"Y" : sender.tag == 2 ? @"N" : nil ;
    
    [AMSystemManager interfaceLeaveBatchApprove:_userKey leaveApplyIds:_leaveId auditStatus:status complation:^(id obj) {
        //完成跳回列表页
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}



- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
