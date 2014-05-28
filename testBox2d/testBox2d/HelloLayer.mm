//
//  HelloLayer.m
//  testBox2d
//
//  Created by JiangHuifu on 14-5-28.
//  Copyright (c) 2014年 veger. All rights reserved.
//

#import "HelloLayer.h"
#import "Box2D.h"
@interface HelloLayer(){
    b2World* _world;
    b2Body* _body;
    CCSprite* _ball;
}
@property(nonatomic,strong) CCSprite* ball;
@end
@implementation HelloLayer
@synthesize ball = _ball;
+(id)scene{
    CCScene* scene = [CCScene node];
    HelloLayer* layer = [HelloLayer node];
    [scene addChild:layer];
    return scene;
}
-(id)init{
    if (self = [super init]) {
        
        CGSize winSize = [[CCDirector sharedDirector] viewSize];
        
        //Create sprite and add it to the layout
        _ball = [CCSprite spriteWithImageNamed:@"ball.png"];
        _ball.scaleX = 52 / _ball.contentSize.width;
        _ball.scaleY = 52 / _ball.contentSize.height;
        _ball.position = ccp(100, 300);
        [self addChild:_ball];
        
        //Create a world
        b2Vec2 gravity = b2Vec2(0.0f,-8.0f);
        _world = new b2World(gravity);
        
        //Create edges around the entire screen
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0, 0);
        
        b2Body* groundBody = _world->CreateBody(&groundBodyDef);
        b2EdgeShape groundEdge;
        b2FixtureDef boxShapeDef;
        boxShapeDef.shape = &groundEdge;
        
        //wall definitions
        groundEdge.Set(b2Vec2(0, 0), b2Vec2(winSize.width/PTM_RATIO, 0));
        groundBody->CreateFixture(&boxShapeDef);
        groundEdge.Set(b2Vec2(0,0), b2Vec2(0, winSize.height/PTM_RATIO));
        groundBody->CreateFixture(&boxShapeDef);
        groundEdge.Set(b2Vec2(0,winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO,winSize.height/PTM_RATIO));
        groundBody->CreateFixture(&boxShapeDef);
        groundEdge.Set(b2Vec2(winSize.width/PTM_RATIO,winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO, 0));
        groundBody->CreateFixture(&boxShapeDef);
        
        //Create ball body and shape
        b2BodyDef ballBodyDef;
        ballBodyDef.type = b2_dynamicBody;
        ballBodyDef.position.Set(100/PTM_RATIO, 100/PTM_RATIO);
        ballBodyDef.userData = (__bridge void*)_ball;
        _body = _world->CreateBody(&ballBodyDef);
        
        b2CircleShape circle;
        circle.m_radius = 26.0/PTM_RATIO;
        
        b2FixtureDef ballShapeDef;
        ballShapeDef.shape = &circle;
        ballShapeDef.density = 1.0f;
        ballShapeDef.friction = 0.2f;
        ballShapeDef.restitution = 0.8f;
        _body->CreateFixture(&ballShapeDef);
        
        [self schedule:@selector(tick:) interval:0.017];
        
        [self schedule:@selector(kick) interval:5.0];
        
        
        self.userInteractionEnabled = YES;
    }
    return self;
}
-(void)tick:(CCTime) dt{
    _world->Step(dt, 10, 10);
    for (b2Body* b = _world->GetBodyList(); b; b=b->GetNext()) {
        CCSprite* ballData = (__bridge CCSprite*)b->GetUserData();
        ballData.position = ccp(b->GetPosition().x*PTM_RATIO,
                                b->GetPosition().y*PTM_RATIO);
        ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
    }
}
-(void)kick{
    b2Vec2 force = b2Vec2(30, 30);
    _body->ApplyLinearImpulse(force, _body->GetPosition());
}
-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    b2Vec2 force = b2Vec2(-30,30);
    _body->ApplyLinearImpulse(force, _body->GetPosition());
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    NSLog(@"touchEnded");
}


-(void)dealloc{
    delete _world;
    _body = NULL;
    _world = NULL;
}
@end
