//
//  APIManager.m
//  XTJailed
//
//  Created by Sem Voigtländer on 13/12/2017.
//  Copyright © 2017 Jailed Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/NSObjCRuntime.h>
#import <dlfcn.h>
#import <mach-o/ldsyms.h>
#import "APIManager.h"

@interface APIManager()
@end
@implementation APIManager

+(BOOL)loadFW:(NSString*)name private:(BOOL)isprivate {
    if(!isprivate) {
        return [[NSBundle bundleWithPath:[NSString stringWithFormat:@"/System/Library/Frameworks/%@.framework", name]] load];
    }
    return [[NSBundle bundleWithPath:[NSString stringWithFormat:@"/System/Library/PrivateFrameworks/%@.framework", name]] load];
}

/*
+(void)dumpClasses {
    uint count = 0;
    const char **classes;
    Dl_info info;
    dladdr(&_mh_execute_header, &info);
    NSLog(@"main is at: %#16llx",(uint64_t)info.dli_saddr);
    classes = objc_copyClassNamesForImage(info.dli_fname, &count);
    //printf("[Classes]\n");
    for (uint i = 0; i < count; i++) {
        NSBundle *b = [NSBundle bundleForClass:NSClassFromString([NSString stringWithUTF8String:classes[i]])];
        if(b != [NSBundle mainBundle]) {
            NSArray* bundlePath = [[b bundlePath] componentsSeparatedByString:@"/"];
            printf("\t%s:\n\t\t- %s\n",[[bundlePath lastObject] UTF8String], classes[i]);
        }
    }
}
*/


+(NSArray*)dumpClasses:(NSString*)framework privateFW:(BOOL)pfw{
    
    uint count = 0;
    Class * classes = NULL;
    NSString *fwClasses = @"";
    count = objc_getClassList(NULL, 0);
    if(count > 0) {
        //printf("[%s Classes]\n", [framework UTF8String]);
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * count);
        count = objc_getClassList(classes, count);
        for (uint i = 0; i < count; i++) {
            NSBundle *b = [NSBundle bundleForClass:NSClassFromString([NSString stringWithUTF8String:class_getName(classes[i])])];
            NSString* path =[NSString stringWithFormat:@"/System/Library/PrivateFrameworks/%@.framework",framework];
            if(!pfw) {
                path = [NSString stringWithFormat:@"/System/Library/Frameworks/%@.framework",framework];
            }
            if([[b bundlePath] isEqualToString:path]) {
                //printf("\t\t- (%s) %s\n",class_getName(class_getSuperclass(classes[i])),class_getName(classes[i]));
                fwClasses = [fwClasses stringByAppendingString:[NSString stringWithFormat:@"%@\n", NSStringFromClass(classes[i])]];
            }
        }
    } else {
        //printf("No classes found in %s.\n", [framework UTF8String]);
    }
    return [fwClasses componentsSeparatedByString:@"\n"];
}


+(NSDictionary*)dumpAllFromFramework:(NSString*)framework privateFW:(BOOL)pfw{
    NSDictionary* data = [NSDictionary dictionary];
    NSArray* classes = [APIManager dumpClasses:framework privateFW:pfw];
    if(classes != nil) {
        [data setValue:classes forUndefinedKey:@"Classes"];
        for(int i = 0; i < classes.count;i++) {
            Class c = NSClassFromString(classes[i]);
            [data setValue:[APIManager dumpProperties:c] forUndefinedKey:@"Properties"];
            [data setValue:[APIManager dumpMethods:c] forUndefinedKey:@"Methods"];
        }
    }
    return data;
}

+(NSArray*)dumpMethods:(Class)class {
    uint methodCnt = 0;
    NSArray* methodArr = [NSArray array];
    Method* methods = class_copyMethodList(class, &methodCnt);
    //printf("[%s Methods]:\n", class_getName(class));
    for (uint i = 0; i < methodCnt; i++) {
        Method method = methods[i];
        //printf("\t- %s\n", sel_getName(method_getName(method)));
        methodArr = [methodArr arrayByAddingObject:[NSString stringWithUTF8String:sel_getName(method_getName(method))]];
    }
    return methodArr;
}

