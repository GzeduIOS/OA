//
//  DetailsViewController.h
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-17.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController
@property(nonatomic,strong)NSString *STRid;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrlabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIImageView *photoimage;
@property(nonatomic,strong)NSUserDefaults *userdefaults;
@end
