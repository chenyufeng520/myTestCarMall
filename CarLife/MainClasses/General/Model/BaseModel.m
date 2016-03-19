//
//  BaseModel.m
//

#import "BaseModel.h"

@implementation BaseModel
//自定义初始化
- (id)initWithDic:(NSDictionary *)jsonDic {
    
    self = [super init];
    
    if (self) {
        //将字典中value交给model的属性
        [self setAttrbuteWith:jsonDic];
    }
    
    return self;
}

//1.将字典中value交给model的属性
- (void)setAttrbuteWith:(NSDictionary *)jsonDic {
    
    //已知数据：jsonDic:   jsonKey   jsonValue
    
    //可以将jsonKey作为model的属性名
    //  jsonKey:model
    
    //1.取得属性的名字
    //json的key ： 属性名
    NSDictionary *mapDic = [self attributeMapDic:jsonDic];
    for (NSString *jsonKey in mapDic) {
        
        //取得属性名
        NSString *modelArrt = [mapDic objectForKey:jsonKey];
        //type   setType:
        //方法选择器
        //方式一：
        //        @selector(<#selector#>)
        //方式二：
        //        NSSelectorFromString(@"setType:");
        
        //取得对应的setter方法
        SEL sel = [self stringToSel:modelArrt];
        
        //取得json中对象的value
        id value = [jsonDic objectForKey:jsonKey];
        
        //如果value是null
        if ([value isKindOfClass:[NSNull class]]) {
            value = @"";
        }
        
        //判断self是否实现了sel
        if ([self respondsToSelector:sel]) {
            
            [self performSelector:sel withObject:value];
            
        }
    }
}


//生成setter的方法  name  age  height  newId   setNewId:
- (SEL)stringToSel:(NSString *)modelArrt {
    //newId  ->  Newid
    //    [modelArrt capitalizedString];
    
    //截取属性首字母
    NSString *firstStr = [modelArrt substringToIndex:1];
    //首字母转换成大写
    firstStr = [firstStr uppercaseString];
    
    //首字母以外的字符串
    NSString *endStr = [modelArrt substringFromIndex:1];
    
    NSString *sel = [NSString stringWithFormat:@"set%@%@:",firstStr,endStr];
    //将字符串转换成sel
    SEL selector = NSSelectorFromString(sel);
    
    return selector;
    
}

//2.将jsonkey作为属性名:  映射关系
- (NSDictionary *)attributeMapDic:(NSDictionary *)jsonDic {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    for (NSString *jsonKey in jsonDic) {
        [dic setObject:jsonKey forKey:jsonKey];
    }
    
    return dic;
}

@end
