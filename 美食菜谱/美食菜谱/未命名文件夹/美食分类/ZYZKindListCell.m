//
//  ZYZKindListCell.m
//  美食菜谱
//
//  Created by Jarvan on 15/12/17.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import "ZYZKindListCell.h"

@interface ZYZKindListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *caidanImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *myDetailLabel;
@end

@implementation ZYZKindListCell

- (void)setCellWithModel:(ZYZKindModel *)model{
    self.bgImageView.layer.cornerRadius = 8.0;
    
    self.caidanImageView.layer.cornerRadius = 8.0;
    
    self.caidanImageView.clipsToBounds = YES;
    
    [self.caidanImageView sd_setImageWithURL:[NSURL URLWithString:model.thumb_2] placeholderImage:[UIImage imageNamed:@"placeholder-iPad"]];
    
    self.titleLabel.text = model.title;
    
    self.myDetailLabel.text = model.yuanliao;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