+(NSArray*)dumpProperties:(Class)class{
    uint count = 0;char* propertyType = "";
    objc_property_t *properties = class_copyPropertyList(class, &count);
    //printf("[%s Properties]:\n", class_getName(class));
    NSArray* propertyArr = [NSArray array];
    for(uint i = 0; i < count; i++) {
        if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"NSString"]) {
            propertyType = "NSString";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"NSMutableData"]) {
            propertyType = "NSMutableData";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"NSURL"]) {
            propertyType = "NSURL";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"NSArray"]) {
            propertyType = "NSArray";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"NSError"]) {
            propertyType = "NSError";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"T*"]) {
            propertyType = "char *";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"Tc"]) {
            propertyType = "char";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"TC"]) {
            propertyType = "unsigned char";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"Tq"]) {
            propertyType = "long long";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"TQ"]) {
            propertyType = "unsigned long long";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"Ts"]) {
            propertyType = "short";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"TB"]) {
            propertyType = "BOOL";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"Ti"]) {
            propertyType = "int";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"TI"]) {
            propertyType = "NSInteger";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"Td"]) {
            propertyType = "double";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"Tf"]) {
            propertyType = "float";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"T#"]) {
            propertyType = "Class";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"NSMutableArray"]) {
            propertyType = "NSMutableArray";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"NSObject"]) {
            propertyType = "NSObject";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"NSDictionary"]) {
            propertyType = "NSDictionary";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"NSData"]) {
            propertyType = "NSData";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"Tv"]) {
            propertyType = "void";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"T@"]) {
            propertyType = "id";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"T:"]) {
            propertyType = "selector";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"CGSize=dd"]) {
            propertyType = "CGSize{double,double}";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"^{__IOSurface=}"]) {
            propertyType = "IOSurface*";
        } else if([[NSString stringWithUTF8String:property_getAttributes(properties[i])] containsString:@"T?"]) {
            propertyType = "Unknown";
        } else {
            propertyType = (char*)property_getAttributes(properties[i]);
        }
        //printf("\t- (%s) %s\n",propertyType, property_getName(properties[i]));
        propertyArr = [propertyArr arrayByAddingObject:[NSString stringWithFormat:@"(%@) %@",[NSString stringWithUTF8String:propertyType], [NSString stringWithUTF8String:property_getName(properties[i])]]];
        propertyType = "";
    }
    printf("[iVars]:\n");
    uint ivarsCnt;
    Ivar* ivars = class_copyIvarList(class, &ivarsCnt);
    for (uint i = 0; i < ivarsCnt; i++) {
        char* ivar = (char*)ivar_getName(ivars[i]);
        propertyArr = [propertyArr arrayByAddingObject:[NSString stringWithFormat:@"(iVar) %s", ivar]];
    }
    return propertyArr;
}

+(id) tryCallMethod:(NSString*)ClassName methodName:(NSString*)methodName {
    Class tryClass = NSClassFromString(ClassName);
    if(tryClass != nil) {
        @try {
            if([methodName isEqualToString:@"dealloc"]) {
                return @"Failed to call method.\n(Reason: NULL Dereference)";
            }
            id result = [[tryClass alloc] performSelector:NSSelectorFromString(methodName)];
            if(result != nil || ![result isEqual:@""] || ![result isEqualToString:@""]) {
                return result;
            } else {
                return @"Method called but is probably void";
            }
        } @catch(NSException *ex) {
            return [NSString stringWithFormat:@"Failed to call method.\n(Reason: %@)", ex.reason];
        }
    } else {
        return @"Failed to call method.\n(Reason: Class is null.)";
    }
}

+ (NSString*) tryReadProperty:(NSString*)ClassName property:(NSString*)property{
    @try {
        Class tryClass = NSClassFromString(ClassName);
        if(tryClass == nil) {
            return @"Failed to read property\n(Reason: Class is null.)";
        } else {
            id instance = [[tryClass alloc] valueForKey:property];
            NSString* result = [NSString stringWithFormat:@"%@",instance];
            if(result == nil || [result isEqualToString:@"(null)"]) {
                instance = [tryClass valueForKey:property];
                result = [NSString stringWithFormat:@"%@",instance];
                if(result == nil || [result isEqualToString:@"(null)"]) {
                    return @"Failed to read property\n(Reason: read returned null.)";
                } else {
                    return result;
                }
            } else {
                return result;
            }
        }
    } @catch(NSException *ex) {
        if([ex.name containsString:@"NSUnknownKeyException"]) {
            return @"Failed to read property\n(Reason: read returned null.)";
        }
        return [NSString stringWithFormat:@"Failed to read property\n(Reason: %@ %@.)",ex.name , ex.reason];
    }
}
@end

