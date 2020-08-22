//
//  ClassFactory.h
//  解耦化程序
//
//  Created by zhuwei on 16/4/10.
//  Copyright © 2016年 zhuwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWSingleton.h"

/**
 *  通过协议查询实现类列表宏
 *
 *  @param __protocol 协议
 *
 *  @return 返回实现类列表
 */
#define QUERY_CLASSES_FOR_FORPROTOCOL(__protocol) \
([[ClassFactory sharedInstance] queryImplClassesForProtocol:@protocol(__protocol)]))

/**
 *  通过协议查询实现类宏
 *
 *  @param __protocol 协议
 *
 *  @return 实现类
 */
#define QUERY_CLASS_FOR_FORPROTOCOL(__protocol) \
([[ClassFactory sharedInstance] queryImplClassForProtocol:@protocol(__protocol)]))

/**
 *  通过协议查询实现类列表的实例列表宏
 *
 *  @param __protocol 协议
 *
 *  @return 实现类列表的实例列表
 */
#define QUERY_INSTANCES_FOR_PROTOCOL(__protocol) \
((NSArray<id<__protocol>>*)([[ClassFactory sharedInstance] queryImplInstancesForProtocol:@protocol(__protocol)]))

/**
 *  通过协议查询实现类的实例
 *
 *  @param __protocol 协议
 *
 *  @return 实例
 */
#define QUERY_INSTANCE_FOR_PROTOCOL(__protocol) \
((id<__protocol>)([[ClassFactory sharedInstance] queryImplInstanceForProtocol:@protocol(__protocol)]))


/**
 *  声明这个协议表示该类注册进类工厂中
 */
@protocol ClassFactoryRegisterProtocol <NSObject>

@end

/**
 *  类工程，用于解耦
 */
@interface ClassFactory : NSObject

INTERFACE_SINGLETON(ClassFactory)

/**
 *  通过协议返回实现协议的所有类
 *
 *  @param protocol 协议
 *
 *  @return 返回实现协议的所有类
 */
- (NSArray<Class> *)queryImplClassesForProtocol:(Protocol *)protocol;

/**
 *  通过协议返回实现协议的类
 *
 *  @param protocol 协议名称
 *
 *  @return 返回实现协议的类
 */
- (Class)queryImplClassForProtocol:(Protocol *)protocol;

/**
 *  通过协议返回实现类的实例列表
 *
 *  @param protocol 协议名
 *
 *  @return 返回实例列表
 */
- (NSArray *)queryImplInstancesForProtocol:(Protocol *)protocol;

/**
 *  通过协议返回实现协议的类的实例
 *
 *  @param protocol 协议名称
 *
 *  @return 实例
 */
- (id)queryImplInstanceForProtocol:(Protocol *)protocol;



@end
