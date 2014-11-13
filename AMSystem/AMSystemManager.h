//
//  AMSystemManager.h
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-5.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^InterfaceCompleteCallback)(id obj);
typedef void (^RequestUrlCallback)(NSDictionary *json, NSURLResponse *response, NSData *data, NSError *error);

@interface AMSystemManager : NSObject

@property (nonatomic,strong)NSArray *arr;

/*
 * 创建带参数的异步GET请求 并执行回调
 */
+(void)requestGetConnectByParams:(NSDictionary *)params
                  requestUrlpath:(NSString *)path
                        callBack:(RequestUrlCallback)callBack;

//登陆
+(void)interfaceLoginByName:(NSString *)userName
                   passWord:(NSString *)userPassages
                 complation:(InterfaceCompleteCallback)complation;
//签到
+(void)interfaceRegister:(NSString *)userKEY
            userSignType:(NSString *)userSigntype
         userSignAddress:(NSString *)userSignaddr
           userLongitude:(NSString *)longitude
            userLatitude:(NSString *)latitude
             pictureData:(NSData *)picData
              complation:(InterfaceCompleteCallback)complation;
//请假管理
+(void)interfaceLeaveInfos:(NSString *)userKEY
               auditStatus:(NSString *)AUDITSTATUS
                  userType:(NSString *)userTYPE
                complation:(InterfaceCompleteCallback)complation;
//请假详情
+(void)interfaceLeaveDetail:(NSString *)loginKey
               leaveApplyId:(NSString *)leaveID
                 complation:(InterfaceCompleteCallback)complation;
//请假申请
+(void)interfaceLeaveApply:(NSString *)Key
                 beginTime:(NSString *)beginDate
                   endTime:(NSString *)EndDate
                 applyType:(NSString *)applyType
               applyReason:(NSString *)ApplyReason
                complation:(InterfaceCompleteCallback)complation;
//请假申请批量审批接口
+(void)interfaceLeaveBatchApprove:(NSString *)Key
                    leaveApplyIds:(NSString *)leaveApplyIDS
                      auditStatus:(NSString *)auditStatus
                       complation:(InterfaceCompleteCallback)complation;
//考勤签到汇总报表
+(void)interfaceAttendanceReportInfos:(NSString *)Key
                            beginDate:(NSString *)beginDate
                              endDate:(NSString *)EndDate
                           complation:(InterfaceCompleteCallback)complation;
//考勤-某人某月考勤签到记录(精确到日)
+(void)interfaceAttendanceReportExactToDay:(NSString *)Key
                                serachDate:(NSString *)date
                                complation:(InterfaceCompleteCallback)complation;
//考勤-某人某月考勤签到记录(精确到月)
+(void)interfaceAttendanceReportExactToMonth:(NSString *)Key
                                  serachTime:(NSString *)time
                                  complation:(InterfaceCompleteCallback)complation;
//考勤签到审核
+(void)interfaceAttendaceInfos:(NSString *)Key
                   auditStatus:(NSString *)auditstatus
                      userType:(NSString *)type
                    complation:(InterfaceCompleteCallback)complation;
//考勤详情
+(void)interfaceAttendanceDetail:(NSString *)Key
                          userId:(NSString *)Attid
                      complation:(InterfaceCompleteCallback)complation;
//考勤签到批量审核
+(void)interfaceAttendaceBatchApprove:(NSString *)auditKey
                        attendanceIds:(NSString *)auditIDS
                          auditStatus:(NSString *)STATUS
                           complation:(InterfaceCompleteCallback)complation;
@end
