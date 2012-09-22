//
//  CalculatorGraphViewController.m
//  Calculator
//
//  Created by Piotr Płaneta on 16.09.2012.
//
//

#import "CalculatorGraphViewController.h"
#import "CalculatorBrain.h"
#import "GraphView.h"

@interface CalculatorGraphViewController () <GraphViewDataSource>
@property (nonatomic, weak) IBOutlet GraphView *graphView;
@end

@implementation CalculatorGraphViewController

//SplitViewBarButtonItemPresenter section

@synthesize toolbar = _toolbar;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        NSMutableArray *items = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [items removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [items insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = items;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter
{
    return self;
}

//End of SplitViewBarButtonItemPresenter section

//UISplitViewControllerDelegate section

- (BOOL)splitViewController:(UISplitViewController *)svc
    shouldHideViewController:(UIViewController *)vc
               inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Calculator";
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}

//End of UISplitViewControllerDelegate section

@synthesize programDescription = _programDescription;
@synthesize program = _program;
@synthesize graphView = _graphView;

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    self.graphView.dataSource = self;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tap:)];
    [recognizer setNumberOfTapsRequired:3];
    [self.graphView addGestureRecognizer:recognizer];
}

- (void)setProgram:(id)program
{
    _program = program;
    [self.graphView setNeedsDisplay];
    [self setProgramDescription];
}

- (float)resultOfProgramForXValue:(float)x forGraphView:(GraphView *)sender
{
    return [CalculatorBrain runProgram:self.program usingVariableValues:[[NSDictionary alloc] initWithObjectsAndKeys:[[NSNumber alloc] initWithFloat:x], @"x", nil]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    CGRect labelFrame = self.programDescription.frame;
    labelFrame.origin.x = self.graphView.frame.size.width - 300;
    labelFrame.origin.y = self.graphView.frame.size.height - 41;
    self.programDescription.frame = labelFrame;
    return YES;
}

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
    [self setProgramDescription];
}

- (void)viewDidLoad
{
    self.splitViewController.delegate = self;
    [self setProgramDescription];
}

- (void)setProgramDescription
{
    self.programDescription.text = [CalculatorBrain descriptionOfProgram:self.program];
}

- (void)viewDidUnload {
    [self setProgram:nil];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs synchronize];

    [super viewDidUnload];
}


@end
