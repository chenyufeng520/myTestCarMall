//
//  NewsListModel.h
//  CarLife
//
//  Created by 陈宇峰 on 16/5/20.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsListModel : NSObject

@property(nonatomic,copy)NSString *desc,*link,*pubDate,*source,*title,*channelId,*channelName,*nid;
@property (nonatomic ,strong) NSMutableArray *imageurls;

- (id)initWithJasonDic:(NSDictionary *)jasonDic;

@end
