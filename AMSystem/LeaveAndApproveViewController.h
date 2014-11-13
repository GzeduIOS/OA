//
//  LeaveAndApproveViewController.h
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-5.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myReachability.h"
@interface LeaveAndApproveViewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    //视图数据部分
    NSArray *notApproveDataAry;
    NSArray *approvedDataAry;
   
}
@property (strong ,nonatomic)NSDictionary *userInfoDictionary;//上下文传递的用户数据
@property (nonatomic , strong)NSString *segueId;//跳转来源标识
@property (strong,nonatomic)UIButton *btnConfirm;//批量审核的确认按钮

@end
