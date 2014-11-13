//
//  AMSystemManager.m
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-5.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import "AMSystemManager.h"
#import "SBJson/JSON.h"
#import "PeoperData.h"
#import "MyCell.h"
@implementation AMSystemManager

/*
 * 创建带参数的异步GET请求 并执行回调
 */
+(void)requestGetConnectByParams:(NSDictionary *)params
                  requestUrlpath:(NSString *)path
                        callBack:(RequestUrlCallback)callBack{
    
    //设置GET请求的URL参数
    NSMutableString *urlParams = [[NSMutableString alloc]initWithString:@"?"];
    NSArray *keys= [params allKeys];
    for(int i=0;i<[keys count];i++){
        
        NSString *key = [keys objectAtIndex:i];
        NSString *val = [params objectForKey:key];
        
        if(i!=0){[urlParams appendFormat:@"&"];}
        [urlParams appendFormat:@"%@=%@", key, val];
    }
    
    //创建URL请求
    NSString *urlparams = [[urlParams description] stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSURL *url = [NSURL URLWithString:[path stringByAppendingString:urlparams]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //异步发送GET请求
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSString *dataString = [[NSString alloc]initWithData:data encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
            NSDictionary *json = [parser objectWithString:dataString error:nil];
            callBack(json, response, data, error);
            
        //});
    }];

}

//签到
+(void)interfaceRegister:(NSString *)userKey
            userSignType:(NSString *)signtype
         userSignAddress:(NSString *)signAddress
           userLongitude:(NSString *)longitude
            userLatitude:(NSString *)latitude
             pictureData:(NSData *)picData
              complation:(InterfaceCompleteCallback)complation{
    
    
    //中文转码(文字的编码)
    signAddress = [signAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //URL参数
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userKey, @"formMap.KEY",
                            signtype, @"formMap.SIGN_TYPE",
                            signAddress, @"formMap.SIGN_ADDRESS",
                            longitude, @"formMap.LONGITUDE",
                            latitude, @"formMap.LATITUDE",
                            nil];
    
    
    
    //分隔符(下横线开头后随意字符)
    NSString *boundary = @"AaB03x";
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",boundary];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    
    //请求
    NSURL *url = [NSURL URLWithString:@"http://oa.96930.cn/interface/attendance/sign.do"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    //-----header----
    [request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary] forHTTPHeaderField:@"Content-Type"];
    
    
    //-----body------
    NSStringEncoding encoding = NSUTF8StringEncoding;//字符编码(Data存储的编码)
    NSMutableData *body = [[NSMutableData alloc]init];
    
    //设置URL参数
    NSArray *keys= [params allKeys];
    for(int i=0;i<[keys count];i++){//遍历keys
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        
        //添加分界线，换行
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", MPboundary] dataUsingEncoding:encoding]];
        //添加字段名称，换2行
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:encoding]];
        //添加字段的值
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:key]] dataUsingEncoding:encoding]];
        
    }
    
    
    //设置图片
    NSString *interfacePicParamName = @"file_arr";
    NSString *uploadPicName = @"image.png";//上传图片名称
    if (picData) {
        //添加分界线，换行
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", MPboundary] dataUsingEncoding:encoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", interfacePicParamName, uploadPicName] dataUsingEncoding:encoding]];
        [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:encoding]];
        [body appendData:picData];//插入大数据(图片)
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //设置结束符
    [body appendData:[[NSString stringWithFormat:@"%@", endMPboundary] dataUsingEncoding:encoding]];
    
    //设置内容长度
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    request.HTTPBody = body;//赋值
    
    //回调代码块
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSString *dataString = [[NSString alloc]initWithData:data encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
        NSDictionary *json = [parser objectWithString:dataString error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            complation(json);
        });
    }];
    
}

//登录
+(void)interfaceLoginByName:(NSString *)userName
                   passWord:(NSString *)passWord
                 complation:(InterfaceCompleteCallback)complation{
    
    NSString *path = [NSString stringWithFormat:@"http://oa.96930.cn/interface/login/submit.do"];
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
                            userName, @"formMap.USERNAME",
                            passWord, @"formMap.PASSWORD",
                            nil];
    
    [AMSystemManager requestGetConnectByParams:params
                     requestUrlpath:path
                           callBack:^(NSDictionary *json, NSURLResponse *response, NSData *data, NSError *error) {
                               if(complation==nil){return;}
                               dispatch_async(dispatch_get_main_queue(), ^{//使用主线程绘画界面
                                   complation(json);
                               });
                           }];
}

