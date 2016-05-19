//
//  ToolKitCell.h
//  CarLife
//
//  Created by 陈宇峰 on 16/5/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolKitCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *toolImg;
@property(nonatomic,strong)UILabel *toolTitle;

-(void)reloadCellWithInfo:(NSDictionary*)info;

@end
