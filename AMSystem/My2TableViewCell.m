//
//  my2TableViewCell.m
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-24.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import "My2TableViewCell.h"

@implementation My2TableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.name.text = self.person.attname;
    self.time.text = self.person.signdate;
    self.adrress.text = self.person.signaddres;
    self.type.text = self.person.signtype;
    self.depyname.text = self.person.deptname;
    self.MyImage.image = self.person.pic;
    
}
@end
