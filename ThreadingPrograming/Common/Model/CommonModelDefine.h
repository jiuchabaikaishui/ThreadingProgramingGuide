//
//  ModelDefine.h
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/17.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#ifndef ModelDefine_h
#define ModelDefine_h


#define MethodNotImplementedInSubclass()      @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"你必须在%@的子类中重写%@方法。", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil]





#endif /* ModelDefine_h */
