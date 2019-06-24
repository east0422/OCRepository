//
//  main.m
//  01RuntimeBasic
//
//  Created by dfang on 2018-8-30.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "Person.h"
#import "Teacher.h"

// 获取aClass的成员变量和成员方法
void getMethodsAndIvars(Class aClass);
// 使用objc_msgSend调用方法
void testObjcMsgSend();
// 懒加载方法，在运行时动态添加方法
void testMethodAdd();
// 方法交换
void testMethodExchange();

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        Person *person = [[Person alloc] init];
        // 使用clang -rewrite-objc main.c编译生成c++代码
//        Person *person = ((Person *(*)(id, SEL))(void *)objc_msgSend)((id)((Person *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("Person"), sel_registerName("alloc")), sel_registerName("init"));
        
//        getMethodsAndIvars([NSString class]);

//        getMethodsAndIvars([Person class]);
//        getMethodsAndIvars([Teacher class]);
        
//        testObjcMsgSend();
        testMethodAdd();
//        testMethodExchange();
    }
    
    return 0;
}

// 获取类的成员方法和成员变量
void getMethodsAndIvars(Class aClass) {
    // methods
    unsigned int numMethods;
    // copy记得不使用时释放内存
    Method *methods = class_copyMethodList(aClass, &numMethods);
    for (int i = 0; i < numMethods; ++i) {
        SEL sel = method_getName(methods[i]);
        const char *methodName = sel_getName(sel);
        // eatWith:, drinkWater, sex, setSex:, marriedWith:, .cxx_destruct, name, setName:, setWeight:, weight, age, setAge:
        NSLog(@"%@ method: %s", aClass, methodName);
    }
    free(methods);
    
    // ivars
    unsigned int numIvars;
    Ivar *vars = class_copyIvarList(aClass, &numIvars); // 指针
    for (int i = 0; i < numIvars; ++i) {
//        Ivar ivar = *(vars + i);
        Ivar ivar = vars[i];
        const char *ivarName = ivar_getName(ivar);
        const char *ivarType = ivar_getTypeEncoding(ivar);
        // ivar有address, height, tel, _name, _sex, _age, _weight
        NSLog(@"%@ ivar: %s, type: %s", aClass, ivarName, ivarType);
    }
    free(vars);
    
    // properties
    unsigned int numProperties;
    objc_property_t *properties = class_copyPropertyList(aClass, &numProperties);
    for (int i = 0; i < numProperties; ++i) {
        objc_property_t property = properties[i];
        const char *proName = property_getName(property);
        // property有weight, name, sex, age
        NSLog(@"%@ property: %s", aClass, proName);
    }
    free(properties);
}

// 使用objc_msgSend调用方法
void testObjcMsgSend() {
    Person *person = [Person new];
    person.name = @"小明";
   // objc_getRequiredClass("Person") == NSClassFromString(@"Person") == [Person class]
    Class personClass = objc_getRequiredClass("Person"); // NSClassFromString(@"Person"); // [Person class];
    [person performSelector:@selector(drinkWater)]; // 小明 drink water!
    [personClass performSelector:@selector(eatRice)]; // Person eat rice!
    
    // 需先将build setting中objc_msgSend值YES改为NO
    objc_msgSend(person, @selector(eatWith:), @"apple"); // 小明 eat apple!
    
    // 不需要引入Person.h，在运行时才会检查是否有对应的对象及方法
    Class p2Class = objc_msgSend(objc_getRequiredClass("Person"), @selector(alloc));
    NSObject *p2 = objc_msgSend(p2Class, @selector(init));
    objc_msgSend(p2, @selector(setName:), @"小李");
    objc_msgSend(p2, @selector(eatWith:), @"banana");
}

void testMethodAdd () {
    Teacher *wang = [[Teacher alloc] init];
    wang.name = @"小王";
    // hit方法在运行时动态关联实现
    objc_msgSend(wang, @selector(hit:), @"李明");
}

// 使用runtime进行方法交换
void testMethodExchange() {
    NSURL *url = [NSURL URLWithString:@"www.baidu.com/中文测试"]; // url is nil
    NSLog(@"%@", url); // (null)
}
