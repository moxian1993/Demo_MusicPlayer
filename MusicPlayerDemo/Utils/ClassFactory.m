//
//  ClassFactory.m
//  解耦化程序
//
//  Created by zhuwei on 16/4/10.
//  Copyright © 2016年 zhuwei. All rights reserved.
//

#import "ClassFactory.h"
#import <objc/runtime.h>

@implementation ClassFactory {
    NSMutableDictionary *_dictClasses;
}

IMPLEMENTATION_SINGLETON(ClassFactory)

- (instancetype)init
{
    self = [super init];
    if (self) {
       _dictClasses = [NSMutableDictionary dictionary];
        [self setupClasses];
    }
    return self;
}

#pragma mark - 安装注册 -
/**
 *  初始化类映射
 */
- (void)setupClasses {
    NSArray *queryClses = [self queryRegisteredClasses];
    
    [queryClses enumerateObjectsUsingBlock:^(id cls, NSUInteger idx, BOOL *stop) {
        [self bindClass:cls];
    }];
}

/**
 *  查询当前注册的类
 *
 *  @return 返回注册类列表
 */
- (NSMutableArray *)queryRegisteredClasses {
    NSMutableArray *registeredClass = [NSMutableArray array];
    //获取所有类
    int numberOfClasses = objc_getClassList(NULL, 0);
    Protocol *registerProtocol = @protocol(ClassFactoryRegisterProtocol);
    Class *classes = (Class *)malloc(sizeof(Class) * numberOfClasses);
    objc_getClassList(classes, numberOfClasses);
    
    for (int i = 0; i < numberOfClasses; i ++) {
        Class cls = classes[i];
        for (Class thisCls = cls; nil != thisCls; thisCls = class_getSuperclass(thisCls)) {
            if(class_conformsToProtocol(cls, registerProtocol) && ![NSStringFromClass(thisCls) isEqualToString:@"NSObject"]) {
                [registeredClass addObject:thisCls];
            }
        }
    }
    free(classes);
    return registeredClass;
}

/**
 *  绑定类
 *
 *  @param cls 需要绑定的类
 */
- (void)bindClass:(Class)cls {
    NSMutableArray * classStack = [NSMutableArray array];
    for ( Class thisClass = cls; nil != thisClass; thisClass = class_getSuperclass( thisClass ) )
    {
        [classStack addObject:thisClass];
    }
    
    for ( Class thisClass in classStack )
    {
        uint protocolListCount = 0;
        Protocol * const *pArrProtocols = class_copyProtocolList(thisClass,&protocolListCount);
        if(pArrProtocols != NULL && protocolListCount > 0) {
            for (int i = 0; i < protocolListCount; i++) {
                Protocol *protocol = *(pArrProtocols + i);
                [self bindProtocol:protocol Class:cls];
            }
            free((void *)pArrProtocols);
        }
    }
}

/**
 *  类与协议进行绑定
 *
 *  @param protocol 协议
 *  @param cls      需要绑定的类
 */
- (void)bindProtocol:(Protocol *)protocol Class:(Class)cls {
    
    if(protocol == nil) return;
    
    //注册当前的协议类
    NSString* protocolString = NSStringFromProtocol(protocol);
    if(protocolString == nil || [protocolString isEqualToString:@"NSObject"] || protocol_isEqual(protocol, @protocol(ClassFactoryRegisterProtocol))) return;
    
    //注册类
    NSMutableArray *_protocolClasses = _dictClasses[protocolString];
    if(_protocolClasses == nil) {
        _protocolClasses = [NSMutableArray array];
        [_dictClasses setObject:_protocolClasses forKey:protocolString];
    }
    
    if([_protocolClasses containsObject:cls]) return;
    
    //把子类实现放在父类实现的前面
    BOOL added = NO;
    for (NSInteger i = 0; i < [_protocolClasses count]; i ++) {
        Class existedProtocolCls = _protocolClasses[i];
        if([cls isSubclassOfClass:existedProtocolCls]) {
            [_protocolClasses insertObject:cls atIndex:i];
            added = YES;
            break;
        }
    }
    if(!added) {
        [_protocolClasses addObject:cls];
    }
    
    //注册子协议
    uint protocolListCount = 0;
    Protocol * const *pArrProtocols = protocol_copyProtocolList(protocol,&protocolListCount);
    if(pArrProtocols != NULL && protocolListCount > 0) {
        for (int i = 0; i < protocolListCount; i++) {
            Protocol *subprotocol = *(pArrProtocols + i);
            [self bindProtocol:subprotocol Class:cls];
        }
        free((void *)pArrProtocols);
    }
    
}

#pragma mark - 查询 -
/**
 *  通过类创建实例
 *
 *  @param cls 类
 *
 *  @return 返回实例
 */
- (id)createInstanceWithClass:(Class)cls {
    id instance = nil;
    //判断是否是单例模式，如果是单例模式就取单例方法
    SEL sharedInstanceMethod = NSSelectorFromString(@"sharedInstance");
    Method method = class_getClassMethod(cls, sharedInstanceMethod);
    if ( method )
    {
        IMP imp = method_getImplementation( method );
        id (*func)(id, SEL) = (void *)imp;
        if ( func )
        {
            instance = func(cls, sharedInstanceMethod);
        }
    } else {
        instance = [[cls alloc] init];
    }
    return instance;
}

/**
 *  通过协议查询实现类列表
 *
 *  @param protocol 协议
 *
 *  @return 返回实现类列表
 */
- (NSArray<Class> *)queryImplClassesForProtocol:(Protocol *)protocol {
    NSAssert(protocol, @"protocol is nil");
    return [_dictClasses objectForKey:NSStringFromProtocol(protocol)];
}

/**
 *  痛殴协议查询实现类
 *
 *  @param protocol 协议
 *
 *  @return 返回实现类
 */
- (Class)queryImplClassForProtocol:(Protocol *)protocol {
    NSArray<Class> *clses = [self queryImplClassesForProtocol:protocol];
    if(clses != nil && [clses count] > 0)
        return clses.firstObject;
    return nil;
}

/**
 *  通过协议返回实现类的实例列表
 *
 *  @param protocol 协议名
 *
 *  @return 返回实例列表
 */
- (NSArray *)queryImplInstancesForProtocol:(Protocol *)protocol {
    NSMutableArray *instances = [NSMutableArray array];
    
    NSArray<Class> *clses = [self queryImplClassesForProtocol:protocol];
    if(clses == nil || clses.count == 0) return instances;
    
    for (Class cls in clses) {
        id instance = [self createInstanceWithClass:cls];
        if(instance != nil) [instances addObject:instance];
    }
    
    return instances;
}

/**
 *  通过协议查询实现类的实例
 *
 *  @param protocol 协议
 *
 *  @return 返回实例
 */
- (id)queryImplInstanceForProtocol:(Protocol *)protocol {
    Class cls = [self queryImplClassForProtocol:protocol];
    return [self createInstanceWithClass:cls];
    
    
}

@end
