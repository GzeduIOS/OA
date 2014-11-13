//
//  URLOperation.h
//  AMSystem
//
//  Created by Benjamin on 11/7/14.
//  Copyright (c) 2014 GZDEU. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol URLOperationDelegate;
@protocol URLOperationDelegate <NSObject>
- (void)connectionFinishWithJson:(NSDictionary *)json;
@end

@interface URLOperation : NSOperation{
    
    NSMutableURLRequest *urlRequest;
    NSURLConnection *urlConnection;
    NSStringEncoding encoding;
    NSMutableDictionary *urlParams;
    id<URLOperationDelegate> delegate;
    
    //线程控制
    BOOL executing;
    BOOL finished;
    
}
-(id)initURLWithString:(NSString *)url
         andWithParams:(NSMutableDictionary *)params
              delegate:(id<URLOperationDelegate>)dele;
@end