//请假管理
+(void)interfaceLeaveInfos:(NSString *)userKey
               auditStatus:(NSString *)status
                  userType:(NSString *)userType
                complation:(InterfaceCompleteCallback)complation{
    
    //创建URL请求
    NSString *path = [NSString stringWithFormat:@"http://oa.96930.cn/interface/leave/list.do"];
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
                               userKey, @"formMap.KEY",
                               status, @"formMap.AUDIT_STATUS",
                               userType, @"formMap.TYPE",
                               nil];
    
    [AMSystemManager requestGetConnectByParams:params
                     requestUrlpath:path
                           callBack:^(NSDictionary *json, NSURLResponse *response, NSData *data, NSError *error) {
                               if(complation==nil){return;}
                               dispatch_async(dispatch_get_main_queue(), ^{//使用主线程绘画界面
                                   complation(json);
                               });
                           }];
    
}

//请假详情
+(void)interfaceLeaveDetail:(NSString *)userKey
               leaveApplyId:(NSString *)leaveApplyId
                 complation:(InterfaceCompleteCallback)complation{
    
    //创建URL请求
    NSString *path = [NSString stringWithFormat:@"http://oa.96930.cn/interface/leave/detail.do"];
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
                               userKey, @"formMap.KEY",
                               leaveApplyId, @"formMap.LEAVE_APPLY_ID",
                               nil];
    
    //异步发送GET请求
    [AMSystemManager requestGetConnectByParams:params
                     requestUrlpath:path
                           callBack:^(NSDictionary *json, NSURLResponse *response, NSData *data, NSError *error) {
                               if(complation==nil){return;}
                               dispatch_async(dispatch_get_main_queue(), ^{//使用主线程绘画界面
                                   complation(json);
                               });
                           }];
    
}

//请假申请批量审批接口
+(void)interfaceLeaveBatchApprove:(NSString *)userKey
                    leaveApplyIds:(NSString *)leaveApplyIds
                      auditStatus:(NSString *)status
                       complation:(InterfaceCompleteCallback)complation{
    
    //创建URL请求
    NSString *path = [NSString stringWithFormat:@"http://oa.96930.cn/interface/leave/audit.do"];
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
                            userKey, @"formMap.KEY",
                            leaveApplyIds, @"formMap.LEAVE_APPLY_IDS",
                            status, @"formMap.AUDIT_STATUS",
                            nil];
    
    //异步发送GET请求
    [AMSystemManager requestGetConnectByParams:params
                     requestUrlpath:path
                           callBack:^(NSDictionary *json, NSURLResponse *response, NSData *data, NSError *error) {
                               if(complation==nil){return;}
                               dispatch_async(dispatch_get_main_queue(), ^{//使用主线程绘画界面
                                   complation(json);
                               });
                           }];
    
}

//请假申请 提交
+(void)interfaceLeaveApply:(NSString *)userKey
                 beginTime:(NSString *)beginTime
                   endTime:(NSString *)endTime
                 applyType:(NSString *)applyType
               applyReason:(NSString *)applyReason
                complation:(InterfaceCompleteCallback)complation{
    
    //创建URL请求
    NSString *path = [NSString stringWithFormat:@"http://oa.96930.cn/interface/leave/apply.do"];
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
                            userKey, @"formMap.KEY",
                            beginTime, @"formMap.APPLY_BEGIN_DATE",
                            endTime, @"formMap.APPLY_END_DATE",
                            applyType, @"formMap.APPLY_TYPE",
                            applyReason, @"formMap.APPLY_REASON",
                            nil];
    
    //异步发送GET请求
    [AMSystemManager requestGetConnectByParams:params
                     requestUrlpath:path
                           callBack:^(NSDictionary *json, NSURLResponse *response, NSData *data, NSError *error) {
                               if(complation==nil){return;}
                               dispatch_async(dispatch_get_main_queue(), ^{//使用主线程绘画界面
                                   complation(json);
                               });
                           }];
    
    
}

//考勤签到审核
+(void)interfaceAttendaceInfos:(NSString *)userKey
                   auditStatus:(NSString *)status
                      userType:(NSString *)type
                    complation:(InterfaceCompleteCallback)complation{
    
    //创建URL请求
    NSString *path = [NSString stringWithFormat:@"http://oa.96930.cn/interface/attendance/list.do"];
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
                            userKey, @"formMap.KEY",
                            status, @"formMap.AUDIT_STATUS",
                            type, @"formMap.TYPE",
                            nil];
    
    //异步发送GET请求
    [AMSystemManager requestGetConnectByParams:params
                     requestUrlpath:path
                           callBack:^(NSDictionary *json, NSURLResponse *response, NSData *data, NSError *error) {
                               if(complation==nil){return;}
                               
                               //dispatch_async(dispatch_get_main_queue(), ^{//使用主线程绘画界面
                                   complation(json);
                               //});
                           }];
    
    
}

