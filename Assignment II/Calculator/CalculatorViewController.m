//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Piotr Płaneta on 22.07.2012.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringNumber;
@property (nonatomic, strong) CalculatorBrain *brain;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize userInput = _userInput;
@synthesize variablesDisplay = variablesDisplay;
@synthesize userIsInTheMiddleOfEnteringNumber = _userIsInTheMiddleOfEnteringNumber;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (NSDictionary *)testVariableValues
{
    if (!_testVariableValues) _testVariableValues = [[NSDictionary alloc] init];
    return _testVariableValues;
}


- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.currentTitle;
    if ([digit isEqualToString:@"0"]) {
        if ([self.display.text isEqualToString:@"0"]) {
            return;
        }
    }
    if (self.userIsInTheMiddleOfEnteringNumber)
    {
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringNumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringNumber) {
        [self enterPressed];
    }
    
    [self.brain pushOperation:sender.currentTitle];
    [self refreshUserInterface];

}

- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self refreshUserInterface];
}

- (IBAction)decimalPointPressed
{
    if (!self.userIsInTheMiddleOfEnteringNumber) {
        self.display.text = @"0.";
        self.userIsInTheMiddleOfEnteringNumber = YES;
        return;
    }
    NSRange positionOfDecimalPoint = [self.display.text rangeOfString:@"."];
    if (positionOfDecimalPoint.location == NSNotFound) {
        self.userIsInTheMiddleOfEnteringNumber = YES;
        NSString* decimalPoint = @".";
        self.display.text = [self.display.text stringByAppendingString:decimalPoint];
    }
}

- (IBAction)clearPressed
{
    self.display.text = @"0";
    self.userInput.text = @"";
    self.variablesDisplay.text = @"";
    self.userIsInTheMiddleOfEnteringNumber = NO;
    [self.brain clearStack];
}

- (IBAction)undoPressed
{
    if (self.userIsInTheMiddleOfEnteringNumber) {
        if (self.display.text.length == 1) {
            [self refreshUserInterface];
        }
        else {
            self.display.text = [self.display.text substringToIndex:(self.display.text.length - 1)];
        }
    }
    else {
        [self.brain removeItemFromTopOfStack];
        [self refreshUserInterface];
    }
}

- (IBAction)plusMinusPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringNumber) {
        double currentNumber = [self.display.text doubleValue];
        currentNumber = -currentNumber;
        self.display.text = [NSString stringWithFormat:@"%g", currentNumber];
    }
    else {
        [self operationPressed:sender];
    }
}
- (IBAction)variablePressed:(UIButton *)sender
{
    [self.brain pushVariable:[sender currentTitle]];
    [self refreshUserInterface];
}

- (IBAction)testPressed:(UIButton *)sender
{
    if ([[sender currentTitle] isEqualToString:@"Test 1"])
    {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys: @1, @"a", @2, @"b", @3, @"c", nil];
        [self refreshUserInterface];
    }
    if ([[sender currentTitle] isEqualToString:@"Test 2"])
    {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys: @1.23, @"a", @2.123, @"b", @-3.656, @"c", nil];
        [self refreshUserInterface];
    }
    if ([[sender currentTitle] isEqualToString:@"Test 3"])
    {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys: @100, @"a", @2123, @"b", @3543, @"c", nil];
        [self refreshUserInterface];
    }
    if ([[sender currentTitle] isEqualToString:@"Test nil"])
    {
        self.testVariableValues = nil;
        [self refreshUserInterface];
    }
}


- (void)refreshUserInterface
{
    NSString *variables = [[NSString alloc] init];
    for (NSString *variable in [CalculatorBrain variablesUsedInProgram:self.brain.program]) {
        NSNumber *value = [self.testVariableValues objectForKey:variable];
        variables = [variables stringByAppendingString:[NSString stringWithFormat:@"%@ = %g   ", variable, [value doubleValue]]];
    }
    self.variablesDisplay.text = variables;
    double result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
    NSString* resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    self.userInput.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    self.userIsInTheMiddleOfEnteringNumber = NO;
}

- (void)viewDidUnload
{
    [self setBrain:nil];
    [self setTestVariableValues:nil];
    
    [self setDisplay:nil];
    [self setUserInput:nil];
    [self setVariablesDisplay:nil];
    
    [super viewDidUnload];
}

@end
