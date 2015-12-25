//
//  ZYZRecommendCell.m
//  美食菜谱
//
//  Created by Jarvan on 15/12/12.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import "ZYZRecommendCell.h"

@interface ZYZRecommendCell ()


@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *caidanImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detaiLabel;

@end



@implementation ZYZRecommendCell


- (void)setCellWithModel:(ZYZRecommendModel *)model{
    self.bgImageView.layer.cornerRadius = 8.0;
    
    self.titleLabel.text = model.title;
    
    self.detaiLabel.text = model.yuanliao;
    
    [self.caidanImageView sd_setImageWithURL:[NSURL URLWithString:model.thumb_2] placeholderImage:[UIImage imageNamed:@"placeholder_Phone"]];
    
    self.caidanImageView.layer.cornerRadius = 8.0;
    
    self.caidanImageView.clipsToBounds = YES;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
