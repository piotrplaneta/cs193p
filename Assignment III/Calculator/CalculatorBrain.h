//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Piotr Płaneta on 22.07.2012.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

@property (readonly) id program;

+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program
  usingVariableValues:(NSDictionary *)variableValues;
+ (NSString *)descriptionOfProgram:(id)program;
+ (NSSet *)variablesUsedInProgram:(id)program;

- (void)pushOperand:(double)digit;
- (void)pushOperation:(NSString*)operation;
- (void)pushVariable:(NSString *)variable;
- (NSString *)descriptionOfCurrentProgram;
- (void)removeItemFromTopOfStack;
- (void)clearStack;
@end
