//
//  BaseModel.h
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

//自定义初始化
- (id)initWithDic:(NSDictionary *)jsonDic;

//1.将字典中value交给model的属性
- (void)setAttrbuteWith:(NSDictionary *)jsonDic;

//2.将jsonkey作为属性名:  映射关系
- (NSDictionary *)attributeMapDic:(NSDictionary *)jsonDic;

@end
