//
//  NewsListModel.m
//  CarLife
//
//  Created by 陈宇峰 on 16/5/20.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "NewsListModel.h"

@implementation NewsListModel

- (id)initWithJasonDic:(NSDictionary *)jasonDic
{
    if (self = [super init])
    {
        self.channelId = jasonDic[@"channelId"];
        self.channelName = jasonDic[@"channelName"];
        self.desc = jasonDic[@"desc"];
        self.link = jasonDic[@"link"];
        self.pubDate = jasonDic[@"pubDate"];
        self.title = jasonDic[@"title"];
        self.source = jasonDic[@"source"];
        self.nid = jasonDic[@"nid"];
        self.imageurls = [NSMutableArray array];
        
        for (int i = 0; i < [jasonDic[@"imageurls"] count]; i++)
        {
            NSDictionary * imageDic = jasonDic[@"imageurls"][i];
            [self.imageurls addObject:imageDic[@"url"]];
        }
    }
    return self;
}

@end
