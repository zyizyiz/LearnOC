//
//  main.m
//  LearnOC
//
//  Created by ios on 2019/1/11.
//  Copyright © 2019年 KN. All rights reserved.
//


/*
 OC的对象、类都是基于C\C++的什么数据结构实现的?  答: 基于结构体，在OC文件编译后会生成struct NSObjct_IMPL 的结构体
 
 
 objc 源码:
 size_t instanceSize(size_t extraBytes) {
     size_t size = alignedInstanceSize() + extraBytes;
     // CF requires all objects be at least 16 bytes.
     if (size < 16) size = 16;
     return size;
 }
 
 */
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>

/*
struct NSObject_IMPL {
    Class isa; //指针在64位系统中是占8个字节，在32位系统中占4个字节
};

struct Student_IMPL {
    struct NSObject_IMPL NSObject_IVARS;  // 8个字节
    NSString *name;  // 8个字节
    int age;   // 4个字节
};
 */

@interface Student : NSObject {
    NSString *name;
    int age;
}
@end

@implementation Student

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSObject *obj = [[NSObject alloc]init];
        
        // 8 查看objc4源码，证明在64位系统中NSObject中的实例属性占8个字节
        // Debug -> Debug Workflow -> View Memory 查看obj指向的值
        // 41 61 A1 C2 FF FF 1D 00 00 00 00 00 00 00 00 00
        // 代表系统分配了16个字节，但类只使用了8个字节（创建一个实例对象，至少需要多少内存？）
        NSLog(@"%zd",class_getInstanceSize([NSObject class]));
        
        // 16 代表一个NSObject对象占用16个字节（创建一个实例对象，实际上分配了多少内存？）
        NSLog(@"%zd",malloc_size((__bridge const void *)obj));
        
        Student *stu = [[Student alloc]init];
        // 24  系统会分配类中实例属性中占最大的字节的倍数
        NSLog(@"%zd",class_getInstanceSize([Student class]));
        // 32  系统会分配16个字节的倍数给对象\类
        NSLog(@"%zd",malloc_size((__bridge const void *)stu));
        
    }
    return 0;
}
