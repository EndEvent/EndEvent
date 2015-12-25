//
//  ZYZTopDetailSecondCell.m
//  美食菜谱
//
//  Created by Jarvan on 15/12/21.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import "ZYZTopDetailSecondCell.h"

@interface ZYZTopDetailSecondCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *caipinImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *myDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@end

@implementation ZYZTopDetailSecondCell

- (void)setCellWithDictionary:(NSDictionary *)dic{
    self.bgImageView.layer.cornerRadius = 8.0;
    [self.caipinImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"thumb_2"]] placeholderImage:[UIImage imageNamed:@"placeholder-iPad"]];
    self.caipinImageView.layer.cornerRadius = 8.0;
    self.caipinImageView.clipsToBounds = YES;
    self.titleLabel.text = dic[@"title"];
    self.myDetailLabel.text = dic[@"category"];
    self.ageLabel.text = dic[@"age"];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
