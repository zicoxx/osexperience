#import "OSPaneModel.h"




@implementation OSPaneModel
@synthesize panes = _panes;


+ (id)sharedInstance
{
    static OSPaneModel *_model;

    if (_model == nil)
    {
        _model = [[self alloc] init];
    }

    return _model;
}


- (id)init{
	if(![super init])
		return nil;

	self.panes = [[NSMutableArray alloc] init];

	return self;
}

- (unsigned int)count{
	return [self.panes count];
}


- (void)addPane:(OSPane*)pane atIndex:(unsigned int)index{
	[self.panes insertObject:pane atIndex:index];
}


- (void)addPaneToFront:(OSPane*)pane{
	[self.panes insertObject:pane atIndex:0];
}

- (void)addPaneToBack:(OSPane*)pane{
	[self.panes addObject:pane];
	[[OSSlider sharedInstance] addPane:pane];
	[[OSThumbnailView sharedInstance] addPane:pane];
}

- (void)removePane:(OSPane*)pane{
	[self.panes removeObject:pane];
}

- (unsigned int)indexOfPane:(OSPane*)pane{
	return [self.panes indexOfObject:pane];
}


- (OSPane*)paneAtIndex:(unsigned int)index{
	if(index < 0 || index > self.panes.count - 1)
		return nil;
	return [self.panes objectAtIndex:index];
}

- (void)dealloc{
	[self.panes release];
	[super dealloc];
}



@end