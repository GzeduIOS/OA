//
//  PeoperData.h
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-16.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeoperData : NSObject
//请假管理
@property (nonatomic,copy)NSString *name;
@property (nonatomic,strong)NSString *applyBeginDate;
@property (nonatomic,strong)NSString *applyEndDate;
@property (nonatomic,strong)NSString *applyTimeSpan;
@property (nonatomic,strong)NSString *applyType;
@property (nonatomic,strong)NSString *deptName;
@property (nonatomic,strong)NSString *leaveId;
@property (nonatomic,strong)NSString *applyReason;

//考勤签到审核
@property (nonatomic ,copy)NSString *attname;//名字
@property (nonatomic ,strong)NSString *signaddres;
@property (nonatomic ,strong)NSString *signdate;
@property (nonatomic ,strong)NSString *deptname;//部门名
@property (nonatomic ,strong)UIImage *pic;
@property (nonatomic)NSString *attendanceId;
@property (nonatomic ,strong)NSString *signtype;
@property (nonatomic ,strong)NSString *auditStatus;//审核状态
// 考勤签到汇总
@property (nonatomic ,copy)NSString *AReportname;//名字
@property (nonatomic ,strong)NSString *normal_num;
@property (nonatomic ,strong)NSString *exception_num;

@end