//考勤签到批量审核
+(void)interfaceAttendaceBatchApprove:(NSString *)userKey
                        attendanceIds:(NSString *)attendanceIds
                          auditStatus:(NSString *)status
                           complation:(InterfaceCompleteCallback)complation{
    
    //创建URL请求
    NSString *path = [NSString stringWithFormat:@"http://oa.96930.cn/interface/attendance/audit.do"];
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
                            userKey, @"formMap.KEY",
                            status, @"formMap.AUDIT_STATUS",
                            attendanceIds, @"formMap.ATTENDANCE_IDS",
                            nil];
    
    //异步发送GET请求
    [AMSystemManager requestGetConnectByParams:params
                     requestUrlpath:path
                           callBack:^(NSDictionary *json, NSURLResponse *response, NSData *data, NSError *error) {
                               if(complation==nil){return;}
                               dispatch_async(dispatch_get_main_queue(), ^{//使用主线程绘画界面
                                   complation(json);
                               });
                           }];
    
}

//考勤签到汇总报表
+(void)interfaceAttendanceReportInfos:(NSString *)userKey
                            beginDate:(NSString *)beginTime
                              endDate:(NSString *)endTime
                           complation:(InterfaceCompleteCallback)complation{
    
    //创建URL请求
    NSString *path = [NSString stringWithFormat:@"http://oa.96930.cn/interface/attendance/report.do"];
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
                            userKey, @"formMap.KEY",
                            beginTime, @"formMap.BEGIN_DATE",
                            endTime, @"formMap.END_DATE",
                            nil];
    
    //异步发送GET请求
    [AMSystemManager requestGetConnectByParams:params
                     requestUrlpath:path
                           callBack:^(NSDictionary *json, NSURLResponse *response, NSData *data, NSError *error) {
                               if(complation==nil){return;}
                               dispatch_async(dispatch_get_main_queue(), ^{//使用主线程绘画界面
                                   complation(json);
                               });
                           }];
}

//考勤查询-某人某月考勤签到记录-精确到月
+(void)interfaceAttendanceReportExactToMonth:(NSString *)userKey
                                  serachTime:(NSString *)time
                                  complation:(InterfaceCompleteCallback)complation{
    
    //创建URL请求
    NSString *path = [NSString stringWithFormat:@"http://oa.96930.cn/interface/attendance/perReport.do"];
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
                            userKey, @"formMap.KEY",
                            time, @"formMap.TIME",
                            nil];
    
    //异步发送GET请求
    [AMSystemManager requestGetConnectByParams:params
                     requestUrlpath:path
                           callBack:^(NSDictionary *json, NSURLResponse *response, NSData *data, NSError *error) {
                               if(complation==nil){return;}
                               dispatch_async(dispatch_get_main_queue(), ^{//使用主线程绘画界面
                                   complation(json);
                               });
                           }];
    
}


//考勤查询-某人某月考勤签到记录-精确到日
+(void)interfaceAttendanceReportExactToDay:(NSString *)userKey
                                serachDate:(NSString *)date
                                complation:(InterfaceCompleteCallback)complation{
    
    //创建URL请求
    NSString *path = [NSString stringWithFormat:@"http://oa.96930.cn/interface/attendance/perReportDetail.do"];
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
                            userKey, @"formMap.KEY",
                            date, @"formMap.DATE",
                            nil];
    
    //异步发送GET请求
    [AMSystemManager requestGetConnectByParams:params
                     requestUrlpath:path
                           callBack:^(NSDictionary *json, NSURLResponse *response, NSData *data, NSError *error) {
                               if(complation==nil){return;}
                               dispatch_async(dispatch_get_main_queue(), ^{//使用主线程绘画界面
                                   complation(json);
                               });
                           }];
    
}

//考勤详情
+(void)interfaceAttendanceDetail:(NSString *)userKey
                       userId:(NSString *)userId
                      complation:(InterfaceCompleteCallback)complation{
    
    //创建URL请求
    NSString *path = [NSString stringWithFormat:@"http://oa.96930.cn/interface/attendance/detail.do"];
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
                            userKey, @"formMap.KEY",
                            userId, @"formMap.ATTENDANCE_ID",
                            nil];
    
    //异步发送GET请求
    [AMSystemManager requestGetConnectByParams:params
                     requestUrlpath:path
                           callBack:^(NSDictionary *json, NSURLResponse *response, NSData *data, NSError *error) {
                               if(complation==nil){return;}
                               dispatch_async(dispatch_get_main_queue(), ^{//使用主线程绘画界面
                                   complation(json);
                               });
                           }];
}

@end
