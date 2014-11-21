//
//  InformationViewController.h
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-22.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeoperData.h"

@interface LeaveDetailViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblApplyType;
@property (weak, nonatomic) IBOutlet UILabel *lblApplyReason;
@property (weak, nonatomic) IBOutlet UILabel *lblApplyBeginDate;
@property (weak, nonatomic) IBOutlet UILabel *lblApplyEndDate;
@property (weak, nonatomic) IBOutlet UILabel *lblApplyTimeSpan;

@property (weak, nonatomic) IBOutlet UITextView *txtMemo;
@property (weak, nonatomic) IBOutlet UIButton *btnPass;
@property (weak, nonatomic) IBOutlet UIButton *btnReject;
@property (weak, nonatomic) IBOutlet UILabel *lblMemoDescription;

@property NSString *applyType;
@property NSString *applyReason;
@property NSString *applyBeginDate;
@property NSString *applyEndDate;
@property NSString *applyTimeSpan;

@property NSString *userRoleCode;
@property NSString *leaveId;
@property NSString *userKey;
@property BOOL isHiddenApproveArea;
@property BOOL ishiddenNotView;

@end
